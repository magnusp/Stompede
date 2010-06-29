package github.stompede.broker.destination
{
    import github.stompede.broker.session.Session;

    public interface Destination
    {
        function get name():String;

        // TODO Should perhaps be something like SubscriberInfo instead of Session
        function addSubscriber(session:Session):void;

        function dispose():void;

        function removeSubscriber(session:Session):void;

        function putMessage(message:Message):void;
    }
}