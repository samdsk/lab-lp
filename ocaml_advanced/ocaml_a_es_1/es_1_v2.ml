type network = EmptyNetwork | Network of person list 
and person = Person of name * friends * relatives * relationship
and name = Name of string
and friends = Friends of person list 
and relatives = Relatives of person list 
and relationship = Relationships of person list
and connections = Friend | Relative | Relationship

exception GraphIsEmpty
exception NotFoundInNetwork
exception NetworkIsEmpty

let empty = EmptyNetwork
let empty_node = Person(Name(""),Friends([]),Relatives([]),Relationships([]))
let add_to_network person = function 
  | EmptyNetwork -> Network([person])
  | Network(l) -> Network(person::l)

let create_person n = Person(Name(n),Friends([]),Relatives([]),Relationships([]))

let rec duplicate person = function
  | [] -> false
  | Person(Name(n),_,_,_)::t -> match person with
  | Person(Name(p_n),_,_,_)-> if n = p_n then true else duplicate person t

let rec add_a_to_b person_a person_b what_to_do = function
  | [] -> raise NotFoundInNetwork
  | Person(Name(n),Friends(fl),Relatives(rl),Relationships(rel)) as h ::t ->
    if n = person_b then 
    begin 
      match what_to_do with
      | Friend -> if duplicate person_a fl then h::t else
        Person(Name(n),Friends(fl@[person_a]),Relatives(rl),Relationships(rel))::t
      | Relative -> if duplicate person_a rl then h::t else
        Person(Name(n),Friends(fl),Relatives(rl@[person_a]),Relationships(rel))::t
      | Relationship -> if duplicate person_a rel then h::t else
        Person(Name(n),Friends(fl),Relatives(rl),Relationships(rel@[person_a]))::t
    end
    else
      h::add_a_to_b person_a person_b what_to_do t

let add_operation a b l operation = 
  let pa = List.find (fun (Person(Name(n),_,_,_)) -> n = a) l in 
  let new_list = (add_a_to_b pa b operation l) in 
  let pb = List.find (fun (Person(Name(n),_,_,_)) -> n = b) l in
  Network(add_a_to_b pb a operation new_list)

let add_friend a b = function
  | EmptyNetwork -> raise NetworkIsEmpty
  | Network(l) -> add_operation a b l Friend    

let add_kinship a b = function
  | EmptyNetwork -> raise NetworkIsEmpty
  | Network(l) -> add_operation a b l Relative

let add_sexual_rel a b = function
  | EmptyNetwork -> raise NetworkIsEmpty
  | Network(l) -> add_operation a b l Relationship


let a = create_person "Alice"
let b = create_person "Bob"
let c = create_person "Charlie"
let d = create_person "Diana"
let net = add_to_network b (add_to_network a empty)
let net = add_to_network c net
let net = add_to_network d net
let net = add_friend "Alice" "Bob" net
let net = add_sexual_rel "Alice" "Bob" net
let net = add_kinship "Diana" "Bob" net
let net = add_kinship "Diana" "Bob" net