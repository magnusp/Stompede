package github.stompede.server
{

	public class ServerConfiguration implements IServerConfiguration
	{
		public function get localPort():int {
			return 61613;
		}
		
		public function get localAddress():String {
			return "127.0.0.1";
		}
		
		public function get backlog():int {
			return 0;
		}
	}
}