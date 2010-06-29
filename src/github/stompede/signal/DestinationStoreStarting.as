package github.stompede.signal
{
	import github.stompede.broker.destination.DestinationStore;
	
	import org.osflash.signals.Signal;
	
	public class DestinationStoreStarting extends Signal
	{
		public function DestinationStoreStarting()
		{
			super(DestinationStore);
		}
	}
}