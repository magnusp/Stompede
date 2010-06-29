package github.stompede.signal
{
    import github.stompede.broker.session.Session;

    import org.osflash.signals.Signal;

    public class DisconnectSignal extends Signal
    {
        public function DisconnectSignal()
        {
            super(Session);
        }
    }
}