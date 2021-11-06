module Matrix(R:Ring.Ring) : (MatrixADT.Matrix with type elt = R.t) =
  struct
    type elt = R.t
    type matrix = elt list list

    (* creates a matrix of size n×n of zeroes *)
    let zeroes n m =
      List.init n (fun x -> List.init m (fun x -> R.zero))

    (* creates an identity matrix, i.e., all zeroes apart the 1s on the diagonal *)
    let identity n =
      List.init n (fun x -> List.init n (fun y -> if (x <> y) then R.zero else R.one))

    (* (* creates a matrix n×n with the numbers from 1 to n² *) *)
    (* let init n = *)
    (*   List.init n (fun x -> List.init n (fun y -> x*n+y+1)) *)

    let rec transpose =
      function
        []           -> []
      | []::xss      -> transpose xss
      | (x::xs)::xss -> (x :: List.map List.hd xss) :: transpose (xs :: List.map List.tl xss)

    (* calculates the dot product between two vectors *)
    let dotprod xs ys =
      let rec dotprod res xs ys =
        match xs, ys with
          x::xs, y::ys -> (dotprod (R.(+) res (R.( * ) x y)) xs ys)
        | _, _ -> res
      in dotprod R.zero xs ys;;

    (* creates a new matrix as the sum of the given matrixes *)
    let (+) m1 m2 =
      List.map2 (fun r1 r2 -> List.map2 (fun e1 e2 -> (R.(+) e1 e2)) r1 r2) m1 m2 ;;

    (* creates a new matrix as the multiplication of the given matrixes *)
    let ( * ) m1 m2 =
      let rec matprod arows brows =
        let cols = transpose brows in
          List.map (fun row -> List.map (dotprod row) cols) arows
      in matprod m1 m2 ;;

    (** pretty printing functions **)
    let pp_print_elem ppf e = (R.pp_print ppf e) ;;
    
    let pp_comma ppf () = Format.fprintf ppf ", " ;;
    let pp_comma_nl ppf () = Format.fprintf ppf ",\n " ;;
    
    let pp_print_generic ppf sep p lst =
      Format.fprintf ppf "%a" Format.(pp_print_list ~pp_sep:sep p) lst ;;
    
    let pp_print_row ppf lst =
      let pp_print_row ppf lst = pp_print_generic ppf pp_comma pp_print_elem lst
      in Format.fprintf ppf "[%a]" pp_print_row lst ;;
    
    let pp_print_matrix ppf tbl =
      let pp_print_matrix ppf tbl = pp_print_generic ppf pp_comma_nl pp_print_row tbl
      in Format.fprintf ppf "[%a]" pp_print_matrix tbl ;;
        
  end ;;
