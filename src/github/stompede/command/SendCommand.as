package github.stompede.command
{
	import flash.utils.ByteArray;
	
	import github.stompede.broker.ISession;
	import github.stompede.destination.IDestination;
	import github.stompede.destination.IDestinationStore;
	import github.stompede.destination.IDestinationStoreAware;
	
	import mx.utils.UIDUtil;
	
	public class SendCommand extends BaseCommand implements ICommand, IDestinationStoreAware
	{
		public static const NAME:String = "SEND";
		
		protected var m_destination:String;
		protected var m_destinationStore:IDestinationStore;
		
		override public function set headers(value:Object):void {
			m_destination = value.destination; 
		}
		
		override public function responseForSession(session:ISession):ByteArray {
			if(m_destinationStore != null) {
				var destination:IDestination = m_destinationStore.get(m_destination);
				
				// TODO Allow post-processing of messages?
				var ba:ByteArray = new ByteArray();
				ba.writeUTFBytes("MESSAGE" + NEWLINE);
				ba.writeUTFBytes("destination:" + destination.name + NEWLINE);
				ba.writeUTFBytes("message-id:123" + NEWLINE);
				//ba.writeUTFBytes("content-length:"+ body.length + NEWLINE);
				ba.writeUTFBytes(BODY_START);
				ba.writeUTFBytes("This is a test message");
				ba.writeByte(NULL_BYTE);
				trace(ba.position);
				ba.position = 0;
				
				
				destination.put(ba);
			}
			
			return null;
		}
		
		public function set destinationStore(value:IDestinationStore):void {
			m_destinationStore = value;
		}
	}
}