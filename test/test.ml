let total = ref 0
let passed = ref 0
let failed = ref 0

let check name condition =
  total := !total + 1;
  if condition then begin
    Printf.printf "[OK] %03d - %s\n" !total name;
    passed := !passed + 1
  end
  else begin
    Printf.printf "[FAIL] %03d - %s\n" !total name;
    failed := !failed + 1
  end

let check_equal name expected actual = check name (expected = actual)

let raises_invalid_arg name operation =
  try
    operation ();
    check name false
  with Invalid_argument _ -> check name true

(* 30 tests for the small number theory module. *)
let test_number_theory () =
  check_equal "absolute positive" 7 (Number_theory.absolute 7);
  check_equal "absolute negative" 7 (Number_theory.absolute (-7));
  check_equal "absolute zero" 0 (Number_theory.absolute 0);
  check_equal "gcd" 6 (Number_theory.gcd 24 18);
  check_equal "gcd with reversed values" 6 (Number_theory.gcd 18 24);
  check_equal "gcd with negative value" 4 (Number_theory.gcd (-12) 8);
  check_equal "gcd with zero" 9 (Number_theory.gcd 9 0);
  check_equal "lcm" 12 (Number_theory.lcm 4 6);
  check_equal "lcm with zero" 0 (Number_theory.lcm 0 6);
  check "coprime values" (Number_theory.are_coprime 8 15);
  check "non-coprime values" (not (Number_theory.are_coprime 8 12));
  check_equal "modular power" 24 (Number_theory.power_mod 2 10 40);
  check_equal "power with zero exponent" 1 (Number_theory.power_mod 3 0 10);
  check_equal "modular inverse" (Some 7) (Number_theory.mod_inverse 3 10);
  check_equal "missing modular inverse" None (Number_theory.mod_inverse 2 4);
  check "two is prime" (Number_theory.is_prime 2);
  check "ninety-seven is prime" (Number_theory.is_prime 97);
  check "one hundred is not prime" (not (Number_theory.is_prime 100));
  check "negative number is not prime" (not (Number_theory.is_prime (-5)));
  check_equal "next prime after fourteen" 17 (Number_theory.next_prime 14);
  check_equal "next prime when already prime" 17 (Number_theory.next_prime 17);
  check_equal "primes up to ten" [ 2; 3; 5; 7 ] (Number_theory.primes_up_to 10);
  check_equal "primes below two" [] (Number_theory.primes_up_to 1);
  check_equal "divisors of twelve" [ 1; 2; 3; 4; 6; 12 ]
    (Number_theory.divisors 12);
  check_equal "divisors of a prime" [ 1; 7 ] (Number_theory.divisors 7);
  check_equal "prime factors of 360"
    [ (2, 3); (3, 2); (5, 1) ]
    (Number_theory.prime_factors 360);
  check_equal "prime factors of one" [] (Number_theory.prime_factors 1);
  check_equal "phi of one" 1 (Number_theory.euler_phi 1);
  check_equal "phi of nine" 6 (Number_theory.euler_phi 9);
  check_equal "phi of ten" 4 (Number_theory.euler_phi 10)

(* 15 tests for conversions used by the command line tools. *)
let test_encoding () =
  check_equal "codes of an empty string" [] (Encoding.string_to_codes "");
  check_equal "codes of a word" [ 65; 66; 67 ] (Encoding.string_to_codes "ABC");
  check_equal "codes keep punctuation" [ 65; 33 ]
    (Encoding.string_to_codes "A!");
  check_equal "codes to string" "ABC" (Encoding.codes_to_string [ 65; 66; 67 ]);
  check_equal "string round trip" "Hello"
    (Encoding.codes_to_string (Encoding.string_to_codes "Hello"));
  check_equal "empty string round trip" ""
    (Encoding.codes_to_string (Encoding.string_to_codes ""));
  check_equal "integer list formatting" "1 2 3"
    (Encoding.int_list_to_string [ 1; 2; 3 ]);
  check_equal "integer list parsing" [ 1; 2; 3 ]
    (Encoding.string_to_int_list "1 2 3");
  check_equal "integer list parsing with spaces" [ 1; 2; 3 ]
    (Encoding.string_to_int_list "1  2 3");
  check_equal "empty integer list formatting" ""
    (Encoding.int_list_to_string []);
  check_equal "hexadecimal empty string" "" (Encoding.to_hex "");
  check_equal "hexadecimal one character" "41" (Encoding.to_hex "A");
  check_equal "hexadecimal word" "48656C6C6F" (Encoding.to_hex "Hello");
  check_equal "hexadecimal one character decoding" "A" (Encoding.from_hex "41");
  check_equal "hexadecimal round trip" "Hello"
    (Encoding.from_hex (Encoding.to_hex "Hello"))

(* 20 tests for classical ciphers. *)
let test_ciphers () =
  check_equal "caesar encryption" "Khoor" (Ciphers.caesar_encrypt 3 "Hello");
  check_equal "caesar wraps around" "Aa" (Ciphers.caesar_encrypt 1 "Zz");
  check_equal "caesar keeps uppercase" "CDE" (Ciphers.caesar_encrypt 2 "ABC");
  check_equal "caesar keeps punctuation" "Khoor! 123"
    (Ciphers.caesar_encrypt 3 "Hello! 123");
  check_equal "caesar negative shift" "Hello"
    (Ciphers.caesar_encrypt (-3) "Khoor");
  check_equal "caesar decryption" "Hello" (Ciphers.caesar_decrypt 3 "Khoor");
  check_equal "caesar round trip" "A longer text!"
    (Ciphers.caesar_decrypt 12 (Ciphers.caesar_encrypt 12 "A longer text!"));
  check_equal "rot13" "Uryyb" (Ciphers.rot13 "Hello");
  check_equal "rot13 twice" "Hello" (Ciphers.rot13 (Ciphers.rot13 "Hello"));
  check_equal "atbash" "Zyx CbA" (Ciphers.atbash "Abc XyZ");
  check_equal "atbash keeps punctuation" "Z!" (Ciphers.atbash "A!");
  check_equal "atbash twice" "Hello" (Ciphers.atbash (Ciphers.atbash "Hello"));
  check_equal "vigenere encryption" "LXFOPVEFRNHR"
    (Ciphers.vigenere_encrypt "LEMON" "ATTACKATDAWN");
  check_equal "vigenere decryption" "ATTACKATDAWN"
    (Ciphers.vigenere_decrypt "LEMON" "LXFOPVEFRNHR");
  check_equal "vigenere round trip" "Hello student"
    (Ciphers.vigenere_decrypt "KEY"
       (Ciphers.vigenere_encrypt "KEY" "Hello student"));
  check_equal "vigenere keeps spaces" "Lxfopv ef rnhr"
    (Ciphers.vigenere_encrypt "LEMON" "Attack at dawn");
  check_equal "vigenere accepts lowercase key" "LXFOPV"
    (Ciphers.vigenere_encrypt "lemon" "ATTACK");
  check_equal "vigenere empty key" "Hello" (Ciphers.vigenere_encrypt "" "Hello");
  check_equal "vigenere empty text" "" (Ciphers.vigenere_encrypt "KEY" "");
  check_equal "large caesar shift" "Khoor" (Ciphers.caesar_encrypt 29 "Hello")

(* 15 tests for the small RSA demonstration. *)
let test_rsa () =
  let keys = Rsa.demo_keys () in
  check_equal "rsa modulus" 3233 keys.public_key.modulus;
  check_equal "rsa public exponent" 17 keys.public_key.exponent;
  check_equal "rsa private exponent" 2753 keys.private_key.exponent;
  check_equal "rsa known encryption" 2790
    (Rsa.encrypt_number keys.public_key 65);
  check_equal "rsa known decryption" 65
    (Rsa.decrypt_number keys.private_key 2790);
  check_equal "rsa zero" 0
    (Rsa.decrypt_number keys.private_key (Rsa.encrypt_number keys.public_key 0));
  check_equal "rsa one" 1
    (Rsa.decrypt_number keys.private_key (Rsa.encrypt_number keys.public_key 1));
  check_equal "rsa number round trip" 42
    (Rsa.decrypt_number keys.private_key
       (Rsa.encrypt_number keys.public_key 42));
  check_equal "rsa empty text" [] (Rsa.encrypt_text keys.public_key "");
  check_equal "rsa text round trip" "Hello"
    (Rsa.decrypt_text keys.private_key
       (Rsa.encrypt_text keys.public_key "Hello"));
  check_equal "rsa punctuation round trip" "A!"
    (Rsa.decrypt_text keys.private_key (Rsa.encrypt_text keys.public_key "A!"));
  check_equal "rsa encrypted length" 5
    (List.length (Rsa.encrypt_text keys.public_key "Hello"));
  let small_keys = Rsa.make_key_pair 5 11 3 in
  check_equal "rsa custom key" 7
    (Rsa.decrypt_number small_keys.private_key
       (Rsa.encrypt_number small_keys.public_key 7));
  raises_invalid_arg "rsa rejects a large message" (fun () ->
      Rsa.encrypt_number keys.public_key 3233 |> ignore);
  raises_invalid_arg "rsa rejects a non-prime" (fun () ->
      Rsa.make_key_pair 4 53 17 |> ignore)

(* 10 tests for the Diffie-Hellman key exchange example. *)
let test_diffie_hellman () =
  let parameters = Diffie_hellman.demo_parameters () in
  let alice = Diffie_hellman.make_participant parameters 6 in
  let bob = Diffie_hellman.make_participant parameters 15 in
  check_equal "dh prime" 23 parameters.prime;
  check_equal "dh generator" 5 parameters.generator;
  check_equal "dh alice private value" 6 alice.private_value;
  check_equal "dh alice public value" 8 alice.public_value;
  check_equal "dh bob public value" 19 bob.public_value;
  check_equal "dh alice shared secret" 2
    (Diffie_hellman.shared_secret parameters alice.private_value
       bob.public_value);
  check_equal "dh bob shared secret" 2
    (Diffie_hellman.shared_secret parameters bob.private_value
       alice.public_value);
  let other = Diffie_hellman.make_parameters 29 2 in
  check_equal "dh accepts another prime" 29 other.prime;
  raises_invalid_arg "dh rejects a composite modulus" (fun () ->
      Diffie_hellman.make_parameters 21 2 |> ignore);
  raises_invalid_arg "dh rejects a private value of zero" (fun () ->
      Diffie_hellman.make_participant parameters 0 |> ignore)

(* 10 tests for the small ElGamal example. *)
let test_elgamal () =
  let keys = Elgamal.demo_keys () in
  let encrypted = Elgamal.encrypt keys.public_key 15 7 in
  check_equal "elgamal prime" 23 keys.public_key.prime;
  check_equal "elgamal generator" 5 keys.public_key.generator;
  check_equal "elgamal public value" 8 keys.public_key.public_value;
  check_equal "elgamal first cipher part" 19 encrypted.first_part;
  check_equal "elgamal second cipher part" 14 encrypted.second_part;
  check_equal "elgamal decryption" 7
    (Elgamal.decrypt keys.private_key encrypted);
  check_equal "elgamal round trip one" 1
    (Elgamal.decrypt keys.private_key (Elgamal.encrypt keys.public_key 15 1));
  check_equal "elgamal round trip twenty-two" 22
    (Elgamal.decrypt keys.private_key (Elgamal.encrypt keys.public_key 15 22));
  raises_invalid_arg "elgamal rejects a large message" (fun () ->
      Elgamal.encrypt keys.public_key 15 23 |> ignore);
  raises_invalid_arg "elgamal rejects a zero temporary value" (fun () ->
      Elgamal.encrypt keys.public_key 0 7 |> ignore)

let () =
  print_endline "Number theory";
  test_number_theory ();
  print_endline "Encoding";
  test_encoding ();
  print_endline "Classical ciphers";
  test_ciphers ();
  print_endline "RSA";
  test_rsa ();
  print_endline "Diffie-Hellman";
  test_diffie_hellman ();
  print_endline "ElGamal";
  test_elgamal ();
  Printf.printf "\n%d tests: %d passed, %d failed\n" !total !passed !failed;
  if !total <> 100 || !failed > 0 then exit 1
