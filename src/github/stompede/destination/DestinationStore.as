package github.stompede.destination
{
	import de.polygonal.ds.HashMap;

	public class DestinationStore implements IDestinationStore
	{
		protected var destinations:HashMap;
		
		public function get(name:String):IDestination
		{
			if(destinations == null)
				destinations = new HashMap();
			
			var destination:IDestination = destinations.get(name) as IDestination;
			if(destination == null) {
				destination = new Destination();
				destination.name = name;
				destinations.set(name, destination);
			}
			return destination;
		}
	}
}