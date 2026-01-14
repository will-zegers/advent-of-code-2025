type point3d = (int * int * int)
type point_to_point = float * (int * int)

let rec array_of_channel ch n : point3d array =
  try
    let line = String.split_on_char ',' (input_line ch) in
      let line_int = List.map int_of_string line in
      match line_int with
        [x; y; z] -> array_of_channel ch ((x, y, z) :: n)
        | _ -> failwith "Invalid input data"
  with End_of_file -> Array.of_list n

let array_of_file path : point3d array =
  let ch = open_in path in
  let lines = array_of_channel ch [] in
    close_in ch;

    lines

let point_to_point_distance (x1, y1, z1) (x2, y2, z2) : float =
  sqrt (float_of_int ((x1 - x2) * (x1 - x2) +
                      (y1 - y2) * (y1 - y2) +
                      (z1 - z2) * (z1 - z2)))

let make_point_to_point_list path : point_to_point list =
  let input = array_of_file path in
  let input_length = Array.length input in

    let rec inner i j acc =
      if i = input_length then
        acc
      else if j = input_length then
        inner (i + 1) (i + 2) acc
      else
        inner i (j + 1) ((point_to_point_distance input.(i) input.(j), (i, j)) :: acc)

    in List.sort compare (inner 0 1 [])

let rec print_list l =
  match l with
    [] -> []
  | (_, (i, j))::t -> (i, j) :: print_list t
