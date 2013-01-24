#!/bin/bash

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
