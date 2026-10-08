let print_usage () =
  print_endline "Usage:";
  print_endline "  crypto_lab gcd NUMBER NUMBER";
  print_endline "  crypto_lab prime NUMBER";
  print_endline "  crypto_lab primes LIMIT";
  print_endline "  crypto_lab factors NUMBER";
  print_endline "  crypto_lab caesar encrypt SHIFT TEXT";
  print_endline "  crypto_lab caesar decrypt SHIFT TEXT";
  print_endline "  crypto_lab rot13 TEXT";
  print_endline "  crypto_lab atbash TEXT";
  print_endline "  crypto_lab vigenere encrypt KEY TEXT";
  print_endline "  crypto_lab vigenere decrypt KEY TEXT";
  print_endline "  crypto_lab hex encode TEXT";
  print_endline "  crypto_lab hex decode TEXT";
  print_endline "  crypto_lab rsa demo TEXT";
  print_endline "  crypto_lab rsa generate P Q E PUBLIC_KEY PRIVATE_KEY";
  print_endline "  crypto_lab rsa encrypt PUBLIC_KEY INPUT OUTPUT";
  print_endline "  crypto_lab rsa decrypt PRIVATE_KEY INPUT OUTPUT";
  print_endline "  crypto_lab diffie-hellman";
  print_endline "  crypto_lab elgamal NUMBER"

let get_argument index =
  if index >= Array.length Sys.argv then invalid_arg "not enough arguments"
  else Sys.argv.(index)

let read_number index =
  try int_of_string (get_argument index)
  with Failure _ -> invalid_arg "a number was expected"

let print_numbers values =
  List.iter (fun value -> Printf.printf "%d " value) values;
  print_newline ()

let run_gcd () =
  let first = read_number 2 in
  let second = read_number 3 in
  Printf.printf "%d\n" (Number_theory.gcd first second)

let run_prime () =
  let number = read_number 2 in
  if Number_theory.is_prime number then Printf.printf "%d is prime\n" number
  else Printf.printf "%d is not prime\n" number

let run_primes () =
  let limit = read_number 2 in
  print_numbers (Number_theory.primes_up_to limit)

let run_factors () =
  let number = read_number 2 in
  List.iter
    (fun (factor, count) -> Printf.printf "%d^%d " factor count)
    (Number_theory.prime_factors number);
  print_newline ()

let run_caesar () =
  let action = get_argument 2 in
  let shift = read_number 3 in
  let text = get_argument 4 in
  if action = "encrypt" then print_endline (Ciphers.caesar_encrypt shift text)
  else if action = "decrypt" then
    print_endline (Ciphers.caesar_decrypt shift text)
  else invalid_arg "use encrypt or decrypt"

let run_rot13 () = print_endline (Ciphers.rot13 (get_argument 2))
let run_atbash () = print_endline (Ciphers.atbash (get_argument 2))

let run_vigenere () =
  let action = get_argument 2 in
  let key = get_argument 3 in
  let text = get_argument 4 in
  if action = "encrypt" then print_endline (Ciphers.vigenere_encrypt key text)
  else if action = "decrypt" then
    print_endline (Ciphers.vigenere_decrypt key text)
  else invalid_arg "use encrypt or decrypt"

let run_hex () =
  let action = get_argument 2 in
  let text = get_argument 3 in
  if action = "encode" then print_endline (Encoding.to_hex text)
  else if action = "decode" then print_endline (Encoding.from_hex text)
  else invalid_arg "use encode or decode"

let run_rsa_demo () =
  let text = get_argument 3 in
  let keys = Rsa.demo_keys () in
  let encrypted = Rsa.encrypt_text keys.public_key text in
  Printf.printf "Public key: (%d, %d)\n" keys.public_key.exponent
    keys.public_key.modulus;
  Printf.printf "Encrypted: ";
  print_numbers encrypted;
  Printf.printf "Decrypted: %s\n" (Rsa.decrypt_text keys.private_key encrypted)

let run_rsa_generate () =
  let first_prime = read_number 3 in
  let second_prime = read_number 4 in
  let public_exponent = read_number 5 in
  let public_path = get_argument 6 in
  let private_path = get_argument 7 in
  let keys = Rsa.make_key_pair first_prime second_prime public_exponent in
  Key_files.save_public_key public_path keys.public_key;
  Key_files.save_private_key private_path keys.private_key;
  Printf.printf "Public key written to %s\n" public_path;
  Printf.printf "Private key written to %s\n" private_path

let run_rsa_encrypt () =
  let public_path = get_argument 3 in
  let input_path = get_argument 4 in
  let output_path = get_argument 5 in
  let key = Key_files.load_public_key public_path in
  let text = File_tools.read_file input_path in
  let encrypted = Rsa.encrypt_text key text in
  File_tools.write_file output_path (Encoding.int_list_to_string encrypted);
  Printf.printf "Encrypted %s into %s\n" input_path output_path

let run_rsa_decrypt () =
  let private_path = get_argument 3 in
  let input_path = get_argument 4 in
  let output_path = get_argument 5 in
  let key = Key_files.load_private_key private_path in
  let numbers = Encoding.string_to_int_list (File_tools.read_file input_path) in
  let text = Rsa.decrypt_text key numbers in
  File_tools.write_file output_path text;
  Printf.printf "Decrypted %s into %s\n" input_path output_path

let run_rsa () =
  match get_argument 2 with
  | "demo" -> run_rsa_demo ()
  | "generate" -> run_rsa_generate ()
  | "encrypt" -> run_rsa_encrypt ()
  | "decrypt" -> run_rsa_decrypt ()
  | _ -> invalid_arg "unknown rsa command"

let run_diffie_hellman () =
  let parameters = Diffie_hellman.demo_parameters () in
  let alice = Diffie_hellman.make_participant parameters 6 in
  let bob = Diffie_hellman.make_participant parameters 15 in
  let alice_secret =
    Diffie_hellman.shared_secret parameters alice.private_value bob.public_value
  in
  let bob_secret =
    Diffie_hellman.shared_secret parameters bob.private_value alice.public_value
  in
  Printf.printf "Alice public value: %d\n" alice.public_value;
  Printf.printf "Bob public value: %d\n" bob.public_value;
  Printf.printf "Shared values: %d and %d\n" alice_secret bob_secret

let run_elgamal () =
  let message = read_number 2 in
  let keys = Elgamal.demo_keys () in
  let encrypted = Elgamal.encrypt keys.public_key 15 message in
  Printf.printf "Cipher: (%d, %d)\n" encrypted.first_part encrypted.second_part;
  Printf.printf "Decrypted: %d\n" (Elgamal.decrypt keys.private_key encrypted)

let run () =
  if Array.length Sys.argv < 2 then print_usage ()
  else
    match Sys.argv.(1) with
    | "help" -> print_usage ()
    | "gcd" -> run_gcd ()
    | "prime" -> run_prime ()
    | "primes" -> run_primes ()
    | "factors" -> run_factors ()
    | "caesar" -> run_caesar ()
    | "rot13" -> run_rot13 ()
    | "atbash" -> run_atbash ()
    | "vigenere" -> run_vigenere ()
    | "hex" -> run_hex ()
    | "rsa" -> run_rsa ()
    | "diffie-hellman" -> run_diffie_hellman ()
    | "elgamal" -> run_elgamal ()
    | _ ->
        print_usage ();
        invalid_arg "unknown command"

let () =
  try run () with
  | Invalid_argument message ->
      Printf.eprintf "Error: %s\n" message;
      exit 1
  | Sys_error message ->
      Printf.eprintf "File error: %s\n" message;
      exit 1
  | Failure message ->
      Printf.eprintf "Error: %s\n" message;
      exit 1
