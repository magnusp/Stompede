package github.stompede.signal
{
	import github.stompede.broker.destination.DestinationStore;
	
	import org.osflash.signals.Signal;
	
	public class DestinationStoreStopping extends Signal
	{
		public function DestinationStoreStopping()
		{
			super(DestinationStore);
		}
	}
}