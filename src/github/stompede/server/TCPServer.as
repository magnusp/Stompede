package github.stompede.server
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.ServerSocketConnectEvent;
	import flash.net.ServerSocket;
	
	import mx.events.DynamicEvent;
	import mx.utils.UIDUtil;
	
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;

	
	public class TCPServer extends EventDispatcher
	{
		private static const LOG:ILogger = LoggerFactory.getClassLogger(TCPServer);
		
		private var m_serverSocket:ServerSocket;
		private var m_serverConfiguration:IServerConfiguration;
		
		public function set configuration(value:IServerConfiguration):void {
			m_serverConfiguration = value;
		}
				
		public function start():void {
			if(m_serverSocket == null) {
				m_serverSocket = new ServerSocket();
			}

			// TODO Weak reference here, perhaps?
			m_serverSocket.addEventListener(ServerSocketConnectEvent.CONNECT, function(e:ServerSocketConnectEvent):void { dispatchEvent(e) });
			m_serverSocket.bind(m_serverConfiguration.localPort, m_serverConfiguration.localAddress);
			m_serverSocket.listen(m_serverConfiguration.backlog);
			LOG.info("TCPServer listening on {0}:{1}",
				m_serverSocket.localAddress,
				m_serverSocket.localPort
			);
		}
		
		public function stop():void {
			if(m_serverSocket.bound)
				m_serverSocket.close();
			
			LOG.info("TCPServer stopped");
		}
	}
}