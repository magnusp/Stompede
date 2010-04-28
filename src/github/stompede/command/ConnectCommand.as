package github.stompede.command
{
	import flash.utils.ByteArray;
	
	import github.stompede.broker.ISession;
	
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.rxr.utils.ByteArrayReader;

	public class ConnectCommand extends BaseCommand implements ICommand
	{
		private static const LOG:ILogger = LoggerFactory.getClassLogger(ConnectCommand);
		public static const NAME:String = "CONNECT";
		
		/* Cosmetics and experimental. It could be nice to assign an
		 * anonymous user so that handling is consistent - there are
		 * only authenticated users.
		*/
		public static var DEFAULT_ANONYMOUS_LOGIN:String = "anonymous";
		public static var DEFAULT_ANONYMOUS_PASSCODE:String = "anonymous";
		// TODO What is an reasonable default?
		public static var USE_DEFAULT_ANONYMOUS:Boolean = false;
		
		private var m_login:String;
		private var m_passcode:String;
		
		override public function set headers(value:Object):void {
			try {
				m_login = value.login;
				m_passcode = value.passcode;	
			} catch (e:Error) {
			} finally {
				if(m_login==null && m_passcode == null) {
					m_login = DEFAULT_ANONYMOUS_LOGIN;
					m_passcode = DEFAULT_ANONYMOUS_PASSCODE;
				}
			}
		}
		
		override public function responseForSession(session:ISession):ByteArray {
			var ba:ByteArray = new ByteArray();
			ba.writeUTFBytes("CONNECTED\n");
			ba.writeUTFBytes("session: " + session.uid + "\n");
			ba.writeUTFBytes(BODY_START);
			ba.writeByte(NULL_BYTE);
			return ba;
		}
	}
}