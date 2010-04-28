package org.codehaus.stomp
{
	import flash.utils.ByteArray;
	import flash.utils.IDataInput;
	
	import org.rxr.utils.ByteArrayReader;

	public class FrameReader {
		
		private var reader : ByteArrayReader;
		private var frameComplete: Boolean = false;
		private var contentLength: int = -1;
		
		public var command : String;
		public var headers : Object;
		public var body : ByteArray = new ByteArray();
		private var bodyProcessed:Boolean = false;
		
		public function get isComplete(): Boolean
		{
			return frameComplete;
		}
		
		public function readBytes(data: IDataInput): void
		{
			data.readBytes(reader, reader.length, data.bytesAvailable);
			processBytes();
		}
		
		public function processBytes(): void
		{
			if (!command && reader.scan(0x0A) != -1)
				processCommand();
			
			if (command && !headers && reader.indexOfString("\n\n") != -1)
				processHeaders();
			
			if (command && headers && (bodyProcessed=bodyComplete()))
				processBody();
			
			if (command && headers && bodyProcessed)
				frameComplete = true;
		}
		
		private function processCommand(): void
		{
			command = reader.readLine();
		}
		
		private function processHeaders(): void
		{
			headers = new Object();
			
			var headerString : String = reader.readUntilString("\n\n");
			var headerValuePairs : Array = headerString.split("\n");
			
			for each (var pair : String in headerValuePairs) 
			{
				var separator : int = pair.indexOf(":");
				headers[pair.substring(0, separator)] = pair.substring(separator+1);
			}
			
			if(headers["content-length"])
				contentLength = headers["content-length"];
			
			reader.forward();
		}
		
		private function processBody(): void
		{
			while (reader.bytesAvailable > 0 && reader.peek(0x00) <= 27) {
				reader.forward();
			}
			body.position=0;
		}
		
		private function bodyComplete() : Boolean 
		{
			if(contentLength != -1) 
			{
				const len: int = body.length;
				if(contentLength > reader.bytesAvailable + len) 
				{
					body.writeBytes(reader.readFor(reader.bytesAvailable));
					return false;
				} 
				else 
				{
					body.writeBytes(reader.readFor(contentLength - len));
				}
			} 
			else 
			{
				var nullByteIndex: int = reader.scan(0x00);
				if(nullByteIndex != -1) 
				{
					if (nullByteIndex > 0) 
						body.writeBytes(reader.readFor(nullByteIndex));	
					
					contentLength = body.length;
				} 
				else 
				{
					body.writeBytes(reader.readFor(reader.bytesAvailable));
					return false;
				}
			}
			return true;
		}
		
		public function FrameReader(reader: ByteArrayReader): void
		{
			this.reader = reader;
			processBytes();
		}
	}
}