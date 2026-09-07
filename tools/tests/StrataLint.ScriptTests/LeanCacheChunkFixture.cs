using System.Security.Cryptography;
using System.Text;
using System.Text.Json;
using FixtureFile = StrataLint.TestSupport.TemporaryFileSystem.File;

namespace StrataLint.Tests;

[System.Runtime.Versioning.UnsupportedOSPlatform("windows")]
internal sealed class LeanCacheChunkFixture : IDisposable
{
    internal const string Archive = "0123456789abcdefgh";
    private const string ProducerSha = "0123456789abcdef0123456789abcdef01234567";
    private readonly TemporaryDirectory temporary = new();
    private readonly string repository;
    private readonly string bin;
    private readonly string script;
    private readonly string releases;

    internal LeanCacheChunkFixture(string archive = Archive)
    {
        repository = Path.Combine(temporary.Path, "repo");
        bin = Path.Combine(temporary.Path, "bin");
        releases = Path.Combine(temporary.Path, "releases");
        script = Path.Combine(repository, "tools/scripts/worktree/lean-cache-publish.sh");
        foreach (var directory in new[] { repository, bin, releases, Path.GetDirectoryName(script)!, Path.Combine(repository, ".lake/build") })
            ScriptHarnessScratch.EnsureDirectory(directory);
        ScriptHarnessScratch.CopyScriptInto(
            Path.Combine(TestRepositoryLayout.FindRoot(), "tools/scripts/worktree/lean-cache-publish.sh"), script);
        Write(Path.Combine(repository, "lean-toolchain"), "leanprover/lean4:v4.31.0\n");
        Write(Path.Combine(temporary.Path, "archive"), archive);
        Write(Path.Combine(temporary.Path, "tags"), "");
        ScriptHarnessScratch.WriteExecutableStub(Path.Combine(repository, "tools/scripts/worktree/lean-cache-input.sh"),
            $"printf '%s %s\\n' '{new string('3', 64)}' '{new string('4', 64)}'");
        ScriptHarnessScratch.WriteExecutableStub(Path.Combine(bin, "lake"), """
            case "$1" in
              pack) cp "$CHUNK_FIXTURE/archive" "$2" ;;
              unpack) cp "$2" "$CHUNK_FIXTURE/unpacked" ;;
              *) exit 80 ;;
            esac
            """);
        ScriptHarnessScratch.WriteExecutableStub(Path.Combine(bin, "gh"), """
            set -euo pipefail
            case "$1 $2" in
              'release view') exit 1 ;;
              'release list') cat "$CHUNK_FIXTURE/tags" ;;
              'release create')
                release="$CHUNK_FIXTURE/releases/$3"
                mkdir "$release"
                shift 3
                while [[ $# -gt 0 ]]; do
                  case "$1" in
                    --target|--repo|--title|--notes) shift 2 ;;
                    /*) cp "$1" "$release/"; shift ;;
                    *) exit 81 ;;
                  esac
                done
                ;;
              'release download')
                tag="$3"
                release="$CHUNK_FIXTURE/releases/$tag"
                shift 3
                destination=''
                patterns=()
                while [[ $# -gt 0 ]]; do
                  case "$1" in
                    --dir) destination="$2"; shift 2 ;;
                    --repo) [[ "$2" == fixture/cache ]]; shift 2 ;;
                    --pattern) patterns+=("$2"); shift 2 ;;
                    *) exit 82 ;;
                  esac
                done
                [[ -n "$destination" && ${#patterns[@]} -gt 0 ]]
                printf '%s\n' "$tag" >> "$CHUNK_FIXTURE/download-tags"
                for pattern in "${patterns[@]}"; do
                  printf '%s\n' "$pattern" >> "$CHUNK_FIXTURE/download-patterns"
                  found=0
                  for file in "$release"/*; do
                    [[ -f "$file" && "${file##*/}" == $pattern ]] || continue
                    cp "$file" "$destination/"
                    found=1
                  done
                  [[ "$found" == 1 ]] || exit 83
                done
                ;;
              api\ repos/fixture/cache/releases/tags/*)
                cat "$CHUNK_FIXTURE/${2##*/}.json"
                ;;
              *) exit 84 ;;
            esac
            """);
    }

    internal string Tag => CandidateTag('4', '3');
    internal string CandidateTag(char config, char sources) => $"lean-cache-v1-leanprover-lean4-v4-31-0-{new string(config, 16)}-{new string(sources, 16)}";
    internal string? Unpacked => FixtureFile.Exists(Path.Combine(temporary.Path, "unpacked"))
        ? FixtureFile.ReadAllText(Path.Combine(temporary.Path, "unpacked")) : null;
    internal string[] DownloadPatterns => ScriptHarnessScratch.ReadRecordedCalls(Path.Combine(temporary.Path, "download-patterns"));
    internal string[] DownloadTags => ScriptHarnessScratch.ReadRecordedCalls(Path.Combine(temporary.Path, "download-tags"));
    internal string Manifest(string tag) => ReadAsset(tag, "manifest.txt");
    internal string ReadAsset(string tag, string name) => FixtureFile.ReadAllText(Path.Combine(releases, tag, name));
    internal string[] Assets(string tag) => Directory.GetFiles(Path.Combine(releases, tag))
        .Select(Path.GetFileName).Order(StringComparer.Ordinal).ToArray()!;
    internal void ListReleases(params string[] tags) => Write(Path.Combine(temporary.Path, "tags"), string.Join('\n', tags) + "\n");

    internal Attempt Publish(string chunkBytes)
    {
        var result = Run("publish", chunkBytes, false);
        if (result.ExitCode == 0) WriteMetadata(Tag, null);
        return result;
    }

    internal Attempt Fetch(bool allowSeed = false) => Run("fetch", "default", allowSeed);

    internal void AddRelease(string tag, bool chunked = true, bool oldManifest = false, string? deviation = null)
    {
        var directory = Path.Combine(releases, tag);
        ScriptHarnessScratch.EnsureDirectory(directory);
        var suffixes = tag.Split('-');
        var config = new string(suffixes[^2][0], 64);
        var sources = new string(suffixes[^1][0], 64);
        var manifest = $"toolchain=leanprover/lean4:v4.31.0\nconfig_sha256={config}\nsources_sha256={sources}\n"
            + $"archive_sha256={(deviation == "bad-whole" ? new string('0', 64) : Digest(Archive))}\n"
            + $"producer_commit_sha={ProducerSha}\nworkflow_run_id=4242\n";
        if (!oldManifest) manifest += $"parts={(deviation == "invalid-parts" ? "0" : deviation == "empty-parts" ? "" : chunked ? "3" : "1")}\n";
        if (chunked)
        {
            foreach (var (index, bytes) in new[] { (0, "01234567"), (1, "89abcdef"), (2, "gh") })
            {
                if (!(deviation == "missing-part-digest" && index == 1))
                    manifest += $"part_sha256_{index}={Digest(bytes)}\n";
                if (deviation == "missing-part" && index == 1) continue;
                Write(Path.Combine(directory, $"lean-build.tgz.part-{index:D2}"), deviation == "bad-part" && index == 1 ? "corrupt!" : bytes);
            }
        }
        else Write(Path.Combine(directory, "lean-build.tgz"), Archive);
        Write(Path.Combine(directory, "manifest.txt"), manifest);
        if (deviation == "extra-asset") Write(Path.Combine(directory, "lean-build.tgz"), Archive);
        WriteMetadata(tag, deviation);
    }

    internal void AssertSuccess(Attempt result) => Assert.True(result.ExitCode == 0, result.Text);

    private void WriteMetadata(string tag, string? deviation) => Write(Path.Combine(temporary.Path, $"{tag}.json"),
        JsonSerializer.Serialize(new
        {
            target_commitish = ProducerSha,
            assets = Assets(tag).Select(name => new
            {
                name,
                digest = "sha256:" + (deviation == "bad-github-part-digest" && name.EndsWith("part-01", StringComparison.Ordinal)
                    ? new string('0', 64) : Digest(ReadAsset(tag, name))),
            }).ToArray(),
        }));

    private Attempt Run(string verb, string chunkBytes, bool allowSeed)
    {
        var arguments = new List<string>
        {
            "-u", "STRATALINT_CACHE_TEST_CHUNK_BYTES",
            $"PATH={bin}:{Environment.GetEnvironmentVariable("PATH")}",
            $"CHUNK_FIXTURE={temporary.Path}",
            "STRATALINT_CACHE_REPO=fixture/cache",
            $"GITHUB_SHA={ProducerSha}", "GITHUB_RUN_ID=4242",
        };
        if (chunkBytes != "default") arguments.Add($"STRATALINT_CACHE_TEST_CHUNK_BYTES={chunkBytes}");
        arguments.AddRange(["/bin/bash", script, verb, "--repository", repository]);
        if (allowSeed) arguments.Add("--allow-seed");
        var result = TestProcessRunner.Run("/usr/bin/env", arguments.ToArray(), repository,
            TestBudgets.ScriptProcessHangGuard, 64 * 1024);
        return new Attempt(result.ExitCode, Encoding.UTF8.GetString(result.StandardOutput) + Encoding.UTF8.GetString(result.StandardError));
    }

    private static void Write(string path, string text) => ScriptHarnessScratch.WriteScratchText(path, text);
    private static string Digest(string value) => Convert.ToHexStringLower(SHA256.HashData(Encoding.ASCII.GetBytes(value)));
    public void Dispose() => temporary.Dispose();
    internal sealed record Attempt(int ExitCode, string Text);
}
