package suite
{
	import suite.test.ConnectionTest;

	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class StompedeSuite
	{
		public var connectionTest:ConnectionTest;
	}
}