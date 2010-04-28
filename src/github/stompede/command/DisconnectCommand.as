package github.stompede.command
{
	import flash.utils.ByteArray;
	
	import github.stompede.broker.ISession;
	
	public class DisconnectCommand extends BaseCommand implements ICommand
	{
		public static const NAME:String = "DISCONNECT";
		
		override public function responseForSession(session:ISession):ByteArray {
			return null;
		}
	}
}