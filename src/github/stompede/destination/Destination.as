package github.stompede.destination
{
	import de.polygonal.ds.HashMap;
	import de.polygonal.ds.Itr;
	import de.polygonal.ds.SLL;
	import de.polygonal.ds.SLLIterator;
	import de.polygonal.ds.SLLNode;
	import de.polygonal.ds.Set;
	
	import flash.net.Socket;
	import flash.utils.ByteArray;
	
	import github.stompede.broker.ISession;
	import github.stompede.broker.Session;
	
	import org.as3commons.reflect.ClassUtils;
	
	public class Destination implements IDestination
	{
		protected var m_name:String;
		protected var m_subscribers:Set;
		
		public function set name(value:String):void {
			m_name = value;
		}

		public function get name():String {
			return m_name;
		}
		
		public function get subscribers():Set {
			if(m_subscribers==null) {
				m_subscribers = new Set();
			}
			return m_subscribers;
		}
		
		public function put(data:ByteArray):void
		{
			trace("Writing to destination", name, "with", subscribers.size(), "subscribers");
			var itr:Itr = subscribers.iterator() as Itr;
			while(itr.hasNext()) {
				var session:ISession = itr.next() as ISession;
				
				session.output.writeBytes(data);
				if(session.output is Socket)
					Socket(session.output).flush();
			}
		}
		
		public function addSubscriber(session:ISession):void {
			subscribers.setIfAbsent(session);
		}
		
		public function removeSubscriber(session:ISession):void {
			trace(subscribers.size());
			subscribers.removeIfExists(session);
			trace(subscribers.size());
			/*var itr:SLLIterator = subscribers.iterator() as SLLIterator;
			var sessionsToRemove:Array = new Array();
			while(itr.hasNext()) {
				var node:ISession = itr.next() as ISession;
				if(node === session)
					subscribers.remove(node);
				trace(node);
			}*/
			
			/*var node:SLLNode = subscribers.head() as SLLNode;
			while (node != null)
			{
				var element:ISession = node.val as ISession;
				node = node.next;
			}*/
		}
	}
}