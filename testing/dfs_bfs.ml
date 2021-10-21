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



