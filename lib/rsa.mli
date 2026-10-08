type public_key = { exponent : int; modulus : int }
type private_key = { exponent : int; modulus : int }
type key_pair = { public_key : public_key; private_key : private_key }

val make_key_pair : int -> int -> int -> key_pair
val demo_keys : unit -> key_pair
val encrypt_number : public_key -> int -> int
val decrypt_number : private_key -> int -> int
val encrypt_text : public_key -> string -> int list
val decrypt_text : private_key -> int list -> string
