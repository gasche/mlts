exception Error of string * int * int

let ints_of_pos (pos : Lexing.position) =
  pos.pos_lnum, pos.pos_cnum - pos.pos_bol
                                 
let string_of_pos l c =
  ("Line " ^ (string_of_int l)
   ^ ", column "^ (string_of_int c) ^ ": ")

let parse_and_translate mlts_prog =
  let tokens = Lexing.from_string mlts_prog in
  try
    let p = MltsParser.main MltsLexer.token tokens in

    let prog, _, _, _ = Translator.toLPString p in
    prog
  with Translator.TranslatorError(s, pos)
       -> raise (Error("Translation error : " ^ s, 0, 0))
     | MltsLexer.Error(s, pos)
       -> let l, c = ints_of_pos pos in
          raise (Error((string_of_pos l c) ^ "Lexing error : " ^ s, l, c))
     | MltsParser.Error ->
        let l, c = ints_of_pos (tokens.Lexing.lex_start_p) in
        raise (Error((string_of_pos l c) ^ "Parsing error.", l, c))
