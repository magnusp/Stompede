package github.stompede.signal
{
    import github.stompede.broker.session.Session;

    import org.osflash.signals.Signal;

    public class ConnectSignal extends Signal
    {
        public function ConnectSignal()
        {
            super(Session, String, String);
        }
    }
}