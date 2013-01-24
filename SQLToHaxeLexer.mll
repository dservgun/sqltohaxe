(*A tokenizer for sql statements*)
{
  open SQLToHaxeParser;;
  open Lexing;;
  let string_chars s = String.sub s 1 ((String.length s)-2) ;;
  
  (*Keywords are not case sensitive.
  Column names, table names are case sensitive.*)
  
  let keywords = 
    [ 
      ("BOOL", BOOL);
      ("CHARSET", CHARSET);
      ("BOOLEAN", BOOL);
      ("DROP", DROP);
      ("EXISTS", EXISTS);
      ("INSERT", INSERT);
      ("INTO", INTO);
      ("VALUES", VALUES);
      ("COMMENT", COMMENT);
      ("AUTO_INCREMENT", AUTO_INCREMENT);
      ("DEFAULT", DEFAULT);
      ("CHECK", CHECK);
      ("KEY", KEY);
      ("CREATE", CREATE);
      ("ROW_FORMAT", ROW_FORMAT);
      ("TABLE", TABLE);
      ("PRIMARY", PRIMARY);
      ("FOREIGN", FOREIGN);
      ("TYPE", TYPE);
      ("ENGINE", ENGINE);
      ("DATETIME", DATETIME);
      ("VARCHAR", VARCHAR);
      ("COLLATE",COLLATE);
      ("TEMPORARY", TEMPORARY);
      ("IF", IF);
      ("ASC", ASC);
      ("DESC", DESC);
      ("NOT", NOT);
      ("UNIQUE", UNIQUE);
      ("BIT", BIT);
      ("TINYINT", TINYINT);
      ("SMALLINT", SMALLINT);
      ("MEDIUMINT", MEDIUMINT);
      ("INDEX", INDEX);
      ("KEY", KEY);
      ("INT", INTEGERTOKEN);
      ("BIGINT", BIGINT);
      ("REAL", REALTOKEN);
      ("DOUBLE", DOUBLETOKEN);
      ("FLOAT", FLOATTOKEN);
      ("DECIMAL", DECIMALTOKEN);
      ("NUMERIC", NUMERICTOKEN);
      ("DATE", DATETOKEN);
      ("TIME", TIMETOKEN);
      ("TIMESTAMP", TIMESTAMPTOKEN);
      ("DATETIME", DATETIMETOKEN);
      ("YEAR", YEARTOKEN);
      ("CHAR", CHARACTER);
      ("CHARACTER", CHARACTER);
      ("COLLATION", COLLATION);
      ("BINARY", BINARY);
      ("VARBINARY", VARBINARY);
      ("TINYBLOB", TINYBLOB);
      ("BLOB", BLOB);
      ("MEDIUMBLOB", MEDIUMBLOB);
      ("LONGBLOB", LONGBLOB);
      ("TEXT", TEXT);
      ("TINYTEXT", TINYTEXT);
      ("MEDIUMTEXT", MEDIUMTEXT);
      ("LONGTEXT", LONGTEXT);
      ("ENUM", ENUM);
      ("REFERENCES", REFERENCES);
      ("MATCH", MATCH);
      ("FULL", FULL);
      ("PARTIAL", PARTIAL);
      ("SIMPLE", SIMPLE);
      ("ON", ON);
      ("UPDATE", UPDATE);
      ("DELETE", DELETE);
      ("RESTRICT" , RESTRICT);
      ("CASCADE", CASCADE);
      ("SET", SET);
      ("NULL", NULL);
      ("NO", NO);
      ("ACTION", ACTION);
      ("USING", USING);
      ("BTREE", BTREE);
      ("HASH", HASH);
      ("RTREE", RTREE)
      ]

  let symbolTable = Hashtbl.create 100;;
  let loadKeywords aList aTable = List.iter (fun (x,y) -> Hashtbl.add aTable x y) keywords;;
  loadKeywords keywords symbolTable;;
  let incr_linenum lexbuf =     
  	let pos = lexbuf.Lexing.lex_curr_p in
    lexbuf.Lexing.lex_curr_p <- { pos with
      Lexing.pos_lnum = pos.Lexing.pos_lnum + 1;
      Lexing.pos_bol = pos.Lexing.pos_cnum - pos.Lexing.pos_bol;
      Lexing.pos_cnum = 0
    }
  let ident (tokenText : string) = 
    let convertCase = String.uppercase tokenText in
    if Hashtbl.mem symbolTable convertCase then 
    let result = Hashtbl.find symbolTable convertCase in
    	Printf.printf "ident %s \n" tokenText;
      result
    else 
      let result = ID(tokenText) in
      	Printf.printf "ident %s\n" tokenText;
        result;;

}

let num = ['0' - '9']+
let intNum = '-'?num
let floatNum = '-'?num ('.' num)? (['e' 'E'] num)?
let lowerCase = ['a'-'z']
let upperCase = ['A'-'Z']
let ident = ['a'-'z' 'A'-'Z' '0'-'9' '_']['a'-'z' 'A'-'Z' '0'-'9' '_']*
let SPACE = ' ' | '\t'
let NEWLINE = '\n' | '\r' '\n'
let START_COMMENT = "--"
let ALT_START_COMMENT = "/*"
let ALT_END_COMMENT = "*/"
let LPAREN = '('
let RPAREN = ')'
let COMMA = ','
let SEMI_COLON = ';'
let EQUALS = '='
let LBRACKET ='['
let RBRACKET = ']'
let LBRACE = '{'
let RBRACE = '}'
let QUOTE = "'"
let BACKTICK = '`'
let DOUBLE_QUOTE ='"'

rule token = parse
  | intNum { INT ( int_of_string(Lexing.lexeme lexbuf))}
  | floatNum {FLOAT (float_of_string (Lexing.lexeme lexbuf))}
  | ident {
      ident (Lexing.lexeme lexbuf)}	    
  | START_COMMENT {comment lexbuf}
  | ALT_START_COMMENT {alt_comment lexbuf}
  | SPACE {token lexbuf}
  | COMMA {COMMA}
  | NEWLINE {incr_linenum lexbuf; token lexbuf}
  | EQUALS {EQUALS}
  | SEMI_COLON {SEMI_COLON}
  | LPAREN {LPAREN}
  | RPAREN {RPAREN}
  |  '"' [^ '"']* '"' { ident(string_chars (Lexing.lexeme lexbuf))}
  |  ''' [^ ''']* ''' { ident(string_chars (Lexing.lexeme lexbuf))}
  |  '`' [^ '`']* '`' { ident(string_chars (Lexing.lexeme lexbuf))}
  | eof {EOF}
and comment = parse 
  | NEWLINE { 
  	token lexbuf}
  | _ {comment lexbuf}
and alt_comment = parse 
	| ALT_END_COMMENT {token lexbuf}
	| _ {alt_comment lexbuf}
