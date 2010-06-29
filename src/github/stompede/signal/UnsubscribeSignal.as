package github.stompede.signal
{
    import github.stompede.broker.session.Session;

    import org.osflash.signals.Signal;

    public class UnsubscribeSignal extends Signal
    {
        public function UnsubscribeSignal()
        {
            super(Session, String);
        }
    }
}