module FlexGenerator = struct
(*
open TableDefinition.TableDefinition
open ColumnDefinition.ColumnDefinition
open GeneratorConstants.GeneratorConstants;;
open Printf
let attributes aStatement = List.filter (fun aColumn -> not (isKey aColumn)) aStatement.columns
  
let generatePackageName = sprintf "package %s;\n" interfaceDirectory
let generateFlexImports  = 
  List.fold_right (fun className acc -> 
sprintf 
"import %s;
%s" 
className acc) fullyQualifiedFlexImports "";;

let generateInterfaceClassHeader (tableName:string) = sprintf
"
class %s {
" (tableName)

let generateConstructorHeader (aClassName: string) = sprintf 
"
//Constructor
public function new() { 
  grid = new Grid();
  form = new Form();
  var formHeading : FormHeading;
  formHeading = new FormHeading();
  formHeading.label = \"%s\";
  form.addChild(formHeading);

" aClassName

let generateSaveCancelControls aStatement =
"
  //Note: Add save and cancel handlers in
  //corresponding interface helper classes.
  var gridRow = new GridRow();
  var gridItem = new GridItem();
  saveButton = new Button();
  saveButton.label = \"Save\";
  saveButton.addEventListener(MouseEvent.CLICK, save);
  saveButton.addEventListener(FlexEvent.ENTER, retrieve);
  gridItem.addChild(saveButton);
  gridRow.addChild(gridItem);
  var gridItem = new GridItem();
  cancelButton = new Button();
  cancelButton.label = \"Cancel\";
  gridItem.addChild(cancelButton);
  gridRow.addChild(gridItem);
  grid.addChild(gridRow);
  form.addChild(grid);
"

let generateConstructorFooter aStatement = sprintf 
"
%s
}
" (generateSaveCancelControls aStatement)                                           

(* Create a form heading with the class name in 
  mixed case as the label. *)

let generateInterfaceContainer  = sprintf 
"
public var form: Form;
public var grid: Grid;
public var saveButton : Button;
public var cancelButton : Button;
private var loader : URLLoader;

"

let generateInterfaceContainerAccessor = sprintf ""
let generateInterfaceContainerMutator = sprintf ""

let generateLabel aColumn = sprintf "private var %s:%s;\n" (aColumn.name) "Text";;
let generateControlName aColumn = sprintf "%s_control" aColumn.name

let decodeControl aColumn = 
    let createHaxeField aDataType = 
    match aDataType with
    | IntType(aLength) -> "TextInput"
    | IntegerType(aLength) -> "TextInput"
    | BigIntType(aLength) -> "TextInput"
    | RealType(aLength) -> "TextInput"
    | DateType -> "DateField"
    | TimeType -> "TextInput"
    | DateTimeType -> "DateField"
    | YearType -> "TextInput"
    | BoolType -> "CheckBox"
    | TinyTextType(aLength)-> "TextInput"
    | TextType(aLength) -> "RichTextEditor"
    | EnumType(aStringList) -> "TextInput"
    | _ -> "TextInput" 
    in
    match aColumn.definition with 
    |ColumnDef(colDef) -> createHaxeField colDef.dataType
    |_ -> ""

    
let generateControl aColumn = 
    sprintf "public var %s:%s;\n" (generateControlName aColumn) (decodeControl aColumn)
    
let generateControls aColumn = (generateLabel aColumn) ^ (generateControl aColumn)


let generateInterfaceClassBody aStatement = 
    let attributes = attributes aStatement in
    sprintf 
"
%s
%s
%s
%s
" 
    generateInterfaceContainer
    generateInterfaceContainerAccessor
    generateInterfaceContainerMutator
    (List.fold_right 
    (fun x acc -> 
     match x.definition with
     | ColumnDef(colDefinition) -> sprintf "%s\n%s" (generateControls x) acc
     | _ -> sprintf ""
     ) attributes "")


let generateInterfaceClassFooter aStatement = sprintf 
"
}
"

let generateShowErrorMethod aStatement = sprintf
" public function showError(err: Dynamic, operation: DatabaseOperation) : Void {
  Alert.show(\"Error : \" + Std.string(err) + \" Operation : \" + 
    Std.string(operation));
  return;
}
"

(* Decode the control type and  *)
let generateSetValuesMethod aStatement = 
let attributes = attributes aStatement in
let createAssignment anAttribute  =
  let attrName = anAttribute.name in
  let controlType = decodeControl anAttribute in
  match controlType with
  | "CheckBox" -> sprintf 
  "
    var value = element.get(\"%s\");
    var intValue = Std.parseInt(value);
    if(intValue == 1) {
      %s.selected = true;
    } else {
      %s.selected = false;
    }
  " attrName (generateControlName anAttribute) (generateControlName anAttribute)
  
  | _ -> sprintf "%s.text = element.get(\"%s\");" (generateControlName anAttribute) attrName in
  
let xmlAssignments = 
List.fold_right( fun x acc ->
  let attrName = x.name in
  if acc <>  "" then
sprintf
" %s
  %s" (createAssignment x) acc
else
  sprintf
" %s" (createAssignment x)) attributes ""
in

sprintf 
" public function setValues(xmlDocument : String) {
  var document = Xml.parse(xmlDocument);
  var element = document.firstElement();
  if(element == null) {
    Alert.show(\"No %s  found\");
    return;
  }
  %s
}
" aStatement.tableName xmlAssignments


let generateDeleteObjectMethod aStatement = sprintf 
" public function deleteObject(event: MouseEvent) {
  var urlRequest : URLRequest =
    initializeCommand(DatabaseOperation.DELETE);
    loader.addEventListener(Event.COMPLETE, onDelete);
    loader.addEventListener(IOErrorEvent.IO_ERROR,
      onDeleteError);
    try {
      loader.load(urlRequest);
    } catch(err : Dynamic) {
      showError(err, DatabaseOperation.DELETE);
    }
}
"


let generateInitializeCommandMethod aStatement = 
let attributes = attributes aStatement in
let createAssignment anAttr = 
  let attrName = anAttr.name in
  let controlType = decodeControl anAttr in
  match controlType with
  | "CheckBox" -> sprintf 
  "
    if(%s.selected) {
      variables.%s = 1;
    }else {
      variables.%s = 0;
    }    
  " (generateControlName anAttr) attrName attrName 
  | _ -> sprintf "variables.%s = %s.text;" attrName (generateControlName anAttr) in
let generateAssignments = 
List.fold_right (fun x acc -> 
  let attrName = x.name in
  if acc <> "" then
sprintf "
  %s %s" (createAssignment x) acc
  else
sprintf "
%s
" (createAssignment x)
) attributes ""
in
sprintf
"
private function initializeCommand(commandType : DatabaseOperation): URLRequest {
  var request : URLRequest = new URLRequest(Constants.getURL(\"%s\"));
  var variables : URLVariables = new URLVariables();
  %s
  variables.databaseOperation = Constants.getDatabaseText(commandType);
  request.data = variables;
  loader = new URLLoader(request);
  return request;
}
" (modelServletName aStatement.tableName) generateAssignments

let generateRetrieveMethod aStatement = sprintf 
"
public function retrieve(event : FlexEvent) {
  var urlRequest : URLRequest = initializeCommand(DatabaseOperation.RETRIEVE);
  loader.addEventListener(Event.COMPLETE, onRetrieve);
  loader.addEventListener(IOErrorEvent.IO_ERROR, onRetrieveError);
  try {
    loader.load(urlRequest);
  } catch(err : Dynamic){
    showError(err, DatabaseOperation.RETRIEVE);
  }
}
"

let generateOnDeleteMethod aStatement = sprintf 
"
public function onDelete(data: Dynamic) {
  Alert.show(\"Delete \" + Std.string(data));
}
"
let generateOnSaveMethod aStatement = sprintf
"
public function onSave(data : Dynamic) {
  var resultString = data;
  var servletResult = haxe.Unserializer.run(resultString);
  Alert.show( \"Save \" + Std.string(servletResult));
}
"

let generateOnRetrieveMethod aStatement = sprintf 
"
public function onRetrieve(data: Dynamic) {
  Alert.show(\" Retrieving \" + Std.string(loader.data));
  setValues(loader.data);
}

"
let generateOnRetrieveErrorMethod aStatement = sprintf 
"
public function onRetrieveError(err : String) {
  Alert.show(\"Retrieve error \" + err);
  return;
}
"
let generateOnSaveErrorMethod aStatement = sprintf 
"
public function onSaveError(err : String) {
  Alert.show (\"Save error \" + err);
  return;
}
"
let generateOnDeleteErrorMethod aStatement = sprintf 
"
public function onDeleteError(err: String) {
  Alert.show(\" Delete error \" + err);
}
"

let generateSaveMethod aStatement = sprintf
"public function save(event : MouseEvent) : Void {
  //Initialize loader
  var urlRequest : URLRequest = initializeCommand(DatabaseOperation.INSERT);
  loader.addEventListener(Event.COMPLETE, onSave);
  loader.addEventListener(IOErrorEvent.IO_ERROR, onSaveError);
  try {
    loader.load(urlRequest);
  }catch(err: Dynamic) {
    showError(err, DatabaseOperation.SAVE);
  }
}
"

let generateConstructorBody aStatement = 
 
  List.fold_right (fun x acc -> 
  let textName = x.name in
  let controlName = generateControlName x in
  let controlType = decodeControl x in
  let labelText = String.capitalize textName in
  sprintf
"
  //Creating form items for %s
  var formItem = new FormItem();
  formItem.label = \"%s\";
  %s = new %s();
  %s.id = \"%s\";
  formItem.addChild(%s);
  form.addChild(formItem);
  %s
" controlName labelText controlName controlType 
  controlName
    controlName controlName acc) (attributes aStatement) ""

let generateFlexInterface aStatement = match aStatement with
  | CreateStatement(aStatement) -> sprintf 
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
%s
%s
%s
%s
%s
%s
"
    generatePackageName
    (generateLicenseFile ())
    generateFlexImports 
    (generateInterfaceClassHeader aStatement.tableName)
    (generateInterfaceClassBody aStatement)
    (generateConstructorHeader aStatement.tableName)
    (generateConstructorBody aStatement)
    (generateConstructorFooter aStatement)
    (generateSaveMethod aStatement)
    (generateRetrieveMethod aStatement)
    (generateSetValuesMethod aStatement)
    (generateInitializeCommandMethod aStatement)
    (generateDeleteObjectMethod aStatement)
    (generateOnSaveMethod aStatement)
    (generateOnRetrieveMethod aStatement)
    (generateOnDeleteMethod aStatement)
    (generateOnSaveErrorMethod aStatement)
    (generateOnRetrieveErrorMethod aStatement)
    (generateOnDeleteErrorMethod aStatement)
    (generateShowErrorMethod aStatement)
    (generateInterfaceClassFooter aStatement)
  | _ -> raise InvalidStatement


let generateCommonMakeHeader = 
  sprintf "-lib %s\n -%s %s\n \n" defaultLibName actionScriptVersion actionScriptTargetDirectory;;

let generateClassNames statements = 
    List.fold_right (fun x acc -> match x with
                      | CreateStatement(aStatement) -> sprintf "%s.hx \n %s" (aStatement.tableName) acc
                      | _ -> "") statements "";;
                      
let generateFlexMakeFile statements = 
                  sprintf "%s \n %s \n" 
                  generateCommonMakeHeader (generateClassNames statements)

let targetInterfaceDirectory = destinationDirectory ^ "\\" ^ interfaceDirectory
  
let writeFlexInterfaceClass aStatement = 
  let classString = generateFlexInterface aStatement in
    match aStatement with
    | CreateStatement(aStatement) ->
        if Directory.Exists(targetInterfaceDirectory) then
          File.WriteAllText(sprintf "%s\\%s.hx" targetInterfaceDirectory aStatement.tableName, classString)
        else
          Directory.CreateDirectory(targetInterfaceDirectory) |> ignore;
          File.WriteAllText(sprintf "%s\\%s.hx" targetInterfaceDirectory 
          aStatement.tableName, classString)
    | _ -> raise InvalidStatement


let writeFlexInterfaceMakefile statements =
  let makeFileString = generateFlexMakeFile statements in
  let copyContents = 
      File.WriteAllText(
        sprintf "%s\\Index.hxml" targetInterfaceDirectory, 
          makeFileString) in
  if Directory.Exists(targetInterfaceDirectory) then
        copyContents
  else
      Directory.CreateDirectory(targetInterfaceDirectory) |> ignore;
      copyContents

let generateUIInstances statements =   
List.fold_right (fun x acc ->
match x with 
|CreateStatement(aStatement) -> let instanceName = String.lowercase (aStatement.tableName) in
sprintf "
  var %s:%s = new %s(); 
  var vBox_%s:VBox = new VBox();
  vBox_%s.label =\"%s\";
  accordion.addChild(vBox_%s);  
  vBox_%s.addChild(%s.form);
  %s
  " 
  instanceName
  aStatement.tableName 
  aStatement.tableName
  instanceName
  instanceName
  aStatement.tableName  
  instanceName
  instanceName
  instanceName 
  acc
| _ -> sprintf "//Invalid statement--%A;\n" x) statements "";;

let generateFlexApplicationMain statements = sprintf
"
%s\n%s\n%s 
" flexApplicationHeader (generateUIInstances statements) flexApplicationFooter

let writeApplicationMain statements = Printf.printf "%s" (generateFlexApplicationMain statements)

(*
let writeApplicationMain statements =
  let applicationFileString = generateFlexApplicationMain statements in
  let copyContents = File.WriteAllText(sprintf "%s\\ApplicationCanvas.as" targetInterfaceDirectory, applicationFileString) in
  if Directory.Exists(targetInterfaceDirectory) then
    copyContents
  else 
    Directory.CreateDirectory(targetInterfaceDirectory) |> ignore;
    copyContents
    *)
*)
end
    
