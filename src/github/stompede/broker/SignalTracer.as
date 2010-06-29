package github.stompede.broker
{
    import flash.utils.ByteArray;

    import github.stompede.broker.session.Session;
    import github.stompede.protocol.Frame;
    import github.stompede.signal.*;

    import org.as3commons.logging.ILogger;
    import org.as3commons.logging.LoggerFactory;

    public class SignalTracer
    {
        private static var LOG:ILogger = LoggerFactory.getClassLogger(SignalTracer);

        [Inject]
        public var connectSignal:ConnectSignal;
        [Inject]
        public var sessionStartedSignal:SessionStartedSignal;
        [Inject]
        public var sessionStoppedSignal:SessionStoppedSignal;
        [Inject]
        public var frameAvailableSignal:FrameAvailableSignal;
        [Inject]
        public var disconnectSignal:DisconnectSignal;
        [Inject]
        public var subscribeSignal:SubscribeSignal;
        [Inject]
        public var unsubscribeSignal:UnsubscribeSignal;
        [Inject]
        public var sendSignal:SendSignal;

        [PostConstruct]
        public function postConstruct():void {
            connectSignal.add(onConnect);
            sessionStartedSignal.add(onSessionStarted);
            sessionStoppedSignal.add(onSessionStopped);
            frameAvailableSignal.add(onFrameAvailable);
            disconnectSignal.add(onDisconnect);
            subscribeSignal.add(onSubscribe);
            unsubscribeSignal.add(onUnsubscribe);
            sendSignal.add(onSend);
        }

        protected function onConnect(session:Session, login:String = "Anonymous", pass:String = "Anonymous"):void {
            LOG.debug("ConnectSignal - login: {0}, passcode: {1}", login, pass);
        }

        protected function onSessionStarted(session:Session):void {
            LOG.debug("SessionStartedSignal - session: {0}", session);
        }

        protected function onSessionStopped(session:Session):void {
            LOG.debug("SessionStoppedSignal - session: {0}", session);
        }

        protected function onFrameAvailable(frame:Frame, session:Session):void {
            LOG.debug("FrameAvailableSignal - frame: {0}", frame);
        }

        protected function onDisconnect(session:Session):void {
            LOG.debug("DisconnectSignal - session: {0}", session);
        }

        protected function onSubscribe(session:Session, destinationName:String):void {
            LOG.debug("SubscribeSignal - session: {0}, destination: {1}", session, destinationName);
        }

        protected function onUnsubscribe(session:Session, destinationName:String):void {
            LOG.debug("UnsubscribeSignal - session: {0}, destination: {1}", session, destinationName);
        }

        protected function onSend(session:Session, destinationName:String, body:ByteArray):void {
            LOG.debug("SendSignal - session: {0}, destination: {1}, content length: {2}", session, destinationName, body != null ? body.length : "(no body)");
        }
    }
}