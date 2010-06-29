package github.stompede.broker
{
    import github.stompede.broker.destination.DestinationStore;
    import github.stompede.broker.session.SessionStore;
    import github.stompede.server.Server;
    import github.stompede.signal.BrokerStartRequested;
    import github.stompede.signal.BrokerStopRequested;

    public class Broker implements Service
    {
        [Inject]
        public var server:Server;
        [Inject]
        public var sessionStore:SessionStore;
        [Inject]
        public var frameBus:FrameBus;
        [Inject]
        public var destinationStore:DestinationStore;
        [Inject]
        public var brokerStartRequested:BrokerStartRequested;
        [Inject]
        public var brokerStopRequested:BrokerStopRequested;

        public function Broker():void {
        }

        public function start():void {
            brokerStartRequested.dispatch();
        }

        public function stop():void {
            brokerStopRequested.dispatch();
        }
    }
}