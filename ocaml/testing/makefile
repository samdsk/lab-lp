build: modules
	ocamlc -o main.out ntest.cmo mtest.cmo main.ml

modules: interfaces
	ocamlc -c mtest.ml 
interfaces:
	ocamlc -c ntest.mli mtesti.mli

clear: 
	rm -rf $(wildcard *.cmo) $(wildcard *.cmi)
	
