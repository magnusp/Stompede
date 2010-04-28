package github.stompede.broker
{
	import flash.net.Socket;
	import flash.utils.ByteArray;
	import flash.utils.IDataOutput;
	
	import github.stompede.broker.ISession;
	import github.stompede.command.CommandResolver;
	import github.stompede.command.ICommand;
	
	import org.as3commons.logging.ILogger;
	import org.as3commons.logging.LoggerFactory;
	import org.as3commons.reflect.ClassUtils;
	import org.as3commons.reflect.Type;
	import org.codehaus.stomp.FrameReader;
	import org.rxr.utils.ByteArrayReader;
	import github.stompede.destination.IDestinationStoreAware;
	
	public class SocketProcessor implements ISocketProcessor
	{
		private static const LOG:ILogger = LoggerFactory.getClassLogger(SocketProcessor);
		
		/* Consider doing async processing. There might be things down the
		 * line which queries remote services/databases asynced.
		*/
		public function process(data:ByteArray, session:ISession):ByteArray
		{
			LOG.info("Processing socket data");
			var fr:FrameReader = new FrameReader(new ByteArrayReader(data));
			fr.processBytes();

			if(LOG.debugEnabled) {
				var headerString:String = "{ ";
				for(var key:String in fr.headers) {
					headerString+="\"" + key+":"+fr.headers[key]+"\", ";
				}
				if(headerString.length > 0) {
					headerString = headerString.slice(0, headerString.length-2);
				}
				headerString+=" }";
				LOG.debug("Incoming frame [ command { {0} }, headers {1} ]", fr.command, headerString);
				
			}
			var out:ByteArray;
			try {
				var command:ICommand = CommandResolver.resolve(fr.command, fr.headers, fr.body);
				
				if(ClassUtils.isImplementationOf(ClassUtils.forInstance(command), IDestinationStoreAware)) {
					IDestinationStoreAware(command).destinationStore = Broker.destinationStore;
				}
					
				LOG.debug("Command resolved as {0}", org.as3commons.reflect.Type.forInstance(command).name);
				out = command.responseForSession(session);
			} catch (e:Error) { // Need to catch unimplemented commands
				LOG.fatal(e.message);
				LOG.fatal(e.getStackTrace());
			} finally {
				LOG.debug("Returning bytearray response");
				return out;					
			}
		}
	}
}