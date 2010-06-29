package github.stompede.server
{
    import com.adobe.net.URI;

    import flash.events.ServerSocketConnectEvent;
    import flash.net.ServerSocket;

    import github.stompede.broker.Broker;
    import github.stompede.broker.BrokerContext;
    import github.stompede.broker.session.Session;
    import github.stompede.signal.BrokerStartRequested;
    import github.stompede.signal.BrokerStopRequested;

    import org.as3commons.logging.ILogger;
    import org.as3commons.logging.LoggerFactory;

    public class Server
    {
        private static var LOG:ILogger = LoggerFactory.getClassLogger(Server);

        [Inject(name='serverLocation')]
        public var serverLocation:URI;
        [Inject]
        public var broker:Broker;
        [Inject]
        public var brokerContext:BrokerContext;
        [Inject]
        public var brokerStartRequested:BrokerStartRequested;
        [Inject]
        public var brokerStopRequested:BrokerStopRequested;

        private var m_serverSocket:ServerSocket;

        [PostConstruct]
        public function postConstruct():void {
            brokerStartRequested.addOnce(start);
        }

        protected function onSocketConnect(e:ServerSocketConnectEvent):void {
            LOG.debug("Socket connected - {0}:{1}", e.socket.remoteAddress, e.socket.remotePort);

            var session:SocketSession = brokerContext.getInstance(Session, "SocketSession") as SocketSession;
            session.socket = e.socket;
            session.start();
        }

        public function start():void {
			brokerStopRequested.addOnce(stop);
            if (m_serverSocket == null)
                m_serverSocket = new ServerSocket();

            var authority:String = serverLocation.authority;
            var port:Number = Number(serverLocation.port);
            m_serverSocket.addEventListener(ServerSocketConnectEvent.CONNECT, onSocketConnect);
            m_serverSocket.bind(port, authority);
            m_serverSocket.listen();
            LOG.info("Serversocket listening on {0}:{1}", authority, port);
        }

        public function stop():void {
			brokerStartRequested.addOnce(start);
            m_serverSocket.removeEventListener(ServerSocketConnectEvent.CONNECT, onSocketConnect);
            m_serverSocket.close();
            LOG.info("Serversocket stopped");
        }
    }
}