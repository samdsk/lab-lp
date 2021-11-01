type graph = Empty | Node of (node * node list)
and node = name * friends * relatives * relationship
and name = Name of string
and friends = Friends of node list 
and relatives = Relatives of node list 
and relationship = Relationship of node list

exception GraphIsEmpty
exception NotFoundInNetwork

let empty = Empty

let add_person name = function
  | Empty -> Nodes([Name])