package github.stompede.broker.destination
{
    import de.polygonal.ds.Iterator;
    import de.polygonal.ds.Set;
    
    import flash.utils.ByteArray;
    
    import github.stompede.broker.BrokerContext;
    import github.stompede.broker.session.Session;
    import github.stompede.signal.*;
    
    import org.as3commons.logging.ILogger;
    import org.as3commons.logging.LoggerFactory;

    /* TODO
     * It would be neat to have some sort of global signal triggered once every n seconds
     * that runs "jobs" that have been queued. There is something in SocketSession that
     * already runs on a timer, perhaps it could/should be globalized?
     */
    public class MemoryStore implements DestinationStore
    {
        private static var LOG:ILogger = LoggerFactory.getClassLogger(MemoryStore);

        [Inject]
        public var subscribeSignal:SubscribeSignal;
        [Inject]
        public var unsubscribeSignal:UnsubscribeSignal;
        [Inject]
        public var sendSignal:SendSignal;
        [Inject]
        public var brokerContext:BrokerContext;
		[Inject]
		public var brokerStartRequested:BrokerStartRequested;
		[Inject]
		public var brokerStopRequested:BrokerStartRequested;
		[Inject]
		public var destinationStoreStarting:DestinationStoreStarting;
		[Inject]
		public var destinationStoreStopping:DestinationStoreStopping;
		
        private var destinations:Set = new Set();

        [PostConstruct]
        public function postConstruct():void {
            subscribeSignal.add(onSubscribe);
            unsubscribeSignal.add(onUnsubscribe);
            sendSignal.add(onSend);
        }

        private function onSubscribe(session:Session, destinationName:String):void {
            var destination:Destination = getDestinationForName(destinationName);
            if (destination == null) {
                // Destination semantics here: queue? topic? ... right now we just do topics
                destination = brokerContext.getInstance(Destination, "Topic") as Destination;
                Topic(destination).name = destinationName;
                addDestination(destination);
            }
            destination.addSubscriber(session);
        }

        private function onUnsubscribe(session:Session, destinationName:String):void {
            var destination:Destination = getDestinationForName(destinationName);
            destination.removeSubscriber(session);
        }

        private function onSend(session:Session, destinationName:String, body:ByteArray):void {
            var destination:Destination = getDestinationForName(destinationName);
            if (destination == null) {
                LOG.debug("Message was sent to destination with no subscribers and was not processed further");
                return;
            }

            var message:Message = new Message();
            message.body = body;

            putMessage(destination, message);

        }

        public function addDestination(destination:Destination):void {
            LOG.debug("Adding destination: {0}", destination);
            destinations.set(destination);
        }

        public function removeDestination(destination:Destination):void {
            LOG.debug("Removing destination: {0}", destination);
            destination.dispose();
            destinations.remove(destination);
        }

        public function getDestinationForName(name:String):Destination {
            var itr:Iterator = destinations.getIterator();
            while (itr.hasNext()) {
                var destination:Destination = itr.next() as Destination;
                if (destination.name == name)
                    return destination;
            }
            return null;
        }

        public function putMessage(destination:Destination, message:Message):void {
            message.destination = destination;
            destination.putMessage(message);
            LOG.debug("Message put to destination: {0}, message: {1}", destination, message);
        }
		
		public function start():void {
			destinationStoreStarting.dispatch(this);
		}
		
		public function stop():void {
			destinationStoreStopping.dispatch(this);
		}
    }
}