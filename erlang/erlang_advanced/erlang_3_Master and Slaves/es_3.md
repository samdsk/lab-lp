This problem illustrates a situation where we have a process (the master) which supervises other processes (the slaves). In a real example the slave could, for example, be controlling different hardware units. The master's job is to ensure that all the slave processes are alive. If a slave crashes (maybe because of a software fault), the master is to recreate the failed slave.

Write a module ms with the following interface:

`start(N)` which starts the master and tell it to start N slave processes and registers the master as the registered process master.
`to_slave(Message, N)` which sends a message to the master and tells it to relay the message to slave N; the slave should exit (and be restarted by the master) if the message is `die`.
the master should detect the fact that a slave process dies, restart it and print a message that it has done so.
The slave should print all messages it receives except the message `die`

**Hints:**

the master should trap exit messages and create links to all the slave processes.
the master should keep a list of pids of the slave processes and their associated numbers.

Example:

```
> ms:start(4).

=> true

> ms:to_slave(hello, 2).

=> {hello,2}

Slave 2 got message hello

> ms:to_slave(die, 3).

=> {die,3}

master restarting dead slave3
```
