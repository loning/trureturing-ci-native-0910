namespace StrataLint.Tests;

public sealed class LeanCachePublishTests
{
    [Fact]
    public void ReleaseSeedsUsePartitionAndAtomicPublication() => LeanSeedProcessContract.Run("TransportTests");
}
