package github.stompede.broker.session
{
    import github.stompede.protocol.Frame;
    import github.stompede.signal.*;

    public class BaseSession implements Session
    {
        [Inject]
        public var sessionStartedSignal:SessionStartedSignal;
        [Inject]
        public var sessionStoppedSignal:SessionStoppedSignal;
        [Inject]
        public var frameAvailableSignal:FrameAvailableSignal;

        private var m_sessionId:String;

        public function dispatch(frame:Frame):void {
            // Should be overriden
        }

        public function set sessionId(sessionId:String):void {
            m_sessionId = sessionId;
        }

        public function get sessionId():String {
            return m_sessionId;
        }

        public function start():void
        {
            sessionStartedSignal.dispatch(this);
        }

        public function stop():void
        {
            sessionStoppedSignal.dispatch(this);
        }
    }
}