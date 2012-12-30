#!/bin/bash


ocamlyacc SQLToHaxeParser.mly
ocamllex SQLToHaxeLexer.mll

ocamlc -c SQLToHaxeParser.mli

ocamlc -g -o SQLToHaxe unix.cma str.cma GeneratorConstants.ml ColumnDefinition.ml TableDefinition.ml \
SQLToHaxeParser.ml \
SQLToHaxeLexer.ml \
SQLToAsGenerator.ml \
SQLToHaxeGenerator.ml SQLToJavaDBGenerator.ml SQLToJavaDTOGenerator.ml FlexGenerator.ml SQLToHaxe.ml
