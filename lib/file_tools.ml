let read_file path =
  let channel = open_in_bin path in
  let length = in_channel_length channel in
  let content = really_input_string channel length in
  close_in channel;
  content

let write_file path content =
  let channel = open_out_bin path in
  output_string channel content;
  close_out channel

let file_exists path = Sys.file_exists path
let remove_file path = if file_exists path then Sys.remove path
