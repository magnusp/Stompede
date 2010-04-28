package github.stompede.broker
{
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;

	public class SocketJob
	{
		public var socket:Socket;
		public var data:ByteArray;
		
		public function SocketJob(socket:Socket, byteArray:ByteArray)
		{
			this.socket = socket;
			this.data = byteArray;
		}

	}
}