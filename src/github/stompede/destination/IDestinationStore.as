package github.stompede.destination
{
	public interface IDestinationStore
	{
		function get(name:String):IDestination;
	}
}