package github.stompede.protocol
{
    public class StompInvalidContentLength extends Error
    {
        public function StompInvalidContentLength()
        {
            super("github.stompede.protocol.StompInvalidContentLength: A frame was recieved with a content length beyond the EOF");
        }
    }
}