package github.stompede.command
{
	import flash.utils.ByteArray;
	
	import github.stompede.broker.ISession;
	import github.stompede.destination.IDestination;
	import github.stompede.destination.IDestinationStore;
	import github.stompede.destination.IDestinationStoreAware;
	
	public class UnsubscribeCommand extends BaseCommand implements ICommand, IDestinationStoreAware
	{
		public static const NAME:String = "UNSUBSCRIBE";
		
		protected var m_destination:String;
		protected var m_destinationStore:IDestinationStore;
		
		override public function set headers(value:Object):void {
			m_destination = value.destination;
		}
		
		override public function responseForSession(session:ISession):ByteArray {
			if(m_destinationStore != null) {
				var destination:IDestination = m_destinationStore.get(m_destination);
				destination.removeSubscriber(session);
			}
			
			return null;
		}
		
		public function set destinationStore(value:IDestinationStore):void {
			m_destinationStore = value;
		}
	}
}