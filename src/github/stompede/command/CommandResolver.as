package github.stompede.command
{
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.as3commons.reflect.ClassUtils;
	import org.as3commons.reflect.Type;

	public class CommandResolver
	{
		private static const LOG:ILogger = LoggerFactory.getClassLogger(CommandResolver);
		
		private static var registry:Dictionary;
		
		public static function resolve(command:String, headers:Object, body:ByteArray):ICommand
		{
			var clazz:Class = registry[command];
			if(clazz==null)
				throw new Error("Command for \"" + command + "\" not in registry");
			
			var commandInstance:ICommand = new clazz();
			commandInstance.headers = headers;
			commandInstance.body = body;
			return commandInstance;
		}
		
		public static function register(command:String, commandClass:Class):void {
			command = command.toUpperCase();
			
			if(registry == null) {
				LOG.warn("CommandResolver registry was null, creating default Dictionary instance");
				registry = new Dictionary();
			}
			
			if(LOG.infoEnabled) {
				LOG.info("Registering {0} for command \"{1}\"", org.as3commons.reflect.Type.forClass(commandClass).fullName, command);
			}
			registry[command] = commandClass;
		}
	}
}