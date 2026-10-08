let total = ref 0
let passed = ref 0
let failed = ref 0

let check name condition =
  total := !total + 1;
  if condition then begin
    Printf.printf "[OK] %02d - %s\n" !total name;
    passed := !passed + 1
  end
  else begin
    Printf.printf "[FAIL] %02d - %s\n" !total name;
    failed := !failed + 1
  end

let check_equal name expected actual = check name (expected = actual)
let public_path = "/tmp/ocaml_crypto_lab_public.key"
let private_path = "/tmp/ocaml_crypto_lab_private.key"
let input_path = "/tmp/ocaml_crypto_lab_input.txt"
let encrypted_path = "/tmp/ocaml_crypto_lab_encrypted.txt"
let output_path = "/tmp/ocaml_crypto_lab_output.txt"

let cleanup () =
  File_tools.remove_file public_path;
  File_tools.remove_file private_path;
  File_tools.remove_file input_path;
  File_tools.remove_file encrypted_path;
  File_tools.remove_file output_path

let () =
  cleanup ();
  let keys = Rsa.demo_keys () in
  File_tools.write_file input_path "Hello from a file";
  Key_files.save_public_key public_path keys.public_key;
  Key_files.save_private_key private_path keys.private_key;
  check "public key file exists" (File_tools.file_exists public_path);
  check "private key file exists" (File_tools.file_exists private_path);
  let public_key = Key_files.load_public_key public_path in
  check_equal "public exponent is saved" 17 public_key.exponent;
  check_equal "public modulus is saved" 3233 public_key.modulus;
  let private_key = Key_files.load_private_key private_path in
  check_equal "private exponent is saved" 2753 private_key.exponent;
  check_equal "private modulus is saved" 3233 private_key.modulus;
  let content = File_tools.read_file input_path in
  check_equal "input file can be read" "Hello from a file" content;
  let encrypted = Rsa.encrypt_text public_key content in
  File_tools.write_file encrypted_path (Encoding.int_list_to_string encrypted);
  check "encrypted file exists" (File_tools.file_exists encrypted_path);
  let saved_numbers =
    Encoding.string_to_int_list (File_tools.read_file encrypted_path)
  in
  check_equal "encrypted file keeps its length" (List.length encrypted)
    (List.length saved_numbers);
  let output = Rsa.decrypt_text private_key saved_numbers in
  File_tools.write_file output_path output;
  check_equal "decrypted file has the original content" "Hello from a file"
    (File_tools.read_file output_path);
  cleanup ();
  check "temporary files are removed" (not (File_tools.file_exists output_path));
  Printf.printf "\n%d file tests: %d passed, %d failed\n" !total !passed !failed;
  if !failed > 0 then exit 1
