using StrataLint.Engine;

namespace StrataLint.Tests;

public sealed class LeanSourceTokenizerTests
{
    [Theory]
    [InlineData("')'")]
    [InlineData("'\\''")]
    [InlineData("r#\"quotes \" native_decide )\"#")]
    [InlineData("r##\"quotes \"# native_decide /-\"##")]
    [InlineData("`native_decide")]
    [InlineData("``native_decide")]
    [InlineData("\u00abnative_decide\u00bb")]
    [InlineData("native_decide!")]
    [InlineData("native_decide?")]
    [InlineData("native_decide\u2127")]
    [InlineData("native_decide\U0001d49c")]
    public void LexicalAtomsDoNotLeakInteriorTokensOrDelimiters(string atom)
    {
        var token = Assert.Single(LeanSourceTokenizer.Tokenize(atom));
        Assert.Equal(atom, token.Text);
    }

    [Theory]
    [InlineData("\u03bb")]
    [InlineData("\u03a0")]
    [InlineData("\u03a3")]
    public void LeanBinderSymbolsAreNotIdentifierSuffixes(string symbol)
    {
        Assert.Equal(new[] { "native_decide", symbol },
            LeanSourceTokenizer.Tokenize("native_decide" + symbol).Select(static token => token.Text));
    }

    [Theory]
    [InlineData("\u2211'")]
    [InlineData("\u220f'")]
    [InlineData("\u2297'")]
    public void SymbolicPrimesDoNotConsumeFollowingCode(string symbol)
    {
        var tokens = LeanSourceTokenizer.Tokenize(symbol + " n, n\nnative_decide");
        Assert.Equal("native_decide", tokens[^1].Text);
        Assert.Equal(2, tokens[^1].Line);
    }

    [Fact]
    public void CharacterLiteralAfterUnicodeOperatorRetainsItsSpelling()
    {
        var tokens = LeanSourceTokenizer.Tokenize("')' \u2260'}'");
        Assert.Equal(new[] { "')'", "\u2260", "'}'" }, tokens.Select(static token => token.Text));
    }

    [Fact]
    public void ExistingPropositionTokensAndLocationsRemainStable()
    {
        var tokens = LeanSourceTokenizer.Tokenize("/- outer /- nested -/ -/\r\n theorem p (n : Nat) : n = n := by rfl -- end\n");
        Assert.Equal(new[] { "theorem", "p", "(", "n", ":", "Nat", ")", ":", "n", "=", "n", ":=", "by", "rfl" }, tokens.Select(static token => token.Text));
        Assert.All(tokens, token => Assert.Equal(2, token.Line));
        Assert.Equal(1, tokens[0].Column);
    }

    [Theory]
    [InlineData("/- unterminated")]
    [InlineData("\"unterminated")]
    [InlineData("(]")]
    [InlineData("(")]
    [InlineData("'(")]
    [InlineData("'ab'")]
    [InlineData(":='a")]
    [InlineData("'\\u00xz'")]
    public void ExistingMalformedSourceValidationRemainsFailClosed(string source)
    {
        Assert.Throws<LeanSourceExtractionException>(() => LeanSourceTokenizer.Tokenize(source));
    }

    [Fact]
    public void OrdinaryStringSpellingIsPreservedForPropositionExtraction()
    {
        const string source = "\"literal \\\" native_decide /- )\"";
        Assert.Equal(source, Assert.Single(LeanSourceTokenizer.Tokenize(source)).Text);
    }

    [Theory]
    [InlineData("s!\"value {(Fin.mk 1 (by native_decide) : Fin 2)}\"")]
    [InlineData("s!\"outer {s!\"inner {(Fin.mk 1 (by native_decide) : Fin 2)}\"}\"")]
    public void PropositionExtractionRetainsInterpolationLiteralWithoutExtraTermTokens(string source)
    {
        var tokens = LeanSourceTokenizer.Tokenize(source);
        Assert.Equal(new[] { "s!", source[2..] }, tokens.Select(static token => token.Text));
    }
}
