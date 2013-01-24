(*Generator constants*)
open Printf;;
module GeneratorConstants = struct
let getCurrentTime() = Printf.sprintf "%f" (Unix.time());;
let sourceDirectory = ""
let ehCacheFile = "ehcache.xml";;

(*TODO : Create/do something about logging *)
let logger anErrorMessage = Printf.printf "%s\n" anErrorMessage
let destinationDirectory () = match Array.length(Sys.argv) with
  | 2 -> "."
  | _ -> sprintf ".\\%s" (Sys.argv.(2))
  
let licenseFile = "license.txt"
let generateLicenseFile ()= 
  try
    let input_chan = open_in licenseFile in
    let buffer = Buffer.create 1024 in
    while true do
      let line = input_line input_chan in
      Buffer.add_string buffer line 
    done;
    Buffer.contents buffer;  
  with End_of_file -> ""
    |Sys_error(err) -> "";;
    
(*The data model*)
let modelDirectory = "model"
(*The interface interface is a keyword in haxe *)
let interfaceDirectory = "view"
let modelServletName aTableName = (aTableName ^ "Servlet.n")
let classComment = "A class comment"
let openingBlock = "{";;
let closingBlock = "}";;
let generateTestClasses = true
let generateView = true
let generateModel = true
let defaultLibName = "flex"
let swfVersion = "9"
let swfAppName = "Application.swf"
let actionScriptVersion="as3"
(*
The index.hxml is in the same directory as
the generated .hx files. *)
let actionScriptTargetDirectory = "."

let fullyQualifiedFlexImports = [
"mx.controls.Alert"; 
"mx.controls.Button";
"mx.controls.ButtonBar";
"mx.controls.Text";
"mx.controls.TextArea";
"mx.controls.TextInput";
"mx.controls.ButtonLabelPlacement";
"mx.controls.CheckBox";
"mx.controls.ColorPicker";
"mx.controls.ComboBase";
"mx.controls.ComboBox";
"mx.controls.DataGrid";
"mx.controls.DateChooser";
"mx.controls.DateField";
"mx.containers.Grid";
"mx.containers.GridRow";
"mx.containers.GridItem";
"mx.containers.Form";
"mx.containers.FormItem";
"mx.containers.FormHeading";
"mx.controls.RichTextEditor";
"mx.containers.VBox";
"mx.containers.HBox";
"mx.controls.List";
"flash.events.Event";
"flash.events.MouseEvent";
"flash.net.URLLoader";
"flash.net.URLVariables";
"flash.net.URLRequest";
"flash.events.IOErrorEvent";
"mx.events.FlexEvent";
"util.Constants";
"util.ServletResult"];;

let flexApplicationHeader = 
"
package {

    import flash.display.*;
    import flash.net.URLRequest;
    import flash.events.Event;
    import mx.core.*;
    import mx.controls.*;
    import mx.containers.*;
    import mx.containers.Accordion;
    import flash.system.ApplicationDomain;
    import flash.system.LoaderContext;
    import mx.controls.Alert;
    import mx.controls.Button;
    import mx.controls.ButtonBar;
    import mx.controls.Text;
    import mx.controls.TextArea;
    import mx.controls.TextInput;
    import mx.controls.ButtonLabelPlacement;
    import mx.controls.CheckBox;
    import mx.controls.ColorPicker;
    import mx.controls.ComboBase;
    import mx.controls.ComboBox;
    import mx.controls.DataGrid;
    import mx.controls.DateChooser;
    import mx.controls.DateField;
    import mx.containers.Grid;
    import mx.containers.GridRow;
    import mx.containers.GridItem;



   public class ApplicationCanvas extends Canvas {

      public function ApplicationCanvas() {
      var accordion:Accordion = new Accordion();
      this.width=1024;
      accordion.width = 1024;
      this.height = 500;
      accordion.height = 500;
      addChild(accordion);
      
"


let flexApplicationFooter = 
"
    } (*Constructor declaration*)
  } (*Class declaration*)
}(*package declaration*)
"
end