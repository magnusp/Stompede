package github.stompede.broker
{
	import de.polygonal.ds.LinkedQueue;
	import de.polygonal.ds.Queue;
	
	import flash.events.ProgressEvent;
	import flash.events.ServerSocketConnectEvent;
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.Timer;
	
	import github.stompede.destination.DestinationStore;
	import github.stompede.destination.IDestinationStore;
	import github.stompede.server.TCPServer;
	
	import mx.utils.UIDUtil;
	
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;

	public class Broker
	{
		private static const LOG:ILogger = LoggerFactory.getClassLogger(Broker);
		public static var destinationStore:IDestinationStore; // TODO Should not be a static
		
		protected var m_sessionPool:Dictionary; // TODO Maybe not a dictionary?
		protected var m_tcpServer:TCPServer;
		protected var socketProcessor:ISocketProcessor;
		protected var jobTimer:Timer;
		
		// Uses the ds (datastructures) lib, docs at http://www.polygonal.de/doc/
		protected var jobs:Queue; 
		
		public function set tcpServer(value:TCPServer):void {
			m_tcpServer = value;
		}
		
		[Postconstruct]
		public function postconstruct():void {
			if(destinationStore == null)
				destinationStore = new DestinationStore();
			
			if(m_sessionPool==null)
				m_sessionPool = new Dictionary();
			
			if(socketProcessor==null)
				socketProcessor = new SocketProcessor();
			
			if(jobs==null)
				jobs = new LinkedQueue();
			
			if(jobTimer==null) {
				jobTimer = new Timer(5);
			}
			// TODO Optionally a server can dis/allow a connection based
			// on the properties provided by a Socket object. This could
			// plug in here.
			jobTimer.addEventListener(TimerEvent.TIMER, onJobTimer);
			m_tcpServer.addEventListener(ServerSocketConnectEvent.CONNECT, onSocketConnect);
			
			m_tcpServer.start();
			jobTimer.start();
		}
		
		private function onSocketConnect(e:ServerSocketConnectEvent):void {
			e.socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
			LOG.info("Accepted socket connection from {0}:{1}",
				e.socket.remoteAddress,
				e.socket.remotePort
			);
		}
		
		private function onJobTimer(e:TimerEvent):void {
			if(jobs==null)
				return;
			
			try {
				var socketJob:SocketJob;
				do
				{
					socketJob = jobs.dequeue() as SocketJob;
					var session:ISession = m_sessionPool[socketJob.socket];
					if(session==null) {
						session = new Session(UIDUtil.createUID());
						session.output = socketJob.socket;
						m_sessionPool[socketJob.socket] = session;
						
					}
					
					var output:ByteArray = socketProcessor.process(socketJob.data, session);
					
					if(socketJob.socket.connected==false) {
						LOG.debug("A job has been processed, but the remote socket has closed. Nothing written.");
					} else {
						if(output!=null) {
							socketJob.socket.writeBytes(output);
							socketJob.socket.flush();
							LOG.debug("Response written to remote socket");						
						} else {
							LOG.debug("Response was null, no response sent to client");
						}
					}
				}
				while (socketJob);
			} catch(e:TypeError) {
				
			}
		}

		private function onSocketData(e:ProgressEvent):void {
			var socket:Socket = e.target as Socket;
			var byteArray:ByteArray = new ByteArray();
			socket.readBytes(byteArray);
			
			var socketJob:SocketJob = new SocketJob(socket, byteArray); 
			jobs.enqueue(socketJob);
		}
		
		public function stop():void {
			jobTimer.stop();
			jobTimer.removeEventListener(TimerEvent.TIMER, onJobTimer);
			jobs.clear();
			m_tcpServer.stop();
			m_tcpServer.removeEventListener(ServerSocketConnectEvent.CONNECT, onSocketConnect);
		}
	}
}