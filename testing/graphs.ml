type 'a tree = Leaf of 'a | Tree of ('a * ('a tree list)) 

module type GraphADT = sig
  type 'a graph
  val empty : unit ->'a graph
  val add_node : 'a -> 'a graph -> 'a graph
  val add_arc : 'a -> 'a -> 'a graph -> 'a graph
  val adjacents : 'a -> 'a graph -> 'a list    
  val is_empty : 'a graph -> bool

  val node_is_in_graph : 'a -> 'a graph -> bool

  exception TheGraphIsEmpty
  exception TheNodeIsNotInGraph

end

module Graph : GraphADT = struct
  (** (node list), (arc(element_1,element_2)) list *)
  type 'a graph = Graph of ('a list) * (('a * 'a) list)
  
  let empty () = Graph([],[]) 
  let is_empty g = match g with Graph(nodes,_) -> (nodes = [])

  exception TheGraphIsEmpty
  exception TheNodeIsNotInGraph

  let rec is_in_list ?(res=false) x = function
    | [] -> res
    | h::t -> if x=h then true else is_in_list ~res:res x t
  
  let node_is_in_graph node = function
    | Graph(n,_) -> (is_in_list node n)  

  let rec add_in_list ?(res=[]) x = function
    | [] -> List.rev (x::res)
    | h::t when x=h -> List.rev_append t (h::res)
    | h::t -> add_in_list ~res:(h::res) x t

  let add_node n = function
    | Graph([],[]) -> Graph([n],[])
    | Graph(nodes, arcs) -> Graph(add_in_list n nodes, arcs)
  
  let add_arc e_sx e_dx = function
    | Graph(nodes,arcs) -> 
        Graph(add_in_list e_sx (add_in_list e_dx nodes), (add_in_list (e_sx,e_dx) arcs))

  (** crea una lista filtrando il primo elemento della coppia*)
  let adjacents n = 
    let adjacents n l = List.map snd (List.filter (fun x -> ((fst x) = n)) l) 
    in function Graph(_, arcs) -> (adjacents n arcs)

end

