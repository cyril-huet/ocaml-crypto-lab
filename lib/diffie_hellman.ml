type parameters = { prime : int; generator : int }
type participant = { private_value : int; public_value : int }

let make_parameters prime generator =
  if not (Number_theory.is_prime prime) then
    invalid_arg "the Diffie-Hellman modulus must be prime";
  if generator <= 1 || generator >= prime then
    invalid_arg "the generator must be between 1 and the prime";
  { prime; generator }

let make_participant parameters private_value =
  if private_value <= 0 || private_value >= parameters.prime then
    invalid_arg "the private value is outside the expected range";
  let public_value =
    Number_theory.power_mod parameters.generator private_value parameters.prime
  in
  { private_value; public_value }

let shared_secret parameters private_value other_public_value =
  if private_value <= 0 || private_value >= parameters.prime then
    invalid_arg "the private value is outside the expected range";
  if other_public_value <= 0 || other_public_value >= parameters.prime then
    invalid_arg "the public value is outside the expected range";
  Number_theory.power_mod other_public_value private_value parameters.prime

let demo_parameters () = make_parameters 23 5
