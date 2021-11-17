Design a distributed version of an associative store in which values are associated with tags. It is possible to store a tag/value pair, and to look up the value(s) associated with a tag. One example for this is an address book for email, in which email addresses (values) are associated with nicknames (tags).

Replicate the store across two nodes on the same host, send lookups to one of the nodes (chosen either at random or alternately), and send updates to both.

Reimplement your system with the store nodes on other hosts (from each other and from the frontend). What do you have to be careful about when you do this?

How could you reimplement the system to include three or four store nodes?

Design a system to test your answer to this exercise. This should generate random store and lookup requests.