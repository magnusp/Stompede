package github.stompede.protocol
{
    public class StompNonTerminatedFrame extends Error
    {
        public function StompNonTerminatedFrame()
        {
            super("github.stompede.protocol.StompNonTerminatedFrame: A frame was recieved without a terminating NUL");
        }
    }
}