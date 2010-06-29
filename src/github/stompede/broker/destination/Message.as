package github.stompede.broker.destination
{
    import flash.utils.ByteArray;

    public class Message
    {
        private static var messageIdCounter:uint = 0;
        private var m_destination:Destination;
        private var m_body:ByteArray;
        private var m_messageId:uint;

        public function Message() {
            m_messageId = Message.messageIdCounter++;
        }

        public function get messageId():String {
            return "mid-".concat(m_messageId);
        }

        public function set destination(destination:Destination):void {
            m_destination = destination;
        }

        public function set body(body:ByteArray):void {
            m_body = body;
        }

        public function get body():ByteArray {
            return m_body;
        }
    }
}