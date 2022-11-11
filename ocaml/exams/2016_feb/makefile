#modules := reduction.ml 


build: module
	ocamlc -o main reduction.cmo main.ml
module: interface
	ocamlc -c reduction.ml 
interface:
	ocamlc -c $(wildcard *.mli)
