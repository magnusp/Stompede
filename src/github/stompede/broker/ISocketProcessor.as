package github.stompede.broker
{
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.IDataOutput;
	
	/* A socket processor does something which results in an IDataOutput which is written out
	 * as a response to the client socket
	*/
	public interface ISocketProcessor
	{
		function process(data:ByteArray, session:ISession):ByteArray;
	}
}