package github.stompede.broker.destination
{
	import github.stompede.broker.Service;

    public interface DestinationStore extends Service
    {
        function addDestination(destination:Destination):void;

        function removeDestination(destination:Destination):void;

        function putMessage(destination:Destination, message:Message):void;
    }
}