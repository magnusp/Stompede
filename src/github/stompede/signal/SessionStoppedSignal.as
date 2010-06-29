package github.stompede.signal
{
    import github.stompede.broker.session.Session;

    import org.osflash.signals.Signal;

    public class SessionStoppedSignal extends Signal
    {
        public function SessionStoppedSignal()
        {
            super(Session);
        }
    }
}