Disclaimer
==========

Work in progress - things will probably not break by trying out Stompede but expect runtime
errors and weird behaviour in general. This project is highly experimental and I've used it to
try out a number of things that are new to me: dependency injection with SwiftSuspenders, AIR 2
server sockets, AS3-signals and whatnot. Forking, providing patches and/or suggestions on
improving Stompede is very much appreciated :)


Overview
========

Stompede is an AS3 implementation of a message broker that speaks [STOMP][]. While it aims to be
fully compliant with the protocol, not all aspects have been implemented. Stompede currently
lacks support for the following frames:

* BEGIN
* COMMIT
* ACK
* ABORT
* RECEIPT
* ERROR

The following frames are supported:

* CONNECT (CONNECTED)
* DISCONNECT
* SUBSCRIBE
* UNSUBSCRIBE
* SEND (MESSAGE)

Details
=======


Destination handling and latency
--------------------------------

All destinations are treated as fan-out: messages are distributed to all subscribers of the
destination and in no particular order. Messages distributed to destinations without subscribers
are discarded. Destination names carry no semantics, thus dont expect support for wildcards, 
patterns or other fancy things :) 


Performance issues
------------------
Due to the nature of Flash/AIR a compromise has been made in order to not block the application
when reading data from clients. Incoming data is offloaded to a queue which is processed on a
timer. In the end, what this means is that you should not expect super-duper performance. Messages
will not be delivered immediatly but "fast enough".


Usage
-----

Stompede has been implemented using the [SwiftSuspenders][] dependency injection solution. The
main entry is the BrokerContext class. By default the server socket binds to localhost but by
specifying an server location URI, the server can be bound to an public address. The following
example shows how to explicitly bind to localhost and start the broker, replace with your public
IP where appropriate:

	import github.stompede.broker.BrokerContext;
	import com.adobe.net.URI;

	var ctx:BrokerContext = new github.stompede.broker.BrokerContext();
	ctx.serverLocation = new URI("tcp://127.0.0.1:61613");
	ctx.start();

Logging is provided by [AS3Commons Logging][] and output is quite verbose. To disable logging, do:

	import org.as3commons.logging.LoggerFactory;

	LoggerFactory.loggerFactory = null;


Connecting to Stompede
----------------------

Stompede has been tested to be working with [as3-stomp][], [stomp.py][] and the [cli.py][]
commandline utility. [Other clients][] will most probably work.


[STOMP]: http://stomp.codehaus.org/
[SwiftSuspenders]: http://github.com/tschneidereit/SwiftSuspenders
[AS3Commons Logging]: http://www.as3commons.org/as3-commons-logging
[as3-stomp]: http://code.google.com/p/as3-stomp/
[stomp.py]: http://code.google.com/p/stomppy/
[cli.py]: http://code.google.com/p/stomppy/source/browse/stomp/cli.py
[Other clients]: http://stomp.codehaus.org/Clients
