(*Testing lists*)
module MyLists = struct
    exception ListEmpty
    let add list n = match list with
                        [] -> [n]
                        | h::t -> n::list;;

    let rec print_list ls = match ls with
        [] -> print_string("\n") |
        h::t -> begin print_int h; print_string(" "); print_list t end;;

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
    
    let rec remove_once x = function 
        [] -> []
        | h::t -> if h==x then t
        else h::remove_once x t


    let rec map ~f = function 
        | [] -> []
        | h::t -> (f h)::(map f t)

    let rec filter f = function
        | [] -> []
        | h::t -> if f h then h::filter f t else filter f t
    
    let rec reduce acc f = function
        | [] -> acc
        | h::t -> reduce (f acc h) f t
    
    let exists p l = reduce false (||) (map p l)
    let forall p l = reduce true (&&) (map p l)
        
end