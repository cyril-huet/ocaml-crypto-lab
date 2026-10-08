let string_to_codes text =
  let result = ref [] in
  for index = String.length text - 1 downto 0 do
    result := Char.code text.[index] :: !result
  done;
  !result

let codes_to_string codes =
  let result = Bytes.create (List.length codes) in
  List.iteri
    (fun index code ->
      if code < 0 || code > 255 then
        invalid_arg "a character code must be between 0 and 255";
      Bytes.set result index (Char.chr code))
    codes;
  Bytes.to_string result

let int_list_to_string values =
  let rec build values =
    match values with
    | [] -> ""
    | [ value ] -> string_of_int value
    | value :: rest -> string_of_int value ^ " " ^ build rest
  in
  build values

let string_to_int_list text =
  let words = String.split_on_char ' ' text in
  let rec read words result =
    match words with
    | [] -> List.rev result
    | "" :: rest -> read rest result
    | word :: rest -> read rest (int_of_string word :: result)
  in
  read words []

let hex_digit value =
  if value < 10 then Char.chr (Char.code '0' + value)
  else Char.chr (Char.code 'A' + value - 10)

let to_hex text =
  let result = Bytes.create (String.length text * 2) in
  for index = 0 to String.length text - 1 do
    let value = Char.code text.[index] in
    Bytes.set result (index * 2) (hex_digit (value / 16));
    Bytes.set result ((index * 2) + 1) (hex_digit (value mod 16))
  done;
  Bytes.to_string result

let hex_value character =
  let code = Char.code character in
  if code >= Char.code '0' && code <= Char.code '9' then code - Char.code '0'
  else if code >= Char.code 'A' && code <= Char.code 'F' then
    code - Char.code 'A' + 10
  else if code >= Char.code 'a' && code <= Char.code 'f' then
    code - Char.code 'a' + 10
  else invalid_arg "invalid hexadecimal character"

let from_hex text =
  if String.length text mod 2 <> 0 then
    invalid_arg "a hexadecimal string must have an even length";
  let result = Bytes.create (String.length text / 2) in
  for index = 0 to Bytes.length result - 1 do
    let first = hex_value text.[index * 2] in
    let second = hex_value text.[(index * 2) + 1] in
    Bytes.set result index (Char.chr ((first * 16) + second))
  done;
  Bytes.to_string result
