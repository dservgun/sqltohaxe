open Lexing;;
open Printf;;
open GeneratorConstants.GeneratorConstants
open SQLToHaxeLexer;;
open SQLToHaxeParser;;
open TableDefinition.TableDefinition;;
open ColumnDefinition.ColumnDefinition;;
open SQLToHaxeGenerator.SQLToHaxeGenerator;;
open FlexGenerator.FlexGenerator;;
open SQLToJavaDBGenerator.SQLToJavaDBGenerator;;
open SQLToJavaDTOGenerator.SQLToJavaDTOGenerator;;
open SQLToAsGenerator.SQLToAsGenerator;;

let printPosition aPos = Printf.sprintf "%s: Line %d Offset %d Character %d" 
	aPos.pos_fname 
	aPos.pos_lnum 
	aPos.pos_bol
	aPos.pos_cnum;;

let parseText (aTextFileName)=
  let in_channel = open_in aTextFileName in
  let lexbuf = Lexing.from_channel in_channel in
      try
      	let pos = lexbuf.lex_curr_p in
      	logger (printPosition pos);
        SQLToHaxeParser.start SQLToHaxeLexer.token lexbuf
      with e ->
        let pos = lexbuf.lex_curr_p in
        let curr = lexbuf.Lexing.lex_curr_p in
        let line = curr.Lexing.pos_lnum in
        let cnum = curr.Lexing.pos_cnum - curr.Lexing.pos_bol in
        let tok = Lexing.lexeme lexbuf in
        let tail = "To be printed" in
        Printf.printf "Error Line number %d character %d at token %s\n" line cnum tok;
        []
        
  ;;


let helpStatement commandName () = sprintf "%s: <database_schema> (mysql only) <destination_directory> (required) <languageType> <modelPrefix> <utilPrefix>\n" 
  commandName;;

let writeCacheConfig cacheFile javaModelPrefix statements =
	try 
		let file = Unix.openfile cacheFile [Unix.O_RDWR;Unix.O_CREAT] 0o777 in
		let out_channel = Unix.out_channel_of_descr file in
			Printf.fprintf out_channel "<?xml version=\"1.0\"?>\n";
			Printf.fprintf out_channel "<ehcache>\n";
			Printf.fprintf out_channel "<!-- Hibernate needs the fqcn for caches -->\n";
			Printf.fprintf out_channel "<!-- create a default cache -->\n";
			Printf.fprintf out_channel "<defaultCache 
			maxElementsInMemory=\"10000\" 
			eternal=\"false\" timeToIdleSeconds=\"120\" 
			maxEntriesLocalHeap=\"10000\"
			timeToLiveSeconds=\"120\" overflowToDisk=\"true\" 
			diskSpoolBufferSizeMB=\"30\" maxElementsOnDisk=\"10000000\" 
			diskPersistent=\"false\" diskExpiryThreadIntervalSeconds=\"120\" 
			memoryStoreEvictionPolicy=\"LRU\" statistics=\"false\"/>\n";			
			List.iter(fun x -> writeEhCacheConfig out_channel javaModelPrefix x) statements;
			Printf.fprintf out_channel "</ehcache>\n";
			flush out_channel;
			Unix.close file
	with Sys_error e -> prerr_endline e
let driver commandLine = 
	try 
	let statements = parseText commandLine.(1) in
	let javaModelPrefix = commandLine.(3) in
	let destinationDirectory= commandLine.(2) in
	let utilPrefix = commandLine.(4) in
		List.iter(fun x ->  (writeJavaDBClass x javaModelPrefix utilPrefix)) statements;
		Printf.printf "Creating writing grid gain store classes\n";
		List.iter(fun x -> (writeGridGainStoreClass x javaModelPrefix utilPrefix))statements;
		writeConfigSnippets javaModelPrefix statements
<<<<<<< HEAD
	with Invalid_argument (aMessage) -> Printf.printf "No input statements file specified %s:  %s\n" aMessage "Invalid command line"; exit(-1);;
=======
	with Invalid_argument (aMessage) -> Printf.printf "No input statements file specified %s:  %s\n" aMessage "Invalid command line";;
>>>>>>> ed816dffd138c3d86db75920b8ce275d31963879

(*
let driver1 commandLine= 
			  let statements = parseText commandLine.(1)in 
			  let languageType = commandLine.(3)in
			  let javaModelPrefix = commandLine.(4) in
			  let utilPrefix = commandLine.(5) in
			  let cacheType = commandLine.(6) in
			  Printf.printf "Driver %s\n" commandLine.(1);
			  match languageType with 
				
		  | "java" -> List.iter (fun x -> Printf.printf "%s" (writeJavaDBClass x javaModelPrefix utilPrefix; writeJavaDTOClass x javaModelPrefix ; sprintf "Writing class to %A\n" x)) statements
		  | "haxe" -> List.iter (fun x -> Printf.printf "%s" (writeModelClass x; sprintf "Writing class to %A\n" x)) statements;
					List.iter (fun x -> writeFlexInterfaceClass x) statements;
					(*Generate makefiles for different targets. *)
					writeFlexInterfaceMakefile statements;
					(*Generate the application main *)
					writeApplicationMain statements
		  | "as" -> List.iter(fun x -> Printf.printf "%s"(writeAsClass x javaModelPrefix; sprintf "Writing class to %A\n" x)) statements
		  | _ -> exit 0
  
  ;; 
  *)

Printf.printf "Debug: command line arguments\n";;
if((Array.length Sys.argv) = 1) then
  Printf.printf "%s" (helpStatement Sys.argv.(0) ())
else
	Printf.printf "%s\n" Sys.argv.(1);
  	ignore(driver (Sys.argv))
