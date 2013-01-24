module TableDefinition = struct 
exception UndefinedType;;
exception UndefinedKeyType;;

open ColumnDefinition.ColumnDefinition;;
type tableStorageType = Temporary | Permanent;;
(*TODO: cleanup this type *)
type tableExists = NOT_EXISTS;;
exception InvalidStatement;;
type table = {
  tableName : string;
  columns : column list;
  constraints : dbConstraint list;
  primaryKeys: string list;
  indexes : string list;
  uniqueKeys: string list
}
  
type createStatement = {
  tableName: string;
  columns : column list;
  tableExists: tableExists;
  tableStorage : tableStorageType  
  };;
  

type statement = NoStatement | SelectStatement | InsertStatement | CreateStatement of createStatement;;

let printTableExists a = match a with NOT_EXISTS -> "Not Exists"

let printStorageType a = 
match a with 
Temporary -> "Temporory" 
|Permanent -> "Permanent";;

let printStatement aStatement = match aStatement with
	NoStatement -> "NoStatement"
	|SelectStatement -> "SelectStatement"
	| InsertStatement -> "InsertStatement"
	| CreateStatement(c) -> Printf.sprintf "%s -> %s: %s" c.tableName (printTableExists c.tableExists) 
(printStorageType c.tableStorage);;
	

let printStatements aStatementList = 
	let result = List.fold_left( fun accum x -> accum ^ (printStatement x) ^ "\n") "" 
		aStatementList in
	result;;

let createCreateStatement tableStorage tableExists tableName columns=
  let result = CreateStatement({
    tableStorage = tableStorage;
    tableName = tableName;
    columns = columns;
    tableExists = tableExists
  }) in result;;



let getPrimaryKeyIds aTable =
List.filter (fun x -> 
match x.definition with
|ColumnDef(d) ->d.primaryKey
|_ -> false) aTable.columns ;;

(* Ignore primary keys and foreign keys *)
let tableAttributes aKeyColumn aTable = 
let aForeignKey = "ForeignKey" in
let primaryKey = "PrimaryKey" in
let uniqueKey = "UniqueKey" in
List.filter (fun aColumn -> not ((aColumn.name = aKeyColumn.name) or 
  (aColumn.name = aForeignKey) or (aColumn.name = primaryKey)
  or(aColumn.name = uniqueKey))) aTable.columns;;

let allTableAttributes aTable = 
let aForeignKey = "ForeignKey" in
let primaryKey = "PrimaryKey" in
let uniqueKey = "UniqueKey" in 
  List.filter( fun aColumn -> not (
  (aColumn.name = aForeignKey)
  or (aColumn.name = primaryKey) 
  or (aColumn.name = uniqueKey))
  ) aTable.columns;;

end