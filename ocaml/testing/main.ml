let main () = 
  let x = open_in "prova.txt"
  in try 
    while true do
      let line = input_line x in
      print_endline line
    done
    
  with End_of_file -> close_in x

let read () = 
  let x = read_line () in print_endline x