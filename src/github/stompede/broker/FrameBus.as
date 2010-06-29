package github.stompede.broker
{
    import github.stompede.signal.FrameAvailableSignal;

    public interface FrameBus
    {
        function set frameAvailableSignal(frameAvailableSignal:FrameAvailableSignal):void;

        function get frameAvailableSignal():FrameAvailableSignal;
    }
}