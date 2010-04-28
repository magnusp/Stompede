package github.stompede.broker
{
	import flash.utils.IDataOutput;

	public interface ISession
	{
		function set uid(value:String):void;
		function set output(value:IDataOutput):void;
		function get output():IDataOutput;
		function get broker():Broker;
		function get uid():String;
	}
}