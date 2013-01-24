#!/bin/bash

<<<<<<< HEAD
ocamlyacc SQLToHaxeParser.mly
ocamllex SQLToHaxeLexer.mll
ocamlc -c SQLToHaxeParser.mli

ocamlc -c GeneratorConstants.ml
ocamlc -c ColumnDefinition.ml
ocamlc -c TableDefinition.ml
ocamlc -c SQLToHaxeParser.ml
ocamlc -c SQLToHaxeLexer.ml
ocamlc -c SQLToAsGenerator.ml
ocamlc -c SQLtoHaxeGenerator.ml
ocamlc -c SQLToJavaDBGenerator.ml
ocamlc -c SQLToJavaDTOGenerator.ml
ocamlc -c FlexGenerator.ml
ocamlc -g -o SQLToHaxe unix.cma str.cma GeneratorConstants.cmo ColumnDefinition.cmo TableDefinition.cmo SQLToHaxeParser.cmo SQLToHaxeLexer.cmo SQLToAsGenerator.cmo SQLToHaxeGenerator.cmo SQLToJavaDBGenerator.cmo SQLToJavaDTOGenerator.cmo FlexGenerator.cmo SQLToHaxe.ml 
=======

ocamlyacc SQLToHaxeParser.mly
ocamllex SQLToHaxeLexer.mll

ocamlc -c SQLToHaxeParser.mli

ocamlc -g -o SQLToHaxe unix.cma str.cma GeneratorConstants.ml ColumnDefinition.ml TableDefinition.ml \
SQLToHaxeParser.ml \
SQLToHaxeLexer.ml \
SQLToAsGenerator.ml \
SQLToHaxeGenerator.ml SQLToJavaDBGenerator.ml SQLToJavaDTOGenerator.ml FlexGenerator.ml SQLToHaxe.ml
>>>>>>> ed816dffd138c3d86db75920b8ce275d31963879
