package github.stompede.signal
{
    import github.stompede.broker.session.Session;
    import github.stompede.protocol.Frame;

    import org.osflash.signals.Signal;

    public class FrameAvailableSignal extends Signal
    {
        public function FrameAvailableSignal()
        {
            super(Frame, Session);
        }
    }
}