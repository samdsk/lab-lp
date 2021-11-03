type network = EmptyNetwork | Network of person list 
and person = Person of name * friends * relatives * relationship
and name = Name of string
and friends = Friends of person list 
and relatives = Relatives of person list 
and relationship = Relationships of person list
and connections = Friend | Relative | Relationship

exception NetworkIsEmpty
exception NotFoundInNetwork


let empty = EmptyNetwork
let empty_node = Person(Name(""),Friends([]),Relatives([]),Relationships([]))
let add_to_network person = function 
  | EmptyNetwork -> Network([person])
  | Network(l) -> Network(person::l)

let print p_names p_list what_to_do = 
  let print_type  what_to_do =  match what_to_do with
      | Friend -> print_string "Friend ->"
      | Relative -> print_string "Relative ->"
      | Relationship -> print_string "Relationship ->" in print_type  what_to_do;
  let rec print p_names = function 
    | [] -> print_newline(); p_names
    | Person(Name(n),_,_,_)::t->
      
        print_string (" "^n^" ");
        print (if (List.exists (fun x -> n=x) p_names) then p_names else n::p_names) t
  in print p_names p_list 


let print_socialnetwork person net = 
  let rec print_socialnetwork person visited = function
    | EmptyNetwork -> raise NetworkIsEmpty
    | Network(l) as net ->       
      match person with
      | [] -> print_endline("Fine...")
      | h::t ->
        if List.exists (fun x-> h=x) visited then print_socialnetwork t visited net
        else begin
        let pa = (List.find (fun (Person(Name(n),_,_,_)) -> n = h ) l) in 
        match pa with
        Person(Name(n),Friends(fl),Relatives(rl),Relationships(rel))->
          print_string ("Nome utente: "^n^": \n");
          print_socialnetwork ((print (print (print person fl Friend) rl Relative) rel Relationship))  (h::visited) net
        end
  in print_socialnetwork [person] [] net

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
        Person(Name(n),Friends(person_a::fl),Relatives(rl),Relationships(rel))::t
      | Relative -> if duplicate person_a rl then h::t else
        Person(Name(n),Friends(fl),Relatives(person_a::rl),Relationships(rel))::t
      | Relationship -> if duplicate person_a rel then h::t else
        Person(Name(n),Friends(fl),Relatives(rl),Relationships(person_a::rel))::t
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
let net = add_friend "Alice" "Diana" net
let net = add_sexual_rel "Alice" "Bob" net
let net = add_kinship "Diana" "Bob" net
let net = add_kinship "Diana" "Bob" net

let () = print_socialnetwork "Bob" net