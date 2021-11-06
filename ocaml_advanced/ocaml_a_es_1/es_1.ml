type graph = Empty | Network of node list
and node = {name:string; friendship: node list; kinship: node list; sexual_rel: node list;}

exception GraphIsEmpty
exception NotFoundInNetwork
let empty = Empty

let create_node = fun n -> {name=n; friendship= [];  kinship= []; sexual_rel= [];}

let add_to_network n g = match g with
  | Empty -> Network([n])
  | Network(l) -> Network(l@[n])

let rec duplicate a = function 
  | [] -> false
  | {name=n}::t -> match a with
    | {name=a_n} -> if n=a_n then true else duplicate a t


let add_friend a b = function
  | Empty -> raise GraphIsEmpty
  | Network(l) -> 

    let rec add_a_to_b a f_b = function
    | [] -> raise NotFoundInNetwork
    | ({name=n;friendship=fl;kinship=kl;sexual_rel=sl} as h)::t ->     
    if n = a then 
      begin
      if (duplicate f_b fl) 
        then h::t
      else {name=n;friendship=fl@[f_b];kinship=kl;sexual_rel=sl}::t 
      end
    else h::(add_a_to_b a f_b t) in    

      let f_a = List.find (fun {name=n} -> n=a) l in
      let new_list = (add_a_to_b b f_a l) in
      let f_b = List.find (fun {name=n} -> n=b) l in
      Network(add_a_to_b a f_b new_list)

let add_kinship a b = function
  | Empty -> raise GraphIsEmpty
  | Network(l) -> 
    
    let rec add_a_to_b a f_b = function
    | [] -> raise NotFoundInNetwork
    | ({name=n;friendship=fl;kinship=kl;sexual_rel=sl} as h)::t ->     
    if n = a then 
      begin
      if (duplicate f_b kl ) 
        then h::t
      else {name=n;friendship=fl;kinship=kl@[f_b];sexual_rel=sl}::t 
      end
    else h::(add_a_to_b a f_b t) in    

      let f_a = List.find (fun {name=n} -> n=a) l in
      let new_list = (add_a_to_b b f_a l) in
      let f_b = List.find (fun {name=n} -> n=b) l in
      Network(add_a_to_b a f_b new_list)

let add_sexual_rel a b = function
  | Empty -> raise GraphIsEmpty
  | Network(l) -> 
    
    let rec add_a_to_b a f_b = function
    | [] -> raise NotFoundInNetwork
    | ({name=n;friendship=fl;kinship=kl;sexual_rel=sl} as h)::t ->     
    if n = a then 
      begin
      if (duplicate f_b sl ) 
        then h::t
      else {name=n;friendship=fl;kinship=kl;sexual_rel=sl@[f_b]}::t 
      end
    else h::(add_a_to_b a f_b t) in    

      let f_a = List.find (fun {name=n} -> n=a) l in
      let new_list = (add_a_to_b b f_a l) in
      let f_b = List.find (fun {name=n} -> n=b) l in
      Network(add_a_to_b a f_b new_list)
  
let a = create_node "Alice"
let b = create_node "Bob"
let c = create_node "Charlie"
let d = create_node "Diana"
let net = add_to_network b (add_to_network a empty)
let net = add_to_network c net
let net = add_to_network d net
let net = add_friend "Alice" "Bob" net
let net = add_sexual_rel "Alice" "Bob" net
let net = add_kinship "Diana" "Bob" net
let net = add_kinship "Diana" "Bob" net
