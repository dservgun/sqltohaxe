%{
  open TableDefinition.TableDefinition;;
  open GeneratorConstants.GeneratorConstants;;
  open ColumnDefinition.ColumnDefinition;;
  exception UnsupportedException;;
  exception UnsupportedStatement;;
  (* TODO: Better parsing rules for engine options *)
%}
%start start
%token <string> ID 
%token <int> INT
%token <float> FLOAT
%token EOF
%token DOUBLE_QUOTE
%token LPAREN RPAREN BACKTICK SPACE NEWLINE COMMA SEMI_COLON TYPE QUOTE ENGINE
%token CREATE TABLE INTEGER FOREIGN EQUALS PRIMARY LBRACKET RBRACKET IF NOT EXISTS
%token LBRACE RBRACE ROW_FORMAT
%token ASC DESC UNIQUE BIT USING
%token BTREE RTREE HASH
%token TINYINT SMALLINT MEDIUMINT
%token INTTOKEN INTEGERTOKEN BIGINT
%token REALTOKEN DOUBLETOKEN FLOATTOKEN
%token DECIMALTOKEN NUMERICTOKEN
%token DATETOKEN TIMETOKEN
%token TIMESTAMPTOKEN DATETIMETOKEN
%token YEARTOKEN KEY INDEX REFERENCES
%token TEMPORARY CHECK BINARY VARBINARY TINYBLOB BLOB MEDIUMBLOB LONGBLOB 
%token TINYTEXT TEXT MEDIUMTEXT LONGTEXT ENUM
%token DATETIME VARCHAR CHARACTER SET COLLATE
%token MATCH FULL PARTIAL SIMPLE 
%token ON UPDATE DELETE 
%token RESTRICT CASCADE NULL NO ACTION
%token DEFAULT AUTO_INCREMENT COMMENT
%token INSERT INTO VALUES
%token CHARACTER_SET COLLATION BOOL CHARSET
%token DROP
%left INDEX KEY 
%type <TableDefinition.TableDefinition.statement list> start 

%%

start : StatementList {$1}
StatementList : Statement {[$1]} | Statement SEMI_COLON StatementList {$1 :: $3} | Statement SEMI_COLON {[$1]}
Statement : CREATE TemporaryTable TABLE TableExists ID_DEF LPAREN CreateDefinition RPAREN TableOption 
  {  
    logger("Inside create statement...");
    createCreateStatement $2 $4 $5 $7
  }
  | INSERT INTO ID VALUES LPAREN InsertValueList RPAREN { InsertStatement}
  | DROP TABLE IF EXISTS ID {Printf.printf "Drop not supported";NoStatement}
  | SET ID EQUALS INT {Printf.printf "SET not supported";NoStatement}
  | SET ID EQUALS ID  {Printf.printf "SET not supported ";NoStatement}
  
TemporaryTable : {Permanent} | LBRACKET TEMPORARY RBRACKET {Temporary}
TableExists : {NOT_EXISTS}  | IF NOT EXISTS {NOT_EXISTS}
CreateDefinition :  ColumnDefinition {[$1]} | ColumnDefinition COMMA CreateDefinition {$1 :: $3}
ColumnDefinition :  ID_DEF ColumnDataTypeDefinition {
						abbrCreateColumn $1 $2}
				| KEY ID LPAREN IndexColumnList RPAREN {
					Printf.printf "Creating key column for %s\n" "UniqueKey";
					createKeyColumn UniqueKey $4;
				
				}
				|  PRIMARY KEY IndexType LPAREN IndexColumnList RPAREN 
				  {
					Printf.printf "Creating key column for %s\n" "PrimaryKey";
					createKeyColumn PrimaryKey $5;
				  }
				| PRIMARY KEY LPAREN IndexColumnList RPAREN
					{
						Printf.printf "Creating key column for %s\n" "Primary Key";
						createKeyColumn PrimaryKey $4
					}				
				|  UNIQUE KEY IndexName IndexType LPAREN IndexColumnList RPAREN
				  {
					createKeyColumn UniqueKey $4
				  }
				|  FullOrSpatial IndexOrKey IndexName LPAREN IndexColumnList RPAREN IndexType
				  {
					raise UnsupportedStatement
				  }
				|  FOREIGN KEY LPAREN IndexColumnName RPAREN ReferenceDefinition
				  {
				  (*
					Datatype should match the reference.TODO
					Check the foreign key and mark the field as a foreign key.
					*)
					createKeyColumn ForeignKey [$4]
				  }
				|  CHECK LPAREN Expression RPAREN {raise UnsupportedStatement}
				| INDEX ID LPAREN IndexColumnList OptionalOrderBy RPAREN {createKeyColumn UniqueKey $4}				
OptionalOrderBy : 
	{"ASC"}
	| ASC {"ASC"}
	| DESC {"DESC"}
	
ColumnDataTypeDefinition : DataType ColumnTypeQualifiers 
{ 
  ColumnDef(createColumnWithQualifiers $1 $2)
}

DataType : 
  | BIT OptionalLength {BitType ($2)}
  | TINYINT OptionalLength {TinyIntType($2)}
  | SMALLINT OptionalLength {SmallIntType ($2)}
  | MEDIUMINT OptionalLength {IntType ($2)}
  | INTEGERTOKEN OptionalLength {IntType($2)}
  | BIGINT OptionalLength {BigIntType ($2)}
  | REALTOKEN OptionalDecimalSpec {RealType(createRealType($2))}
  | DOUBLETOKEN OptionalDecimalSpec {RealType(createRealType($2))}
  | FLOATTOKEN OptionalDecimalSpec {RealType(createRealType($2))}
  | DECIMALTOKEN OptionalDecimalSpec {RealType(createRealType($2))}
  | NUMERICTOKEN OptionalDecimalSpec {RealType(createRealType($2))}
  | TIMETOKEN {TimeType}
  | DATETOKEN {DateType}
  | TIMESTAMPTOKEN {TimeStampType}
  | DATETIMETOKEN {DateTimeType}
  | YEARTOKEN {YearType}
  | CHARACTER OptionalLength {CharType($2)}
  | VARCHAR LPAREN INT RPAREN OptionalCharset OptionalCollation 
  {
    (*Handle error in case of incorrect input*)
    createVarcharField (IntLength($3)) $5 $6
  }
  | BINARY OptionalLength 
  {
    createBinaryField $2
  }
  | VARBINARY LPAREN ID_DEF RPAREN { VarBinary (int_of_string $3)}
  | TINYBLOB {TinyBlob}
  | BLOB {Blob}
  | MEDIUMBLOB {MediumBlob}
  | LONGBLOB {LongBlob}
  | TEXT OptionalBinary OptionalCharset OptionalCollation {createTextField $2 $3 $4}
  | TINYTEXT OptionalBinary OptionalCharset OptionalCollation {createTinyTextField $2 $3 $4}
  | MEDIUMTEXT OptionalBinary OptionalCharset OptionalCollation {createMediumTextField $2 $3 $4}
  | LONGTEXT OptionalBinary OptionalCharset OptionalCollation {createLongTextField $2 $3 $4}
  | ENUM LPAREN ValueList RPAREN{EnumType ($3)}
  | SET LPAREN ValueList RPAREN {SetType($3)}
  | SpatialText {$1}
  | BOOL {BoolType}


TableOption : 
		{
		logger ("No table option specified");
		""} 
		| TYPE EQUALS ID_DEF {$3} 
		| ENGINE EQUALS ID_DEF {$3}
		| ENGINE EQUALS ID_DEF DEFAULT CHARSET EQUALS ID_DEF {$3}
		| ENGINE EQUALS ID_DEF DEFAULT CHARSET EQUALS ID_DEF ROW_FORMAT EQUALS ID_DEF {$3}
		| ENGINE EQUALS ID_DEF DEFAULT CHARSET EQUALS ID_DEF COMMENT EQUALS ID {$3}
		| ENGINE EQUALS ID_DEF DEFAULT CHARSET EQUALS ID_DEF COMMENT EQUALS ID AUTO_INCREMENT EQUALS INT {$3}
		| ENGINE EQUALS ID_DEF DEFAULT CHARSET EQUALS ID_DEF AUTO_INCREMENT EQUALS INT {$3}
		| ENGINE EQUALS ID_DEF DEFAULT CHARSET EQUALS ID_DEF ROW_FORMAT EQUALS ID_DEF AUTO_INCREMENT EQUALS INT {$3}
		| ENGINE EQUALS ID_DEF DEFAULT CHARACTER SET EQUALS ID_DEF COLLATE EQUALS ID_DEF {$3}
		| ENGINE EQUALS ID_DEF DEFAULT CHARACTER SET EQUALS ID_DEF COLLATE EQUALS ID_DEF COMMENT EQUALS ID {$3}
		| ENGINE EQUALS ID_DEF DEFAULT CHARACTER SET EQUALS ID_DEF ROW_FORMAT EQUALS ID_DEF AUTO_INCREMENT EQUALS INT{$3}
		
Temporary: {TEMPORARY}
IndexOrKey : INDEX {Index} | KEY {Key}
ReferenceDefinition : REFERENCES ID_DEF LPAREN IndexColumnList RPAREN MatchReference DeleteConstraint {}
IndexColumnList :
  IndexColumnName {
  Printf.printf "Index column --->%s\n" (printIndexColumn $1);
  [$1]
  } | 
  IndexColumnName COMMA IndexColumnList {$1 :: $3}
IndexColumnName : 
  ID_DEF OptionalLength OptionalOrder {createIndexColumn $1 $2 $3}
OptionalLength : {NoColumnLength} | LPAREN INT RPAREN 
{
  IntLength($2)
} 
OptionalOrder : {NoColumnOrder}| ASC {Ascending} | DESC {Descending}
OptionalBinary : {false} | BINARY {true}
OptionalCharset : {defaultCharset} | CHARACTER SET ID_DEF {$3}
OptionalCollation :{defaultCollation} | COLLATE ID_DEF {$2}
OptionalDecimalSpec : {(0,0)} | ID_DEF COMMA ID_DEF {(int_of_string $1, int_of_string $3)}
SpatialText : {raise UnsupportedType}
SelectStatement : {raise UnsupportedStatement}
IDLIST : ID_DEF {[$1]} | ID_DEF COMMA IDLIST {$1 :: $3}
ID_DEF : ID {$1}
ColumnTypeQualifiers: 
	OptionalNull OptionalDefault  OptionalUniqueKey OptionalPrimaryKey AutoIncrement OptionalComment
  	{
    ($1, $2, $3, $4, false, $5, $6)
  	}

OptionalDefault: 
        		{"Default"} 
				| DEFAULT ID_DEF
					{
						Printf.printf "Default value %s\n" 
					$2; "Default"}
				| DEFAULT INT {
					Printf.printf "Default value %d\n" $2;
					"Default"
				}
				| DEFAULT NULL {"Default"}
OptionalNull:
	{true} 
	| NOT NULL {false} 
    |NULL {true}
    
AutoIncrement : {false} | AUTO_INCREMENT {true}
OptionalUniqueKey: {false} | UNIQUE {true} |UNIQUE KEY {true}
OptionalPrimaryKey : {false} | PRIMARY {true} |PRIMARY KEY {true}
OptionalComment : {defaultOptionalComment} | COMMENT  ID {$2} 
IndexType : {[]} | USING LBRACE IndexAlgorithm RBRACE {[]}  | USING IndexAlgorithm {[]}
IndexAlgorithm : BTREE {} | HASH {}| RTREE {}
IndexName : {""} | ID {$1}
FullOrSpatial : {""}
Expression : {""}
ValueList : Value {[$1]} | Value COMMA ValueList {$1 :: $3}
Value: QUOTE EscapedString QUOTE {$2}
EscapedString : ID {Printf.printf "%s" $1;$1} | ID EscapedString {$1 ^ " " ^ $2}
MatchReference : {Simple} | MATCH FULL {Full} | MATCH PARTIAL {Partial} | MATCH SIMPLE {Simple}
DeleteConstraint : {NoAction} | ON DELETE ReferenceOption {$3}
UpdateConstraint : {NoAction} | ON UPDATE ReferenceOption {$3}
ReferenceOption : RESTRICT {Restrict} | CASCADE {Cascade} | SET NULL {SetNull} | NO ACTION {NoAction}
InsertValueList : {}
