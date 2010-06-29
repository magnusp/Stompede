package github.stompede.signal
{
    import flash.utils.ByteArray;

    import github.stompede.broker.session.Session;

    import org.osflash.signals.Signal;

    public class SendSignal extends Signal
    {
        public function SendSignal()
        {
            super(Session, String, ByteArray);
        }
    }
}