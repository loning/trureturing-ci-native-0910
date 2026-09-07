using System.Buffers;

namespace StrataLint.Cli;

internal static partial class CleanLanesCommand
{
    private static async Task<LaneProcessProbeOutcome> ReadLsofSnapshot(
        Stream stream,
        string canonicalLanePath,
        CancellationToken cancellation)
    {
        var parser = new LsofSnapshotParser(canonicalLanePath);
        var buffer = new byte[8192];
        int count;
        while ((count = await stream.ReadAsync(buffer, cancellation).ConfigureAwait(false)) != 0)
        {
            parser.Append(buffer.AsSpan(0, count));
        }
        return parser.Complete();
    }

    private sealed class LsofSnapshotParser(string canonicalLanePath)
    {
        // Bound a malformed field, independently of the number of open descriptors.
        private const int MaximumFieldBytes = 64 * 1024 * 1024;
        private readonly ArrayBufferWriter<byte> fieldBytes = new();
        private bool valid = true;
        private bool separatorSeen;
        private bool processSeen;
        private bool fileSeen;
        private bool nameSeen = true;
        private bool inUse;
        private string? fileType;

        internal void Append(ReadOnlySpan<byte> bytes)
        {
            foreach (var value in bytes)
            {
                // Invalid snapshots must still be drained so the child can finish.
                if (!valid) return;
                if (fieldBytes.WrittenCount == 0 && !separatorSeen && value == (byte)'\n')
                {
                    separatorSeen = true;
                    continue;
                }
                if (value != 0)
                {
                    if (fieldBytes.WrittenCount == MaximumFieldBytes)
                    {
                        valid = false;
                        return;
                    }
                    fieldBytes.GetSpan(1)[0] = value;
                    fieldBytes.Advance(1);
                    continue;
                }
                if (fieldBytes.WrittenCount == 0)
                {
                    valid = false;
                    return;
                }
                try
                {
                    valid = ParseField(StrictUtf8.GetString(fieldBytes.WrittenSpan));
                }
                catch (Exception exception) when (exception is not OutOfMemoryException)
                {
                    valid = false;
                }
                fieldBytes.Clear();
                separatorSeen = false;
            }
        }

        internal LaneProcessProbeOutcome Complete()
        {
            var complete = valid && fieldBytes.WrittenCount == 0 && processSeen && fileSeen && nameSeen;
            return new LaneProcessProbeOutcome(complete, complete && inUse);
        }

        private bool ParseField(string field)
        {
            switch (field[0])
            {
                case 'p':
                    if (field.Length == 1
                        || field.AsSpan(1).ContainsAnyExceptInRange('0', '9')
                        || !nameSeen
                        || (processSeen && !fileSeen)) return false;
                    processSeen = true;
                    fileSeen = false;
                    return true;
                case 'f':
                    if (!processSeen || field.Length == 1 || !nameSeen) return false;
                    fileSeen = true;
                    nameSeen = false;
                    fileType = null;
                    return true;
                case 't':
                    if (!processSeen || !fileSeen || nameSeen
                        || fileType is not null || field.Length == 1) return false;
                    fileType = field[1..];
                    return true;
                case 'n':
                    if (!processSeen || !fileSeen || nameSeen) return false;
                    if (field.Length == 1 && fileType is not ("NPOLICY" or "NEXUS" or "PIPE")) return false;
                    nameSeen = true;
                    var observedPath = field[1..];
                    if (Path.IsPathRooted(observedPath))
                    {
                        observedPath = CanonicalPath(observedPath);
                        inUse |= string.Equals(observedPath, canonicalLanePath, StringComparison.Ordinal)
                            || observedPath.StartsWith(canonicalLanePath + Path.DirectorySeparatorChar,
                                StringComparison.Ordinal);
                    }
                    return true;
                default:
                    return false;
            }
        }
    }
}
