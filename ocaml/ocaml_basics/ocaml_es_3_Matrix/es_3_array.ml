type matrix = (int array) array

exception MatriciDiDimensioneDiversa
let zero  n m = Array.init n (fun x -> (Array.init m (fun y -> 0)))

let identity n = Array.init n (fun x -> Array.init n (fun y -> if x<>y then 0 else 1))

let init n = Array.init n (fun x -> Array.init n (fun y -> x*n+y+1))

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

let transpose mx = 
  let n = (Array.length mx) 
  in let m = Array.length mx.(0) 
    in let rec transpose i output mx = 
        if (i<n) then
          begin
            let rec inner x y mx output=               
              if (y<m) 
              then 
                begin                  
                  output.(y).(x) <- (mx.(x).(y));                   
                  inner x (y+1) mx output; 
                end
              else ()       
            in (inner i 0 mx output);            
            transpose (i+1) output mx 
          end        
        else begin  output end          
      in transpose 0 (zero m n) mx 

let ( * ) mx1 mx2 = 
  let n1 = Array.length mx1 and n2 = Array.length mx2 
  in let m1 = Array.length mx1.(0) and m2 = Array.length mx2.(0) 
    in let rec mul i output = 
        if(n1<>m2)|| then raise MatriciDiDimensioneDiversa
        else
        begin
          if (i<n1) then 
          begin
            let rec cell j =  
              if (j<m2) then 
                begin             
                output.(i).(j) <- (let rec el y = 
                  if((y<n1) || (y<m2)) then                  
                    ((mx1.(i).(y)) * (mx2.(y).(j)) + (el (y+1)))
                  else 0
                in el 0);
                cell (j+1)
                end
              else ()                
            in cell 0;              
            (mul (i+1) output)  
          end          
          else output
        end
    in (mul 0 (zero n1 m2))
let ( + ) mx1 mx2 = 
  let n = Array.length mx1 and n2 = Array.length mx2 
  in let m = Array.length mx1.(0) and m2 = Array.length mx2.(0) 
    in let rec plus_c i mx1 mx2 output = 
      if(n<>n2)||(m<>m2) then raise MatriciDiDimensioneDiversa
      else 
      begin
        if (i<n) then
          begin          
          let rec plus_r x j mx1 mx2 output =               
            if(j<m) then 
              begin
              output.(i).(j) <- (mx1.(i).(j) + mx2.(i).(j)); 
              plus_r x (j+1) mx1 mx2 output 
              end              
            else ()
          in plus_r i 0 mx1 mx2 output;
          plus_c (i+1) mx1 mx2 output
          end        
        else output 
      end
    in (plus_c 0 mx1 mx2 (zero n m))

let m_1 = [|[|1;2;3|];[|4;5;6|];[|7;8;9|];[|10;11;12|]|]   
let m_2 = [|[|21;22;23;25|];[|24;25;26;45|];[|27;28;29;55|]|]  


let () = print_matrix ((m_1))
let () = print_matrix ((m_2) * (m_1))