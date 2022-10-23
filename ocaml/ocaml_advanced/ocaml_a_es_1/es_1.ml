type network = EmptyNetwork | Network of person list 
and person = Person of name * friends * relatives * relationships
and name = Name of string
and friends = Friends of person list
and relatives = Relatives of person list
and relationships = Relationships of person list
and connection = Friend | Relative | Relationship

exception NetworkIsEmpty
exception NotFoundInNetwork

let create_network = EmptyNetwork

let person name = Person(name,Friends[],Relatives[],Relationships[])

let insert_person person network = match network with
  | EmptyNetwork -> Network([person])
  | Network(l) as n -> if List.mem person l then n else Network(person :: l)

let rec remove p = function
  | [] -> []
  | h::t -> if h == p then t else h :: (remove p t)

let update_network person = function
  | EmptyNetwork -> raise NetworkIsEmpty
  | Network(l) as n -> if List.mem person l then  
    Network(person:: (remove person l) )
  else n

let make_connection person_a person_b = function
  | Friend -> 
    begin
      match person_a with 
        Person(Name(n),Friends(f),Relatives(r),Relationships(rs)) as p -> 
          if List.mem person_b f then p else
          Person(Name(n),Friends(person_b :: f),Relatives(r),Relationships(rs))
    end
  | Relative -> 
    begin
      match person_a with 
        Person(Name(n),Friends(f),Relatives(r),Relationships(rs)) as p ->
          if List.mem person_b r then p else
          Person(Name(n),Friends(f),Relatives(person_b :: r),Relationships(rs))
    end
  | Relationship ->
    begin
      match person_a with 
        Person(Name(n),Friends(f),Relatives(r),Relationships(rs)) as p -> 
          if List.mem person_b rs then p else
          Person(Name(n),Friends(f),Relatives(r),Relationships(person_b :: rs))
    end

let get_name = function Person(n,_,_,_) -> n
let find_person person = function 
  | EmptyNetwork -> raise NotFoundInNetwork
  | Network(l) -> List.find (fun (Person(n,_,_,_)) -> n == (get_name person)) l

let add_connection connection person_a person_b = function
  | EmptyNetwork -> raise NetworkIsEmpty
  | Network(l) as n -> if List.mem person_a l && List.mem person_b l then
    let new_network = update_network(make_connection person_a person_b connection) n 
    in update_network
      (make_connection person_b (find_person person_a new_network) connection) new_network 
    else raise NotFoundInNetwork

let add_friend person_a person_b = function
  | EmptyNetwork -> raise NetworkIsEmpty
  | Network(_) as n -> add_connection Friend person_a person_b n

let add_relative person_a person_b = function
  | EmptyNetwork -> raise NetworkIsEmpty
  | Network(_) as n -> add_connection Relative person_a person_b n

let add_relationship person_a person_b = function
  | EmptyNetwork -> raise NetworkIsEmpty
  | Network(_) as n -> add_connection Relationship person_a person_b n



