package github.stompede.broker
{
    import github.stompede.broker.session.Session;
    import github.stompede.protocol.Frame;
    import github.stompede.protocol.FrameConst;
    import github.stompede.signal.*;

    import org.as3commons.logging.ILogger;
    import org.as3commons.logging.LoggerFactory;

    public class FrameBusImpl implements FrameBus
    {
        private static var LOG:ILogger = LoggerFactory.getClassLogger(FrameBusImpl);

        [Inject]
        public var connectSignal:ConnectSignal;
        [Inject]
        public var subscribeSignal:SubscribeSignal;
        [Inject]
        public var unsubscribeSignal:UnsubscribeSignal;
        [Inject]
        public var sendSignal:SendSignal;
        [Inject]
        public var disconnectSignal:DisconnectSignal;

        private var m_frameAvailableSignal:FrameAvailableSignal;

        [PostConstruct]
        public function postConstruct():void {
            m_frameAvailableSignal.add(onFrameAvailable);
        }

        [Inject]
        public function set frameAvailableSignal(frameAvailableSignal:FrameAvailableSignal):void {
            m_frameAvailableSignal = frameAvailableSignal;
        }

        public function get frameAvailableSignal():FrameAvailableSignal {
            return m_frameAvailableSignal;
        }

        // TODO Signal dispatching should include concretes, like DestinationInfo, instead of basic strings
        protected function onFrameAvailable(frame:Frame, session:Session):void {
            switch (frame.command) {
                case FrameConst.CONNECT:
                    connectSignal.dispatch(session, frame.headers.find(FrameConst.LOGIN), frame.headers.find(FrameConst.PASSCODE));
                    break;
                case FrameConst.DISCONNECT:
                    disconnectSignal.dispatch(session);
                    break;
                case FrameConst.SUBSCRIBE:
                    subscribeSignal.dispatch(session, frame.headers.find(FrameConst.DESTINATION));
                    break;
                case FrameConst.UNSUBSCRIBE:
                    unsubscribeSignal.dispatch(session, frame.headers.find(FrameConst.DESTINATION));
                    break;
                case FrameConst.SEND:
                    sendSignal.dispatch(session, frame.headers.find(FrameConst.DESTINATION), frame.body);
                    break;
                default:
                    LOG.debug("Unable to dispatch unknown frame: {0}", frame.command);
            }
        }
    }
}