(* Module to generate Java DTO classes *)
module SQLToJavaDTOGenerator = struct
open Printf
open ColumnDefinition.ColumnDefinition;;
open TableDefinition.TableDefinition;;
open GeneratorConstants.GeneratorConstants;;
open SQLToJavaDBGenerator.SQLToJavaDBGenerator;;
let dtoImports = 
  ["org.slf4j.Logger"; 
   "org.slf4j.LoggerFactory";
   "java.util.Date";
   "java.sql.Connection";
   "it.gotoandplay.smartfoxserver.lib.ActionscriptObject"
  ];;

let generateClassFooter = "}//End of class";;
let generateClassHeader aStatement =
sprintf
"
public class %s {
"  aStatement.tableName;;
let generateDTOAttribute anAttribute =
  match anAttribute.definition with
  | ColumnDef(aDefinition) ->
    let columnDataType = aDefinition.dataType in
    let attributeName = anAttribute.name in
    let genAttributeName = generateAttributeName attributeName columnDataType in
    let genAttributeMutator = generateMutator attributeName columnDataType in
    let genAttributeAccessor = generateAccessor attributeName columnDataType in
  sprintf
"
%s
%s
%s
" genAttributeName genAttributeAccessor genAttributeMutator
 | _ -> ""
;;
let generateDeleteMethod aStatement persistencePackageName =
  let className = aStatement.tableName in
  let instanceName = "a" ^ className in
  let fullyQualifiedName = persistencePackageName ^ "." ^ className in
  sprintf 
"
  public void delete(Connection aConnection) {
    %s %s = new %s();
    %s.delete(aConnection, this);
  }
" fullyQualifiedName instanceName fullyQualifiedName instanceName;;

let generateSaveMethod aStatement persistencePackageName = 
let className = aStatement.tableName in
let instanceName = "a" ^ className in
let fullyQualifiedName = persistencePackageName ^ "." ^ className in
sprintf
"
public void save(Connection aConnection) {
  %s %s = new %s();
  %s.save(aConnection, this);
  this.copyValues(%s);
}
" fullyQualifiedName instanceName fullyQualifiedName instanceName instanceName;;

let generateAOInstruction anAttribute = 
sprintf 
"ao.put(%s, \"\" + %s);
" (String.uppercase anAttribute.name) anAttribute.name;;

let generateAOUpdateMethod aStatement = 
  let allAttributes = allTableAttributes aStatement in
sprintf
"
public void updateAO(ActionscriptObject ao) {
  %s
}
" (List.fold_right (fun x acc -> sprintf "%s %s " (generateAOInstruction x) acc) allAttributes "")
;;  

let generateDTOClassAttributes aStatement =
List.fold_right (fun x acc -> sprintf "%s %s" (generateDTOAttribute x) acc) (allTableAttributes aStatement) "";;
let generateClassConstant aColumn = 
sprintf 
"public static String %s = \"%s\";
" (String.uppercase aColumn.name) (aColumn.name);;
let generateClassConstants aStatement = 
List.fold_right (fun x acc -> 
sprintf 
"%s %s" (generateClassConstant x) acc
) (allTableAttributes aStatement) "";;

let generateDefaultConstructor aStatement =
sprintf
"
  public %s(){}
" aStatement.tableName;;

let generateConstructor2 aStatement = "";;
let generateConstructor1 aStatement persistencePackageName =
let generateAssignment aColumn instanceName = 
sprintf "
  this.%s = %s.get%s();" (aColumn.name) (instanceName) (String.capitalize(aColumn.name)) in
let className = aStatement.tableName in
let fullyQualifiedName = persistencePackageName ^ "." ^ className in
let instanceName = "a" ^ className in
sprintf
"
  public %s(%s %s){
    %s
  }
" 
className 
fullyQualifiedName 
instanceName 
(List.fold_right (fun x acc -> sprintf "%s %s" (generateAssignment x instanceName) acc) (allTableAttributes aStatement) "");; 

let generateJavaDTOClass aStatement dtoPackageName persistencePackageName =
match aStatement with 
| CreateStatement(aStatement) ->
  let keyList = getPrimaryKeyIds aStatement in
  let keyLength = List.length keyList in
  if keyLength > 1 then 
    raise(CompositeKeysNotSupported("Feature not supported"))
  else
    let keyAttribute = (List.hd keyList) in
    let attributeList = tableAttributes keyAttribute aStatement in
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
%s
%s
" 
(generatePackageName dtoPackageName "")
(generateLicenseFile ())
(generateGeneratedDocumentation aStatement.tableName)
(generateClassImports dtoImports)
(generateClassHeader aStatement)
(generateClassConstants aStatement)
(generateDTOClassAttributes aStatement)
(generateDefaultConstructor aStatement)
(generateConstructor1 aStatement persistencePackageName)
(generateConstructor2 aStatement)
(generateCopyValues keyAttribute attributeList persistencePackageName aStatement)
(generateSaveMethod aStatement persistencePackageName)
(generateDeleteMethod aStatement persistencePackageName)
(generateAOUpdateMethod aStatement)
(generateClassFooter)
| _ -> raise InvalidStatement
;;
      
let writeJavaDTOClass aStatement aModelPrefix =
	Printf.printf "%s" (generateJavaDTOClass aStatement "testDTO" "testPersistence");;
	
(*let writeJavaDTOClass aStatement aModelPrefix = 
  let transformModelPrefix aModelPrefix = (regex "\.").Replace(aModelPrefix, "\\") in
  let dtoPackageName = aModelPrefix ^ "." ^ (decodeClassType DTO) in
  let dtoDirectory = destinationDirectory ^ "\\" ^ (transformModelPrefix aModelPrefix) ^ "\\" ^ (decodeClassType DTO) in
  let persistencePackageName  = aModelPrefix ^ "." ^ (decodeClassType Persistence) in
  let classString = generateJavaDTOClass aStatement dtoPackageName persistencePackageName in
    match aStatement with
    | CreateStatement(aStatement) -> 
      if Directory.Exists(dtoDirectory) then
        File.WriteAllText(sprintf "%s\\%s.java" dtoDirectory aStatement.tableName, classString)
      else
            Directory.CreateDirectory(dtoDirectory) |> ignore;
            File.WriteAllText(sprintf "%s\\%s.java" dtoDirectory aStatement.tableName, classString)
    | _ -> raise InvalidStatement;; *)
  
end