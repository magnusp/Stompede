package github.stompede.signal
{
    import github.stompede.broker.session.Session;

    import org.osflash.signals.Signal;

    public class SessionStartedSignal extends Signal
    {
        public function SessionStartedSignal()
        {
            super(Session);
        }
    }
}