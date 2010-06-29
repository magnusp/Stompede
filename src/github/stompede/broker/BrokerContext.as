package github.stompede.broker {
    import com.adobe.net.URI;
    
    import github.stompede.broker.destination.Destination;
    import github.stompede.broker.destination.DestinationStore;
    import github.stompede.broker.destination.MemoryStore;
    import github.stompede.broker.destination.Topic;
    import github.stompede.broker.session.Session;
    import github.stompede.broker.session.SessionStore;
    import github.stompede.broker.session.SessionStoreImpl;
    import github.stompede.server.Server;
    import github.stompede.server.SocketSession;
    import github.stompede.signal.*;
    
    import org.as3commons.logging.ILogger;
    import org.as3commons.logging.LoggerFactory;
    import org.swiftsuspenders.Injector;

    public class BrokerContext implements Service {
        private static var LOG:ILogger = LoggerFactory.getClassLogger(BrokerContext);

        private var m_broker:Broker;

        protected var m_injector:Injector = new Injector();
        protected var isConfigured:Boolean = false;

        [Inject]
        public var signalTracer:SignalTracer;

        public function BrokerContext(serverLocation:URI = null):void {
            m_injector.mapValue(BrokerContext, this);

            if (serverLocation != null)
                this.serverLocation = serverLocation;
        }

        public function set serverLocation(serverLocation:URI):void {
            m_injector.mapValue(URI, serverLocation, "serverLocation");
        }

        protected function mapSignals():void {
            m_injector.mapSingleton(BrokerStartRequested);
            m_injector.mapSingleton(BrokerStopRequested);
            m_injector.mapSingleton(ConnectSignal);
            m_injector.mapSingleton(DisconnectSignal);
            m_injector.mapSingleton(FrameAvailableSignal);
            m_injector.mapSingleton(SendSignal);
            m_injector.mapSingleton(SessionStartedSignal);
            m_injector.mapSingleton(SessionStoppedSignal);
            m_injector.mapSingleton(SubscribeSignal);
            m_injector.mapSingleton(UnsubscribeSignal);
			m_injector.mapSingleton(DestinationStoreStarting);
			m_injector.mapSingleton(DestinationStoreStopping);

        }

        public function getInstance(clazz:Class, named:String = ""):Object {
            return m_injector.getInstance(clazz, named);
        }

        public function instantiate(clazz:Class):Object {
            return m_injector.instantiate(clazz);
        }

        public function start():void {
            if (!m_injector.hasMapping(URI, "serverLocation")) {
                LOG.warn("Server location not configured, using tcp://127.0.0.1:61613");
                serverLocation = new URI("tcp://127.0.0.1:61613");
            }

            mapSignals();

            m_injector.mapValue(Broker, new Broker());

            m_injector.mapSingleton(Server);

            m_injector.mapSingletonOf(SessionStore, SessionStoreImpl);
            m_injector.mapSingletonOf(DestinationStore, MemoryStore);
            m_injector.mapSingletonOf(FrameBus, FrameBusImpl);

            m_injector.mapClass(Session, SocketSession, "SocketSession");
            m_injector.mapClass(Destination, Topic, "Topic");


            if (m_injector.hasMapping(SignalTracer))
                m_injector.injectInto(this);

            m_broker = m_injector.instantiate(Broker) as Broker;
            m_broker.start();
        }

        public function stop():void {
            m_broker.stop();
        }
    }
}