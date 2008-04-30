(*
  PressObjects, DAO + Persistence Interface Classes
  Copyright (C) 2006-2008 Laserpress Ltda.

  http://www.pressobjects.org

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit PressSession;

{$I Press.inc}

interface

uses
  Classes,
  Contnrs,
  PressApplication,
  PressClasses,
  PressNotifier,
  PressSubject;

const
  CPressOIDGeneratorService = CPressDataAccessServicesBase + $0002;

type
  TPressDAOCacheClass = class of TPressDAOCache;

  TPressDAOCache = class(TObject)
  private
    { TODO : Implement binary tree }
    { TODO : Implement IsBroken support }
    FObjectList: TPressObjectList;
  protected
    property ObjectList: TPressObjectList read FObjectList;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure AddObject(AObject: TPressObject); virtual;
    function CreateIterator: TPressObjectIterator;
    function FindObject(AClass: TPressObjectClass; const AId: string): TPressObject;
    function HasObject: Boolean;
    procedure ReleaseObjects; virtual;
    function RemoveObject(AObject: TPressObject): Integer; virtual;
  end;

  TPressDAOAttributes = class(TObject)
  private
    FList: TStringList;
    function GetItems(AIndex: Integer): string;
  public
    constructor Create(const AAttributes: string = '');
    destructor Destroy; override;
    procedure Add(const AAttribute: string);
    procedure AddUnloadedAttributes(AObject: TPressObject; AIncludeLazyLoading: Boolean);
    function Count: Integer;
    function CreatePathAttributes: TPressDAOAttributes;
    function IsEmpty: Boolean;
    function Include(AAttribute: TPressAttributeMetadata): Boolean;
    property Items[AIndex: Integer]: string read GetItems; default;
  end;

  TPressDAO = class(TPressService, IPressDAO)
  private
    { TODO : Implement transacted object control }
    FCache: TPressDAOCache;
    FLazyCommit: Boolean;
    FNotifier: TPressNotifier;
    FTransactionLevel: Integer;
    procedure DisposeObject(AObject: TPressObject);
    procedure Notify(AEvent: TPressEvent);
  protected
    procedure DoneService; override;
    procedure Finit; override;
    procedure InternalBulkRetrieve(AProxyList: TPressProxyList; AStartingAt, AItemCount: Integer; AAttributes: TPressDAOAttributes); virtual;
    function InternalCacheClass: TPressDAOCacheClass; virtual;
    procedure InternalCommit; virtual;
    procedure InternalDispose(AClass: TPressObjectClass; const AId: string); virtual;
    function InternalExecuteStatement(const AStatement: string; AParams: TPressParamList): Integer; virtual;
    function InternalGenerateOID(AClass: TPressObjectClass; const AAttributeName: string): string; virtual;
    function InternalImplementsBulkRetrieve: Boolean; virtual;
    function InternalImplementsLazyLoading: Boolean; virtual;
    procedure InternalLoad(AObject: TPressObject; AIncludeLazyLoading, ALoadContainers: Boolean); virtual;
    function InternalOQLQuery(const AOQLStatement: string; AParams: TPressParamList): TPressProxyList; virtual;
    procedure InternalRefresh(AObject: TPressObject); virtual;
    function InternalRetrieve(AClass: TPressObjectClass; const AId: string; AMetadata: TPressObjectMetadata; AAttributes: TPressDAOAttributes): TPressObject; virtual;
    procedure InternalRetrieveAttribute(AAttribute: TPressAttribute); virtual;
    function InternalRetrieveQuery(AQuery: TPressQuery): TPressProxyList; virtual;
    procedure InternalRollback; virtual;
    class function InternalServiceType: TPressServiceType; override;
    procedure InternalShowConnectionManager; virtual;
    function InternalSQLProxy(const ASQLStatement: string; AParams: TPressParamList): TPressProxyList; virtual;
    function InternalSQLQuery(AClass: TPressObjectClass; const ASQLStatement: string; AParams: TPressParamList): TPressProxyList; virtual;
    procedure InternalStartTransaction; virtual;
    procedure InternalStore(AObject: TPressObject); virtual;
    function UnsupportedFeatureError(const AFeatureName: string): EPressError;
    property Cache: TPressDAOCache read FCache;
  public
    constructor Create; override;
    function CreateObject(AClass: TPressObjectClass; AMetadata: TPressObjectMetadata): TPressObject;
    procedure AssignObject(AObject: TPressObject);
    procedure BulkRetrieve(AProxyList: TPressProxyList; AStartingAt, AItemCount: Integer; const AAttributes: string);
    procedure Commit;
    procedure Dispose(AClass: TPressObjectClass; const AId: string);
    function ExecuteStatement(const AStatement: string; AParams: TPressParamList = nil): Integer;
    function GenerateOID(AClass: TPressObjectClass; const AAttributeName: string = ''): string;
    procedure Load(AObject: TPressObject; AIncludeLazyLoading, ALoadContainers: Boolean);
    function OQLQuery(const AOQLStatement: string; AParams: TPressParamList = nil): TPressProxyList;
    procedure Refresh(AObject: TPressObject);
    procedure ReleaseObject(AObject: TPressObject);
    function Retrieve(AClass: TPressObjectClass; const AId: string; AMetadata: TPressObjectMetadata = nil; const AAttributes: string = ''): TPressObject;
    procedure RetrieveAttribute(AAttribute: TPressAttribute);
    function RetrieveQuery(AQuery: TPressQuery): TPressProxyList;
    procedure Rollback;
    procedure ShowConnectionManager;
    function SQLProxy(const ASQLStatement: string; AParams: TPressParamList = nil): TPressProxyList;
    function SQLQuery(AClass: TPressObjectClass; const ASQLStatement: string; AParams: TPressParamList = nil): TPressProxyList;
    procedure StartTransaction;
    procedure Store(AObject: TPressObject);
    procedure SynchronizeProxy(AProxy: TPressProxy);
    property LazyCommit: Boolean read FLazyCommit write FLazyCommit;
  end;

  TPressPersistence = class;

  TPressOIDGeneratorClass = class of TPressOIDGenerator;

  TPressOIDGenerator = class(TPressService)
  protected
    function InternalGenerateOID(Sender: TPressPersistence; AObjectClass: TPressObjectClass; const AAttributeName: string): string; virtual;
    procedure InternalReleaseOID(Sender: TPressPersistence; AObjectClass: TPressObjectClass; const AAttributeName, AOID: string); virtual;
    class function InternalServiceType: TPressServiceType; override;
  public
    function GenerateOID(Sender: TPressPersistence; AObjectClass: TPressObjectClass; const AAttributeName: string): string;
    procedure ReleaseOID(Sender: TPressPersistence; AObjectClass: TPressObjectClass; const AAttributeName, AOID: string);
  end;

  TPressPersistence = class(TPressDAO)
  private
    FOIDGenerator: TPressOIDGenerator;
    function GetOIDGenerator: TPressOIDGenerator;
  protected
    procedure Finit; override;
    function InternalDBMSName: string; virtual;
    function InternalGenerateOID(AClass: TPressObjectClass; const AAttributeName: string): string; override;
    function InternalOIDGeneratorClass: TPressOIDGeneratorClass; virtual;
    property OIDGenerator: TPressOIDGenerator read GetOIDGenerator;
  public
    function DBMSName: string;
  end;

  TPressPersistentObjectLink = class(TObject)
  private
    FPersistentObject: TObject;
    FPressObject: TPressObject;
    procedure SetPersistentObject(AValue: TObject);
  public
    constructor Create(APressObject: TPressObject; APersistentObject: TObject);
    destructor Destroy; override;
    property PersistentObject: TObject read FPersistentObject write SetPersistentObject;
    property PressObject: TPressObject read FPressObject;
  end;

  TPressThirdPartyPersistenceCache = class(TPressDAOCache)
  private
    FPersistentObjectLinkList: TObjectList;
    function GetPersistentObjectLink(AIndex: Integer): TPressPersistentObjectLink;
  protected
    property PersistentObjectLinkList: TObjectList read FPersistentObjectLinkList;
  public
    constructor Create; override;
    destructor Destroy; override;
    function AddLink(APressObject: TPressObject; APersistentObject: TObject): Integer;
    function IndexOfLink(APressObject: TPressObject): Integer;
    procedure ReleaseObjects; override;
    function RemoveObject(AObject: TPressObject): Integer; override;
    property PersistentObjectLink[AIndex: Integer]: TPressPersistentObjectLink read GetPersistentObjectLink;
  end;

  TPressThirdPartyPersistence = class(TPressPersistence)
  private
    function GetCache: TPressThirdPartyPersistenceCache;
    function GetPersistentObject(APressObject: TPressObject): TObject;
    procedure SetPersistentObject(APressObject: TPressObject; AValue: TObject);
  protected
    function InternalCacheClass: TPressDAOCacheClass; override;
    property Cache: TPressThirdPartyPersistenceCache read GetCache;
    property PersistentObject[APressObject: TPressObject]: TObject read GetPersistentObject write SetPersistentObject;
  end;

implementation

uses
  SysUtils,
{$ifdef PressLog}
  PressLog,
{$endif}
  PressConsts,
  PressUtils;

type
  TPressObjectFriend = class(TPressObject);

  TPressDAOCommit = class(TPressEvent)
  end;

{ TPressDAOCache }

procedure TPressDAOCache.AddObject(AObject: TPressObject);
begin
  ObjectList.Add(AObject);
end;

constructor TPressDAOCache.Create;
begin
  inherited Create;
  FObjectList := TPressObjectList.Create(False);
end;

function TPressDAOCache.CreateIterator: TPressObjectIterator;
begin
  Result := ObjectList.CreateIterator;
end;

destructor TPressDAOCache.Destroy;
begin
  FObjectList.Free;
  inherited;
end;

function TPressDAOCache.FindObject(
  AClass: TPressObjectClass; const AId: string): TPressObject;
var
  I: Integer;
begin
  if AId <> '' then
    for I := 0 to Pred(ObjectList.Count) do
    begin
      Result := ObjectList[I];
      if (Result.PersistentId = AId) and
       (not Assigned(AClass) or (Result.ClassType.InheritsFrom(AClass))) then
        Exit;
    end;
  Result := nil;
end;

function TPressDAOCache.HasObject: Boolean;
begin
  Result := Assigned(FObjectList) and (FObjectList.Count > 0);
end;

procedure TPressDAOCache.ReleaseObjects;
begin
  { TODO : IsBroken support }
end;

function TPressDAOCache.RemoveObject(AObject: TPressObject): Integer;
begin
  Result := ObjectList.Remove(AObject);
end;

{ TPressDAOAttributes }

procedure TPressDAOAttributes.Add(const AAttribute: string);
begin
  FList.Add(AAttribute);
end;

procedure TPressDAOAttributes.AddUnloadedAttributes(
  AObject: TPressObject; AIncludeLazyLoading: Boolean);
var
  VAttribute: TPressAttribute;
begin
  with AObject.CreateAttributeIterator do
  try
    BeforeFirstItem;
    while NextItem do
    begin
      VAttribute := CurrentItem;
      if VAttribute.IsPersistent and
       (AIncludeLazyLoading or not VAttribute.Metadata.LazyLoad) and
       (VAttribute.State = asNotLoaded) then
        Add(VAttribute.Metadata.Name);
    end;
  finally
    Free;
  end;
end;

function TPressDAOAttributes.Count: Integer;
begin
  Result := FList.Count;
end;

constructor TPressDAOAttributes.Create(const AAttributes: string);
begin
  inherited Create;
  FList := TStringList.Create;
  FList.Sorted := True;
  FList.Duplicates := dupError;
  FList.CommaText := StringReplace(AAttributes, ';', ',', [rfReplaceAll]);
end;

function TPressDAOAttributes.CreatePathAttributes: TPressDAOAttributes;
var
  I: Integer;
begin
  Result := TPressDAOAttributes.Create;
  try
    for I := 0 to Pred(FList.Count) do
      if Pos(SPressAttributeSeparator, FList[I]) > 0 then
        Result.Add(FList[I]);
  except
    FreeAndNil(Result);
    raise;
  end;
end;

destructor TPressDAOAttributes.Destroy;
begin
  FList.Free;
  inherited;
end;

function TPressDAOAttributes.GetItems(AIndex: Integer): string;
begin
  Result := FList[AIndex];
end;

function TPressDAOAttributes.Include(
  AAttribute: TPressAttributeMetadata): Boolean;
var
  VAttribute: string;
  VPos: Integer;
begin
  Result := ((FList.Count = 0) and not AAttribute.LazyLoad) or
   (FList.Count = 1) and (FList[0] = '*');
  if not Result and (FList.Count > 0) then
  begin
    VAttribute := AAttribute.Name;
    Result := FList.Find(VAttribute, VPos);
    if not Result and (VPos < FList.Count) then
      Result := Copy(FList[VPos], 1, Length(VAttribute) + 1) =
       VAttribute + SPressAttributeSeparator;
  end;
end;

function TPressDAOAttributes.IsEmpty: Boolean;
begin
  Result := FList.Count = 0;
end;

{ TPressDAO }

procedure TPressDAO.AssignObject(AObject: TPressObject);
begin
  FCache.AddObject(AObject);
end;

procedure TPressDAO.BulkRetrieve(
  AProxyList: TPressProxyList; AStartingAt, AItemCount: Integer;
  const AAttributes: string);
var
  VAttributes: TPressDAOAttributes;
begin
  if not InternalImplementsBulkRetrieve then
    Exit;
  StartTransaction;
  try
    VAttributes := TPressDAOAttributes.Create(AAttributes);
    try
      InternalBulkRetrieve(AProxyList, AStartingAt, AItemCount, VAttributes);
    finally
      VAttributes.Free;
    end;
    Commit;
  except
    Rollback;
    raise;
  end;
end;

procedure TPressDAO.Commit;
begin
  if FTransactionLevel < 1 then
    Exit;
  if FTransactionLevel > 1 then
    Dec(FTransactionLevel)
  else if LazyCommit then
    TPressDAOCommit.Create(Self).QueueNotification
  else
  begin
    FTransactionLevel := 0;
    InternalCommit;
  end;
end;

constructor TPressDAO.Create;
begin
  inherited;
  FCache := InternalCacheClass.Create;
  FNotifier := TPressNotifier.Create({$ifdef FPC}@{$endif}Notify);
  FNotifier.AddNotificationItem(Self, [TPressDAOCommit]);
end;

function TPressDAO.CreateObject(AClass: TPressObjectClass;
  AMetadata: TPressObjectMetadata): TPressObject;
begin
  Result := TPressObject(AClass.NewInstance);
  try
    // lacks inherited Create
    TPressObjectFriend(Result).InitInstance(Self, AMetadata, True);
  except
    FreeAndNil(Result);
    raise;
  end;
end;

procedure TPressDAO.Dispose(AClass: TPressObjectClass; const AId: string);
var
  VObject: TPressObject;
begin
  StartTransaction;
  try
    { TODO : Improve }
    VObject := Retrieve(AClass, AId);
    try
      if Assigned(VObject) and VObject.IsPersistent then
      begin
        TPressObjectFriend(VObject).BeforeDispose;
        VObject.DisableChanges;
        try
{$ifdef PressLogDAOInterface}
          PressLogMsg(Self, 'Disposing', [VObject]);
{$endif}
          TPressObjectFriend(VObject).InternalDispose(
           {$ifdef FPC}@{$endif}DisposeObject);
          PressAssignPersistentId(VObject, '');
        finally
          VObject.EnableChanges;
        end;
        TPressObjectFriend(VObject).AfterDispose;
      end;
    finally
      VObject.Free;
    end;
    Commit;
  except
    Rollback;
    raise;
  end;
end;

procedure TPressDAO.DisposeObject(AObject: TPressObject);
begin
  InternalDispose(AObject.ClassType, AObject.PersistentId);
end;

procedure TPressDAO.DoneService;
begin
  inherited;
  if Assigned(Cache) then
    Cache.ReleaseObjects;
end;

function TPressDAO.ExecuteStatement(
  const AStatement: string; AParams: TPressParamList): Integer;
begin
  StartTransaction;
  try
    Result := InternalExecuteStatement(AStatement, AParams);
    Commit;
  except
    Rollback;
    raise;
  end;
end;

procedure TPressDAO.Finit;
begin
  FNotifier.Free;
  FCache.Free;
  inherited;
end;

function TPressDAO.GenerateOID(AClass: TPressObjectClass;
  const AAttributeName: string): string;
begin
  Result := InternalGenerateOID(AClass, AAttributeName);
end;

procedure TPressDAO.InternalBulkRetrieve(
  AProxyList: TPressProxyList; AStartingAt, AItemCount: Integer;
  AAttributes: TPressDAOAttributes);
begin
  raise UnsupportedFeatureError('Bulk retrieve');
end;

function TPressDAO.InternalCacheClass: TPressDAOCacheClass;
begin
  Result := TPressDAOCache;
end;

procedure TPressDAO.InternalCommit;
begin
  raise UnsupportedFeatureError('Commit transaction');
end;

procedure TPressDAO.InternalDispose(
  AClass: TPressObjectClass; const AId: string);
begin
  raise UnsupportedFeatureError('Dispose object');
end;

function TPressDAO.InternalExecuteStatement(
  const AStatement: string; AParams: TPressParamList): Integer;
begin
  raise UnsupportedFeatureError('Execute statement');
end;

function TPressDAO.InternalGenerateOID(AClass: TPressObjectClass;
  const AAttributeName: string): string;
begin
  raise UnsupportedFeatureError('Generator');
end;

function TPressDAO.InternalImplementsBulkRetrieve: Boolean;
begin
  Result := False;
end;

function TPressDAO.InternalImplementsLazyLoading: Boolean;
begin
  Result := False;
end;

procedure TPressDAO.InternalLoad(
  AObject: TPressObject; AIncludeLazyLoading, ALoadContainers: Boolean);
begin
  raise UnsupportedFeatureError('Load object');
end;

function TPressDAO.InternalOQLQuery(
  const AOQLStatement: string; AParams: TPressParamList): TPressProxyList;
begin
  raise UnsupportedFeatureError('OQL Query');
end;

procedure TPressDAO.InternalRefresh(AObject: TPressObject);
begin
  raise UnsupportedFeatureError('Refresh object');
end;

function TPressDAO.InternalRetrieve(
  AClass: TPressObjectClass; const AId: string;
  AMetadata: TPressObjectMetadata; AAttributes: TPressDAOAttributes): TPressObject;
begin
  raise UnsupportedFeatureError('Retrieve object');
end;

procedure TPressDAO.InternalRetrieveAttribute(AAttribute: TPressAttribute);
begin
  raise UnsupportedFeatureError('Retrieve attribute');
end;

function TPressDAO.InternalRetrieveQuery(
  AQuery: TPressQuery): TPressProxyList;

  function SelectPart: string;
  begin
    Result := 'select ' + AQuery.FieldNamesClause;
  end;

  function FromPart: string;
  begin
    Result := AQuery.FromClause;
    if Result <> '' then
      if (AQuery.Style = qsOQL) and AQuery.Metadata.IncludeSubClasses then
        Result := ' from any ' + Result
      else
        Result := ' from ' + Result;
  end;

  function WherePart: string;
  begin
    Result := AQuery.WhereClause;
    if Result <> '' then
      Result := ' where ' + Result;
  end;

  function GroupByPart: string;
  begin
    Result := AQuery.GroupByClause;
    if Result <> '' then
      Result := ' group by ' + Result;
  end;

  function OrderByPart: string;
  begin
    Result := AQuery.OrderByClause;
    if Result <> '' then
      Result := ' order by ' + Result;
  end;

var
  VQueryStr: string;
begin
  VQueryStr := SelectPart + FromPart + WherePart + GroupByPart + OrderByPart;
  {$ifdef PressLogDAOPersistence}PressLogMsg(Self, 'Querying "' +  VQueryStr + '"');{$endif}
  case AQuery.Style of
    qsOQL:
      Result := OQLQuery(VQueryStr, AQuery.Params);
    qsReference:
      Result := SQLProxy(VQueryStr, AQuery.Params);
    else {qsCustom}
      Result := SQLQuery(
       AQuery.Metadata.ItemObjectClass, VQueryStr, AQuery.Params);
  end;
end;

procedure TPressDAO.InternalRollback;
begin
  raise UnsupportedFeatureError('Rollback transaction');
end;

class function TPressDAO.InternalServiceType: TPressServiceType;
begin
  Result := CPressDAOService;
end;

procedure TPressDAO.InternalShowConnectionManager;
begin
end;

function TPressDAO.InternalSQLProxy(
  const ASQLStatement: string; AParams: TPressParamList): TPressProxyList;
begin
  raise UnsupportedFeatureError('SQL Proxy');
end;

function TPressDAO.InternalSQLQuery(AClass: TPressObjectClass;
  const ASQLStatement: string; AParams: TPressParamList): TPressProxyList;
begin
  raise UnsupportedFeatureError('SQL Query');
end;

procedure TPressDAO.InternalStartTransaction;
begin
  raise UnsupportedFeatureError('Start transaction');
end;

procedure TPressDAO.InternalStore(AObject: TPressObject);
begin
  raise UnsupportedFeatureError('Store object');
end;

procedure TPressDAO.Load(AObject: TPressObject;
  AIncludeLazyLoading, ALoadContainers: Boolean);
begin
  if not InternalImplementsLazyLoading then
    Exit;
  StartTransaction;
  try
    AObject.DisableChanges;
    try
      InternalLoad(AObject, AIncludeLazyLoading, ALoadContainers);
    finally
      AObject.EnableChanges;
    end;
    Commit;
  except
    Rollback;
    raise;
  end;
end;

procedure TPressDAO.Notify(AEvent: TPressEvent);
begin
  if FTransactionLevel = 1 then
  begin
    FTransactionLevel := 0;
    InternalCommit;
  end;
end;

function TPressDAO.OQLQuery(
  const AOQLStatement: string; AParams: TPressParamList): TPressProxyList;
begin
  StartTransaction;
  try
    Result := InternalOQLQuery(AOQLStatement, AParams);
    Commit;
  except
    Rollback;
    raise;
  end;
end;

procedure TPressDAO.Refresh(AObject: TPressObject);
begin
  if not AObject.IsPersistent then
    Exit;
  StartTransaction;
  try
    AObject.DisableChanges;
    try
{$ifdef PressLogDAOInterface}
      PressLogMsg(Self, 'Refresh', [AObject]);
{$endif}
      TPressObjectFriend(AObject).InternalRefresh(
       {$ifdef FPC}@{$endif}InternalRefresh);
    finally
      AObject.EnableChanges;
    end;
    AObject.Unchanged;
    Commit;
  except
    Rollback;
    raise;
  end;
end;

procedure TPressDAO.ReleaseObject(AObject: TPressObject);
begin
  Cache.RemoveObject(AObject);
end;

function TPressDAO.Retrieve(
  AClass: TPressObjectClass; const AId: string;
  AMetadata: TPressObjectMetadata; const AAttributes: string): TPressObject;
var
  VAttributes: TPressDAOAttributes;
begin
  Result := Cache.FindObject(AClass, AId);
  if Assigned(Result) then
    Result.AddRef
  else
  begin
    StartTransaction;
    try
      {$ifdef PressLogDAOInterface}PressLogMsg(Self,
       Format('Retrieving %s(%s)', [AClass.ClassName, AId]));{$endif}
      { TODO : Ensure the class type of the retrieved object }
      VAttributes := TPressDAOAttributes.Create(AAttributes);
      try
        Result := InternalRetrieve(AClass, AId, AMetadata, VAttributes);
      finally
        VAttributes.Free;
      end;
      Commit;
    except
      Rollback;
      raise;
    end;
    if Assigned(Result) then
      TPressObjectFriend(Result).AfterRetrieve;
  end;
end;

procedure TPressDAO.RetrieveAttribute(AAttribute: TPressAttribute);
begin
  if not InternalImplementsLazyLoading then
    Exit;
  StartTransaction;
  try
    AAttribute.DisableChanges;
    try
      InternalRetrieveAttribute(AAttribute);
    finally
      AAttribute.EnableChanges;
    end;
    Commit;
  except
    Rollback;
    raise;
  end;
end;

function TPressDAO.RetrieveQuery(AQuery: TPressQuery): TPressProxyList;
begin
  StartTransaction;
  try
    Result := InternalRetrieveQuery(AQuery);
    Commit;
  except
    Rollback;
    raise;
  end;
end;

procedure TPressDAO.Rollback;
begin
  if FTransactionLevel < 1 then
    Exit;
  Dec(FTransactionLevel);
  if FTransactionLevel = 0 then
    InternalRollback;
end;

procedure TPressDAO.ShowConnectionManager;
begin
  InternalShowConnectionManager;
end;

function TPressDAO.SQLProxy(
  const ASQLStatement: string; AParams: TPressParamList): TPressProxyList;
begin
  StartTransaction;
  try
    Result := InternalSQLProxy(ASQLStatement, AParams);
    Commit;
  except
    Rollback;
    raise;
  end;
end;

function TPressDAO.SQLQuery(AClass: TPressObjectClass;
  const ASQLStatement: string; AParams: TPressParamList): TPressProxyList;
begin
  StartTransaction;
  try
    Result := InternalSQLQuery(AClass, ASQLStatement, AParams);
    Commit;
  except
    Rollback;
    raise;
  end;
end;

procedure TPressDAO.StartTransaction;
begin
  if FTransactionLevel > 0 then
    Inc(FTransactionLevel)
  else
  begin
    FTransactionLevel := 1;
    InternalStartTransaction;
  end;
end;

procedure TPressDAO.Store(AObject: TPressObject);
begin
  if Assigned(AObject) and not AObject.IsOwned and not AObject.IsUpdated then
  begin
    AObject.Lock;
    try
      TPressObjectFriend(AObject).BeforeStore;
      StartTransaction;
      try
        AObject.DisableChanges;
        try
{$ifdef PressLogDAOInterface}
          PressLogMsg(Self, 'Storing', [AObject]);
{$endif}
          TPressObjectFriend(AObject).InternalStore(
           {$ifdef FPC}@{$endif}InternalStore);
          PressAssignPersistentId(AObject, AObject.Id);
        finally
          AObject.EnableChanges;
        end;
        AObject.Unchanged;
        Commit;
      except
        Rollback;
        raise;
      end;
      TPressObjectFriend(AObject).AfterStore;
    finally
      AObject.Unlock;
    end;
  end;
end;

procedure TPressDAO.SynchronizeProxy(AProxy: TPressProxy);
var
  VObject: TPressObject;
begin
  if not AProxy.HasInstance and AProxy.HasReference then
  begin
    VObject := Cache.FindObject(AProxy.ObjectClassType, AProxy.ObjectId);
    if Assigned(VObject) then
    begin
      { TODO : Lock between assignment and AddRef call }
      AProxy.Instance := VObject;
      if AProxy.ProxyType = ptOwned then
        VObject.AddRef;
    end;
  end;
end;

function TPressDAO.UnsupportedFeatureError(
  const AFeatureName: string): EPressError;
begin
  Result := EPressError.CreateFmt(SUnsupportedFeature, [AFeatureName]);
end;

{ TPressOIDGenerator }

function TPressOIDGenerator.GenerateOID(
  Sender: TPressPersistence; AObjectClass: TPressObjectClass;
  const AAttributeName: string): string;
begin
  Result := InternalGenerateOID(Sender, AObjectClass, AAttributeName);
end;

function TPressOIDGenerator.InternalGenerateOID(
  Sender: TPressPersistence; AObjectClass: TPressObjectClass;
  const AAttributeName: string): string;
var
  VId: array[0..15] of Byte;
  I: Integer;
begin
  PressGenerateGUID(TGUID(VId));
  SetLength(Result, 32);
  for I := 0 to 15 do
    Move(IntToHex(VId[I], 2)[1], Result[2*I+1], 2);
end;

procedure TPressOIDGenerator.InternalReleaseOID(Sender: TPressPersistence;
  AObjectClass: TPressObjectClass; const AAttributeName, AOID: string);
begin
end;

class function TPressOIDGenerator.InternalServiceType: TPressServiceType;
begin
  Result := CPressOIDGeneratorService;
end;

procedure TPressOIDGenerator.ReleaseOID(Sender: TPressPersistence;
  AObjectClass: TPressObjectClass; const AAttributeName, AOID: string);
begin
  InternalReleaseOID(Sender, AObjectClass, AAttributeName, AOID);
end;

{ TPressPersistence }

function TPressPersistence.DBMSName: string;
begin
  Result := InternalDBMSName;
end;

procedure TPressPersistence.Finit;
begin
  FOIDGenerator.Free;
  inherited;
end;

function TPressPersistence.GetOIDGenerator: TPressOIDGenerator;
begin
  if not Assigned(FOIDGenerator) then
  begin
    FOIDGenerator := InternalOIDGeneratorClass.Create;
    FOIDGenerator.AddRef;
  end;
  Result := FOIDGenerator;
end;

function TPressPersistence.InternalDBMSName: string;
begin
  raise UnsupportedFeatureError('DBMS name');
end;

function TPressPersistence.InternalGenerateOID(AClass: TPressObjectClass;
  const AAttributeName: string): string;
begin
  Result := OIDGenerator.GenerateOID(Self, AClass, AAttributeName);
end;

function TPressPersistence.InternalOIDGeneratorClass: TPressOIDGeneratorClass;
begin
  Result := TPressOIDGeneratorClass(
   PressApp.DefaultServiceClass(CPressOIDGeneratorService));
end;

{ TPressPersistentObjectLink }

constructor TPressPersistentObjectLink.Create(
  APressObject: TPressObject; APersistentObject: TObject);
begin
  inherited Create;
  FPressObject := APressObject;
  FPersistentObject := APersistentObject;
end;

destructor TPressPersistentObjectLink.Destroy;
begin
  FPersistentObject.Free;
  inherited;
end;

procedure TPressPersistentObjectLink.SetPersistentObject(AValue: TObject);
begin
  FPersistentObject.Free;
  FPersistentObject := AValue;
end;

{ TPressThirdPartyPersistenceCache }

function TPressThirdPartyPersistenceCache.AddLink(
  APressObject: TPressObject; APersistentObject: TObject): Integer;
begin
  Result := PersistentObjectLinkList.Add(
   TPressPersistentObjectLink.Create(APressObject, APersistentObject));
end;

constructor TPressThirdPartyPersistenceCache.Create;
begin
  inherited Create;
  FPersistentObjectLinkList := TObjectList.Create(True);
end;

destructor TPressThirdPartyPersistenceCache.Destroy;
begin
  FPersistentObjectLinkList.Free;
  inherited;
end;

function TPressThirdPartyPersistenceCache.GetPersistentObjectLink(
  AIndex: Integer): TPressPersistentObjectLink;
begin
  Result := PersistentObjectLinkList[AIndex] as TPressPersistentObjectLink;
end;

function TPressThirdPartyPersistenceCache.IndexOfLink(
  APressObject: TPressObject): Integer;
begin
  for Result := 0 to Pred(PersistentObjectLinkList.Count) do
    if PersistentObjectLink[Result].PressObject = APressObject then
      Exit;
  Result := -1;
end;

procedure TPressThirdPartyPersistenceCache.ReleaseObjects;
begin
  inherited;
  PersistentObjectLinkList.Clear;
end;

function TPressThirdPartyPersistenceCache.RemoveObject(
  AObject: TPressObject): Integer;
var
  VIndex: Integer;
begin
  Result := inherited RemoveObject(AObject);
  VIndex := IndexOfLink(AObject);
  if VIndex >= 0 then
    PersistentObjectLinkList.Delete(VIndex);
end;

{ TPressThirdPartyPersistence }

function TPressThirdPartyPersistence.GetCache: TPressThirdPartyPersistenceCache;
begin
  Result := inherited Cache as TPressThirdPartyPersistenceCache;
end;

function TPressThirdPartyPersistence.GetPersistentObject(
  APressObject: TPressObject): TObject;
var
  VIndex: Integer;
begin
  VIndex := Cache.IndexOfLink(APressObject);
  if VIndex >= 0 then
    Result := Cache.PersistentObjectLink[VIndex].PersistentObject
  else
    Result := nil;
end;

function TPressThirdPartyPersistence.InternalCacheClass: TPressDAOCacheClass;
begin
  Result := TPressThirdPartyPersistenceCache;
end;

procedure TPressThirdPartyPersistence.SetPersistentObject(
  APressObject: TPressObject; AValue: TObject);
var
  VIndex: Integer;
begin
  VIndex := Cache.IndexOfLink(APressObject);
  if VIndex >= 0 then
    Cache.PersistentObjectLink[VIndex].PersistentObject := AValue
  else
    Cache.AddLink(APressObject, AValue);
end;

initialization
  PressApp.Registry[CPressOIDGeneratorService].ServiceTypeName :=
   SPressOIDGeneratorServiceName;
  TPressOIDGenerator.RegisterService;

finalization
  TPressOIDGenerator.UnregisterService;

end.