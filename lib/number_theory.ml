let absolute value = if value < 0 then -value else value

let gcd first second =
  let first = absolute first in
  let second = absolute second in
  let rec find current other =
    if other = 0 then current else find other (current mod other)
  in
  find first second

let lcm first second =
  if first = 0 || second = 0 then 0
  else absolute (first / gcd first second * second)

let are_coprime first second = gcd first second = 1

let power_mod base exponent modulo =
  if modulo <= 0 then invalid_arg "the modulo must be positive";
  if exponent < 0 then invalid_arg "the exponent cannot be negative";
  let first_value = base mod modulo in
  let rec calculate value power result =
    if power = 0 then result
    else
      let new_result =
        if power mod 2 = 1 then result * value mod modulo else result
      in
      let new_value = value * value mod modulo in
      calculate new_value (power / 2) new_result
  in
  calculate first_value exponent 1

let is_prime number =
  if number < 2 then false
  else
    let rec check divisor =
      if divisor > number / divisor then true
      else if number mod divisor = 0 then false
      else check (divisor + 1)
    in
    check 2

let next_prime number =
  let first = if number < 2 then 2 else number in
  let rec find candidate =
    if is_prime candidate then candidate else find (candidate + 1)
  in
  find first

let primes_up_to limit =
  let result = ref [] in
  for number = 2 to limit do
    if is_prime number then result := number :: !result
  done;
  List.rev !result

let divisors number =
  if number <= 0 then []
  else
    let result = ref [] in
    for divisor = 1 to number do
      if number mod divisor = 0 then result := divisor :: !result
    done;
    List.rev !result

let prime_factors number =
  if number <= 1 then []
  else
    let rec divide value factor count =
      if value mod factor = 0 then divide (value / factor) factor (count + 1)
      else if count > 0 then (factor, count) :: divide value (factor + 1) 0
      else if factor > value / factor then
        if value > 1 then [ (value, 1) ] else []
      else divide value (factor + 1) 0
    in
    divide number 2 0

let euler_phi number =
  if number <= 0 then 0
  else
    let count = ref 0 in
    for value = 1 to number do
      if are_coprime value number then count := !count + 1
    done;
    !count

(* This simple version is enough for the small educational examples. *)
let mod_inverse value modulo =
  if modulo <= 1 then None
  else
    let value = ((value mod modulo) + modulo) mod modulo in
    let rec find candidate =
      if candidate >= modulo then None
      else if value * candidate mod modulo = 1 then Some candidate
      else find (candidate + 1)
    in
    find 1
