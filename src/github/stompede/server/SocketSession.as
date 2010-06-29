package github.stompede.server
{
    import de.polygonal.ds.LinkedQueue;
    
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.events.TimerEvent;
    import flash.net.Socket;
    import flash.utils.ByteArray;
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;
    import flash.utils.Timer;
    
    import github.stompede.broker.session.BaseSession;
    import github.stompede.protocol.Frame;
    import github.stompede.signal.BrokerStopRequested;
    
    import org.as3commons.logging.ILogger;
    import org.as3commons.logging.LoggerFactory;

    public class SocketSession extends BaseSession
    {
        private static var LOG:ILogger = LoggerFactory.getClassLogger(SocketSession);
		
		[Inject]
		public var brokerStopRequested:BrokerStopRequested;
		
        private static var packetQueue:LinkedQueue = new LinkedQueue();
        private static var m_jobTimer:Timer = new Timer(10);

        private var m_remoteAddress:String;
        private var m_remotePort:uint;

        public var socket:Socket;

		[PostConstruct]
		public function postConstruct():void {
			brokerStopRequested.addOnce(stop);
		}
		
        private function onJobTimer(event:TimerEvent):void {
            while (SocketSession.packetQueue.size > 0) {
                var job:Object = SocketSession.packetQueue.dequeue();
                job.session.processData(job.data as IDataInput);
            }
        }

        override public function start():void {
            if (socket == null)
                throw new Error("Unable to start SocketSession, no socket?");

            // TODO Somehow manage this timer so that it doesnt run when there are no started sessions
            if (!m_jobTimer.running) {
				if(!m_jobTimer.hasEventListener(TimerEvent.TIMER))
                	SocketSession.m_jobTimer.addEventListener(TimerEvent.TIMER, onJobTimer);
                SocketSession.m_jobTimer.start();
            }

            m_remoteAddress = socket.remoteAddress;
            m_remotePort = socket.remotePort;

            socket.addEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
            socket.addEventListener(Event.CLOSE, onSocketClose);

            super.start();
        }

        override public function stop():void {
            socket.removeEventListener(ProgressEvent.SOCKET_DATA, onSocketData);
            socket.removeEventListener(Event.CLOSE, onSocketClose);
			if(socket.connected)
				socket.close();
			
            super.stop();
        }

        protected function onSocketData(e:ProgressEvent):void {
            LOG.debug("Socket data recieved from {0}:{1}", Socket(e.target).remoteAddress, Socket(e.target).remotePort);
            var packet:Object = {session:this, data: new ByteArray()};

            var s:Socket = e.target as Socket;

            s.readBytes(packet.data, 0, s.bytesAvailable);
            ByteArray(packet.data).position = 0;
            SocketSession.packetQueue.enqueue(packet);
        }

        protected function onSocketClose(e:Event):void {
            LOG.debug("Remote socket closed: {0}:{1}", m_remoteAddress, m_remotePort);
            stop();
        }

        protected function processData(data:IDataInput):void {
            var frame:Frame = Frame.unmarshal(data);
            if (frame != null) {
                LOG.debug("In {0}", frame.toString());
                frameAvailableSignal.dispatch(frame, this);
            }
        }

        public function toString():String {
            return "[SocketSession remoteAddress: ".concat(m_remoteAddress).concat(", remotePort: ").concat(m_remotePort).concat("]");
        }

        override public function dispatch(frame:Frame):void {
            if (!socket.connected) {
                LOG.debug("Attempted to dispatch a frame to an unconnected socket, ignoring further processing");
                return;
            }

            Frame.marshal(frame, socket as IDataOutput);
            LOG.debug("Out {0}", frame.toString());
        }
    }
}