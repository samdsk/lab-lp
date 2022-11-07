open Graphs
let arcs_to_graph arcs = 
  let rec arcs_to_graph g = function
    | (f,s) ::t -> (arcs_to_graph (Graphs.Graph.add_arc f s g) t)
    | [] -> g
  in (arcs_to_graph (Graphs.Graph.empty () ) arcs)  

let graph_to_tree g root = 
  let rec make_tree n = function
    | [] -> Leaf(n)
    | h::t as adj_to_n -> Tree(n,(make_forest adj_to_n))
        and make_forest = function
          | [] -> []
          | h::t -> (make_tree h (Graphs.Graph.adjacents h g))::(make_forest t)
  in make_tree root (Graphs.Graph.adjacents root g) 


let dfs graph v = 
  let rec dfs graph v g_output = function 
    | [] -> g_output
    | h::t when (Graphs.Graph.node_is_in_graph h g_output) -> dfs graph v g_output t 
    | h::t -> 
      dfs graph v (Graphs.Graph.add_arc v h (dfs graph h (Graphs.Graph.add_node h g_output)(Graphs.Graph.adjacents h graph))) t
    in if(Graphs.Graph.is_empty graph) then raise Graphs.Graph.TheGraphIsEmpty
    else if not(Graphs.Graph.node_is_in_graph v graph) then raise Graphs.Graph.TheNodeIsNotInGraph
    else graph_to_tree (dfs graph v (Graphs.Graph.add_node v (Graphs.Graph.empty())) (Graphs.Graph.adjacents v graph)) v

let bfs graph v =
  let rec bfs graph v g_output = function
    | [] -> g_output
    | h::t when (Graphs.Graph.node_is_in_graph h g_output) -> bfs graph v g_output t
    | h::t -> bfs graph v (Graphs.Graph.add_arc v h g_output) (List.rev_append (Graphs.Graph.adjacents h graph) t)
  in  if(Graphs.Graph.is_empty graph) then raise Graphs.Graph.TheGraphIsEmpty
      else if not(Graphs.Graph.node_is_in_graph v graph) then raise Graphs.Graph.TheNodeIsNotInGraph
      else graph_to_tree(bfs graph v (Graphs.Graph.add_node v (Graphs.Graph.empty())) (Graphs.Graph.adjacents v graph)) v
  
  let rec print_tlist = function
      | (Tree(v,_))::t -> print_string(v^" "); print_tlist t
      | Leaf(v)::t -> print_string(v^" ");print_tlist t
      | [] -> print_string("\n")
 

let rec print_tree = function
  | Leaf(v) -> ()(*print_string(v^"-leaf\n")*)
  | Tree(v,tl) -> print_string(v^"\n"); (print_tlist tl); 
      let rec print_bfs l = match l with
        | [] -> () (*print_string("-\n")*)
        | h::t -> print_tree h; print_bfs t
      in print_bfs tl
  

let arcs_1 = [(1,2);(1,3);(4,1);(5,4);(3,2);(2,5);(5,3);(5,6);(5,7);(6,7);(6,3);(6,4)]
let arcs_2 = [("Algol","Pascal");("Algol","C");("Algol","Java");("C","Java");("Algol","Python");("Pascal","Modula 2");("C","C++");("Java","Scala");("Lisp","ML");("Lisp","Scale");("Lisp","Erlang");("ML","OcaML")]


let g_1 = arcs_to_graph arcs_2

let t_1 = dfs g_1 "Algol"

let () = print_tree t_1 