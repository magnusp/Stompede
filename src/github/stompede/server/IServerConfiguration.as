package github.stompede.server
{
	public interface IServerConfiguration
	{
		function get localPort():int;
		function get localAddress():String;
		function get backlog():int;
	}
}