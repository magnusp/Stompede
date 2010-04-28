package github.stompede.command
{
	import flash.utils.ByteArray;
	
	import github.stompede.broker.ISession;

	public interface ICommand
	{
		function responseForSession(session:ISession):ByteArray;
		function set headers(value:Object):void;
		function set body(value:ByteArray):void;
	}
}