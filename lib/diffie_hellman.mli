type parameters = { prime : int; generator : int }
type participant = { private_value : int; public_value : int }

val make_parameters : int -> int -> parameters
val make_participant : parameters -> int -> participant
val shared_secret : parameters -> int -> int -> int
val demo_parameters : unit -> parameters
