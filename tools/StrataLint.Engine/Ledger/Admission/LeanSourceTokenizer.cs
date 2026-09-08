using System.Collections.Immutable;
using System.Text;

namespace StrataLint.Engine;

internal sealed record LeanSourceToken(
    string Text, int Line, int Column, ImmutableArray<string> IdentifierParts = default)
{
    internal bool IsIdentifier => !IdentifierParts.IsDefaultOrEmpty;
    internal string Identifier => LeanSourceTokenizer.IdentifierText(IdentifierParts);
}

internal static class LeanSourceTokenizer
{
    internal static ImmutableArray<LeanSourceToken> Tokenize(string source) =>
        new Scanner(source, includeInterpolationTerms: false).ReadCode();

    // Proposition extraction retains literal spelling; source policies also inspect embedded terms.
    internal static ImmutableArray<LeanSourceToken> TokenizeIncludingInterpolationTerms(string source) =>
        new Scanner(source, includeInterpolationTerms: true).ReadCode();

    internal static ImmutableArray<string> IdentifierParts(string text)
    {
        var tokens = Tokenize(text);
        return tokens.Length == 1 && tokens[0].IsIdentifier ? tokens[0].IdentifierParts : [];
    }

    internal static string IdentifierText(IEnumerable<string> parts) =>
        string.Join('.', parts.Select(static part =>
            part.Length > 0 && part[0] != '\u00ab' && IsIdentifierStart(char.ConvertToUtf32(part, 0))
                && part.EnumerateRunes().Skip(1).All(static rune => IsIdentifierPart(rune.Value))
                    ? part
                    : "\u00ab" + part + "\u00bb"));

    private sealed class Scanner(string source, bool includeInterpolationTerms)
    {
        private int index;
        private int line = 1;
        private int column;

        internal ImmutableArray<LeanSourceToken> ReadCode(int? interpolationLine = null)
        {
            var result = ImmutableArray.CreateBuilder<LeanSourceToken>();
            var brackets = new Stack<(char Symbol, int Line)>();
            while (index < source.Length)
            {
                if (char.IsWhiteSpace(source[index]))
                {
                    Advance();
                    continue;
                }

                if (At("--"))
                {
                    while (index < source.Length && source[index] != '\n')
                    {
                        Advance();
                    }

                    continue;
                }

                if (At("/-"))
                {
                    ReadComment();
                    continue;
                }

                if (interpolationLine is not null && source[index] == '}' && brackets.Count == 0)
                {
                    Advance();
                    return result.ToImmutable();
                }

                var start = index;
                var tokenLine = line;
                var tokenColumn = column;
                var identifierParts = ImmutableArray<string>.Empty;
                var rawQuote = RawStringQuote();
                if (rawQuote >= 0)
                {
                    ReadRawString(rawQuote);
                }
                else if (source[index] == '"')
                {
                    var interpolated = result.Count > 0 && result[^1].Text is "s!" or "m!" or "f!";
                    ReadString(interpolated, result);
                }
                else if (source[index] == '\'')
                {
                    ReadCharacter();
                }
                else if (NameLiteralPrefixLength() is var prefix && prefix > 0)
                {
                    Advance(prefix);
                    ReadIdentifier();
                }
                else if (IsIdentifierStart(CodePointAt(index)))
                {
                    identifierParts = ReadIdentifier();
                }
                else
                {
                    var symbol = index + 1 < source.Length && source.Substring(index, 2) is
                        ":=" or "=>" or "->" or "<-" or "::" or "<=" or ">=" or "==" or "!="
                            ? source.Substring(index, 2)
                            : source.Substring(index, char.IsSurrogatePair(source, index) ? 2 : 1);
                    Advance(symbol.Length);
                    // Unicode symbolic notation can carry primes (for example mathlib's tsum/tprod).
                    // ASCII operators still allow an adjacent character literal, as in :=')'.
                    if (symbol[0] > 127 && Rune.IsSymbol(Rune.GetRuneAt(symbol, 0)))
                    {
                        while (index < source.Length && source[index] == '\'' && !AtCharacterLiteral())
                        {
                            Advance();
                        }
                    }

                    if (symbol.Length == 1 && symbol[0] is '(' or '[' or '{')
                    {
                        brackets.Push((symbol[0], tokenLine));
                    }
                    else if (symbol.Length == 1 && symbol[0] is ')' or ']' or '}')
                    {
                        var expected = symbol[0] switch { ')' => '(', ']' => '[', _ => '{' };
                        if (!brackets.TryPop(out var actual) || actual.Symbol != expected)
                        {
                            throw Error("Lean delimiters are unbalanced.", tokenLine);
                        }
                    }
                }

                result.Add(new LeanSourceToken(source[start..index], tokenLine, tokenColumn, identifierParts));
            }

            if (brackets.TryPeek(out var opening))
            {
                throw Error("Lean delimiters are unbalanced.", opening.Line);
            }

            if (interpolationLine is not null)
            {
                throw Error("Lean string interpolation is unterminated.", interpolationLine.Value);
            }

            return result.ToImmutable();
        }

        private void ReadComment()
        {
            var startLine = line;
            var depth = 0;
            do
            {
                if (At("/-"))
                {
                    depth++;
                    Advance(2);
                }
                else if (At("-/"))
                {
                    depth--;
                    Advance(2);
                }
                else
                {
                    Advance();
                }
            }
            while (index < source.Length && depth > 0);
            if (depth != 0)
            {
                throw Error("Lean block comment is unterminated.", startLine);
            }
        }

        private void ReadString(bool interpolated, ImmutableArray<LeanSourceToken>.Builder result)
        {
            var startLine = line;
            Advance();
            while (index < source.Length)
            {
                var value = source[index];
                if (value == '\\')
                {
                    Advance();
                    if (index < source.Length)
                    {
                        Advance();
                    }
                }
                else if (value == '"')
                {
                    Advance();
                    return;
                }
                else if (interpolated && value == '{')
                {
                    var interpolationLine = line;
                    Advance();
                    var terms = ReadCode(interpolationLine);
                    if (includeInterpolationTerms)
                    {
                        result.AddRange(terms);
                    }
                }
                else
                {
                    Advance();
                }
            }

            throw Error("Lean string literal is unterminated.", startLine);
        }

        private int RawStringQuote()
        {
            if (source[index] != 'r')
            {
                return -1;
            }

            var cursor = index + 1;
            while (cursor < source.Length && source[cursor] == '#')
            {
                cursor++;
            }

            return cursor < source.Length && source[cursor] == '"' ? cursor : -1;
        }

        private void ReadRawString(int quote)
        {
            var startLine = line;
            var terminator = "\"" + new string('#', quote - index - 1);
            Advance(quote - index + 1);
            while (index < source.Length)
            {
                if (At(terminator))
                {
                    Advance(terminator.Length);
                    return;
                }

                Advance();
            }

            throw Error("Lean raw string literal is unterminated.", startLine);
        }

        private bool AtCharacterLiteral()
        {
            var start = (index, line, column);
            try
            {
                ReadCharacter();
                return true;
            }
            catch (LeanSourceExtractionException)
            {
                return false;
            }
            finally
            {
                (index, line, column) = start;
            }
        }

        private void ReadCharacter()
        {
            var startLine = line;
            Advance();
            if (index < source.Length && source[index] == '\\')
            {
                Advance();
                if (index < source.Length)
                {
                    var escape = source[index];
                    Advance();
                    var digits = escape switch { 'x' => 2, 'u' => 4, _ => 0 };
                    for (var count = 0; count < digits; count++)
                    {
                        if (index >= source.Length || !char.IsAsciiHexDigit(source[index]))
                        {
                            throw Error("Lean character escape is malformed.", startLine);
                        }

                        Advance();
                    }
                }
            }
            else if (index < source.Length)
            {
                Advance(char.IsSurrogatePair(source, index) ? 2 : 1);
            }

            if (index >= source.Length || source[index] != '\'')
            {
                throw Error("Lean character literal is unterminated or malformed.", startLine);
            }

            Advance();
        }

        private int NameLiteralPrefixLength()
        {
            var length = At("``") ? 2 : At("`") ? 1 : 0;
            return length > 0 && index + length < source.Length && IsIdentifierStart(CodePointAt(index + length))
                ? length
                : 0;
        }

        private ImmutableArray<string> ReadIdentifier()
        {
            var parts = ImmutableArray.CreateBuilder<string>();
            while (index < source.Length)
            {
                if (source[index] == '\u00ab')
                {
                    var startLine = line;
                    Advance();
                    var start = index;
                    while (index < source.Length && source[index] != '\u00bb')
                    {
                        Advance();
                    }

                    if (index == source.Length)
                    {
                        throw Error("Lean escaped identifier is unterminated.", startLine);
                    }

                    parts.Add(source[start..index]);
                    Advance();
                }
                else
                {
                    var start = index;
                    while (index < source.Length && IsIdentifierPart(CodePointAt(index)))
                    {
                        Advance(char.IsSurrogatePair(source, index) ? 2 : 1);
                    }

                    parts.Add(source[start..index]);
                }

                if (index + 1 >= source.Length || source[index] != '.' || !IsIdentifierStart(CodePointAt(index + 1)))
                {
                    return parts.ToImmutable();
                }

                Advance();
            }

            return parts.ToImmutable();
        }

        private bool At(string text) => source.AsSpan(index).StartsWith(text, StringComparison.Ordinal);

        private int CodePointAt(int offset) => char.ConvertToUtf32(source, offset);

        private static LeanSourceExtractionException Error(string message, int atLine) => new(message, atLine);

        private void Advance(int count = 1)
        {
            for (var offset = 0; offset < count; offset++)
            {
                if (source[index++] == '\n')
                {
                    line++;
                    column = 0;
                }
                else
                {
                    column++;
                }
            }
        }
    }

    // Lean v4.33.0 Init/Meta/Defs.lean defines explicit isIdFirst/isIdRest ranges.
    private static bool IsIdentifierStart(int value) =>
        value is '_' or '\u00ab' or >= 'a' and <= 'z' or >= 'A' and <= 'Z'
        || IsLetterLike(value);

    private static bool IsIdentifierPart(int value) =>
        value != '\u00ab' && IsIdentifierStart(value)
        || value is '\'' or '!' or '?' or >= '0' and <= '9'
            or >= 0x2080 and <= 0x2089
            or >= 0x2090 and <= 0x209c
            or >= 0x1d62 and <= 0x1d6a
            or 0x2c7c;

    private static bool IsLetterLike(int value) => value is
        >= 0x03b1 and <= 0x03c9 and not 0x03bb
        or >= 0x0391 and <= 0x03a9 and not 0x03a0 and not 0x03a3
        or >= 0x03ca and <= 0x03fb
        or >= 0x1f00 and <= 0x1ffe
        or >= 0x2100 and <= 0x214f
        or >= 0x1d49c and <= 0x1d59f
        or >= 0x00c0 and <= 0x00ff and not 0x00d7 and not 0x00f7
        or >= 0x0100 and <= 0x017f;
}
