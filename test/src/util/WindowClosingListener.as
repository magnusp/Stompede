package util
{
    import org.flexunit.runner.IDescription;
    import org.flexunit.runner.Result;
    import org.flexunit.runner.notification.Failure;
    import org.flexunit.runner.notification.IRunListener;

    import spark.components.WindowedApplication;

    public class WindowClosingListener implements IRunListener
    {
        private var windowedApplication:WindowedApplication;

        public function WindowClosingListener(windowedApplication:WindowedApplication)
        {
            this.windowedApplication = windowedApplication;
        }

        public function testRunStarted(description:IDescription):void
        {
        }

        public function testRunFinished(result:Result):void
        {
            if (result.failureCount > 0) {
                var failure:Failure;
                var stringArray:Array;

                trace("\nTest result " + result.failureCount + "F " + result.ignoreCount + "I");
                for (var i:int = 0; i < result.failureCount; i++) {
                    failure = result.failures[i] as Failure;
                    trace(failure.description.displayName);
                    stringArray = failure.stackTrace.split("\n");

                    for (var k:int = 0; stringArray.length; k++) {
                        if (k > 5) {
                            trace("--- suppressed ---");
                            break;
                        }
                        trace("  " + stringArray[k]);

                    }

                }
            }

            windowedApplication.close();
        }

        public function testStarted(description:IDescription):void
        {
            trace("  --- Start: " + description.displayName);
        }

        public function testFinished(description:IDescription):void
        {
            trace("  ---  End\n");
        }

        public function testFailure(failure:Failure):void
        {
        }

        public function testAssumptionFailure(failure:Failure):void
        {
        }

        public function testIgnored(description:IDescription):void
        {
        }
    }
}