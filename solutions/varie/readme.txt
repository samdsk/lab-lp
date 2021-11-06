This example shows how to separate the server output from the client output
when the server is spawned by the client on a remote host.

The usage scenario is

1. To create the nodes for the server and the client
      # erl -sname amora                              (server node)
      # erl -sname sif                                (client node)

2. To register the server node as a group leader
      amora@hymir> global:register_name('remote-host', group_leader()).
   note that 'remote-host' is the label for the group leader not for the
   server

3. To chek if the client node sees the server node
      sif@hymir> nodes().
   The result is [] because the Erlang cluster is loosely connected, i.e.,
   sif doesn't see amora up to the first contact

4. Let's force the first contact with ping
      sif@hymir> net_adm:ping('amora@hymir').
   Note, if you get pang this is means you have some network problems, e.g.,
   an active firewall, the correct reply is pong

5. To check if the cluster is correctly built.
      sif@hymir> nodes().
   Now amora@hymir is on the nodes list, note that sif is not there because
   nodes() shows only the "other" nodes in the cluster.

6. Let's load the same modules used by the server on the client
      sif@hymir> nl(remoting).

7. Let's initialize the system from the client
      sif@hymir> remoting:start('amora@hymir', frigga).

8. Let's try it
      sif@hymir> remoting:send_msg(frigga, "This is a test message!!").
   If everything works as expected the message should be printed also on the
   shell used by the server node. 

(Note, this scenario uses the names of my machines, you have to adapt them to
your environment).
