package github.stompede.broker.session
{
    import de.polygonal.ds.HashMap;
    
    import github.stompede.protocol.Frame;
    import github.stompede.protocol.FrameConst;
    import github.stompede.signal.ConnectSignal;
    import github.stompede.signal.SessionStartedSignal;
    import github.stompede.signal.SessionStoppedSignal;
    
    import org.as3commons.logging.ILogger;
    import org.as3commons.logging.LoggerFactory;

    public class SessionStoreImpl implements SessionStore
    {
        private static var LOG:ILogger = LoggerFactory.getClassLogger(SessionStoreImpl);

        [Inject]
        public var sessionStartedSignal:SessionStartedSignal;
        [Inject]
        public var sessionStoppedSignal:SessionStoppedSignal;
		[Inject]
		public var connectSignal:ConnectSignal;
		
        private var sessions:HashMap = new HashMap();
        private var sessionCounter:int = 0;

        [PostConstruct]
        public function postConstruct():void {
            sessionStartedSignal.add(onSessionStarted);
            sessionStoppedSignal.add(onSessionStopped);
			connectSignal.add(onConnect);
        }

        protected function generateSessionId():String {
            return String(sessionCounter++);
        }

        protected function onSessionStarted(session:Session):void {
            session.sessionId = "id-" + generateSessionId();
            sessions.insert(session, session.sessionId);
            LOG.debug("Added session: {0}", session);
        }

        protected function onSessionStopped(session:Session):void {
            sessions.remove(session);
            LOG.debug("Removed session: {0}", session);
        }
		
		protected function onConnect(session:Session, login:String=null, passcode:String=null):void {
			var headers:HashMap = new HashMap();
			headers.insert(FrameConst.SESSIONID, session.sessionId);
			var frame:Frame = new Frame(FrameConst.CONNECTED, headers);
			session.dispatch(frame);
		}
    }
}