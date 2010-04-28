package github.stompede.broker
{
	import flash.net.Socket;
	import flash.utils.IDataOutput;
	
	import org.codehaus.stomp.FrameReader;

	public class Session implements ISession
	{
		protected var m_uid:String;
		protected var m_output:IDataOutput;
		
		public function Session(uid:String=null)
		{
			m_uid = uid;
		}
		
		public function set output(value:IDataOutput):void {
			m_output = value;
		}
		
		public function get output():IDataOutput {
			return m_output;
		}
		
		public function set uid(value:String):void {
			m_uid = value;
		}
		
		public function get uid():String {
			return m_uid;
		}
		
		public function get broker():Broker {
			return null;
		}
	}
}