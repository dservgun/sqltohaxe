module SQLToHaxeGenerator  = struct
open ColumnDefinition.ColumnDefinition;;
open TableDefinition.TableDefinition;;
open GeneratorConstants.GeneratorConstants;;
open Printf;;
let parentDbClassName = "neko.db.Object";;
let importClassNames = 
  ["util.MySQLDatabaseConnection";
  "neko.io.File";
  "neko.io.FileOutput";
  "util.Exception";
  "util.Logger";
  "util.DateFormatter";
  "util.ServletResult";
  "util.Constants"];;

let generateClassImports = List.fold_right 
  (fun c acc -> 
  match acc with "" -> 
    sprintf "import %s;" c
  | _ -> sprintf
"import %s;
%s" c acc) importClassNames "";;

let generatePackageName = "package model;\n";;
let generateLicenseFile = 
 (* let licenseText = File.ReadAllText(licenseFile) in *)
 let licenseText = "Use GNU licence here" in
sprintf
"
/**
%s
*/
" licenseText

let generatedDocumentation aClassName = sprintf "/* %s Class file generated on %s */\n" 
  aClassName (string_of_float (Unix.time()))
let classHeader aClassName aParentClassName = match aParentClassName with
    | "" -> sprintf "class %s \n" aClassName
    | aParentClassName -> sprintf 
"%s
%s
%s
%s
class %s extends %s %s
"
        generatePackageName
        (generatedDocumentation aClassName)
        generateLicenseFile
        generateClassImports
        aClassName aParentClassName openingBlock

let classFooter aClassName aParentClassName = closingBlock

let convertToHaxeType aColumn = 
  let createDataType aDataType = match aDataType with 
      | BitType(anInt) -> "Bool"
      | TinyIntType(anInt) -> "Int"
      | SmallIntType(anInt) -> "Int"
      | MediumIntType(anInt) -> "Int"
      | IntType(anInt) -> "Int"
      | IntegerType(anInt) -> "Int"
      | BigIntType(anInt) -> "Int"
      | RealType(anInt) -> "Float"
      | DateType -> "Date"
      | TimeType -> "Date"
      | TimeStampType -> "Date"
      | DateTimeType -> "Date"
      | YearType -> "Int"
      | CharType(anInt)-> "String"
      | VarcharType(anInt) -> "String"
      | Binary(anInt) -> "Blob"
      | VarBinary(anInt) -> "Blob"
      | TinyBlob -> "Blob"
      | Blob -> "Blob"
      | MediumBlob -> "Blob"
      | LongBlob -> "Blob"
      | TextType(aText) -> "String"
      | TinyTextType(aText) -> "String"
      | MediumTextType(aText) -> "String"
      | LongTextType(aText) -> "String"
      | EnumType(aList) -> "String"
      | SetType(aSet) -> "Set"
      | BoolType -> "Bool"
  in  
  match aColumn.definition with 
  | ColumnDef(columnDefinition) -> createDataType columnDefinition.dataType      
  | PrimaryKeys(columnDefinition) ->""
  | UniqueKeys(columnDefinition) ->""
  | ForeignKeys(columnDefinition) ->""
   

let classBody aColumn acc = sprintf "public var %s : %s; \n %s" aColumn.name (convertToHaxeType aColumn) acc
let dbManagerStatement className  = sprintf "public static var manager = new neko.db.Manager<%s>(%s);" className className
let dbTableName aClassName = sprintf "static var TABLE_NAME = \"%s\";" aClassName
let dbTableKeys aTable = sprintf "static var TABLE_IDS = [\"%s\"];" (List.fold_right (fun x acc -> 
                        match acc with
                        | "" -> sprintf "%s" x.name
                        | _ -> sprintf "%s,%s" x.name acc) (getPrimaryKeyIds aTable) "")
                        
let attributes columns = List.filter (fun aColumn -> not (isKey aColumn)) columns
let instancePrefix = "a"
let saveFunctionParams columns = 
  (List.fold_right (fun x acc -> 
    let instanceName = instancePrefix ^ String.lowercase x.name in
    if acc <> "" then
      sprintf "%s,%s" instanceName acc
    else
      sprintf "%s" instanceName
    ) (columns) "")

let saveSignature columns =  
    (List.fold_right (fun x acc -> 
    let instanceName = instancePrefix ^ (String.lowercase x.name) in
    let typeName = convertToHaxeType x in
    if acc <> "" then
      sprintf "%s:%s,%s" instanceName typeName acc
    else 
      sprintf "%s:%s" instanceName typeName
      ) (columns) "")

let generateAssignments attributes objectName = 
  let attributePairs = List.fold_right(fun x accum -> x.name::accum) attributes [] in
  List.fold_right (fun  instanceName accumulator -> 
  if accumulator <> "" then
  sprintf
"  %s.%s = %s;
%s" objectName instanceName (instancePrefix ^ (String.lowercase instanceName)) accumulator
  else sprintf
"
  %s.%s = %s;
" objectName instanceName (instancePrefix ^ (String.lowercase instanceName))
) attributePairs ""


(*
//First get the connection, currently MySQLConnection,
//create appropriate assignment statements and then
//find the key, among the attributes, 
//if the value of key is the default_undefined , for example -1 for integers
//insert or sync, and update.    
*)
type saveMethod = InsertMethod | UpdateMethod

let saveBody aStatement methodType = 
  let saveOperation = match methodType with 
    | InsertMethod -> "insert()" 
  | UpdateMethod -> "update()" in
  let closeTransaction = "connection.commit()" in
  let typeName = aStatement.tableName in
  let instanceName = String.lowercase aStatement.tableName in
  sprintf "
  neko.db.Manager.cnx = connection;
  neko.db.Manager.initialize();
  Logger.trace(\"Starting transaction\");
  connection.startTransaction();
  var %s:%s = new %s();
  %s
  %s.%s;
  %s;
" instanceName typeName typeName 
(generateAssignments (attributes aStatement.columns) instanceName) 
instanceName saveOperation closeTransaction;;

let generateReadFromXMLMethod aStatement =
let instanceName = String.lowercase (aStatement.tableName) in
(* To eliminate ambiguity between instance names and attributes *)
let returnObjectName = instanceName ^ "Object" in
let className = aStatement.tableName in
let attrs = attributes aStatement.columns in
let xmlAssignments attributes= 
List.fold_right (fun x acc ->
  let attrName = x.name in
  if acc <> "" then
sprintf "var %s = element.get(\"%s\");
%s
" attrName attrName acc
  else
sprintf "var %s = element.get(\"%s\"); " attrName attrName
) attributes "" in
sprintf 
"
  public function readFromXML(xmlString : String) : %s {
    var %s : %s = new %s();
    var document = Xml.parse(xmlString);
    var element = document.firstElement();
    if(element == null) {
      Logger.trace(\"No child element found \" + xmlString);
      return null;
    }
    %s
    return %s;
  }
" className returnObjectName className className 
  (xmlAssignments attrs) returnObjectName;;


let generateConvertToXMLMethod aStatement = 
let instanceName = String.lowercase(aStatement.tableName) in
let className = aStatement.tableName in
let xmlElementName = instanceName ^ "Element" in
let attrs = (attributes aStatement.columns) in
let xmlAssignments = 
List.fold_right ( fun x acc ->
let attrName = x.name in
if acc <> "" then
sprintf 
"%s.set(\"%s\", Std.string (%s));
%s"  xmlElementName attrName attrName acc
else
sprintf "
%s.set(\"%s\", Std.string (%s));" xmlElementName attrName attrName
) 
attrs ""
in
sprintf 
"
  public function convertToXML() {
    var result = Xml.createDocument();
    var %s = Xml.createElement(\"%s\");
    %s
    result.addChild(%s);
    Logger.trace(result.toString());
    return result.toString();
  }
" xmlElementName className xmlAssignments xmlElementName

let generateDeleteObjectMethod aStatement = 
let instanceName = String.lowercase aStatement.tableName in
let className = aStatement.tableName in
sprintf
"
public static function deleteObject(id : Int, connection : neko.db.Connection) : ServletResult {
  neko.db.Manager.cnx = connection;
  neko.db.Manager.initialize();
  var %s : %s = %s.manager.get(id);
  if( %s == null) {
    return new ServletResult(id, Status.FAIL, DatabaseOperation.DELETE);
  }else {
    %s.manager.delete(%s);
    connection.close();
    var result = new ServletResult(id, Status.SUCCESS,
      DatabaseOperation.DELETE);
    return result;
  }
}
"
instanceName className className instanceName className instanceName

  
let generateRetrieveObjectMethod aStatement =
let instanceName = String.lowercase aStatement.tableName in
let className = aStatement.tableName in
sprintf
"
public static function retrieveObject(id : Int, connection : neko.db.Connection){
  neko.db.Manager.cnx = connection;
  neko.db.Manager.initialize();
  try {
    var %s = %s.manager.get(id);
    connection.close();
    var resultString = %s.convertToXML();
    Logger.trace(resultString);
    return resultString;
    
  }catch(err : Dynamic) {
    connection.close();
    var result = new ServletResult(id, Status.FAIL,
      DatabaseOperation.RETRIEVE);
    var resultSer = haxe.Serializer.run(result);
    return resultSer;
  }
}
"
instanceName className instanceName

let generateSaveObjectMethod aStatement =
  let attrs = attributes aStatement.columns in
  let className = aStatement.tableName in
  let instanceName = String.lowercase aStatement.tableName in
  sprintf
"
  /**
  * Use this method to check for the id of the last insert or the object updated. 
  * Use the raw method insert, updates when you don't need to check for the status of
  * of the insert or update. 
  * XXX: Convention for object ids : aid (TODO: Improve this)
  */
  public static function saveObject(%s, connection : neko.db.Connection) : ServletResult {
    try {
      neko.db.Manager.cnx = connection;
      neko.db.Manager.initialize();
      var %s : %s = %s.manager.get(aid);
      if(%s == null){
        %s.insert(%s, connection);
        connection.close();
        var result = new ServletResult(aid, Status.SUCCESS, DatabaseOperation.INSERT);
        return result;
        } else {
        %s.update(%s, connection);
        connection.close();
        var result = new ServletResult(aid, Status.SUCCESS, DatabaseOperation.UPDATE);
        return result;
        }
    }catch(err: Dynamic) {
      Logger.trace(Std.string(err));
      connection.close();
      var result = new ServletResult(aid, Status.FAIL, DatabaseOperation.SAVE);
      return result;
    }
    
  }
" (saveSignature attrs) instanceName className className instanceName
  className (saveFunctionParams attrs)
  className (saveFunctionParams attrs)

let generateSaveMethod aStatement methodType =
  let methodName = match methodType with InsertMethod -> "insert" | UpdateMethod -> "update" in
  let attrs = attributes aStatement.columns in
  let traceBody = "" in
  sprintf 
"
  public static function %s(%s,connection : neko.db.Connection) {
  %s
  %s 
  }
" methodName (saveSignature attrs) traceBody (saveBody aStatement methodType)

  
(* data model for this class *)

let generateDBClass aStatement = 
  match aStatement with 
  | CreateStatement(aStatement) ->
                      sprintf 
"
%s
%s
%s
%s
%s
%s
%s
%s
%s
%s
%s
%s
%s
" 
  (classHeader aStatement.tableName parentDbClassName) 
  (List.fold_right classBody (attributes aStatement.columns) "") 
  (dbManagerStatement aStatement.tableName)
  (dbTableName aStatement.tableName)
  (dbTableKeys aStatement)
  (generateSaveMethod aStatement InsertMethod)
  (generateSaveMethod aStatement UpdateMethod)
  (generateRetrieveObjectMethod aStatement)
  (generateDeleteObjectMethod aStatement)
  (generateSaveObjectMethod aStatement)
  (generateConvertToXMLMethod aStatement)
  (generateReadFromXMLMethod aStatement)
  (classFooter aStatement.tableName parentDbClassName)
  | _ -> raise InvalidStatement


  let writeModelClass aStatement =
    printf "%s" (generateDBClass aStatement);;
(*let writeModelClass aStatement = 
    let classString = generateDBClass aStatement in
    let modelDirectory = destinationDirectory ^ "\\" ^ modelDirectory in
      match aStatement with
      | CreateStatement(aStatement) -> 
        try
          let handle = Unix.opendir(modelDestinationDirectory) in
          let out_channel = open_out(sprintf "%s/%s.hx" modelDirectory aStatement.tableName) in
          
          if Directory.Exists(modelDirectory) then
            File.WriteAllText(sprintf "%s\\%s.hx" modelDirectory aStatement.tableName, classString)
          else
            Directory.CreateDirectory(modelDirectory) |> ignore;
            File.WriteAllText(sprintf "%s\\%s.hx" modelDirectory aStatement.tableName, classString)
      | _ -> raise InvalidStatement
*)

type hInterface = FLEX_2 | DOT_NET | FLEX | JAVASCRIPT | SWING


end
