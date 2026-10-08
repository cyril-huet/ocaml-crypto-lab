let normalize_shift shift =
  let result = shift mod 26 in
  if result < 0 then result + 26 else result

let is_lowercase code = code >= Char.code 'a' && code <= Char.code 'z'
let is_uppercase code = code >= Char.code 'A' && code <= Char.code 'Z'

let shift_character shift character =
  let shift = normalize_shift shift in
  let code = Char.code character in
  if is_lowercase code then
    Char.chr (Char.code 'a' + ((code - Char.code 'a' + shift) mod 26))
  else if is_uppercase code then
    Char.chr (Char.code 'A' + ((code - Char.code 'A' + shift) mod 26))
  else character

let caesar_encrypt shift text =
  let shift = normalize_shift shift in
  let result = Bytes.of_string text in
  for index = 0 to Bytes.length result - 1 do
    Bytes.set result index (shift_character shift (Bytes.get result index))
  done;
  Bytes.to_string result

let caesar_decrypt shift text = caesar_encrypt (-shift) text
let rot13 text = caesar_encrypt 13 text

let atbash_character character =
  let code = Char.code character in
  if is_lowercase code then Char.chr (Char.code 'z' - code + Char.code 'a')
  else if is_uppercase code then Char.chr (Char.code 'Z' - code + Char.code 'A')
  else character

let atbash text =
  let result = Bytes.of_string text in
  for index = 0 to Bytes.length result - 1 do
    Bytes.set result index (atbash_character (Bytes.get result index))
  done;
  Bytes.to_string result

let key_shift key index =
  let key_character = Char.lowercase_ascii key.[index] in
  let code = Char.code key_character in
  if is_lowercase code then code - Char.code 'a' else 0

let vigenere text key decrypt =
  if String.length key = 0 then text
  else
    let result = Bytes.of_string text in
    let key_index = ref 0 in
    for index = 0 to Bytes.length result - 1 do
      let code = Char.code (Bytes.get result index) in
      if is_lowercase code || is_uppercase code then begin
        let shift = key_shift key !key_index in
        let shift = if decrypt then -shift else shift in
        Bytes.set result index (shift_character shift (Bytes.get result index));
        key_index := (!key_index + 1) mod String.length key
      end
    done;
    Bytes.to_string result

let vigenere_encrypt key text = vigenere text key false
let vigenere_decrypt key text = vigenere text key true
