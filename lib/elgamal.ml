type public_key = { prime : int; generator : int; public_value : int }
type private_key = { prime : int; private_value : int }
type key_pair = { public_key : public_key; private_key : private_key }
type cipher = { first_part : int; second_part : int }

let make_key_pair prime generator private_value =
  if not (Number_theory.is_prime prime) then
    invalid_arg "the ElGamal modulus must be prime";
  if generator <= 1 || generator >= prime then
    invalid_arg "the generator must be between 1 and the prime";
  if private_value <= 0 || private_value >= prime - 1 then
    invalid_arg "the private value is outside the expected range";
  let public_value = Number_theory.power_mod generator private_value prime in
  {
    public_key = { prime; generator; public_value };
    private_key = { prime; private_value };
  }

let demo_keys () = make_key_pair 23 5 6

let encrypt (key : public_key) random_value message =
  if random_value <= 0 || random_value >= key.prime - 1 then
    invalid_arg "the temporary value is outside the expected range";
  if message < 0 || message >= key.prime then
    invalid_arg "the message must be smaller than the prime";
  let first_part =
    Number_theory.power_mod key.generator random_value key.prime
  in
  let shared_value =
    Number_theory.power_mod key.public_value random_value key.prime
  in
  let second_part = message * shared_value mod key.prime in
  { first_part; second_part }

let decrypt (key : private_key) cipher =
  let shared_value =
    Number_theory.power_mod cipher.first_part key.private_value key.prime
  in
  match Number_theory.mod_inverse shared_value key.prime with
  | None -> invalid_arg "the shared value has no inverse"
  | Some inverse -> cipher.second_part * inverse mod key.prime
