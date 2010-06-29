package github.stompede.protocol
{
    public class FrameConst
    {
        // Commands
        public static const CONNECT:String = "CONNECT";
        public static const DISCONNECT:String = "DISCONNECT";
        public static const CONNECTED:String = "CONNECTED";
        public static const SEND:String = "SEND";
        public static const MESSAGE:String = "MESSAGE";
        public static const SUBSCRIBE:String = "SUBSCRIBE";
        public static const UNSUBSCRIBE:String = "UNSUBSCRIBE";

        // Headers
        public static const LOGIN:String = "login";
        public static const PASSCODE:String = "passcode";
        public static const SESSIONID:String = "session-id";
        public static const DESTINATION:String = "destination";
        public static const MESSAGEID:String = "message-id";
    }
}