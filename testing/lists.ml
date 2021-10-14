(*Testing lists*)
module MyLists = struct
    exception ListEmpty
    let add list n = match list with
                        [] -> [n]
                        | h::t -> n::list;;

    let rec print_list ls = match ls with
                            [] -> () |
                            h::t -> begin print_int h; print_newline (); print_list t end;;

    let rec append l n = match l with
        [] -> [n] |
        h::t -> h:: append t n

    let count x l =
        let rec boh tot x = function
            [] -> tot 
            | h::t -> if h==x then boh (tot+1) x t else boh tot x t
            in boh 0 x l
    let rec count ?(pos=0) x = function
            [] -> pos
            | h::t -> if h==x then count ~pos:(pos+1) x t
                else  count ~pos:(pos) x t
    let find x l = 
        let rec find pos x = function
            [] -> (-1)
            | h::t -> if h==x 
                then pos
                else find (pos+1) x t
        in find 0 x l

    let slice l i f = 
        let rec slice offset i f = function 
            [] -> raise ListEmpty
            | h::t -> if (i<=offset && offset <=f)
                then h::slice (offset+1) i f t
                else slice (offset+1) i f t
        in slice 0 i f l

    let rec remove x = function 
        [] -> []
        | h::t -> if h==x then remove x t
        else h::remove x t

end