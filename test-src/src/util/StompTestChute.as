package util
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	
	import org.codehaus.stomp.Stomp;
	import org.codehaus.stomp.event.ConnectedEvent;
	import org.codehaus.stomp.event.MessageEvent;
	import org.codehaus.stomp.event.ReceiptEvent;
	import org.codehaus.stomp.event.ReconnectFailedEvent;
	import org.codehaus.stomp.event.STOMPErrorEvent;

	public class StompTestChute
	{
		public static function attach(stomp:Stomp):void {
			stomp.addEventListener(ConnectedEvent.CONNECTED, nullHandler);
			stomp.addEventListener(Event.ACTIVATE, nullHandler);
			stomp.addEventListener(Event.DEACTIVATE, nullHandler);
			stomp.addEventListener(IOErrorEvent.IO_ERROR, nullHandler);
			stomp.addEventListener(MessageEvent.MESSAGE, nullHandler);
			stomp.addEventListener(ReceiptEvent.RECEIPT, nullHandler);
			stomp.addEventListener(ReconnectFailedEvent.RECONNECT_FAILED, nullHandler);
			stomp.addEventListener(SecurityErrorEvent.SECURITY_ERROR, nullHandler);
			stomp.addEventListener(STOMPErrorEvent.ERROR, nullHandler);			
		}
		
		public static function detach(stomp:Stomp):void {
			stomp.removeEventListener(ConnectedEvent.CONNECTED, nullHandler);
			stomp.removeEventListener(Event.ACTIVATE, nullHandler);
			stomp.removeEventListener(Event.DEACTIVATE, nullHandler);
			stomp.removeEventListener(IOErrorEvent.IO_ERROR, nullHandler);
			stomp.removeEventListener(MessageEvent.MESSAGE, nullHandler);
			stomp.removeEventListener(ReceiptEvent.RECEIPT, nullHandler);
			stomp.removeEventListener(ReconnectFailedEvent.RECONNECT_FAILED, nullHandler);
			stomp.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, nullHandler);
			stomp.removeEventListener(STOMPErrorEvent.ERROR, nullHandler);
		}
		
		public static function nullHandler(o:*):void {}
	}
}