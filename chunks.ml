
type vect = (int*int*int)

let (++) (a, b, c) (a', b', c') = (a+a', b+b', c+c')

let scal x (a, b, c) = (x*a, x*b, x*c)



type orientation = vect*vect

type index = int

type matrix3 = int array array array

type solution = (index * vect * orientation) list * matrix3


let basic_chunks =
  let x = (1,0,0) (* 3 *)
  and y = (0,1,0) (* 4 *)
  and z = (0,0,1) (* 5 *)
  and m (a,b,c) = (-a,-b,-c)
  in
  let std =
    [(x, y);
     (x, m y);
     (m x, y);
     (m x, m y);
     (y, x);
     (y, m x);
     (m y, x);
     (m y, m x);

     (z, y);
     (z, m y);
     (m z, y);
     (m z, m y);
     (y, z);
     (y, m z);
     (m y, z);
     (m y, m z);
     
     (x, z);
     (x, m z);
     (m x, z);
     (m x, m z);
     (z, x);
     (z, m x);
     (m z, x);
     (m z, m x);
    ]
  and line = [(x, y); (z, x); (y, z)]
  in
  let cross = line
  and sym_center =
    [(x, y);
     (x, m y);
     (y, x);
     (y, m x);

     (z, y);
     (z, m y);
     (y, z);
     (y, m z);
     
     (x, z);
     (x, m z);
     (z, x);
     (z, m x);
    ]
  and sym_vert =
    [(x, y);
     (m x, y);
     (y, x);
     (m y, x);

     (z, y);
     (m z, y);
     (y, z);
     (m y, z);

     (x, z);
     (m x, z);
     (z, x);
     (m z, x);
    ]
  and sym_diag =
    [(x, y);
     (x, m y);
     (m x, y);
     (m x, m y);

     (z, y);
     (z, m y);
     (m z, y);
     (m z, m y);
     
     (x, z);
     (x, m z);
     (m x, z);
     (m x, m z);
    ]
  in
 [
  [[ 1; 1; 1];
   [ 1; 0; 0];
   [ 1; 0; 0]], sym_diag;

  [[ 1; 1; 1; 1; 1 ]], line;

  [[ 0; 1; 1];
   [ 1; 1; 0];
   [ 1; 0; 0]], sym_diag;

  [[ 0; 1; 1; 1];
   [ 1; 1; 0; 0]], std;

  [[ 0; 1; 0];
   [ 1; 1; 1];
   [ 0; 1; 0]], cross;

  [[ 1; 1; 0];
   [ 0; 1; 0];
   [ 0; 1; 1]], sym_center;

  [[ 0; 0; 0; 1];
   [ 1; 1; 1; 1]], std;

  [[ 1; 1 ]], line;

  [[ 1; 1; 1]], line;

  [[ 0; 0; 1; 0];
   [ 1; 1; 1; 1]], std;

  [[ 0; 1; 0];
   [ 1; 1; 1];
   [ 0; 0; 1]], std;

  [[ 1; 1; 1];
   [ 1; 0; 1]], sym_vert;

  [[ 0; 1; 1];
   [ 1; 1; 1]], std
]

(*
let cubes = List.fold_left (List.fold_left (List.fold_left (+))) 0 (List.map fst basic_chunks)
*)

let dimensions ll = List.length ll, List.length (List.hd ll)

let chunks = (* numbered_with_dimensions *) (* TODO: symmetries *)
  List.rev (snd (List.fold_left
    (fun (i,l) (chk, orientations) -> (i+1), (((i, chk, dimensions chk), orientations)::l))
    (1, []) basic_chunks
  ))

(*
let _ =
  List.iter (fun ((id, ll, _), _) ->
    Printf.printf "#%u:\n" id;
    List.iter (fun l ->
      List.iter (fun x ->
        print_char (if x = 1 then 'X' else ' ') 
      ) l;
      print_newline ()
    ) ll
  ) chunks
*)

let iterate_cubes_at_position f pos (u, v) chunk =
  let _ =
    List.fold_left (fun p1 l ->
      let _ =
        List.fold_left (fun p2 x ->
          if x = 1 then f p2;
          p2 ++ v
        ) p1 l
      in
      p1 ++ u
    ) pos chunk
  in
  ()


let print (a,b,c) = Printf.printf "(%d, %d, %d)\n" a b c

let print_matrix m =
  for x=0 to 2 do
    for y=0 to 3 do
      for z=0 to 4 do
        Printf.printf "%2u " m.(x).(y).(z)
      done;
      print_newline ()
    done;
    print_newline ()
  done  

(*
let _ = List.iter (fun ch -> iterate_cubes_at_position print (0,0,0) (List.hd orientations) ch; print_newline()) basic_chunks
*)

let check_position (a,b,c) = 
  a <= 2 && b <= 3 && c <= 4 &&
    a >= 0 && b >= 0 && c >= 0

let check_bounds pos (u,v) (x, y) =
  let pos2 = pos ++ (scal (x-1) u) ++ (scal (y-1) v)
  in
  assert (check_position pos);
  check_position pos2

let clear_chunk_at_position matrix pos orientation (id, chunk, dims) =
  let f (a,b,c) =
    if matrix.(a).(b).(c) == id
    then matrix.(a).(b).(c) <- 0
    else raise Exit
  in
  if check_bounds pos orientation dims then
    try
      iterate_cubes_at_position f pos orientation chunk;
      true
    with Exit -> false
  else false
  
let add_chunk_at_position matrix pos orientation ((id, chunk, dims) as chk)=
  let f (a,b,c) =
    if matrix.(a).(b).(c) == 0
    then matrix.(a).(b).(c) <- id
    else raise Exit
  in
  if check_bounds pos orientation dims then
    try
      iterate_cubes_at_position f pos orientation chunk;
      true
    with Exit ->
      assert (not (clear_chunk_at_position matrix pos orientation chk));
      false
  else false

exception Found of solution

(* TODO : GADT ? *)
let rec make_matrix = function
| [] -> Obj.magic 0
| x::l -> Obj.magic (Array.init x (fun _ -> make_matrix l))


let solve emit chunks =
  let matrix : matrix3 = make_matrix [3;4;5]
  in
  let rec search history = function
  | [] -> emit (history, matrix)
  | (chk, orientations) :: queue ->
      for x=0 to 2 do
        for y=0 to 3 do
          for z=0 to 4 do
            List.iter (solve_chunk history queue chk (x,y,z)) orientations
          done
        done
      done
  and solve_chunk history queue ((id, _, _) as chk) ((a,b,c) as  pos) orientation =
    if add_chunk_at_position matrix pos orientation chk
    then begin
(*      Printf.printf "--- Setting chunk %u at position (%u,%u,%u) ---\n" id a b c; *)
      print_string "."; flush stdout;
(*      print_matrix matrix; *)
      search ((id, pos, orientation)::history) queue;
      print_string "\b \b"; flush stdout;
      assert (clear_chunk_at_position matrix pos orientation chk)
    end else ()
  in
  search [] chunks

(* --------- verification of non duplication of solutions --------- *)

module H = Hashtbl

let hash_of_matrix3 m =
  Array.fold_left (fun h0 vv ->
    Array.fold_left (fun h1 v ->
      Array.fold_left (fun h e -> H.hash (h,e)) h1 v) h0 vv
  ) 0 m

let matrix3_to_list m =
  Array.fold_left (fun lll vv ->
    (Array.fold_left (fun ll v ->
      (Array.fold_left (fun l e -> e::l) [] v)::ll) [] vv)::lll
  ) [] m


exception Duplicate of matrix3 * int * int

let search_duplicate_solution chunks =
  let htbl = H.create 10
  and ctr = ref 0 
  in
  let emit (_, m) =
    let k = matrix3_to_list m
    in
    let h = H.hash k
    in
    try
      let () = H.find htbl k
      in
      raise (Duplicate(m, h, !ctr))
    with
      Not_found -> begin
        incr ctr;
(*
        Printf.printf "\nFound solution #%u (%u):\n" (!ctr) h;
        print_matrix m;
*)
        H.add htbl k ()
      end
  in
  try
    solve emit chunks;
    Printf.printf "\nFound %u distinct solutions.\n\n" (!ctr);
    !ctr
  with
    Duplicate(m, h, _) -> begin
      Printf.printf "\nFound duplicate solution (%u):\n" h;
      print_matrix m;
      print_newline ();
      exit (-1)
    end

let check_each_chunk_for_duplication chunks =
  List.map (fun (((id,_,_), _) as chk) ->
    Printf.printf "Checking chunk #%u\n" id;
    (* compute the number of placements for each chunk *)
    (chk, search_duplicate_solution [chk])
  ) chunks

(* reorder chunks by putting "least deterministic" ones first *)
let chunks =
  let chunks_with_counter = check_each_chunk_for_duplication chunks
  in
  List.map fst (List.sort (fun (_, x) (_, y) -> compare x y) chunks_with_counter)

let _ =
  print_string "Reordered chunks by 'determinism':\n";
  List.iter (fun ((id,_,_), _) -> Printf.printf "%#2u\n" id) chunks;
  print_newline ()

(* ------ solving ------ *)
(*
let _ =
  let emit sol = raise (Found(sol))
  in
  try
    solve emit chunks;
    print_string "\nNo solution found.\n"
  with
    Found((_, m)) -> begin
      print_string "\nFound solution:\n";
      print_matrix m
    end
*)

(* ------ solving ------ *)

let _ =
  let emit (_, m) =
      print_string "\nFound solution:\n";
      print_matrix m
  in
  solve emit chunks

