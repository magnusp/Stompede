package github.stompede.protocol {
    import de.polygonal.ds.HashMap;

    import flash.utils.ByteArray;
    import flash.utils.IDataInput;
    import flash.utils.IDataOutput;

    public class Frame {
        public var command:String;
        public var headers:HashMap;
        public var body:ByteArray;

        public function Frame(command:String, headers:HashMap = null, body:ByteArray = null) {
            this.command = command;
            this.headers = headers;
            this.body = body;
        }

        public static function marshal(frame:Frame, out:IDataOutput):void {
            var ba:ByteArray = frame.toFrameByteArray();
            out.writeBytes(ba, 0, ba.bytesAvailable);
        }

        public static function unmarshal(inData:IDataInput):Frame {
            return FrameReader.fromDataInput(inData);
        }

        private function toFrameByteArray():ByteArray {
            var ba:ByteArray = new ByteArray();
            ba.writeUTFBytes(command + "\n");

            if (headers.size > 0) {
                for each(var key:String in headers.getKeySet()) {
                    //headerString = headerString.concat(key, ": ", headers.find(key), ", ");
                    ba.writeUTFBytes(key.concat(":").concat(headers.find(key)).concat("\n"));
                }

                /*var itr:Iterator = headers.getIterator();
                 while(itr.hasNext()) {
                 var key:String = itr.next() as String;
                 ba.writeUTFBytes(key + ":" + headers.find(key) + "\n");
                 }*/
            }

            if (body != null) {
                body.position = 0;
                ba.writeUTFBytes("content-length: " + body.length + "\n");
            }
            ba.writeUTFBytes("\n");
			if(body!=null)
            	ba.writeBytes(body);
            ba.writeByte(0);

            ba.position = 0;
            return ba;
        }

        public function toString():String {
            var buffer:String = "";
            buffer = buffer.concat("[Frame command: ", command);

            if (body != null) {
                body.position = 0;
                if (body.length > 0) {
                    buffer = buffer.concat(", content length: ", body.length);
                }
            }

            var headerString:String;
            if (!headers.isEmpty()) {
                headerString = "{ ";
                for each(var key:String in headers.getKeySet()) {
                    headerString = headerString.concat(key, ": ", headers.find(key), ", ");
                }

                // TODO Hehe, yeah..
                buffer = buffer.concat(", headers: ", headerString.length > 1 ? headerString.substr(0, headerString.length - 2) : "!!!ERROR!!!", " }");
            }

            buffer = buffer.concat("]");

            return buffer;
        }
    }
}

import de.polygonal.ds.HashMap;

import flash.utils.ByteArray;
import flash.utils.IDataInput;

import github.stompede.protocol.Frame;
import github.stompede.protocol.StompInvalidContentLength;
import github.stompede.protocol.StompNonTerminatedFrame;
import github.stompede.util.StringUtils;

import org.rxr.utils.ByteArrayReader;

internal class FrameReader {
    internal var reader:ByteArrayReader;
    private static const NEWLINE:uint = 10;
    public var command:String;
    public var headers:HashMap = new HashMap();
    public var body:ByteArray;
    private var isComplete:Boolean = false;

    public function FrameReader() {
    }

    public static function fromDataInput(data:IDataInput):Frame {
        var frameReader:FrameReader = new FrameReader();
        frameReader.reader = new ByteArrayReader(data);
        frameReader.processBytes();
        if (frameReader.isComplete)
            return new Frame(frameReader.command, frameReader.headers, frameReader.body)

        return null;
    }

    // TODO Look over this (and the class in general)
    protected function processBytes():void {
        command = reader.readLine().toUpperCase();
        if (reader.peek(0) != NEWLINE)
            processHeaders();

        reader.forward();
        if (reader.bytesAvailable > 0 && reader.peek(0) != 0)
            processBody(Number(headers.find("content-length") ? headers.find("content-length") : -1));
        else if (reader.peek(0) == 0) {
            isComplete = true;
        }
    }

    protected function processHeaders():void {
        do {
            var array:Array = reader.readLine().split(":");

            headers.insert(StringUtils.trim(array[0]).toLowerCase(), StringUtils.trim(array[1]).toLowerCase());
        } while (reader.peek(0) != NEWLINE);
    }

    protected function processBody(lengthToRead:int = -1):void {
        body = new ByteArray();

        if (lengthToRead == -1) {
            body.writeBytes(reader.readUntilByte(0));
        } else {
            try {
                body.writeBytes(reader.readFor(lengthToRead));
            } catch(error:Error) {
                throw new StompInvalidContentLength();
            }
            if (reader.peek(0) != 0)
                throw new StompNonTerminatedFrame();
        }
        isComplete = true;
        body.position = 0;
    }
}
