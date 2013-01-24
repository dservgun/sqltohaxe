type token =
  | ID of (string)
  | INT of (int)
  | FLOAT of (float)
  | EOF
  | DOUBLE_QUOTE
  | LPAREN
  | RPAREN
  | BACKTICK
  | SPACE
  | NEWLINE
  | COMMA
  | SEMI_COLON
  | TYPE
  | QUOTE
  | ENGINE
  | CREATE
  | TABLE
  | INTEGER
  | FOREIGN
  | EQUALS
  | PRIMARY
  | LBRACKET
  | RBRACKET
  | IF
  | NOT
  | EXISTS
  | LBRACE
  | RBRACE
  | ROW_FORMAT
  | ASC
  | DESC
  | UNIQUE
  | BIT
  | USING
  | BTREE
  | RTREE
  | HASH
  | TINYINT
  | SMALLINT
  | MEDIUMINT
  | INTTOKEN
  | INTEGERTOKEN
  | BIGINT
  | REALTOKEN
  | DOUBLETOKEN
  | FLOATTOKEN
  | DECIMALTOKEN
  | NUMERICTOKEN
  | DATETOKEN
  | TIMETOKEN
  | TIMESTAMPTOKEN
  | DATETIMETOKEN
  | YEARTOKEN
  | KEY
  | INDEX
  | REFERENCES
  | TEMPORARY
  | CHECK
  | BINARY
  | VARBINARY
  | TINYBLOB
  | BLOB
  | MEDIUMBLOB
  | LONGBLOB
  | TINYTEXT
  | TEXT
  | MEDIUMTEXT
  | LONGTEXT
  | ENUM
  | DATETIME
  | VARCHAR
  | CHARACTER
  | SET
  | COLLATE
  | MATCH
  | FULL
  | PARTIAL
  | SIMPLE
  | ON
  | UPDATE
  | DELETE
  | RESTRICT
  | CASCADE
  | NULL
  | NO
  | ACTION
  | DEFAULT
  | AUTO_INCREMENT
  | COMMENT
  | INSERT
  | INTO
  | VALUES
  | CHARACTER_SET
  | COLLATION
  | BOOL
  | CHARSET
  | DROP

open Parsing;;
# 1 "SQLToHaxeParser.mly"

  open TableDefinition.TableDefinition;;
  open GeneratorConstants.GeneratorConstants;;
  open ColumnDefinition.ColumnDefinition;;
  exception UnsupportedException;;
  exception UnsupportedStatement;;
  (* TODO: Better parsing rules for engine options *)
# 110 "SQLToHaxeParser.ml"
let yytransl_const = [|
    0 (* EOF *);
  260 (* DOUBLE_QUOTE *);
  261 (* LPAREN *);
  262 (* RPAREN *);
  263 (* BACKTICK *);
  264 (* SPACE *);
  265 (* NEWLINE *);
  266 (* COMMA *);
  267 (* SEMI_COLON *);
  268 (* TYPE *);
  269 (* QUOTE *);
  270 (* ENGINE *);
  271 (* CREATE *);
  272 (* TABLE *);
  273 (* INTEGER *);
  274 (* FOREIGN *);
  275 (* EQUALS *);
  276 (* PRIMARY *);
  277 (* LBRACKET *);
  278 (* RBRACKET *);
  279 (* IF *);
  280 (* NOT *);
  281 (* EXISTS *);
  282 (* LBRACE *);
  283 (* RBRACE *);
  284 (* ROW_FORMAT *);
  285 (* ASC *);
  286 (* DESC *);
  287 (* UNIQUE *);
  288 (* BIT *);
  289 (* USING *);
  290 (* BTREE *);
  291 (* RTREE *);
  292 (* HASH *);
  293 (* TINYINT *);
  294 (* SMALLINT *);
  295 (* MEDIUMINT *);
  296 (* INTTOKEN *);
  297 (* INTEGERTOKEN *);
  298 (* BIGINT *);
  299 (* REALTOKEN *);
  300 (* DOUBLETOKEN *);
  301 (* FLOATTOKEN *);
  302 (* DECIMALTOKEN *);
  303 (* NUMERICTOKEN *);
  304 (* DATETOKEN *);
  305 (* TIMETOKEN *);
  306 (* TIMESTAMPTOKEN *);
  307 (* DATETIMETOKEN *);
  308 (* YEARTOKEN *);
  309 (* KEY *);
  310 (* INDEX *);
  311 (* REFERENCES *);
  312 (* TEMPORARY *);
  313 (* CHECK *);
  314 (* BINARY *);
  315 (* VARBINARY *);
  316 (* TINYBLOB *);
  317 (* BLOB *);
  318 (* MEDIUMBLOB *);
  319 (* LONGBLOB *);
  320 (* TINYTEXT *);
  321 (* TEXT *);
  322 (* MEDIUMTEXT *);
  323 (* LONGTEXT *);
  324 (* ENUM *);
  325 (* DATETIME *);
  326 (* VARCHAR *);
  327 (* CHARACTER *);
  328 (* SET *);
  329 (* COLLATE *);
  330 (* MATCH *);
  331 (* FULL *);
  332 (* PARTIAL *);
  333 (* SIMPLE *);
  334 (* ON *);
  335 (* UPDATE *);
  336 (* DELETE *);
  337 (* RESTRICT *);
  338 (* CASCADE *);
  339 (* NULL *);
  340 (* NO *);
  341 (* ACTION *);
  342 (* DEFAULT *);
  343 (* AUTO_INCREMENT *);
  344 (* COMMENT *);
  345 (* INSERT *);
  346 (* INTO *);
  347 (* VALUES *);
  348 (* CHARACTER_SET *);
  349 (* COLLATION *);
  350 (* BOOL *);
  351 (* CHARSET *);
  352 (* DROP *);
    0|]

let yytransl_block = [|
  257 (* ID *);
  258 (* INT *);
  259 (* FLOAT *);
    0|]

let yylhs = "\255\255\
\001\000\002\000\002\000\002\000\003\000\003\000\003\000\003\000\
\003\000\004\000\004\000\005\000\005\000\007\000\007\000\010\000\
\010\000\010\000\010\000\010\000\010\000\010\000\010\000\010\000\
\020\000\020\000\020\000\011\000\021\000\021\000\021\000\021\000\
\021\000\021\000\021\000\021\000\021\000\021\000\021\000\021\000\
\021\000\021\000\021\000\021\000\021\000\021\000\021\000\021\000\
\021\000\021\000\021\000\021\000\021\000\021\000\021\000\021\000\
\021\000\021\000\021\000\021\000\008\000\008\000\008\000\008\000\
\008\000\008\000\008\000\008\000\008\000\008\000\008\000\008\000\
\030\000\016\000\016\000\018\000\012\000\012\000\017\000\023\000\
\023\000\033\000\033\000\033\000\027\000\027\000\025\000\025\000\
\026\000\026\000\024\000\024\000\029\000\034\000\035\000\035\000\
\006\000\022\000\037\000\037\000\037\000\037\000\036\000\036\000\
\036\000\040\000\040\000\038\000\038\000\038\000\039\000\039\000\
\039\000\041\000\041\000\013\000\013\000\013\000\042\000\042\000\
\042\000\014\000\014\000\015\000\019\000\028\000\028\000\043\000\
\044\000\044\000\031\000\031\000\031\000\031\000\032\000\032\000\
\046\000\046\000\045\000\045\000\045\000\045\000\009\000\000\000"

let yylen = "\002\000\
\001\000\001\000\003\000\002\000\009\000\007\000\005\000\004\000\
\004\000\000\000\003\000\000\000\003\000\001\000\003\000\002\000\
\005\000\006\000\005\000\007\000\007\000\006\000\004\000\006\000\
\000\000\001\000\001\000\002\000\002\000\002\000\002\000\002\000\
\002\000\002\000\002\000\002\000\002\000\002\000\002\000\001\000\
\001\000\001\000\001\000\001\000\002\000\006\000\002\000\004\000\
\001\000\001\000\001\000\001\000\004\000\004\000\004\000\004\000\
\004\000\004\000\001\000\001\000\000\000\003\000\003\000\007\000\
\010\000\010\000\013\000\010\000\013\000\011\000\014\000\014\000\
\000\000\001\000\001\000\007\000\001\000\003\000\003\000\000\000\
\003\000\000\000\001\000\001\000\000\000\001\000\000\000\003\000\
\000\000\002\000\000\000\003\000\000\000\000\000\001\000\003\000\
\001\000\006\000\000\000\002\000\002\000\002\000\000\000\002\000\
\001\000\000\000\001\000\000\000\001\000\002\000\000\000\001\000\
\002\000\000\000\002\000\000\000\004\000\002\000\001\000\001\000\
\001\000\000\000\001\000\000\000\000\000\001\000\003\000\003\000\
\001\000\002\000\000\000\002\000\002\000\002\000\000\000\003\000\
\000\000\003\000\001\000\001\000\002\000\002\000\000\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\144\000\001\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\003\000\011\000\000\000\000\000\
\009\000\008\000\000\000\000\000\000\000\097\000\000\000\143\000\
\007\000\013\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\006\000\000\000\
\000\000\000\000\000\000\000\000\125\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\041\000\040\000\042\000\043\000\044\000\000\000\000\000\049\000\
\050\000\051\000\052\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\060\000\016\000\000\000\059\000\000\000\
\000\000\075\000\074\000\000\000\000\000\000\000\000\000\000\000\
\123\000\000\000\000\000\000\000\000\000\000\000\029\000\030\000\
\031\000\032\000\033\000\034\000\000\000\035\000\036\000\037\000\
\038\000\039\000\047\000\000\000\086\000\000\000\000\000\000\000\
\000\000\000\000\000\000\045\000\000\000\000\000\105\000\028\000\
\000\000\000\000\000\000\005\000\015\000\000\000\000\000\000\000\
\000\000\000\000\000\000\119\000\121\000\120\000\118\000\000\000\
\000\000\000\000\000\000\023\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\104\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\019\000\000\000\000\000\000\000\000\000\017\000\026\000\
\027\000\000\000\081\000\092\000\048\000\000\000\000\000\054\000\
\053\000\055\000\056\000\000\000\000\000\057\000\000\000\000\000\
\058\000\101\000\102\000\100\000\000\000\000\000\062\000\000\000\
\000\000\083\000\084\000\079\000\000\000\022\000\078\000\117\000\
\018\000\000\000\024\000\088\000\090\000\130\000\128\000\127\000\
\000\000\110\000\000\000\000\000\000\000\000\000\000\000\020\000\
\046\000\113\000\107\000\000\000\000\000\000\000\021\000\000\000\
\000\000\098\000\000\000\000\000\000\000\115\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\132\000\133\000\134\000\000\000\
\076\000\000\000\000\000\000\000\068\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\139\000\140\000\000\000\136\000\
\000\000\000\000\000\000\000\000\141\000\142\000\000\000\000\000\
\069\000\067\000\072\000\071\000"

let yydgoto = "\002\000\
\007\000\008\000\009\000\011\000\024\000\135\000\044\000\132\000\
\036\000\045\000\085\000\137\000\096\000\098\000\046\000\092\000\
\138\000\206\000\101\000\178\000\086\000\128\000\103\000\110\000\
\153\000\184\000\118\000\158\000\087\000\000\000\247\000\001\001\
\204\000\000\000\000\000\129\000\164\000\198\000\220\000\228\000\
\234\000\143\000\159\000\189\000\016\001\000\000"

let yysindex = "\023\000\
\076\255\000\000\006\255\050\255\230\254\083\255\000\000\000\000\
\078\255\046\255\098\255\108\255\133\255\123\255\076\255\128\255\
\137\255\016\255\082\255\139\255\000\000\000\000\155\255\189\255\
\000\000\000\000\177\255\197\255\163\255\000\000\199\255\000\000\
\000\000\000\000\185\255\196\255\156\255\161\255\166\255\223\255\
\224\255\222\255\242\255\227\255\239\255\153\255\000\000\245\255\
\017\255\250\255\247\255\248\255\000\000\251\255\251\255\251\255\
\251\255\251\255\251\255\189\255\189\255\189\255\189\255\189\255\
\000\000\000\000\000\000\000\000\000\000\251\255\252\255\000\000\
\000\000\000\000\000\000\200\255\200\255\200\255\200\255\254\255\
\255\255\251\255\014\000\000\000\000\000\002\255\000\000\135\255\
\185\255\000\000\000\000\250\255\189\255\189\255\187\255\016\000\
\000\000\228\255\189\255\189\255\249\255\007\000\000\000\000\000\
\000\000\000\000\000\000\000\000\253\255\000\000\000\000\000\000\
\000\000\000\000\000\000\189\255\000\000\191\255\191\255\191\255\
\191\255\009\000\008\000\000\000\009\000\184\255\000\000\000\000\
\178\255\020\000\021\000\000\000\000\000\037\000\251\255\035\000\
\049\000\010\000\195\255\000\000\000\000\000\000\000\000\189\255\
\038\000\053\000\207\255\000\000\054\000\189\255\055\000\210\255\
\246\255\246\255\246\255\246\255\061\000\058\000\056\000\059\000\
\062\000\000\000\011\255\039\000\189\255\189\255\189\255\211\255\
\012\000\000\000\189\255\042\000\065\000\189\255\000\000\000\000\
\000\000\066\000\000\000\000\000\000\000\189\255\189\255\000\000\
\000\000\000\000\000\000\061\000\060\000\000\000\009\000\191\255\
\000\000\000\000\000\000\000\000\022\000\057\000\000\000\244\255\
\070\000\000\000\000\000\000\000\189\255\000\000\000\000\000\000\
\000\000\072\000\000\000\000\000\000\000\000\000\000\000\000\000\
\246\255\000\000\026\000\011\000\210\254\228\255\076\000\000\000\
\000\000\000\000\000\000\013\000\017\000\063\000\000\000\189\255\
\082\000\000\000\067\000\189\255\078\000\000\000\189\255\043\255\
\018\000\243\254\068\000\069\000\071\000\168\255\019\000\074\000\
\075\000\189\255\083\000\090\000\000\000\000\000\000\000\024\000\
\000\000\189\255\189\255\025\000\000\000\027\000\136\255\028\000\
\029\000\077\000\080\000\030\000\000\000\000\000\031\000\000\000\
\081\000\084\000\093\000\100\000\000\000\000\000\103\000\105\000\
\000\000\000\000\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\091\000\000\000\000\000\000\000\000\000\000\000\
\108\001\000\000\000\000\000\000\000\000\000\000\109\001\000\000\
\050\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\037\255\000\000\104\000\000\000\000\000\000\000\
\000\000\073\255\000\000\000\000\000\000\049\255\049\255\049\255\
\049\255\049\255\049\255\080\255\080\255\080\255\080\255\080\255\
\000\000\000\000\000\000\000\000\000\000\049\255\000\000\000\000\
\000\000\000\000\000\000\010\255\010\255\010\255\010\255\000\000\
\000\000\049\255\000\000\000\000\000\000\057\255\000\000\001\000\
\000\000\000\000\000\000\254\255\000\000\000\000\000\000\000\000\
\000\000\252\255\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\022\255\022\255\022\255\
\022\255\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\025\255\000\000\000\000\000\000\000\000\000\000\181\255\000\000\
\000\000\132\255\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\112\000\000\000\000\000\000\000\000\000\000\000\
\097\255\097\255\097\255\097\255\000\000\000\000\113\000\000\000\
\000\000\000\000\000\000\064\255\000\000\000\000\000\000\004\255\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\098\000\000\000\000\000\000\000\022\255\
\000\000\000\000\000\000\000\000\109\255\066\255\000\000\002\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\097\255\000\000\112\255\013\255\000\000\023\255\000\000\000\000\
\000\000\000\000\000\000\048\255\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\003\000\
\038\255\000\000\000\000\000\000\000\000\000\000\056\255\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\004\000\000\000\005\000\000\000\000\000\
\006\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000"

let yygindex = "\000\000\
\000\000\105\001\000\000\000\000\000\000\232\255\032\001\000\000\
\000\000\000\000\000\000\164\255\167\255\030\001\000\000\000\000\
\031\001\000\000\000\000\000\000\000\000\000\000\119\000\131\000\
\036\000\015\000\169\000\152\255\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\240\000\000\000\193\000\000\000\000\000"

let yytablesize = 381
let yytable = "\031\000\
\061\000\063\000\064\000\065\000\066\000\070\000\146\000\147\000\
\145\000\082\000\043\000\030\000\194\000\082\000\248\000\085\000\
\025\000\026\000\106\000\085\000\161\000\094\000\106\000\001\000\
\229\000\126\000\010\000\087\000\116\000\085\000\099\000\087\000\
\116\000\085\000\099\000\109\000\109\000\109\000\109\000\109\000\
\085\000\087\000\093\000\131\000\099\000\087\000\093\000\131\000\
\230\000\095\000\012\000\173\000\087\000\114\000\080\000\099\000\
\093\000\114\000\080\000\249\000\093\000\135\000\103\000\013\000\
\043\000\135\000\103\000\093\000\080\000\108\000\243\000\111\000\
\080\000\108\000\201\000\111\000\103\000\122\000\207\000\080\000\
\085\000\210\000\085\000\108\000\127\000\091\000\216\000\103\000\
\015\000\091\000\003\000\151\000\085\000\195\000\087\000\085\000\
\085\000\085\000\014\000\091\000\106\000\016\000\089\000\091\000\
\087\000\122\000\089\000\087\000\087\000\087\000\091\000\099\000\
\099\000\017\000\109\000\131\000\089\000\112\000\109\000\093\000\
\089\000\112\000\093\000\093\000\093\000\180\000\018\000\089\000\
\109\000\244\000\245\000\080\000\231\000\019\000\080\000\080\000\
\080\000\077\000\196\000\237\000\199\000\200\000\103\000\103\000\
\103\000\020\000\130\000\004\000\131\000\022\000\108\000\108\000\
\111\000\111\000\154\000\155\000\156\000\212\000\213\000\023\000\
\077\000\077\000\091\000\028\000\005\000\091\000\091\000\091\000\
\185\000\186\000\187\000\006\000\027\000\104\000\105\000\106\000\
\107\000\108\000\029\000\089\000\223\000\032\000\089\000\089\000\
\089\000\030\000\080\000\034\000\115\000\030\000\080\000\111\000\
\112\000\113\000\114\000\109\000\109\000\033\000\112\000\112\000\
\124\000\047\000\037\000\035\000\038\000\090\000\091\000\012\001\
\048\000\080\000\080\000\240\000\139\000\049\000\242\000\039\000\
\013\001\014\001\050\000\015\001\140\000\141\000\142\000\051\000\
\052\000\004\001\053\000\217\000\140\000\141\000\142\000\225\000\
\088\000\008\001\009\001\176\000\177\000\040\000\041\000\202\000\
\203\000\042\000\253\000\254\000\255\000\119\000\120\000\121\000\
\089\000\093\000\097\000\099\000\100\000\168\000\148\000\102\000\
\116\000\117\000\122\000\123\000\095\000\152\000\150\000\163\000\
\149\000\160\000\162\000\061\000\063\000\064\000\065\000\066\000\
\070\000\054\000\125\000\171\000\144\000\157\000\055\000\056\000\
\057\000\182\000\058\000\059\000\060\000\061\000\062\000\063\000\
\064\000\065\000\066\000\067\000\068\000\069\000\165\000\166\000\
\169\000\167\000\174\000\070\000\071\000\072\000\073\000\074\000\
\075\000\076\000\077\000\078\000\079\000\080\000\170\000\081\000\
\082\000\083\000\175\000\179\000\181\000\188\000\183\000\190\000\
\192\000\191\000\205\000\193\000\208\000\197\000\209\000\211\000\
\215\000\221\000\218\000\222\000\219\000\224\000\226\000\084\000\
\232\000\236\000\238\000\241\000\005\001\239\000\250\000\251\000\
\235\000\252\000\006\001\246\000\002\001\003\001\025\001\019\001\
\000\001\227\000\020\001\023\001\233\000\026\001\024\001\007\001\
\027\001\028\001\010\000\002\000\004\000\014\000\129\000\010\001\
\021\001\011\001\017\001\022\001\018\001\025\000\126\000\021\000\
\133\000\134\000\172\000\136\000\214\000"

let yycheck = "\024\000\
\000\000\000\000\000\000\000\000\000\000\000\000\099\000\100\000\
\098\000\006\001\035\000\001\001\002\001\010\001\028\001\006\001\
\001\001\002\001\006\001\010\001\125\000\005\001\010\001\001\000\
\071\001\024\001\021\001\006\001\006\001\020\001\006\001\010\001\
\010\001\024\001\010\001\060\000\061\000\062\000\063\000\064\000\
\031\001\020\001\006\001\006\001\020\001\024\001\010\001\010\001\
\095\001\033\001\001\001\144\000\031\001\006\001\006\001\031\001\
\020\001\010\001\010\001\073\001\024\001\006\001\006\001\090\001\
\089\000\010\001\010\001\031\001\020\001\006\001\028\001\006\001\
\024\001\010\001\167\000\010\001\020\001\005\001\171\000\031\001\
\071\001\174\000\073\001\020\001\083\001\006\001\191\000\031\001\
\011\001\010\001\015\001\116\000\083\001\083\001\073\001\086\001\
\087\001\088\001\016\001\020\001\088\001\056\001\006\001\024\001\
\083\001\033\001\010\001\086\001\087\001\088\001\031\001\087\001\
\088\001\016\001\006\001\078\001\020\001\006\001\010\001\083\001\
\024\001\010\001\086\001\087\001\088\001\150\000\019\001\031\001\
\020\001\087\001\088\001\083\001\222\000\001\001\086\001\087\001\
\088\001\006\001\163\000\232\000\165\000\166\000\086\001\087\001\
\088\001\023\001\012\001\072\001\014\001\022\001\087\001\088\001\
\087\001\088\001\119\000\120\000\121\000\182\000\183\000\023\001\
\029\001\030\001\083\001\025\001\089\001\086\001\087\001\088\001\
\154\000\155\000\156\000\096\001\091\001\055\000\056\000\057\000\
\058\000\059\000\024\001\083\001\205\000\005\001\086\001\087\001\
\088\001\001\001\006\001\025\001\070\000\001\001\010\001\061\000\
\062\000\063\000\064\000\087\001\088\001\001\001\087\001\088\001\
\082\000\006\001\018\001\005\001\020\001\053\001\054\001\072\001\
\053\001\029\001\030\001\236\000\026\001\053\001\239\000\031\001\
\081\001\082\001\053\001\084\001\034\001\035\001\036\001\001\001\
\001\001\250\000\005\001\192\000\034\001\035\001\036\001\217\000\
\006\001\002\001\003\001\029\001\030\001\053\001\054\001\029\001\
\030\001\057\001\075\001\076\001\077\001\077\000\078\000\079\000\
\010\001\005\001\001\001\005\001\005\001\135\000\006\001\005\001\
\005\001\058\001\005\001\005\001\033\001\071\001\010\001\086\001\
\002\001\002\001\083\001\011\001\011\001\011\001\011\001\011\001\
\011\001\032\001\005\001\010\001\005\001\013\001\037\001\038\001\
\039\001\072\001\041\001\042\001\043\001\044\001\045\001\046\001\
\047\001\048\001\049\001\050\001\051\001\052\001\019\001\019\001\
\006\001\005\001\005\001\058\001\059\001\060\001\061\001\062\001\
\063\001\064\001\065\001\066\001\067\001\068\001\006\001\070\001\
\071\001\072\001\006\001\006\001\006\001\001\001\073\001\006\001\
\006\001\010\001\055\001\006\001\027\001\031\001\006\001\006\001\
\013\001\086\001\053\001\006\001\020\001\006\001\053\001\094\001\
\005\001\019\001\001\001\006\001\002\001\019\001\019\001\019\001\
\072\001\019\001\001\001\074\001\019\001\019\001\002\001\019\001\
\078\001\087\001\019\001\019\001\088\001\002\001\019\001\080\001\
\002\001\001\001\016\001\000\000\000\000\006\001\013\001\087\001\
\083\001\087\001\087\001\085\001\088\001\006\001\006\001\015\000\
\089\000\092\000\139\000\093\000\188\000"

let yynames_const = "\
  EOF\000\
  DOUBLE_QUOTE\000\
  LPAREN\000\
  RPAREN\000\
  BACKTICK\000\
  SPACE\000\
  NEWLINE\000\
  COMMA\000\
  SEMI_COLON\000\
  TYPE\000\
  QUOTE\000\
  ENGINE\000\
  CREATE\000\
  TABLE\000\
  INTEGER\000\
  FOREIGN\000\
  EQUALS\000\
  PRIMARY\000\
  LBRACKET\000\
  RBRACKET\000\
  IF\000\
  NOT\000\
  EXISTS\000\
  LBRACE\000\
  RBRACE\000\
  ROW_FORMAT\000\
  ASC\000\
  DESC\000\
  UNIQUE\000\
  BIT\000\
  USING\000\
  BTREE\000\
  RTREE\000\
  HASH\000\
  TINYINT\000\
  SMALLINT\000\
  MEDIUMINT\000\
  INTTOKEN\000\
  INTEGERTOKEN\000\
  BIGINT\000\
  REALTOKEN\000\
  DOUBLETOKEN\000\
  FLOATTOKEN\000\
  DECIMALTOKEN\000\
  NUMERICTOKEN\000\
  DATETOKEN\000\
  TIMETOKEN\000\
  TIMESTAMPTOKEN\000\
  DATETIMETOKEN\000\
  YEARTOKEN\000\
  KEY\000\
  INDEX\000\
  REFERENCES\000\
  TEMPORARY\000\
  CHECK\000\
  BINARY\000\
  VARBINARY\000\
  TINYBLOB\000\
  BLOB\000\
  MEDIUMBLOB\000\
  LONGBLOB\000\
  TINYTEXT\000\
  TEXT\000\
  MEDIUMTEXT\000\
  LONGTEXT\000\
  ENUM\000\
  DATETIME\000\
  VARCHAR\000\
  CHARACTER\000\
  SET\000\
  COLLATE\000\
  MATCH\000\
  FULL\000\
  PARTIAL\000\
  SIMPLE\000\
  ON\000\
  UPDATE\000\
  DELETE\000\
  RESTRICT\000\
  CASCADE\000\
  NULL\000\
  NO\000\
  ACTION\000\
  DEFAULT\000\
  AUTO_INCREMENT\000\
  COMMENT\000\
  INSERT\000\
  INTO\000\
  VALUES\000\
  CHARACTER_SET\000\
  COLLATION\000\
  BOOL\000\
  CHARSET\000\
  DROP\000\
  "

let yynames_block = "\
  ID\000\
  INT\000\
  FLOAT\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'StatementList) in
    Obj.repr(
# 42 "SQLToHaxeParser.mly"
                      (_1)
# 595 "SQLToHaxeParser.ml"
               : TableDefinition.TableDefinition.statement list))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Statement) in
    Obj.repr(
# 43 "SQLToHaxeParser.mly"
                          ([_1])
# 602 "SQLToHaxeParser.ml"
               : 'StatementList))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'Statement) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'StatementList) in
    Obj.repr(
# 43 "SQLToHaxeParser.mly"
                                                                      (_1 :: _3)
# 610 "SQLToHaxeParser.ml"
               : 'StatementList))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'Statement) in
    Obj.repr(
# 43 "SQLToHaxeParser.mly"
                                                                                                        ([_1])
# 617 "SQLToHaxeParser.ml"
               : 'StatementList))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 7 : 'TemporaryTable) in
    let _4 = (Parsing.peek_val __caml_parser_env 5 : 'TableExists) in
    let _5 = (Parsing.peek_val __caml_parser_env 4 : 'ID_DEF) in
    let _7 = (Parsing.peek_val __caml_parser_env 2 : 'CreateDefinition) in
    let _9 = (Parsing.peek_val __caml_parser_env 0 : 'TableOption) in
    Obj.repr(
# 45 "SQLToHaxeParser.mly"
  (  
    logger("Inside create statement...");
    createCreateStatement _2 _4 _5 _7
  )
# 631 "SQLToHaxeParser.ml"
               : 'Statement))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _6 = (Parsing.peek_val __caml_parser_env 1 : 'InsertValueList) in
    Obj.repr(
# 49 "SQLToHaxeParser.mly"
                                                        ( InsertStatement)
# 639 "SQLToHaxeParser.ml"
               : 'Statement))
; (fun __caml_parser_env ->
    let _5 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 50 "SQLToHaxeParser.mly"
                            (Printf.printf "Drop not supported";NoStatement)
# 646 "SQLToHaxeParser.ml"
               : 'Statement))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 51 "SQLToHaxeParser.mly"
                      (Printf.printf "SET not supported";NoStatement)
# 654 "SQLToHaxeParser.ml"
               : 'Statement))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 52 "SQLToHaxeParser.mly"
                      (Printf.printf "SET not supported ";NoStatement)
# 662 "SQLToHaxeParser.ml"
               : 'Statement))
; (fun __caml_parser_env ->
    Obj.repr(
# 54 "SQLToHaxeParser.mly"
                 (Permanent)
# 668 "SQLToHaxeParser.ml"
               : 'TemporaryTable))
; (fun __caml_parser_env ->
    Obj.repr(
# 54 "SQLToHaxeParser.mly"
                                                           (Temporary)
# 674 "SQLToHaxeParser.ml"
               : 'TemporaryTable))
; (fun __caml_parser_env ->
    Obj.repr(
# 55 "SQLToHaxeParser.mly"
              (NOT_EXISTS)
# 680 "SQLToHaxeParser.ml"
               : 'TableExists))
; (fun __caml_parser_env ->
    Obj.repr(
# 55 "SQLToHaxeParser.mly"
                                            (NOT_EXISTS)
# 686 "SQLToHaxeParser.ml"
               : 'TableExists))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'ColumnDefinition) in
    Obj.repr(
# 56 "SQLToHaxeParser.mly"
                                     ([_1])
# 693 "SQLToHaxeParser.ml"
               : 'CreateDefinition))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'ColumnDefinition) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'CreateDefinition) in
    Obj.repr(
# 56 "SQLToHaxeParser.mly"
                                                                                      (_1 :: _3)
# 701 "SQLToHaxeParser.ml"
               : 'CreateDefinition))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'ID_DEF) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'ColumnDataTypeDefinition) in
    Obj.repr(
# 57 "SQLToHaxeParser.mly"
                                                    (
            abbrCreateColumn _1 _2)
# 710 "SQLToHaxeParser.ml"
               : 'ColumnDefinition))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'IndexColumnList) in
    Obj.repr(
# 59 "SQLToHaxeParser.mly"
                                           (
          Printf.printf "Creating key column for %s\n" "UniqueKey";
          createKeyColumn UniqueKey _4;
        
        )
# 722 "SQLToHaxeParser.ml"
               : 'ColumnDefinition))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 3 : 'IndexType) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : 'IndexColumnList) in
    Obj.repr(
# 65 "SQLToHaxeParser.mly"
      (
          Printf.printf "Creating key column for %s\n" "PrimaryKey";
          createKeyColumn PrimaryKey _5;
          )
# 733 "SQLToHaxeParser.ml"
               : 'ColumnDefinition))
; (fun __caml_parser_env ->
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'IndexColumnList) in
    Obj.repr(
# 70 "SQLToHaxeParser.mly"
     (
            Printf.printf "Creating key column for %s\n" "Primary Key";
            createKeyColumn PrimaryKey _4
          )
# 743 "SQLToHaxeParser.ml"
               : 'ColumnDefinition))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 4 : 'IndexName) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : 'IndexType) in
    let _6 = (Parsing.peek_val __caml_parser_env 1 : 'IndexColumnList) in
    Obj.repr(
# 75 "SQLToHaxeParser.mly"
      (
          createKeyColumn UniqueKey _4
          )
# 754 "SQLToHaxeParser.ml"
               : 'ColumnDefinition))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 6 : 'FullOrSpatial) in
    let _2 = (Parsing.peek_val __caml_parser_env 5 : 'IndexOrKey) in
    let _3 = (Parsing.peek_val __caml_parser_env 4 : 'IndexName) in
    let _5 = (Parsing.peek_val __caml_parser_env 2 : 'IndexColumnList) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : 'IndexType) in
    Obj.repr(
# 79 "SQLToHaxeParser.mly"
      (
          raise UnsupportedStatement
          )
# 767 "SQLToHaxeParser.ml"
               : 'ColumnDefinition))
; (fun __caml_parser_env ->
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'IndexColumnName) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'ReferenceDefinition) in
    Obj.repr(
# 83 "SQLToHaxeParser.mly"
      (
          (*
          Datatype should match the reference.TODO
          Check the foreign key and mark the field as a foreign key.
          *)
          createKeyColumn ForeignKey [_4]
          )
# 781 "SQLToHaxeParser.ml"
               : 'ColumnDefinition))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'Expression) in
    Obj.repr(
# 90 "SQLToHaxeParser.mly"
                                      (raise UnsupportedStatement)
# 788 "SQLToHaxeParser.ml"
               : 'ColumnDefinition))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : string) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'IndexColumnList) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : 'OptionalOrderBy) in
    Obj.repr(
# 91 "SQLToHaxeParser.mly"
                                                             (createKeyColumn UniqueKey _4)
# 797 "SQLToHaxeParser.ml"
               : 'ColumnDefinition))
; (fun __caml_parser_env ->
    Obj.repr(
# 93 "SQLToHaxeParser.mly"
 ("ASC")
# 803 "SQLToHaxeParser.ml"
               : 'OptionalOrderBy))
; (fun __caml_parser_env ->
    Obj.repr(
# 94 "SQLToHaxeParser.mly"
       ("ASC")
# 809 "SQLToHaxeParser.ml"
               : 'OptionalOrderBy))
; (fun __caml_parser_env ->
    Obj.repr(
# 95 "SQLToHaxeParser.mly"
        ("DESC")
# 815 "SQLToHaxeParser.ml"
               : 'OptionalOrderBy))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : 'DataType) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'ColumnTypeQualifiers) in
    Obj.repr(
# 98 "SQLToHaxeParser.mly"
( 
  ColumnDef(createColumnWithQualifiers _1 _2)
)
# 825 "SQLToHaxeParser.ml"
               : 'ColumnDataTypeDefinition))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'OptionalLength) in
    Obj.repr(
# 103 "SQLToHaxeParser.mly"
                       (BitType (_2))
# 832 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'OptionalLength) in
    Obj.repr(
# 104 "SQLToHaxeParser.mly"
                           (TinyIntType(_2))
# 839 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'OptionalLength) in
    Obj.repr(
# 105 "SQLToHaxeParser.mly"
                            (SmallIntType (_2))
# 846 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'OptionalLength) in
    Obj.repr(
# 106 "SQLToHaxeParser.mly"
                             (IntType (_2))
# 853 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'OptionalLength) in
    Obj.repr(
# 107 "SQLToHaxeParser.mly"
                                (IntType(_2))
# 860 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'OptionalLength) in
    Obj.repr(
# 108 "SQLToHaxeParser.mly"
                          (BigIntType (_2))
# 867 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'OptionalDecimalSpec) in
    Obj.repr(
# 109 "SQLToHaxeParser.mly"
                                  (RealType(createRealType(_2)))
# 874 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'OptionalDecimalSpec) in
    Obj.repr(
# 110 "SQLToHaxeParser.mly"
                                    (RealType(createRealType(_2)))
# 881 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'OptionalDecimalSpec) in
    Obj.repr(
# 111 "SQLToHaxeParser.mly"
                                   (RealType(createRealType(_2)))
# 888 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'OptionalDecimalSpec) in
    Obj.repr(
# 112 "SQLToHaxeParser.mly"
                                     (RealType(createRealType(_2)))
# 895 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'OptionalDecimalSpec) in
    Obj.repr(
# 113 "SQLToHaxeParser.mly"
                                     (RealType(createRealType(_2)))
# 902 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    Obj.repr(
# 114 "SQLToHaxeParser.mly"
              (TimeType)
# 908 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    Obj.repr(
# 115 "SQLToHaxeParser.mly"
              (DateType)
# 914 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    Obj.repr(
# 116 "SQLToHaxeParser.mly"
                   (TimeStampType)
# 920 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    Obj.repr(
# 117 "SQLToHaxeParser.mly"
                  (DateTimeType)
# 926 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    Obj.repr(
# 118 "SQLToHaxeParser.mly"
              (YearType)
# 932 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'OptionalLength) in
    Obj.repr(
# 119 "SQLToHaxeParser.mly"
                             (CharType(_2))
# 939 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 3 : int) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : 'OptionalCharset) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'OptionalCollation) in
    Obj.repr(
# 121 "SQLToHaxeParser.mly"
  (
    (*Handle error in case of incorrect input*)
    createVarcharField (IntLength(_3)) _5 _6
  )
# 951 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'OptionalLength) in
    Obj.repr(
# 126 "SQLToHaxeParser.mly"
  (
    createBinaryField _2
  )
# 960 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'ID_DEF) in
    Obj.repr(
# 129 "SQLToHaxeParser.mly"
                                   ( VarBinary (int_of_string _3))
# 967 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    Obj.repr(
# 130 "SQLToHaxeParser.mly"
             (TinyBlob)
# 973 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    Obj.repr(
# 131 "SQLToHaxeParser.mly"
         (Blob)
# 979 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    Obj.repr(
# 132 "SQLToHaxeParser.mly"
               (MediumBlob)
# 985 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    Obj.repr(
# 133 "SQLToHaxeParser.mly"
             (LongBlob)
# 991 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'OptionalBinary) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'OptionalCharset) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'OptionalCollation) in
    Obj.repr(
# 134 "SQLToHaxeParser.mly"
                                                          (createTextField _2 _3 _4)
# 1000 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'OptionalBinary) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'OptionalCharset) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'OptionalCollation) in
    Obj.repr(
# 135 "SQLToHaxeParser.mly"
                                                              (createTinyTextField _2 _3 _4)
# 1009 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'OptionalBinary) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'OptionalCharset) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'OptionalCollation) in
    Obj.repr(
# 136 "SQLToHaxeParser.mly"
                                                                (createMediumTextField _2 _3 _4)
# 1018 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 2 : 'OptionalBinary) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'OptionalCharset) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'OptionalCollation) in
    Obj.repr(
# 137 "SQLToHaxeParser.mly"
                                                              (createLongTextField _2 _3 _4)
# 1027 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'ValueList) in
    Obj.repr(
# 138 "SQLToHaxeParser.mly"
                                (EnumType (_3))
# 1034 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'ValueList) in
    Obj.repr(
# 139 "SQLToHaxeParser.mly"
                                (SetType(_3))
# 1041 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'SpatialText) in
    Obj.repr(
# 140 "SQLToHaxeParser.mly"
                (_1)
# 1048 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    Obj.repr(
# 141 "SQLToHaxeParser.mly"
         (BoolType)
# 1054 "SQLToHaxeParser.ml"
               : 'DataType))
; (fun __caml_parser_env ->
    Obj.repr(
# 145 "SQLToHaxeParser.mly"
  (
    logger ("No table option specified");
    "")
# 1062 "SQLToHaxeParser.ml"
               : 'TableOption))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'ID_DEF) in
    Obj.repr(
# 148 "SQLToHaxeParser.mly"
                       (_3)
# 1069 "SQLToHaxeParser.ml"
               : 'TableOption))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'ID_DEF) in
    Obj.repr(
# 149 "SQLToHaxeParser.mly"
                         (_3)
# 1076 "SQLToHaxeParser.ml"
               : 'TableOption))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 4 : 'ID_DEF) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : 'ID_DEF) in
    Obj.repr(
# 150 "SQLToHaxeParser.mly"
                                                       (_3)
# 1084 "SQLToHaxeParser.ml"
               : 'TableOption))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 7 : 'ID_DEF) in
    let _7 = (Parsing.peek_val __caml_parser_env 3 : 'ID_DEF) in
    let _10 = (Parsing.peek_val __caml_parser_env 0 : 'ID_DEF) in
    Obj.repr(
# 151 "SQLToHaxeParser.mly"
                                                                                (_3)
# 1093 "SQLToHaxeParser.ml"
               : 'TableOption))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 7 : 'ID_DEF) in
    let _7 = (Parsing.peek_val __caml_parser_env 3 : 'ID_DEF) in
    let _10 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 152 "SQLToHaxeParser.mly"
                                                                         (_3)
# 1102 "SQLToHaxeParser.ml"
               : 'TableOption))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 10 : 'ID_DEF) in
    let _7 = (Parsing.peek_val __caml_parser_env 6 : 'ID_DEF) in
    let _10 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _13 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 153 "SQLToHaxeParser.mly"
                                                                                                   (_3)
# 1112 "SQLToHaxeParser.ml"
               : 'TableOption))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 7 : 'ID_DEF) in
    let _7 = (Parsing.peek_val __caml_parser_env 3 : 'ID_DEF) in
    let _10 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 154 "SQLToHaxeParser.mly"
                                                                                 (_3)
# 1121 "SQLToHaxeParser.ml"
               : 'TableOption))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 10 : 'ID_DEF) in
    let _7 = (Parsing.peek_val __caml_parser_env 6 : 'ID_DEF) in
    let _10 = (Parsing.peek_val __caml_parser_env 3 : 'ID_DEF) in
    let _13 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 155 "SQLToHaxeParser.mly"
                                                                                                          (_3)
# 1131 "SQLToHaxeParser.ml"
               : 'TableOption))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 8 : 'ID_DEF) in
    let _8 = (Parsing.peek_val __caml_parser_env 3 : 'ID_DEF) in
    let _11 = (Parsing.peek_val __caml_parser_env 0 : 'ID_DEF) in
    Obj.repr(
# 156 "SQLToHaxeParser.mly"
                                                                                   (_3)
# 1140 "SQLToHaxeParser.ml"
               : 'TableOption))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 11 : 'ID_DEF) in
    let _8 = (Parsing.peek_val __caml_parser_env 6 : 'ID_DEF) in
    let _11 = (Parsing.peek_val __caml_parser_env 3 : 'ID_DEF) in
    let _14 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 157 "SQLToHaxeParser.mly"
                                                                                                     (_3)
# 1150 "SQLToHaxeParser.ml"
               : 'TableOption))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 11 : 'ID_DEF) in
    let _8 = (Parsing.peek_val __caml_parser_env 6 : 'ID_DEF) in
    let _11 = (Parsing.peek_val __caml_parser_env 3 : 'ID_DEF) in
    let _14 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 158 "SQLToHaxeParser.mly"
                                                                                                               (_3)
# 1160 "SQLToHaxeParser.ml"
               : 'TableOption))
; (fun __caml_parser_env ->
    Obj.repr(
# 160 "SQLToHaxeParser.mly"
           (TEMPORARY)
# 1166 "SQLToHaxeParser.ml"
               : 'Temporary))
; (fun __caml_parser_env ->
    Obj.repr(
# 161 "SQLToHaxeParser.mly"
                   (Index)
# 1172 "SQLToHaxeParser.ml"
               : 'IndexOrKey))
; (fun __caml_parser_env ->
    Obj.repr(
# 161 "SQLToHaxeParser.mly"
                                 (Key)
# 1178 "SQLToHaxeParser.ml"
               : 'IndexOrKey))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 5 : 'ID_DEF) in
    let _4 = (Parsing.peek_val __caml_parser_env 3 : 'IndexColumnList) in
    let _6 = (Parsing.peek_val __caml_parser_env 1 : 'MatchReference) in
    let _7 = (Parsing.peek_val __caml_parser_env 0 : 'DeleteConstraint) in
    Obj.repr(
# 162 "SQLToHaxeParser.mly"
                                                                                                      ()
# 1188 "SQLToHaxeParser.ml"
               : 'ReferenceDefinition))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'IndexColumnName) in
    Obj.repr(
# 164 "SQLToHaxeParser.mly"
                  (
  Printf.printf "Index column --->%s\n" (printIndexColumn _1);
  [_1]
  )
# 1198 "SQLToHaxeParser.ml"
               : 'IndexColumnList))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'IndexColumnName) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'IndexColumnList) in
    Obj.repr(
# 168 "SQLToHaxeParser.mly"
                                        (_1 :: _3)
# 1206 "SQLToHaxeParser.ml"
               : 'IndexColumnList))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'ID_DEF) in
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'OptionalLength) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'OptionalOrder) in
    Obj.repr(
# 170 "SQLToHaxeParser.mly"
                                      (createIndexColumn _1 _2 _3)
# 1215 "SQLToHaxeParser.ml"
               : 'IndexColumnName))
; (fun __caml_parser_env ->
    Obj.repr(
# 171 "SQLToHaxeParser.mly"
                 (NoColumnLength)
# 1221 "SQLToHaxeParser.ml"
               : 'OptionalLength))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : int) in
    Obj.repr(
# 172 "SQLToHaxeParser.mly"
(
  IntLength(_2)
)
# 1230 "SQLToHaxeParser.ml"
               : 'OptionalLength))
; (fun __caml_parser_env ->
    Obj.repr(
# 175 "SQLToHaxeParser.mly"
                (NoColumnOrder)
# 1236 "SQLToHaxeParser.ml"
               : 'OptionalOrder))
; (fun __caml_parser_env ->
    Obj.repr(
# 175 "SQLToHaxeParser.mly"
                                     (Ascending)
# 1242 "SQLToHaxeParser.ml"
               : 'OptionalOrder))
; (fun __caml_parser_env ->
    Obj.repr(
# 175 "SQLToHaxeParser.mly"
                                                        (Descending)
# 1248 "SQLToHaxeParser.ml"
               : 'OptionalOrder))
; (fun __caml_parser_env ->
    Obj.repr(
# 176 "SQLToHaxeParser.mly"
                 (false)
# 1254 "SQLToHaxeParser.ml"
               : 'OptionalBinary))
; (fun __caml_parser_env ->
    Obj.repr(
# 176 "SQLToHaxeParser.mly"
                                  (true)
# 1260 "SQLToHaxeParser.ml"
               : 'OptionalBinary))
; (fun __caml_parser_env ->
    Obj.repr(
# 177 "SQLToHaxeParser.mly"
                  (defaultCharset)
# 1266 "SQLToHaxeParser.ml"
               : 'OptionalCharset))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'ID_DEF) in
    Obj.repr(
# 177 "SQLToHaxeParser.mly"
                                                          (_3)
# 1273 "SQLToHaxeParser.ml"
               : 'OptionalCharset))
; (fun __caml_parser_env ->
    Obj.repr(
# 178 "SQLToHaxeParser.mly"
                   (defaultCollation)
# 1279 "SQLToHaxeParser.ml"
               : 'OptionalCollation))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'ID_DEF) in
    Obj.repr(
# 178 "SQLToHaxeParser.mly"
                                                       (_2)
# 1286 "SQLToHaxeParser.ml"
               : 'OptionalCollation))
; (fun __caml_parser_env ->
    Obj.repr(
# 179 "SQLToHaxeParser.mly"
                      ((0,0))
# 1292 "SQLToHaxeParser.ml"
               : 'OptionalDecimalSpec))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'ID_DEF) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'ID_DEF) in
    Obj.repr(
# 179 "SQLToHaxeParser.mly"
                                                    ((int_of_string _1, int_of_string _3))
# 1300 "SQLToHaxeParser.ml"
               : 'OptionalDecimalSpec))
; (fun __caml_parser_env ->
    Obj.repr(
# 180 "SQLToHaxeParser.mly"
              (raise UnsupportedType)
# 1306 "SQLToHaxeParser.ml"
               : 'SpatialText))
; (fun __caml_parser_env ->
    Obj.repr(
# 181 "SQLToHaxeParser.mly"
                  (raise UnsupportedStatement)
# 1312 "SQLToHaxeParser.ml"
               : 'SelectStatement))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'ID_DEF) in
    Obj.repr(
# 182 "SQLToHaxeParser.mly"
                ([_1])
# 1319 "SQLToHaxeParser.ml"
               : 'IDLIST))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'ID_DEF) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'IDLIST) in
    Obj.repr(
# 182 "SQLToHaxeParser.mly"
                                             (_1 :: _3)
# 1327 "SQLToHaxeParser.ml"
               : 'IDLIST))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 183 "SQLToHaxeParser.mly"
            (_1)
# 1334 "SQLToHaxeParser.ml"
               : 'ID_DEF))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 5 : 'OptionalNull) in
    let _2 = (Parsing.peek_val __caml_parser_env 4 : 'OptionalDefault) in
    let _3 = (Parsing.peek_val __caml_parser_env 3 : 'OptionalUniqueKey) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'OptionalPrimaryKey) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : 'AutoIncrement) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'OptionalComment) in
    Obj.repr(
# 186 "SQLToHaxeParser.mly"
   (
    (_1, _2, _3, _4, false, _5, _6)
    )
# 1348 "SQLToHaxeParser.ml"
               : 'ColumnTypeQualifiers))
; (fun __caml_parser_env ->
    Obj.repr(
# 191 "SQLToHaxeParser.mly"
          ("Default")
# 1354 "SQLToHaxeParser.ml"
               : 'OptionalDefault))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'ID_DEF) in
    Obj.repr(
# 193 "SQLToHaxeParser.mly"
     (
            Printf.printf "Default value %s\n" 
          _2; "Default")
# 1363 "SQLToHaxeParser.ml"
               : 'OptionalDefault))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 196 "SQLToHaxeParser.mly"
                  (
          Printf.printf "Default value %d\n" _2;
          "Default"
        )
# 1373 "SQLToHaxeParser.ml"
               : 'OptionalDefault))
; (fun __caml_parser_env ->
    Obj.repr(
# 200 "SQLToHaxeParser.mly"
                   ("Default")
# 1379 "SQLToHaxeParser.ml"
               : 'OptionalDefault))
; (fun __caml_parser_env ->
    Obj.repr(
# 202 "SQLToHaxeParser.mly"
 (true)
# 1385 "SQLToHaxeParser.ml"
               : 'OptionalNull))
; (fun __caml_parser_env ->
    Obj.repr(
# 203 "SQLToHaxeParser.mly"
            (false)
# 1391 "SQLToHaxeParser.ml"
               : 'OptionalNull))
; (fun __caml_parser_env ->
    Obj.repr(
# 204 "SQLToHaxeParser.mly"
          (true)
# 1397 "SQLToHaxeParser.ml"
               : 'OptionalNull))
; (fun __caml_parser_env ->
    Obj.repr(
# 206 "SQLToHaxeParser.mly"
                (false)
# 1403 "SQLToHaxeParser.ml"
               : 'AutoIncrement))
; (fun __caml_parser_env ->
    Obj.repr(
# 206 "SQLToHaxeParser.mly"
                                         (true)
# 1409 "SQLToHaxeParser.ml"
               : 'AutoIncrement))
; (fun __caml_parser_env ->
    Obj.repr(
# 207 "SQLToHaxeParser.mly"
                   (false)
# 1415 "SQLToHaxeParser.ml"
               : 'OptionalUniqueKey))
; (fun __caml_parser_env ->
    Obj.repr(
# 207 "SQLToHaxeParser.mly"
                                    (true)
# 1421 "SQLToHaxeParser.ml"
               : 'OptionalUniqueKey))
; (fun __caml_parser_env ->
    Obj.repr(
# 207 "SQLToHaxeParser.mly"
                                                       (true)
# 1427 "SQLToHaxeParser.ml"
               : 'OptionalUniqueKey))
; (fun __caml_parser_env ->
    Obj.repr(
# 208 "SQLToHaxeParser.mly"
                     (false)
# 1433 "SQLToHaxeParser.ml"
               : 'OptionalPrimaryKey))
; (fun __caml_parser_env ->
    Obj.repr(
# 208 "SQLToHaxeParser.mly"
                                       (true)
# 1439 "SQLToHaxeParser.ml"
               : 'OptionalPrimaryKey))
; (fun __caml_parser_env ->
    Obj.repr(
# 208 "SQLToHaxeParser.mly"
                                                           (true)
# 1445 "SQLToHaxeParser.ml"
               : 'OptionalPrimaryKey))
; (fun __caml_parser_env ->
    Obj.repr(
# 209 "SQLToHaxeParser.mly"
                  (defaultOptionalComment)
# 1451 "SQLToHaxeParser.ml"
               : 'OptionalComment))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 209 "SQLToHaxeParser.mly"
                                                         (_2)
# 1458 "SQLToHaxeParser.ml"
               : 'OptionalComment))
; (fun __caml_parser_env ->
    Obj.repr(
# 210 "SQLToHaxeParser.mly"
            ([])
# 1464 "SQLToHaxeParser.ml"
               : 'IndexType))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'IndexAlgorithm) in
    Obj.repr(
# 210 "SQLToHaxeParser.mly"
                                                      ([])
# 1471 "SQLToHaxeParser.ml"
               : 'IndexType))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'IndexAlgorithm) in
    Obj.repr(
# 210 "SQLToHaxeParser.mly"
                                                                                   ([])
# 1478 "SQLToHaxeParser.ml"
               : 'IndexType))
; (fun __caml_parser_env ->
    Obj.repr(
# 211 "SQLToHaxeParser.mly"
                       ()
# 1484 "SQLToHaxeParser.ml"
               : 'IndexAlgorithm))
; (fun __caml_parser_env ->
    Obj.repr(
# 211 "SQLToHaxeParser.mly"
                                 ()
# 1490 "SQLToHaxeParser.ml"
               : 'IndexAlgorithm))
; (fun __caml_parser_env ->
    Obj.repr(
# 211 "SQLToHaxeParser.mly"
                                           ()
# 1496 "SQLToHaxeParser.ml"
               : 'IndexAlgorithm))
; (fun __caml_parser_env ->
    Obj.repr(
# 212 "SQLToHaxeParser.mly"
            ("")
# 1502 "SQLToHaxeParser.ml"
               : 'IndexName))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 212 "SQLToHaxeParser.mly"
                      (_1)
# 1509 "SQLToHaxeParser.ml"
               : 'IndexName))
; (fun __caml_parser_env ->
    Obj.repr(
# 213 "SQLToHaxeParser.mly"
                ("")
# 1515 "SQLToHaxeParser.ml"
               : 'FullOrSpatial))
; (fun __caml_parser_env ->
    Obj.repr(
# 214 "SQLToHaxeParser.mly"
             ("")
# 1521 "SQLToHaxeParser.ml"
               : 'Expression))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'Value) in
    Obj.repr(
# 215 "SQLToHaxeParser.mly"
                  ([_1])
# 1528 "SQLToHaxeParser.ml"
               : 'ValueList))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'Value) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'ValueList) in
    Obj.repr(
# 215 "SQLToHaxeParser.mly"
                                                 (_1 :: _3)
# 1536 "SQLToHaxeParser.ml"
               : 'ValueList))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'EscapedString) in
    Obj.repr(
# 216 "SQLToHaxeParser.mly"
                                 (_2)
# 1543 "SQLToHaxeParser.ml"
               : 'Value))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 217 "SQLToHaxeParser.mly"
                   (Printf.printf "%s" _1;_1)
# 1550 "SQLToHaxeParser.ml"
               : 'EscapedString))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : string) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'EscapedString) in
    Obj.repr(
# 217 "SQLToHaxeParser.mly"
                                                                 (_1 ^ " " ^ _2)
# 1558 "SQLToHaxeParser.ml"
               : 'EscapedString))
; (fun __caml_parser_env ->
    Obj.repr(
# 218 "SQLToHaxeParser.mly"
                 (Simple)
# 1564 "SQLToHaxeParser.ml"
               : 'MatchReference))
; (fun __caml_parser_env ->
    Obj.repr(
# 218 "SQLToHaxeParser.mly"
                                       (Full)
# 1570 "SQLToHaxeParser.ml"
               : 'MatchReference))
; (fun __caml_parser_env ->
    Obj.repr(
# 218 "SQLToHaxeParser.mly"
                                                              (Partial)
# 1576 "SQLToHaxeParser.ml"
               : 'MatchReference))
; (fun __caml_parser_env ->
    Obj.repr(
# 218 "SQLToHaxeParser.mly"
                                                                                       (Simple)
# 1582 "SQLToHaxeParser.ml"
               : 'MatchReference))
; (fun __caml_parser_env ->
    Obj.repr(
# 219 "SQLToHaxeParser.mly"
                   (NoAction)
# 1588 "SQLToHaxeParser.ml"
               : 'DeleteConstraint))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'ReferenceOption) in
    Obj.repr(
# 219 "SQLToHaxeParser.mly"
                                                          (_3)
# 1595 "SQLToHaxeParser.ml"
               : 'DeleteConstraint))
; (fun __caml_parser_env ->
    Obj.repr(
# 220 "SQLToHaxeParser.mly"
                   (NoAction)
# 1601 "SQLToHaxeParser.ml"
               : 'UpdateConstraint))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'ReferenceOption) in
    Obj.repr(
# 220 "SQLToHaxeParser.mly"
                                                          (_3)
# 1608 "SQLToHaxeParser.ml"
               : 'UpdateConstraint))
; (fun __caml_parser_env ->
    Obj.repr(
# 221 "SQLToHaxeParser.mly"
                           (Restrict)
# 1614 "SQLToHaxeParser.ml"
               : 'ReferenceOption))
; (fun __caml_parser_env ->
    Obj.repr(
# 221 "SQLToHaxeParser.mly"
                                                (Cascade)
# 1620 "SQLToHaxeParser.ml"
               : 'ReferenceOption))
; (fun __caml_parser_env ->
    Obj.repr(
# 221 "SQLToHaxeParser.mly"
                                                                     (SetNull)
# 1626 "SQLToHaxeParser.ml"
               : 'ReferenceOption))
; (fun __caml_parser_env ->
    Obj.repr(
# 221 "SQLToHaxeParser.mly"
                                                                                           (NoAction)
# 1632 "SQLToHaxeParser.ml"
               : 'ReferenceOption))
; (fun __caml_parser_env ->
    Obj.repr(
# 222 "SQLToHaxeParser.mly"
                  ()
# 1638 "SQLToHaxeParser.ml"
               : 'InsertValueList))
(* Entry start *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let start (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : TableDefinition.TableDefinition.statement list)
