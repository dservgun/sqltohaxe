module ColumnDefinition = struct

open GeneratorConstants.GeneratorConstants
exception UnsupportedType
type characterSet = string
type collation = string
type columnLength = IntLength of int | NoColumnLength
type realColumnLength = RealLength of int * int | NoRealColumnLength

type columnOrder = Ascending | Descending | NoColumnOrder
type keyType  = Unique | Foreign | NotKey
type columnConstraint = ColumnConstraint of string | NoConstraint
type spatialOrText = Spatial | Text
type null = Null | NotNull

type textQualification = 
{
  charset : characterSet;
  collation : collation
}
let defaultCharset = "UTF-8"
let defaultCollation ="DefaultCollation"
let defaultTextQualification = {charset = defaultCharset; collation =defaultCollation}
let defaultOptionalComment = "This column has no comment. Please add comments so that the documentation will reflect them"
type varchar = {
  fieldLength : columnLength;
  varcharQualification : textQualification
}
    
type text = {
  isBinary : bool;
  textQualification : textQualification
}
type point = Point of int * int
type lineString = point list
type enumeratedType = string list
type setType = string list
type dataType = 
    | BitType of columnLength 
    | TinyIntType of columnLength
    | SmallIntType of columnLength
    | MediumIntType of columnLength
    | IntType of columnLength
    | IntegerType of columnLength
    | BigIntType of columnLength
    | RealType of realColumnLength
    | DateType
    | TimeType
    | TimeStampType 
    | DateTimeType
    | YearType
    | CharType of columnLength
    | VarcharType of varchar
    | Binary of columnLength
    | VarBinary of int
    | TinyBlob
    | Blob
    | MediumBlob
    | LongBlob
    | TextType of text
    | TinyTextType of text
    | MediumTextType of text
    | LongTextType of text
    | EnumType of enumeratedType
    | SetType of setType
    | BoolType

  
type columnIndex = Index | Key |NotAnIndex
type indexType = Btree | Hash | Rtree | NoIndexing
type unique = Unique
type expression = Expression of string | NotAnExpression

type indexColumn = 
{
  columnName : string;
  columnLength : columnLength;
  order : columnOrder
}

let printIndexColumn aColumn = Printf.sprintf "Index column %s" aColumn.columnName;;
  
type constraintRecord = 
{
  constraintName: string;
  indexType : indexType;
  indexColumns : indexColumn list
}

type referenceDefinition = 
{
  tableName: string;
  indexColumns : indexColumn list;
  matchReference: matchReference;
  deleteConstraint: integrityConstraint;
  updateConstraint: integrityConstraint
}and 
  matchReference = Full |Partial | Simple
and 
  integrityConstraint = Restrict | Cascade | SetNull | NoAction

type referenceDefinitionType = NoReferenceType | 
  ReferenceDefinition of referenceDefinition


type foreignKeyConstraintRecord = 
{
  referenceDefinition: referenceDefinitionType;
  constraintName: string;
  indexType : indexType;
  indexColumns : indexColumn list
}

type dbConstraint = PrimaryKeyConstraint of constraintRecord 
                | IndexConstraint of constraintRecord 
                | UniqueKeyConstraint of constraintRecord
                | ForeignKeyConstraint of foreignKeyConstraintRecord
                | SpatialConstraint of constraintRecord
                | FullTextConstraint of constraintRecord
                | CheckConstraint of expression

  
type columnDefinition = 
{
  dataType: dataType;
  allowNulls: bool;
  defaultValue: string;
  autoIncrement: bool;
  unique : bool;
  primaryKey: bool;
  foreignKey: bool;
  comment : string
}
type columnConstraintType = PrimaryKey | UniqueKey | ForeignKey

type columnType = ColumnDef of columnDefinition | 
  PrimaryKeys of indexColumn list | 
  UniqueKeys of indexColumn list |
  ForeignKeys of indexColumn list;;


type column = 
{
  name: string;
  definition: columnType;
}

let createColumnRefs anIndexColumnList aType =
  match aType with
  | PrimaryKey -> PrimaryKeys(anIndexColumnList)
  | UniqueKey -> UniqueKeys(anIndexColumnList)
  | ForeignKey -> ForeignKeys(anIndexColumnList)
  
let createDefaultVarcharField aLength = 
  {fieldLength = aLength; varcharQualification = defaultTextQualification}
let createVarcharField aLength charset collation = 
  let qual = {charset = charset; collation = collation} in
    VarcharType({
      fieldLength = aLength; 
      varcharQualification = qual
    })

let createBinaryField aLength = Binary(aLength)
let createTextField isBinary charset collation = 
  TextType({
    isBinary = isBinary; 
    textQualification = {charset = charset; collation = collation}
  })

let createTinyTextField isBinary charset collation = 
  TinyTextType(
    {
      isBinary = isBinary;
      textQualification = {charset = charset; collation = collation}
    }
  )
let createMediumTextField isBinary charset collation =
  MediumTextType(
    {
      isBinary = isBinary;
      textQualification = {charset = charset; collation = collation}
    }
  )
let createLongTextField isBinary charset collation =
  LongTextType(
    {
      isBinary = isBinary;
      textQualification = {charset = charset ; collation = collation}
    }
  )

let createColumn colName colDataType allowNull defaultValue primaryKey foreignKey autoIncrement unique comment =
  let createDefinition colDataType allowNull defaultValue primaryKey foreignKey autoIncrement unique comment =
    ColumnDef({
      dataType = colDataType;
      allowNulls = allowNull;
      defaultValue = defaultValue;
      primaryKey = primaryKey;
      foreignKey = foreignKey;
      autoIncrement = autoIncrement;
      unique = unique;
      comment = comment
    }) in    
  {
    name = colName;
    definition = createDefinition colDataType allowNull defaultValue primaryKey foreignKey autoIncrement unique comment
  }

let createColumnWithQualifiers aDataType (allowNull, defaultValue, unique, primaryKey,foreignKey,autoIncrement, comment) =
  {
    dataType = aDataType;
    allowNulls = allowNull;
    defaultValue = defaultValue;
    primaryKey = primaryKey;
    foreignKey = foreignKey;
    autoIncrement = autoIncrement;
    unique = unique;
    comment = comment
  }
let createDefaultColumnDefinition aDataType = 
  {
    dataType = aDataType;
    allowNulls = false;
    primaryKey = false;
    foreignKey = false;
    defaultValue = "Default";
    autoIncrement = false;
    unique = false;
    comment = "Comment"
  }
let createDefaultForeignKeyColumnDefinition aDataType =
{
  dataType = aDataType;
  allowNulls = false;
  primaryKey = false;
  foreignKey = true;
  defaultValue = "Default";
  autoIncrement = false;
  unique = false;
  comment = "Comment"
}  


let abbrCreateColumn colName colDefinition = 
  logger(Printf.sprintf "Creating abbreviatedColumn %s " colName);
  {
    name = colName;
    definition = colDefinition
  }
let createKeyColumn aType indexColumn = 
 let columnName = match aType with PrimaryKey -> "PrimaryKey" | UniqueKey -> "UniqueKey" | ForeignKey -> "ForeignKey" in
 let colDefinition = match aType with 
    |PrimaryKey -> PrimaryKeys(indexColumn) 
    | UniqueKey -> UniqueKeys(indexColumn) 
    | ForeignKey -> ForeignKeys(indexColumn) in
  {
  name = columnName;
  definition = colDefinition
  }
let isKey aColumn = match aColumn.name with "PrimaryKey" -> true | "UniqueKey" -> true | "ForeignKey" -> true | _ -> false 
let createIndexColumn aColumnName aColumnLength anOrder = 
  Printf.printf "Printing index %s\n" aColumnName;
  { 
    columnName = aColumnName; 
    columnLength = aColumnLength;
    order = anOrder
  }

let createIntType aType = match aType with
  | 0 -> NoColumnLength 
  | length->IntLength(length)

let createRealType aType = match aType with
  | (0,0) -> NoRealColumnLength
  | (length, decimals) -> RealLength(length, decimals)

let createConstraintRecord aConstraintName anIndexType anIndexColumnList referenceDefinition
  = { constraintName = aConstraintName;
      indexType = anIndexType;
      indexColumns = anIndexColumnList;
      referenceDefinition = referenceDefinition
    }
    
let printDataType aDataType = "To be defined"    
end
