package github.stompede.broker.destination
{
    import de.polygonal.ds.HashMap;
    import de.polygonal.ds.Iterator;
    import de.polygonal.ds.Set;

    import github.stompede.broker.session.Session;
    import github.stompede.protocol.Frame;
    import github.stompede.protocol.FrameConst;
    import github.stompede.signal.SessionStoppedSignal;

    import org.as3commons.logging.ILogger;
    import org.as3commons.logging.LoggerFactory;

    public class Topic implements Destination
    {
        private static var LOG:ILogger = LoggerFactory.getClassLogger(Topic);

        [Inject]
        public var destinationStore:DestinationStore;
        [Inject]
        public var sessionStoppedSignal:SessionStoppedSignal;

        private var m_name:String;
        private var m_subscribers:Set;

        [PostConstruct]
        public function postConstruct():void {
            sessionStoppedSignal.add(onSessionStopped);
        }

        private function onSessionStopped(session:Session):void {
            removeSubscriber(session);
        }

        public function set name(name:String):void {
            m_name = name;
        }

        public function get name():String
        {
            return m_name;
        }

        public function addSubscriber(session:Session):void {
            if (m_subscribers == null)
                m_subscribers = new Set();

            m_subscribers.set(session);
            LOG.debug("Adding subscriber - destination: {0}, session: {1}", this, session);
        }

        public function removeSubscriber(session:Session):void {
            m_subscribers.remove(session);
            LOG.debug("Removing subscriber - destination: {0}, session: {1}", this, session);

            if (m_subscribers.isEmpty()) {
                LOG.debug("Destination has no subscribers: {0}", this);
                destinationStore.removeDestination(this);
            }
        }

        public function dispose():void {
            sessionStoppedSignal.remove(onSessionStopped);
        }

        public function putMessage(message:Message):void {
            var headers:HashMap = new HashMap();
            headers.insert(FrameConst.DESTINATION, this.name);
            headers.insert(FrameConst.MESSAGEID, message.messageId);

            var frame:Frame = new Frame(FrameConst.MESSAGE, headers, message.body);

            var itr:Iterator = m_subscribers.getIterator();
            while (itr.hasNext()) {
                var session:Session = itr.next() as Session;
                session.dispatch(frame);
                LOG.debug("Dispatching message - session: {0}, message: {1}", session, message);
            }
        }

        public function toString():String {
            return "[Topic name:".concat(m_name).concat("]");
        }
    }
}