(*//Module to generate Java-Hibernate files DB files
//using java 5 annotations.
*)
module SQLToJavaDBGenerator = struct
open ColumnDefinition.ColumnDefinition;;
open TableDefinition.TableDefinition;;
open GeneratorConstants.GeneratorConstants;;
open Printf;;
exception CompositeKeysNotSupported of string;;
exception FeatureNotSupported of string;;
exception NoPrimaryKeyDefined of string;;
exception InvalidCacheTypeException;;
exception UnsupportedStatementException;;
(*Library dependencies for this generator. *)
 
let dependencies = ["hibernate"; "apache-mina"; "slf4j"];;
let regex s = Str.regexp s;;



type classPersistenceType = Persistence | DTO;;
type cacheType = EhCache | GridGain| Derby;;


let decodeClassType aClassType = 
  match aClassType with Persistence -> "persistence"
  | DTO -> "dto";;
  
let decodeCacheType aCacheType = 
  match aCacheType with EhCache -> "EhCache"
  | GridGain -> "GridGain"
  | _ -> "Derby";;

let encodeCacheType aString = 
  Printf.printf "Encoding %s\n" aString;
  match aString with 
  "EhCache" -> EhCache
  | "GridGain" -> GridGain
  | "Derby" -> Derby
  | _ -> raise InvalidCacheTypeException;;

let getCacheType () = encodeCacheType (Sys.argv.(5));;

let generatePackageName aModelPrefix aPackageName = 
  match aPackageName with
  | "" -> sprintf "package %s;\n" aModelPrefix
  | _ -> sprintf "package %s.%s\n;" aModelPrefix aPackageName;;  
let importClassNames aModelPrefix= 
  let tempList = [
  "javax.persistence.*";
  "org.slf4j.Logger";
  "org.slf4j.LoggerFactory";
  "org.hibernate.Session";
  (sprintf "%s.HibernateUtil" aModelPrefix);
  "java.io.Serializable";
  "java.util.Date";
  "java.util.List";
  "java.util.LinkedList";
   ] in 
   match getCacheType() with
   GridGain -> List.append tempList ["org.gridgain.grid.cache.query.*"]
   | _ -> tempList;;
let importGridGainClassNames aModelPrefix =
  let tempList = [
    "org.gridgain.grid.GridEdition";
    (sprintf "%s.HibernateUtil" aModelPrefix);
    "org.gridgain.grid.GridException";
    "org.gridgain.grid.cache.*";
    "org.gridgain.grid.cache.store.GridCacheStoreAdapter";
    "org.gridgain.grid.editions.GridNotAvailableIn";
    "org.gridgain.grid.typedef.G";
    "org.gridgain.grid.typedef.X";
    "org.hibernate.FlushMode";
    "org.hibernate.HibernateException";
    "org.hibernate.Session";
    "org.hibernate.Transaction";
    "org.jetbrains.annotations.Nullable";
    "org.slf4j.Logger";
    "org.slf4j.LoggerFactory";
    "java.text.MessageFormat";
    "java.util.Date";
    "com.prepgames.domain.gridgain.util.GridGainUtils";
  ] in tempList;;
let generateClassImports packageList = List.fold_right
  (fun c acc ->
    match acc with "" ->
      sprintf "import %s;" c
    | _ -> sprintf 
"import %s;
%s" c acc) packageList "";;

let generateDependencyListComment = 
  let generateDependencyList = List.fold_right
    (fun c acc ->
      match acc with "" -> sprintf "%s" c
      | _ -> sprintf "%s %s" c acc) dependencies in
    sprintf "/*%s*/" (generateDependencyList "");;

let generateGeneratedDocumentation aClassName = 
  sprintf "/* %s Class file generated on %s */\n" aClassName (getCurrentTime());;
  
let generateAnnotationHeader aClassType = 
    let cacheType = getCacheType() in
    match (aClassType, cacheType) with 
    (Persistence, EhCache) -> "@Entity\n@org.hibernate.annotations.Cache(usage = org.hibernate.annotations.CacheConcurrencyStrategy.READ_WRITE)\n"
    | (Persistence, GridGain) -> "@Entity"
    | (Persistence, Derby) -> "@Entity"
    | (DTO, _) -> "";;

let generateGridGainAnnotationHeader aClassType = "@GridNotAvailableIn(GridEdition.COMPUTE_GRID)\n";;

let generateAnnotation aTableName = sprintf "@Table(name=\"%s\")\n" aTableName;;
let generateClassHeader aClassName = sprintf "public class %s implements Serializable{" aClassName;;

let generateClassLogger aClassName = sprintf "private static Logger log = LoggerFactory.getLogger(%s.class);" aClassName;;
let generateConstructor aClassName = sprintf
"
public %s(){};
" aClassName;;
let convertToJavaType attributeDataType = 
  match attributeDataType with
  | BitType(anInt) -> "Boolean"
  | TinyIntType(anInt) -> "Integer"
  | SmallIntType(anInt) -> "Integer"
  | MediumIntType(anInt) -> "Integer"
  | IntType(anInt) -> "Integer"
  | IntegerType(anInt)-> "Integer"
  | RealType(aReal) -> "Double"
  | BigIntType(anInt) -> "java.math.BigInteger"
  | DateType -> "java.util.Date"
  | TimeType -> "java.util.Date"
  | TimeStampType -> "java.util.Date"
  | DateTimeType -> "java.util.Date"
  | YearType -> "Integer"
  | CharType(anInt) -> "String"
  | VarcharType(anInt) -> "String"
  | Binary(anInt) -> "org.apache.mina.common.ByteBuffer"
  | VarBinary(anInt) -> "org.apache.mina.common.ByteBuffer"
  | TinyBlob -> "org.apache.mina.common.ByteBuffer"
  | Blob -> "org.apache.mina.common.ByteBuffer"
  | MediumBlob -> "org.apache.mina.common.ByteBuffer"
  | LongBlob -> "org.apache.mina.common.ByteBuffer"
  | TextType(aText) -> "String"
  | TinyTextType(aText) -> "String"
  | MediumTextType(aText) -> "String"
  | LongTextType(aText) -> "String"
  | EnumType(aText) -> "String"
  | SetType(aSet) -> "java.util.Set"
  | BoolType -> "Boolean";;
  
let convertColumnToJavaType aColumn =
  match aColumn.definition with
  | ColumnDef(columnDefinition) -> convertToJavaType columnDefinition.dataType
  | _ -> "";;

  
let generateAccessor anAttributeName attributeDataType = 
sprintf
" 
  public %s get%s() {
    return %s;
  }
" (convertToJavaType attributeDataType)
  (String.capitalize anAttributeName) anAttributeName;;

(*Assumes that id is a primary key (no composite keys) and all are auto generated *)

let generateIdAnnotation aColumn = 
  let cacheString = match getCacheType() 
    with EhCache-> ""
    | GridGain -> "@GridCacheQuerySqlField(unique=true)"
    | Derby -> "" in
  let idString = match getCacheType()
    with EhCache-> "@Id @GeneratedValue"
    | GridGain -> "@Id"
    | Derby -> ""
  in
  Printf.printf "Using cacheString %s\n" cacheString;    
  Printf.sprintf "%s\n %s" idString cacheString;;
  
let generateColumnAnnotation aColumn = 
  let cacheString = match getCacheType() 
    with EhCache -> ""
    | GridGain -> "@GridCacheQuerySqlField"
    | Derby -> "" in
  sprintf 
"
@Column(name=\"%s\") 
%s" (aColumn.name) cacheString;;


let generateAttributeName anAttributeName attributeDataType = sprintf
"   private %s %s;
" (convertToJavaType attributeDataType) anAttributeName;;
let generateMutator anAttributeName attributeDataType = 
  let paramName = "a" ^ anAttributeName in
sprintf
"
  public void set%s(%s %s){
    this.%s = %s;
  }
" (String.capitalize anAttributeName) (convertToJavaType attributeDataType) paramName anAttributeName paramName;;

let generateAttribute anAttribute =
  match anAttribute.definition with
  | ColumnDef(aDefinition) ->
    let columnDataType = aDefinition.dataType in
    let attributeName = anAttribute.name in
    let genAttributeName = generateAttributeName attributeName columnDataType in
    let genAttributeMutator = generateMutator attributeName columnDataType in
    let genAttributeAccessor = generateAccessor attributeName columnDataType in
  let cacheString = match getCacheType() 
    with EhCache-> ""
    | GridGain -> "@GridCacheQuerySqlField"
    | Derby -> ""
  in
    
  sprintf
"
  @Column(name=\"%s\")
  %s
  %s
%s
%s
" attributeName cacheString genAttributeName genAttributeAccessor genAttributeMutator
 | _ -> ""
;;
let generateCopyValues keyAttribute attributeList dtoPackageName aStatement = "//TO be defined";;
let generateUpdateCreationMethod2 = 
"
  private void updateCreationInformation(){
    if(getId() == null){
      this.setCreationDate(new Date());
    }else {
      this.setModificationDate(new Date());
    }
  }
"

let generateUpdateCreationMethod keyAttribute = 
  match keyAttribute.definition with
  | ColumnDef(aDefinition) ->
    let attributeName = String.capitalize(keyAttribute.name) in
    let attributeAccessorName = "get" ^ attributeName ^ "()" in
    sprintf
"
public void updateCreationInformation(String createdBy, String anIPAddress){
  if(%s == null){
    this.setCreatedBy(createdBy);
    this.setCreationIP(anIPAddress);
    this.setCreationDate(new Date());
  }else {
    this.setModifiedBy(createdBy);
    this.setModificationIP(anIPAddress);
    this.setModificationDate(new Date());
  }
}
" attributeAccessorName
  | _ -> raise(FeatureNotSupported("Invalid column defined"))
;;

let generatePrimaryKey keyAttribute = 
  match keyAttribute.definition with
  | ColumnDef(aDefinition) ->
  let columnDataType = aDefinition.dataType in
  let attributeName = keyAttribute.name in
  let genAttributeName = (generateAttributeName attributeName columnDataType) in
  let genAttributeMutator = (generateMutator  attributeName columnDataType) in
  let genAttributeAccessor = (generateAccessor attributeName columnDataType) in
  let cacheString = match getCacheType() 
    with EhCache-> ""
    | GridGain -> "@GridCacheQuerySqlField(unique=true)"
     | Derby -> "" in
  let idString = match getCacheType() 
      with EhCache -> "@Id @GeneratedValue"
      | GridGain -> "@Id" 
      | Derby -> "" in
sprintf
"
  %s
  %s
  %s
  %s
  %s
  " idString cacheString genAttributeName genAttributeAccessor genAttributeMutator
 | _ -> raise(FeatureNotSupported("Invalid column definition"));;



let generateInternalSave = 
sprintf  
"
  private void save(){
    Session session = null;
    try {
    session = HibernateUtil.getSingleton().getSession();
    session.beginTransaction();
    session.saveOrUpdate(this);
    session.getTransaction().commit();
    } catch(Exception e){
      log.error(\"Error saving \" + this, e);
      if(session != null){
        session.getTransaction().rollback();
      }
      throw new RuntimeException(e);
    }finally{
      if(session != null){
        session.close();
      }
    }
  } %s
" "//End of save";;
let generateDTOSave dtoPackageName aStatement =
  let className = aStatement.tableName in
  let instanceName = "a" ^ className in
sprintf
"
  public void save(%s.%s %s) {
    copyValues(%s);
    save();
  }
" dtoPackageName className instanceName instanceName;;
let generateInternalDelete = 
sprintf
"
  public void delete(String createdBy, String creationIP){
  //TO Be defined.
    this.save(createdBy, creationIP);
  }
";;

let generateLoadObject aStatement = 
let className = aStatement.tableName in 
sprintf
"
  public static %s loadObject(int anId){
    Session session = null;
    try {
    session = HibernateUtil.getSingleton().getSession();
    %s result = (%s) session.load(%s.class, anId);
    return result;
    }catch(Exception e){
      log.error(\"Error loading instance \" + anId, e);      
    }finally{
      if(session != null){
        session.close();
      }
    }
    return null;
  }
" className className className className;;

let generateInternalSave2 =
sprintf
" %s
  public void save(String createdBy, String creationIP){
    Session session = null;
    try {
    session = HibernateUtil.getSingleton().getSession();
    session.beginTransaction();
    session.saveOrUpdate(this);
    session.getTransaction().commit();
    } catch(Exception e){
      log.error(\"Error saving \" + this, e);
      if(session != null){
        session.getTransaction().rollback();
      }
      throw new RuntimeException(e);
    }finally{
      if(session != null){
        session.close();
      }
    }
  }
" "";;
let generateAttributes anAttributeList = List.fold_right (fun x acc -> sprintf "%s %s"(generateAttribute x) acc) anAttributeList "";; 
let generateClassBody aStatement dtoPackageName = 
  logger("Inside generate Class body ");
  let keyList = getPrimaryKeyIds aStatement in
  let keyLength = List.length keyList in
  if keyLength > 1 then 
    raise(CompositeKeysNotSupported("Feature not supported"))
  else
    let keyAttribute = 
      Printf.printf "Key list size %d\n" (List.length keyList);
    if(List.length keyList = 1) then
      (List.hd keyList)
    else
      raise (NoPrimaryKeyDefined("Feature not supported for non keyed tables")) in
    let attributeList = tableAttributes keyAttribute aStatement in
    sprintf 
"
  %s
  %s
  %s
  %s
  %s
  %s
"
    (generatePrimaryKey keyAttribute)
    (generateAttributes attributeList)
    (generateInternalSave)
    (generateInternalSave2)
    (generateInternalDelete)
    (generateLoadObject aStatement)
;;

let generateEndBlock = "}";;
let storeClassName tableName = sprintf "%s_%s" tableName "store";;
let generateGridGainClassHeader tableName =
    let storeClassName = storeClassName tableName in
  sprintf "public class %s extends GridCacheStoreAdapter<Integer,%s> {"
    storeClassName tableName;;
let generateGridGainStaticVariables tableName =
  let storeClassName = storeClassName tableName in
  sprintf "
  private static final String ATTR_SES = (%s.class).getCanonicalName();
  //Well known cache name for the cache. TODO: Should probably be implementing
  //an interface??
  public static final String CACHE_NAME = (%s.class).getCanonicalName();
  private static final Logger log = LoggerFactory.getLogger(%s.class);
  private Session session(GridCacheTx tx) {
    return GridGainUtils.session(tx, ATTR_SES);
  }" 
  storeClassName storeClassName storeClassName;;
  
let generateGridGainLoadMethod tableName =
  sprintf
  "
    /** {@inheritDoc} */
    //@Override
    public %s load(@Nullable String cacheName, @Nullable GridCacheTx tx, Integer key) throws GridException {
        log.info(\"Store load [key=\" + key + \", tx=\" + tx + ']');

        Session ses = session(tx);

        try {
            return (%s) ses.get(%s.class, key);
        }
        catch (HibernateException e) {
            rollback(ses, tx);

            throw new GridException(\"Failed to load value from cache store with key: \" + key, e);
        }
        finally {
            end(ses, tx);
        }
    }" tableName tableName tableName 
    
let generateGridGainPutMethod tableName = 
  sprintf
  "
    //@Override
    public void put(@Nullable String cacheName, @Nullable GridCacheTx tx, Integer key, @Nullable %s  val)
            throws GridException {
        log.info(\"Store put [key=\" + key + \", val=\" + val + \", tx=\" + tx + ']');

        if (val == null) {
            remove(cacheName, tx, key);

            return;
        }

        Session ses = session(tx);

        try {
            ses.saveOrUpdate(val);
        }
        catch (HibernateException e) {
            rollback(ses, tx);

            throw new GridException(\"Failed to put value to cache store [key=\" + key + \", val\" + val + \"]\", e);
        }
        finally {
            end(ses, tx);
        }
    }  
  " tableName;;

let generateGridGainRemoveMethod tableName =
  sprintf
  "
  /** {@inheritDoc} */
    @SuppressWarnings({\"JpaQueryApiInspection\"})
    //@Override
    public void remove(@Nullable String cacheName, @Nullable GridCacheTx tx, Integer key) throws GridException {
        Session ses = session(tx);

        try {
            ses.createQuery(\"delete \" + %s.class.getSimpleName() + \" where key = :key\")
                    .setParameter(\"key\", key).setFlushMode(FlushMode.ALWAYS).executeUpdate();
        }
        catch (HibernateException e) {
            rollback(ses, tx);
            throw new GridException(\"Failed to remove value from cache store with key: \" + key, e);
        }
        finally {
            end(ses, tx);
        }
    }
  " tableName;;

let generateGridGainTransactionMethods () =
  "
      /**
     * Rolls back hibernate session.
     *
     * @param ses Hibernate session.
     * @param tx Cache ongoing transaction.
     */
    private void rollback(Session ses, GridCacheTx tx) {
        // Rollback only if there is no cache transaction,
        // otherwise txEnd() will do all required work.
        if (tx == null) {
            Transaction hTx = ses.getTransaction();

            if (hTx != null && hTx.isActive())
                hTx.rollback();
        }
    }

    /**
     * Ends hibernate session.
     *
     * @param ses Hibernate session.
     * @param tx Cache ongoing transaction.
     */
    private void end(Session ses, GridCacheTx tx) {
        // Commit only if there is no cache transaction,
        // otherwise txEnd() will do all required work.
        if (tx == null) {
            Transaction hTx = ses.getTransaction();

            if (hTx != null && hTx.isActive())
                hTx.commit();

            ses.close();
        }
    }

    /** {@inheritDoc} */
    //@Override
    public void txEnd(@Nullable String cacheName, GridCacheTx tx, boolean commit) throws GridException {
        Session ses = tx.removeMeta(ATTR_SES);

        if (ses != null) {
            Transaction hTx = ses.getTransaction();

            if (hTx != null) {
                try {
                    if (commit) {
                        ses.flush();
                        hTx.commit();
                    }
                    else
                        hTx.rollback();

                    X.println(\"Transaction ended [xid=\" + tx.xid() + \", commit=\" + commit + ']');
                }
                catch (HibernateException e) {
                    throw new GridException(\"Failed to end transaction [xid=\" + tx.xid() +
                            \", commit=\" + commit + ']', e);
                }
                finally {
                    ses.close();
                }
            }
        }
    }
  "
  
            
let generateGridGainStoreClass aStatement persistencePackageName utilPrefix =
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
  "
  (generatePackageName persistencePackageName "")
  (generateLicenseFile())
  (generateClassImports(importGridGainClassNames utilPrefix))
  (generateGridGainAnnotationHeader Persistence)
  (generateGridGainClassHeader aStatement.tableName)
  (generateGridGainStaticVariables aStatement.tableName)
  (generateGridGainLoadMethod aStatement.tableName)
  (generateGridGainPutMethod aStatement.tableName)
  (generateGridGainRemoveMethod aStatement.tableName)
  (generateGridGainTransactionMethods () )
  generateEndBlock
  | _ -> raise UnsupportedStatementException;;
let generateJavaDBClass aStatement persistencePackageName dtoPackageName utilPrefix=
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
" 
  (generatePackageName persistencePackageName "")
  (generateLicenseFile())
  (generateGeneratedDocumentation aStatement.tableName)
  (generateClassImports (importClassNames utilPrefix))
  (generateAnnotationHeader Persistence)
  (generateAnnotation aStatement.tableName)
  (generateClassHeader aStatement.tableName)
  (generateClassLogger aStatement.tableName)
  (generateConstructor aStatement.tableName)
  (generateClassBody aStatement dtoPackageName)  
  generateEndBlock
  | _ -> raise UnsupportedStatementException


let writeGGCacheConfig out_channel javaModelPrefix aStatement =
  match aStatement with 
  CreateStatement(aStatement) ->
    Printf.printf "Generating xml snippet for %s\n" aStatement.tableName;
    let storeName = javaModelPrefix ^ "." ^ aStatement.tableName ^ "_" ^ "store" in
    let configurationClass = "org.gridgain.grid.cache.GridCacheConfigurationAdapter" in
    let cacheMode = "PARTITIONED" in
    let synchronousCommit = "true" in
    let storeEnabled = "true" in
    let writeBehindEnabled = "true" in
    let preloadMode = "SYNC" in
    Printf.fprintf out_channel
    "<bean class=\"%s\">
      <property name=\"name\" value=\"%s\"/>
      <property name=\"synchronousCommit\" value=\"%s\"/>
      <property name=\"storeEnabled\" value=\"%s\"/>
      <property name=\"store\"> 
        <bean class = \"%s\" scope=\"singleton\"/>
      </property>
      
      <property name=\"cacheMode\" value=\"%s\"/>
      <property name=\"writeBehindEnabled\" value=\"%s\"/>
      <property name=\"preloadMode\" value = \"%s\"/>      
     </bean>
    " 
    configurationClass 
    storeName
    synchronousCommit
    storeEnabled
    storeName
    cacheMode
    writeBehindEnabled
    preloadMode
      
  | _ -> raise UnsupportedStatementException;;
  
let writeEhCacheConfig out_channel javaModelPrefix aStatement =
  match aStatement with
  CreateStatement(aStatement) ->
    let cacheName = javaModelPrefix ^ "." ^ aStatement.tableName in
    let maxEntries = 10000 in
    let eternal = "false" in
    let timeToIdleSeconds =300 in
    let timeToLiveSeconds = 600 in 
    let overFlowToDisk = "true" in
    Printf.printf "aConfiguration.addAnnotatedClass(%s.class);\n" cacheName;
    Printf.fprintf out_channel "<cache name=\"%s\" 
      eternal =\"%s\" \n"
      cacheName eternal;
    Printf.fprintf out_channel "timeToIdleSeconds=\"%d\" timeToLiveSeconds=\"%d\"\n"
      timeToIdleSeconds timeToLiveSeconds;
    Printf.fprintf out_channel "overflowToDisk=\"%s\" />\n" overFlowToDisk
  | _ -> raise UnsupportedStatementException;;

let writeJavaDBClass aStatement aModelPrefix utilPrefix =
  let classString = generateJavaDBClass aStatement aModelPrefix "dto" utilPrefix in
  match aStatement with 
  CreateStatement(aStatement) ->
    let javaFileName = aStatement.tableName in
    try 
      let file = Unix.openfile (aStatement.tableName ^".java")  [Unix.O_RDWR;Unix.O_CREAT] 0o777 in
      let out_channel = Unix.out_channel_of_descr file in
        Printf.fprintf out_channel "%s"  classString;
        flush out_channel;
        close_out out_channel;
    with 
      Sys_error e -> prerr_endline e;;
      
let writeGridGainStoreClass aStatement aModelPrefix utilPrefix =
  let classString = generateGridGainStoreClass aStatement aModelPrefix utilPrefix in
  match aStatement with
  CreateStatement(aStatement) ->
    let ggFileName = sprintf "%s_%s.java" (aStatement.tableName) ("store") in
    try
      let file = Unix.openfile(ggFileName) [Unix.O_RDWR; Unix.O_CREAT] 0o777 in
      let out_channel = Unix.out_channel_of_descr file in
        Printf.fprintf out_channel "%s" classString;
        flush out_channel;
        close_out out_channel
    with
      Sys_error e -> prerr_endline e;;

(* Create xml config snippets to be copied into a template file. TODO: This needs 
to change *)

let writeConfigSnippets javaModelPrefix statements =
  let cacheType = getCacheType() in
  match cacheType with
  EhCache -> 
    let ehCacheFile = "ehcache.xml" in
    let file = Unix.openfile(ehCacheFile) [Unix.O_RDWR;Unix.O_CREAT] 0o777 in
    let out_channel = Unix.out_channel_of_descr file in
      List.iter(fun x -> writeEhCacheConfig out_channel javaModelPrefix x) statements;
      flush out_channel;
      close_out out_channel
  | GridGain -> 
    let ggCacheFile = "gg_cache_snippets.xml" in
    let file = Unix.openfile(ggCacheFile) [Unix.O_RDWR; Unix.O_CREAT] 0o777 in
    let out_channel = Unix.out_channel_of_descr file in
      List.iter(fun x -> 
        writeGGCacheConfig out_channel javaModelPrefix x) statements;
      close_out out_channel
  |_ -> ()
      
end