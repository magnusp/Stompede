No details currently. It currently targets Adobe AIR2, beta 2 due to the requirement on ServerSocket.
There may, or may not be, a demo under downloads.

Protocol support is badly lacking, the following (client) commands are supported:

*   CONNECT
*   DISCONNECT
*   SUBSCRIBE
*   UNSUBSCRIBE
*   SEND

Destinations are comparable to topics, messages are recieved by all subscribers on the destination.

[stomp.py][1] includes an awesome [commandline client][2] for experimenting with STOMP brokers, highly recommended!

[1]: http://code.google.com/p/stomppy/
[2]: http://code.google.com/p/stomppy/source/browse/stomp/cli.py