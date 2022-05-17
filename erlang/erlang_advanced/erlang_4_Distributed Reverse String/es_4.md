To reverse the order of the characters in a string is quite trivial but when the length of the string grows trivial could means extremely slow. To decompose the input string in shorter strings and to join back the inverted strings in order to keep the algorithm working always on a short input is a good idea to fast the process.

Write a master-slave (see the previous exercise) distributed system where:

a server process (`MasterProcess`) provides a service called `long_reverse_string()` that given a very large string (≥ 1000 characters) returns the reversed string;
the service `long_reversed_string()` decomposes the input w into 10 strings w⁰, ..., w⁹ with the following lengths (# represents the operator length of a string, and `n=#w%10`): `#w⁰=...=#wⁿ=#w/10+1 e #wⁿ⁺¹=...=#w⁹=#w/10` and forwards to 10 distinct actors (`SlaveProcess`) to reverse the 10 substrings w⁰, ..., w⁹ (service `reverse_string()`) and joins the 10 results.
the client process (`ClientProcess`) just ask for the service on a given string.

When done with the exercise try to relax the constraint on the number of substrings from ten to a generic M passed as an input to the `long_reversed_string` service.