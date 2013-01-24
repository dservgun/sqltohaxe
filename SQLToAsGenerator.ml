module SQLToAsGenerator = struct
open ColumnDefinition.ColumnDefinition;;
open TableDefinition.TableDefinition;;
open GeneratorConstants.GeneratorConstants;;
open Printf;;
let regex s = Str.regexp(s);;
let generateASPackageFooter = "}";;
let generateASPackageHeader aModelPrefix aPackageName=
  match aPackageName with
  | "" -> sprintf "package %s {" aModelPrefix
  | _ -> sprintf "package %s.%s {" aModelPrefix aPackageName;;

let generateASClassFooter = "}";;
let generateASClassHeader aStatement = 
  sprintf
"
  public class %s {
" aStatement.tableName;;

let convertToAsType attributeDataType = 
  match attributeDataType with
  | BitType(anInt) -> "boolean"
  | TinyIntType(anInt) -> "int"
  | SmallIntType(anInt) -> "int"
  | MediumIntType(anInt) -> "int"
  | IntType(anInt) -> "int"
  | IntegerType(anInt)-> "int"
  | RealType(aReal) -> "String"
  | BigIntType(anInt) -> "int"
  | DateType -> "String"
  | TimeType -> "String"
  | TimeStampType -> "String"
  | DateTimeType -> "String"
  | YearType -> "int"
  | CharType(anInt) -> "String"
  | VarcharType(anInt) -> "String"
  | Binary(anInt) -> "String"
  | VarBinary(anInt) -> "String"
  | TinyBlob -> "String"
  | Blob -> "String"
  | MediumBlob -> "String"
  | LongBlob -> "String"
  | TextType(aText) -> "String"
  | TinyTextType(aText) -> "String"
  | MediumTextType(aText) -> "String"
  | LongTextType(aText) -> "String"
  | EnumType(aText) -> "String"
  | SetType(aSet) -> "String"
  | BoolType -> "Boolean";;

let generateAsAttribute aColumn = 
match aColumn.definition with
| ColumnDef(aDefinition) ->
sprintf 
"
public var %s : %s
" aColumn.name (convertToAsType aDefinition.dataType)
| _ -> "";;

let generateASClassBody aStatement = 
  List.fold_right (fun x acc -> sprintf "%s %s"(generateAsAttribute x) acc) aStatement.columns "";;

let generateASClass aStatement aPackageName=
  match aStatement with 
  | CreateStatement(aStatement) ->
                      sprintf 
"
%s
%s
%s
%s
%s
" 
  (generateASPackageHeader aPackageName "")
  (generateASClassHeader aStatement)
  (generateASClassBody aStatement)  
  generateASClassFooter
  generateASPackageFooter
  | _ -> raise InvalidStatement;;



let writeAsClass aStatement aModelPrefix =
	let classString = generateASClass aStatement aModelPrefix in
	Printf.printf "%s" classString;;
(*
let writeAsClass aStatement aModelPrefix = 

    let transformModelPrefix aModelPrefix = 
    	Str.global_replace (regex "\\.") (aModelPrefix ^ "\\") in
    let modelDirectory = destinationDirectory ^ "\\" ^ (transformModelPrefix aModelPrefix) in
    let classString = generateASClass aStatement aModelPrefix in
      match aStatement with
      | CreateStatement(aStatement) -> 
          if Directory.Exists(modelDirectory) then
            File.WriteAllText(sprintf "%s\\%s.as" modelDirectory aStatement.tableName, classString)
          else
            Directory.CreateDirectory(modelDirectory) |> ignore;
            File.WriteAllText(sprintf "%s\\%s.as" modelDirectory aStatement.tableName, classString)
      | _ -> raise InvalidStatement;;
*)

end