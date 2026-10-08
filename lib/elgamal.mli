type public_key = { prime : int; generator : int; public_value : int }
type private_key = { prime : int; private_value : int }
type key_pair = { public_key : public_key; private_key : private_key }
type cipher = { first_part : int; second_part : int }

val make_key_pair : int -> int -> int -> key_pair
val demo_keys : unit -> key_pair
val encrypt : public_key -> int -> int -> cipher
val decrypt : private_key -> cipher -> int
