type public_key = { exponent : int; modulus : int }
type private_key = { exponent : int; modulus : int }
type key_pair = { public_key : public_key; private_key : private_key }

let make_key_pair first_prime second_prime public_exponent =
  if not (Number_theory.is_prime first_prime) then
    invalid_arg "the first number must be prime";
  if not (Number_theory.is_prime second_prime) then
    invalid_arg "the second number must be prime";
  let modulus = first_prime * second_prime in
  let phi = (first_prime - 1) * (second_prime - 1) in
  if Number_theory.gcd public_exponent phi <> 1 then
    invalid_arg "the public exponent has no inverse";
  match Number_theory.mod_inverse public_exponent phi with
  | None -> invalid_arg "cannot calculate the private exponent"
  | Some private_exponent ->
      {
        public_key = { exponent = public_exponent; modulus };
        private_key = { exponent = private_exponent; modulus };
      }

let demo_keys () = make_key_pair 61 53 17

let check_message modulus message =
  if message < 0 || message >= modulus then
    invalid_arg "the message must be smaller than the modulus"

let encrypt_number (key : public_key) message =
  check_message key.modulus message;
  Number_theory.power_mod message key.exponent key.modulus

let decrypt_number (key : private_key) message =
  check_message key.modulus message;
  Number_theory.power_mod message key.exponent key.modulus

let encrypt_text key text =
  let values = ref [] in
  for index = 0 to String.length text - 1 do
    let character = Char.code text.[index] in
    let encrypted = encrypt_number key character in
    values := encrypted :: !values
  done;
  List.rev !values

let decrypt_text key values =
  let result = Bytes.create (List.length values) in
  List.iteri
    (fun index value ->
      let decrypted = decrypt_number key value in
      if decrypted > 255 then
        invalid_arg "the decrypted value is not a character";
      Bytes.set result index (Char.chr decrypted))
    values;
  Bytes.to_string result
