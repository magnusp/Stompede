package github.stompede.destination
{
	import de.polygonal.ds.SLL;
	import de.polygonal.ds.Set;
	
	import flash.utils.ByteArray;
	
	import github.stompede.broker.ISession;

	public interface IDestination
	{
		function put(data:ByteArray):void;
		function set name(value:String):void;
		function get name():String
		function get subscribers():Set;
		function addSubscriber(session:ISession):void;
		function removeSubscriber(session:ISession):void;
	}
}