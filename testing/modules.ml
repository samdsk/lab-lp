(**Modules testing *)
(**Tree like priority queue *)

module type PQ = sig
    type 'a queue
    val insert : 'a queue -> int -> 'a -> 'a queue
    val extract : 'a queue -> int * 'a * 'a queue
end

module PQueue = struct
    type priority = int
    type 'a queue = Empty | Node of priority * 'a * 'a queue * 'a queue

    exception QueueIsEmpty

    let empty = Empty

    let rec insert q p el = 
        match q with
            Empty -> Node(p,el,Empty, Empty)
          | Node(pr, n,left,right) -> if p <= pr 
                then Node(p, el, insert right pr n, left)
                else Node(pr,n,insert right p el, left)
    let rec remove_top q  = 
        match q with
            Empty -> raise QueueIsEmpty
            | Node(_,_,l,Empty) -> l
            | Node(_,_,Empty,r) -> r
            | Node(p,e,
                (Node(p_l,e_l,_,_) as l),
                (Node(p_r,e_r,_,_) as r)) ->  
                    if p_l <= p_r 
                    then Node(p_l,e_l,remove_top l, r)
                    else Node(p_r,e_r,l,remove_top r)
    let extract q = match q with
                    Empty -> raise QueueIsEmpty
                    | Node(p,e,l,r) as q1 -> (p,e,remove_top q1)
end

module type X = sig
    val x : int
    val somma: int -> int
end

module A : X = struct
    let x = 5
    let somma y = x+y
end

module App (M : X) = struct 
    let x = M.x 
    let s = M.somma 7
end