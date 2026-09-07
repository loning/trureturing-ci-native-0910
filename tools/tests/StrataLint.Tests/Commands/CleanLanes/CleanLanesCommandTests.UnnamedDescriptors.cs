using System.Text;
using StrataLint.Engine;

namespace StrataLint.Tests;

public sealed partial class CleanLanesCommandTests
{
    [Theory]
    [InlineData("network-policy", "merged_clean")]
    [InlineData("network-nexus", "merged_clean")]
    [InlineData("anonymous-pipe", "merged_clean")]
    [InlineData("regular-file", "in_use_unknown")]
    [InlineData("directory", "in_use_unknown")]
    [InlineData("named-pipe", "in_use_unknown")]
    [InlineData("unknown-type", "in_use_unknown")]
    [InlineData("missing-type", "in_use_unknown")]
    [InlineData("missing-name", "in_use_unknown")]
    [InlineData("duplicate-type", "in_use_unknown")]
    [InlineData("duplicate-after-policy", "in_use_unknown")]
    [InlineData("busy-after-policy", "in_use")]
    [InlineData("busy-before-policy", "in_use")]
    [InlineData("busy-next-process", "in_use")]
    [InlineData("malformed-after-policy", "in_use_unknown")]
    public void UnnamedDescriptorsPreserveCleanupSafety(string scenario, string expectedReason)
    {
        using var fixture = new CleanLanesFixture();
        const string branch = "harness/unnamed-descriptor";
        var lane = fixture.AddLandedLane(branch);
        var head = fixture.Head(lane);
        var idle = Encoding.UTF8.GetString(IdleLsofOutput().StandardOutput)
            .Replace("p123\0", "p123\0\n", StringComparison.Ordinal) + "\n";
        var policy = "f7\0tNPOLICY\0n\0\n";
        var busy = $"f8\0tDIR\0n{lane}\0\n";
        var suffix = scenario switch
        {
            "network-policy" => policy,
            "network-nexus" => "f7\0tNEXUS\0n\0",
            "anonymous-pipe" => "f7\0tPIPE\0n\0",
            "regular-file" => "f7\0tREG\0n\0",
            "directory" => "f7\0tDIR\0n\0",
            "named-pipe" => "f7\0tFIFO\0n\0",
            "unknown-type" => "f7\0tUNKNOWN\0n\0",
            "missing-type" => "f7\0n\0",
            "missing-name" => "f7\0tNPOLICY\0",
            "duplicate-type" => "f7\0tREG\0tNPOLICY\0n\0",
            "duplicate-after-policy" => "f7\0tNPOLICY\0tREG\0n\0",
            "busy-after-policy" => policy + busy,
            "busy-before-policy" => busy + policy,
            "busy-next-process" => policy + "p456\0\n" + busy,
            "malformed-after-policy" => policy + "f8\0",
            _ => throw new InvalidOperationException(scenario),
        };
        var runner = fixture.CreateRunner((fileName, _, _) => fileName switch
        {
            "gh" => SuccessfulPrOutput(branch, head),
            "lsof" => new ProcessOutput(0, Encoding.UTF8.GetBytes(idle + suffix), []),
            _ => null,
        });

        var result = fixture.RunWithProductionProbes(runner, "--force");

        Assert.True(result.Success, result.Error);
        Assert.Equal(expectedReason, ReasonFor(result.Output, lane));
        Assert.Equal(expectedReason != "merged_clean", Directory.Exists(lane));
        AssertLsofInvocations(runner.Invocations, expectedReason == "merged_clean" ? 2 : 1);
    }
}
