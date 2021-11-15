let zero = fun n m -> Array.make n (Array.make m 0) 
let z0 n m = Array.init n (fun x -> (Array.init m (fun y -> 0)))
let print_matrix mx = 
  let n = (Array.length mx) 
  in let m = (Array.length mx.(0))
    in let rec print_matrix i mx = 
      if (i<n) then 
        begin
          let rec print_row x y mx = 
            if(y<m) then 
              begin
              Printf.printf "%d " ((mx.(x)).(y)); 
              (print_row x (y+1) mx); 
              end
            else print_endline ("")          
          in (print_row i 0 mx);
          print_matrix (i+1) mx
        end
      else ()
    in print_matrix 0 mx
    
let out_mx = z0 3 3

let transpose_1 out = 
  
    let transpose i output= 
            
            (Array.set (output.(0)) 0 9);            
            
            
                      
            (*transpose (i+1) output mx*)
                 
      in transpose 0 out

let m_1 = [|[|1;2;3|];[|4;5;6|];[|7;8;9|]|]
let x output = (Array.set (output.(0)) 0 9)
let () = (x out_mx)

let () = print_matrix (out_mx)

let m_1 = [|[|1;2;3|];[|4;5;6|];[|7;8;9|]|]
(*
let () = print_matrix (m_1)
let () = print_matrix (transpose_1 out_mx; out_mx) *)