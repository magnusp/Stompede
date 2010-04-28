package github.stompede.command
{
	import flash.utils.ByteArray;
	
	import github.stompede.broker.ISession;
	
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;

	public class BaseCommand implements ICommand
	{
		private static const LOG:ILogger = LoggerFactory.getClassLogger(BaseCommand);
		protected static const NEWLINE : String = "\n";
		protected static const BODY_START : String = "\n\n";
		protected static const NULL_BYTE : int = 0x00;
		
		private var m_body:ByteArray;
		
		public function BaseCommand(command:String=null, headers:Object=null, body:ByteArray=null)
		{
			if(headers!=null)
				this.headers = headers;
			
			if(body!=null)
				this.body = body;
		}
		
		public function set headers(value:Object):void {
			LOG.fatal("Setter should be overriden! Using BaseCommand implementation (no headers set).");
		}
		
		public function set body(value:ByteArray):void {
			LOG.warn("Using BaseCommand implementation. (body is copied)");
			m_body = value;
		}
		
		public function get body():ByteArray {
			return m_body;
		}
		
		public function responseForSession(session:ISession):ByteArray {
			LOG.fatal("Method should be overriden! Using BaseCommand implementation (returning null).");
			return null;
		}
	}
}