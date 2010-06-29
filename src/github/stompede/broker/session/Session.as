package github.stompede.broker.session
{
    import github.stompede.broker.Service;
    import github.stompede.protocol.Frame;

    public interface Session extends Service
    {
        function dispatch(frame:Frame):void;

        function get sessionId():String;

        function set sessionId(sessionId:String):void;
    }
}