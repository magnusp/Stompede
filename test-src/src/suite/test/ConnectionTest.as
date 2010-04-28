package suite.test
{
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import github.stompede.server.ServerConfiguration;
	import github.stompede.broker.Broker;
	import github.stompede.server.TCPServer;
	import github.stompede.command.CommandResolver;
	import github.stompede.command.ConnectCommand;
	
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.codehaus.stomp.Stomp;
	import org.codehaus.stomp.event.ConnectedEvent;
	import org.codehaus.stomp.headers.ConnectHeaders;
	import org.flexunit.async.Async;
	
	public class ConnectionTest
	{
		private static const LOG:ILogger = LoggerFactory.getClassLogger(ConnectionTest);
		private var stompede:Broker;
		private var server:TCPServer;
		private var stomp:Stomp;
		private var connectHeaders:ConnectHeaders;
		
		[Before]
		public function setup():void {
			CommandResolver.register("CONNECT", ConnectCommand);
		}
		
		[After]
		public function tearDown():void {
			stompede.stop();
		}
		
		[Test(async)]
		public function authenticatedConnection():void {
			server = new TCPServer();
			server.configuration = new ServerConfiguration();
			
			stompede = new Broker();
			stompede.tcpServer = server;
			
			stompede.postconstruct();
			
			stomp = new Stomp();
			connectHeaders = new ConnectHeaders();
			connectHeaders.login = "login";
			connectHeaders.passcode = "passcode";
			
			stomp.connect("127.0.0.1", 61613, connectHeaders);
			
			Async.proceedOnEvent(this, stomp, ConnectedEvent.CONNECTED,500);
		}		
	}
}