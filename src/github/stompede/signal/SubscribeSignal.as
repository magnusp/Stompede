package github.stompede.signal
{
    import github.stompede.broker.session.Session;

    import org.osflash.signals.Signal;

    public class SubscribeSignal extends Signal
    {
        public function SubscribeSignal()
        {
            super(Session, String);
        }
    }
}