let save_numbers path first second =
  let content = string_of_int first ^ "\n" ^ string_of_int second ^ "\n" in
  File_tools.write_file path content

let read_numbers path =
  let content = File_tools.read_file path in
  let content =
    String.map
      (fun character -> if character = '\n' then ' ' else character)
      content
  in
  match Encoding.string_to_int_list content with
  | [ first; second ] -> (first, second)
  | _ -> invalid_arg "invalid key file"

let save_public_key path (key : Rsa.public_key) =
  save_numbers path key.exponent key.modulus

let save_private_key path (key : Rsa.private_key) =
  save_numbers path key.exponent key.modulus

let load_public_key path : Rsa.public_key =
  let exponent, modulus = read_numbers path in
  { Rsa.exponent; modulus }

let load_private_key path : Rsa.private_key =
  let exponent, modulus = read_numbers path in
  { Rsa.exponent; modulus }
