module SetList = struct
  type 'a t = 'a list
  let empty = []
  let add_element  a s = if List.mem a s then s else a::s
end
