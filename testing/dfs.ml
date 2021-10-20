open Graphs

let arcs_to_graph arcs = 
  let rec arcs_to_graph g = function
    | ((f,s) as h) ::t -> (arcs_to_graph (Graphs.Graph.add_arc f s g) t)
    | [] -> g
  in (arcs_to_graph (Graphs.Graph.empty () ) arcs) 

(*
let graph_to_tree g root = 
  let rec make_tree n = function
    | [] -> Leaf(n)
    | adj_to_n -> Tree(n,(make_forest adj_to_n))
        and make_forest = function
          | [] -> []
          | h::t -> (make_tree h (adjacents h g))::(make_forest t)
  in make_tree root (adjacents root g) 
*)

let dfs graph v = 
  let rec dfs graph v g = function
    | [] -> g
    | h::t when (Graphs.Graph.node_is_in_graph h g) -> dfs graph v g t 
    | h::t -> 
      dsf graph v (Graphs.Graph.add_arc v h (dsf graph h (Graphs.Graph.add_node h g)(Graphs.Graph.adjacent h graph))) t
    in if(is_empty g) then raise TheGraphIsEmpty
    else if not(node_is_in_graph v graph) then raise TheNodeIsNotInGraph
    else graph_to_tree (dfs graph v (Graphs.Graph.add_node v (Graphs.Graph.empty())) (Graphs.Graph.adjacents v graph)) v