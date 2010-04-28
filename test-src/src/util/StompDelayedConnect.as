package util
{
	import flash.events.TimerEvent;
	import flash.net.Socket;
	import flash.utils.Timer;
	
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.codehaus.stomp.Stomp;
	import org.codehaus.stomp.headers.ConnectHeaders;

	public class StompDelayedConnect extends Stomp
	{
		private static const LOG:ILogger= LoggerFactory.getClassLogger(StompDelayedConnect);
		private var m_delay:Number;
		private var m_server:String;
		private var m_port:int;
		private var m_connectHeaders:ConnectHeaders;
		private var m_socket:Socket;
		
		public function StompDelayedConnect(delay:Number=50)
		{
			super();
			m_delay = delay;
		}
		
		override public function connect(server:String="localhost", port:int=61613, connectHeaders:ConnectHeaders=null, socket:Socket=null):void {
			m_server = server;
			m_port = port;
			m_connectHeaders = connectHeaders;
			m_socket = socket;
			
			var t:Timer = new Timer(m_delay, 1);
			t.addEventListener(TimerEvent.TIMER, handleTimer);
			t.start();
			LOG.warn("Stomp {0}ms delayed connect", m_delay);
		}
		
		private function handleTimer(e:TimerEvent):void {
			Timer(e.target).removeEventListener(TimerEvent.TIMER, handleTimer);
			
			super.connect(m_server, m_port, m_connectHeaders, m_socket);
		}
	}
}