(*
  PressObjects, MVP-Model Classes
  Copyright (C) 2006-2007 Laserpress Ltda.

  http://www.pressobjects.org

  See the file LICENSE.txt, included in this distribution,
  for details about the copyright.

  This library is distributed in the hope that it will be useful,
  but WITHOUT ANY WARRANTY; without even the implied warranty of
  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
*)

unit PressMVPModel;

{$I Press.inc}

interface

uses
  Classes,
  {$IFDEF D6+}Variants,{$ENDIF}
  PressClasses,
  PressNotifier,
  PressSubject,
  PressAttributes,
  PressMVP,
  PressUser;

type
  { MVP-Model events }

  TPressMVPModelCreateFormEvent = class(TPressMVPModelEvent)
  end;

  TPressMVPModelCreateIncludeFormEvent = class(TPressMVPModelCreateFormEvent)
  end;

  TPressMVPModelCreatePresentFormEvent = class(TPressMVPModelCreateFormEvent)
  end;

  TPressMVPModelCreateSearchFormEvent = class(TPressMVPModelCreateFormEvent)
  end;

  TPressMVPObjectModelChangedEvent = class(TPressMVPModelEvent)
  private
    FChangeType: TPressMVPChangeType;
  public
    constructor Create(AOwner: TObject; AChangeType: TPressMVPChangeType);
    property ChangeType: TPressMVPChangeType read FChangeType;
  end;

  TPressMVPModelCloseFormEvent = class(TPressMVPModelEvent)
  end;

  { Base Attribute Models }

  TPressMVPAttributeModel = class(TPressMVPModel)
  private
    function GetIsSelected: Boolean;
    function GetSubject: TPressAttribute;
  protected
    function GetAsString: string; virtual;
  public
    property AsString: string read GetAsString;
    property IsSelected: Boolean read GetIsSelected;
    property Subject: TPressAttribute read GetSubject;
  end;

  { Base Value Models }

  TPressMVPValueModel = class(TPressMVPAttributeModel)
  private
    function GetSubject: TPressValue;
  public
    class function Apply(ASubject: TPressSubject): Boolean; override;
    property Subject: TPressValue read GetSubject;
  end;

  { Value Models }

  TPressMVPEnumValueItem = class(TObject)
  private
    FEnumName: string;
    FEnumValue: Integer;
  public
    constructor Create;
    property EnumName: string read FEnumName write FEnumName;
    property EnumValue: Integer read FEnumValue write FEnumValue;
  end;

  TPressMVPEnumValueIterator = class;

  TPressMVPEnumValueList = class(TPressList)
  private
    function GetItems(AIndex: Integer): TPressMVPEnumValueItem;
    procedure SetItems(AIndex: Integer; const Value: TPressMVPEnumValueItem);
  protected
    function InternalCreateIterator: TPressCustomIterator; override;
  public
    function Add(AObject: TPressMVPEnumValueItem): Integer;
    function CreateIterator: TPressMVPEnumValueIterator;
    function Extract(AObject: TPressMVPEnumValueItem): TPressMVPEnumValueItem;
    function First: TPressMVPEnumValueItem;
    function IndexOf(AObject: TPressMVPEnumValueItem): Integer;
    procedure Insert(AIndex: Integer; AObject: TPressMVPEnumValueItem);
    function Last: TPressMVPEnumValueItem;
    function Remove(AObject: TPressMVPEnumValueItem): Integer;
    property Items[AIndex: Integer]: TPressMVPEnumValueItem read GetItems write SetItems; default;
  end;

  TPressMVPEnumValueIterator = class(TPressIterator)
  private
    function GetCurrentItem: TPressMVPEnumValueItem;
  public
    property CurrentItem: TPressMVPEnumValueItem read GetCurrentItem;
  end;

  TPressMVPEnumModel = class(TPressMVPValueModel)
  private
    FEnumValues: TPressMVPEnumValueList;
  public
    destructor Destroy; override;
    class function Apply(ASubject: TPressSubject): Boolean; override;
    function CreateEnumValueIterator(AEnumQuery: string): TPressMVPEnumValueIterator;
    function EnumOf(AIndex: Integer): Integer;
    function EnumValueCount: Integer;
  end;

  TPressMVPDateModel = class(TPressMVPValueModel)
  protected
    procedure InitCommands; override;
  public
    class function Apply(ASubject: TPressSubject): Boolean; override;
  end;

  TPressMVPPictureModel = class(TPressMVPValueModel)
  protected
    procedure InitCommands; override;
  public
    class function Apply(ASubject: TPressSubject): Boolean; override;
  end;

  { Base Structure Models }

  TPressMVPObjectSelection = class(TPressMVPSelection)
  private
    function GetFocus: TPressObject;
    function GetObjects(Index: Integer): TPressObject;
    procedure SetFocus(Value: TPressObject);
  protected
    procedure InternalAssignObject(AObject: TObject); override;
    function InternalCreateIterator: TPressIterator; override;
    function InternalOwnsObjects: Boolean; override;
  public
    function Add(AObject: TPressObject): Integer;
    function CreateIterator: TPressObjectIterator;
    function HasStrongSelection(AObject: TPressObject): Boolean;
    function IndexOf(AObject: TPressObject): Integer;
    function Remove(AObject: TPressObject): Integer;
    procedure Select(AObject: TPressObject);
    property Focus: TPressObject read GetFocus write SetFocus;
    property Objects[Index: Integer]: TPressObject read GetObjects; default;
  end;

  TPressMVPColumnData = class;

  TPressMVPColumnItem = class(TPressStreamable)
  { TODO : Collection item }
  private
    FAttributeName: string;
    FAttributeAlignment: TAlignment;
    FHeaderAlignment: TAlignment;
    FHeaderCaption: string;
    FOwner: TPressMVPColumnData;
    FWidth: Integer;
    procedure InitColumnItem(const AAttributeName: string);
    procedure SetAttributeName(const Value: string);
    procedure SetWidth(Value: Integer);
  public
    constructor Create(AOwner: TPressMVPColumnData; const AAttributeName: string);
    procedure ReadColumnItem(const AColumnItem: string);
  published
    property AttributeName: string read FAttributeName write SetAttributeName;
    property AttributeAlignment: TAlignment read FAttributeAlignment write FAttributeAlignment;
    property HeaderAlignment: TAlignment read FHeaderAlignment write FHeaderAlignment;
    property HeaderCaption: string read FHeaderCaption write FHeaderCaption;
    property Width: Integer read FWidth write SetWidth;
  end;

  TPressMVPColumnIterator = class;

  TPressMVPColumnList = class(TPressList)
  private
    function GetItems(AIndex: Integer): TPressMVPColumnItem;
    procedure SetItems(AIndex: Integer; Value: TPressMVPColumnItem);
  protected
    function InternalCreateIterator: TPressCustomIterator; override;
  public
    function Add(AObject: TPressMVPColumnItem): Integer;
    function CreateIterator: TPressMVPColumnIterator;
    function Extract(AObject: TPressMVPColumnItem): TPressMVPColumnItem;
    function First: TPressMVPColumnItem;
    function IndexOf(AObject: TPressMVPColumnItem): Integer;
    procedure Insert(AIndex: Integer; AObject: TPressMVPColumnItem);
    function Last: TPressMVPColumnItem;
    function Remove(AObject: TPressMVPColumnItem): Integer;
    property Items[AIndex: Integer]: TPressMVPColumnItem read GetItems write SetItems; default;
  end;

  TPressMVPColumnIterator = class(TPressIterator)
  private
    function GetCurrentItem: TPressMVPColumnItem;
  public
    property CurrentItem: TPressMVPColumnItem read GetCurrentItem;
  end;

  TPressMVPColumnData = class(TObject)
  { TODO : Collection }
  private
    FColumnList: TPressMVPColumnList;
    FMap: TPressClassMap;
    function GetColumnList: TPressMVPColumnList;
    function GetColumns(AIndex: Integer): TPressMVPColumnItem;
  protected
    property ColumnList: TPressMVPColumnList read GetColumnList;
  public
    constructor Create(AMap: TPressClassMap);
    destructor Destroy; override;
    function AddColumn(const AAttributeName: string): TPressMVPColumnItem;
    function ColumnCount: Integer;
    property Columns[AIndex: Integer]: TPressMVPColumnItem read GetColumns; default;
    property Map: TPressClassMap read FMap;
  end;

  TPressMVPStructureModel = class(TPressMVPAttributeModel)
  private
    FColumnData: TPressMVPColumnData;
    function GetColumnData: TPressMVPColumnData;
    function GetSelection: TPressMVPObjectSelection;
    function GetSubject: TPressStructure;
  protected
    procedure AssignColumnData(const AColumnData: string);
    procedure InternalAssignDisplayNames(const ADisplayNames: string); virtual; abstract;
    function InternalCreateSelection: TPressMVPSelection; override;
  public
    destructor Destroy; override;
    procedure AssignDisplayNames(const ADisplayNames: string);
    property ColumnData: TPressMVPColumnData read GetColumnData;
    property Selection: TPressMVPObjectSelection read GetSelection;
    property Subject: TPressStructure read GetSubject;
  end;

  { Reference Model }

  TPressMVPReferenceQuery = class(TPressQuery)
  private
    FName: TPressString;
    function GetName: string;
    procedure SetName(const Value: string);
  protected
    function InternalAttributeAddress(const AAttributeName: string): PPressAttribute; override;
    class function InternalMetadataStr: string; override;
  public
    property _Name: TPressString read FName;
  published
    property Name: string read GetName write SetName;
  end;

  TPressMVPReferenceModel = class(TPressMVPStructureModel)
  private
    FMetadata: TPressQueryMetadata;
    FQuery: TPressMVPReferenceQuery;
    FReferencedAttribute: string;
    function GetMetadata: TPressQueryMetadata;
    function GetQuery: TPressMVPReferenceQuery;
    function GetSubject: TPressReference;
    function GetObjectClass: TPressObjectClass;
  protected
    function CreateReferenceQuery: TPressMVPReferenceQuery; virtual;
    function GetAsString: string; override;
    procedure InitCommands; override;
    procedure InternalAssignDisplayNames(const ADisplayNames: string); override;
    function InternalObjectAsString(AObject: TPressObject; ACol: Integer): string; virtual;
    function InternalObjectClass: TPressObjectClass; virtual;
    procedure InternalUpdateQueryMetadata(const AQueryString: string); virtual;
    procedure Notify(AEvent: TPressEvent); override;
    property Metadata: TPressQueryMetadata read GetMetadata;
  public
    constructor Create(AParent: TPressMVPModel; ASubject: TPressSubject); override;
    destructor Destroy; override;
    class function Apply(ASubject: TPressSubject): Boolean; override;
    function CreateQueryIterator(const AQueryString: string): TPressQueryIterator;
    function DisplayText(ACol, ARow: Integer): string;
    function ObjectOf(AIndex: Integer): TPressObject;
    function ReferencedValue(AObject: TPressObject): TPressValue;
    function TextAlignment(ACol: Integer): TAlignment;
    property ObjectClass: TPressObjectClass read GetObjectClass;
    property Query: TPressMVPReferenceQuery read GetQuery;
    property Subject: TPressReference read GetSubject;
  end;

  { Items Model }

  TPressMVPObjectList = class;

  TPressMVPObjectItem = class(TObject)
  private
    FAttributes: TPressAttributeList;
    FItemNumber: Integer;
    FOwner: TPressMVPObjectList;
    FProxy: TPressProxy;
    function GetAttributes: TPressAttributeList;
    function GetDisplayText(ACol: Integer): string;
    function GetInstance: TPressObject;
  protected
    property Attributes: TPressAttributeList read GetAttributes;
  public
    constructor Create(AOwner: TPressMVPObjectList; AProxy: TPressProxy; AItemNumber: Integer);
    destructor Destroy; override;
    function AddAttribute(AAttribute: TPressAttribute): Integer;
    procedure ClearAttributes;
    function HasAttributes: Boolean;
    property DisplayText[ACol: Integer]: string read GetDisplayText;
    property Instance: TPressObject read GetInstance;
    property ItemNumber: Integer read FItemNumber;
    property Proxy: TPressProxy read FProxy;
  end;

  TPressMVPObjectIterator = class;

  TPressMVPObjectList = class(TPressList)
  private
    FColumnData: TPressMVPColumnData;
    procedure CreateAttributes(AObjectItem: TPressMVPObjectItem);
    function CreateObjectItem(AProxy: TPressProxy): TPressMVPObjectItem;
    function GetItems(AIndex: Integer): TPressMVPObjectItem;
    procedure SetItems(AIndex: Integer; Value: TPressMVPObjectItem);
  protected
    function InternalCreateIterator: TPressCustomIterator; override;
  public
    constructor Create(AColumnData: TPressMVPColumnData);
    function Add(AObject: TPressMVPObjectItem): Integer;
    function AddProxy(AProxy: TPressProxy): Integer;
    function CreateIterator: TPressMVPObjectIterator;
    function Extract(AObject: TPressMVPObjectItem): TPressMVPObjectItem;
    function IndexOf(AObject: TPressMVPObjectItem): Integer;
    function IndexOfInstance(AObject: TPressObject): Integer;
    function IndexOfProxy(AProxy: TPressProxy): Integer;
    procedure Insert(Index: Integer; AObject: TPressMVPObjectItem);
    procedure InsertProxy(Index: Integer; AProxy: TPressProxy);
    procedure Reindex(AColumn: Integer);
    function Remove(AObject: TPressMVPObjectItem): Integer;
    function RemoveProxy(AProxy: TPressProxy): Integer;
    property Items[AIndex: Integer]: TPressMVPObjectItem read GetItems write SetItems; default;
  end;

  TPressMVPObjectIterator = class(TPressIterator)
  private
    function GetCurrentItem: TPressMVPObjectItem;
  public
    property CurrentItem: TPressMVPObjectItem read GetCurrentItem;
  end;

  TPressMVPItemsModel = class(TPressMVPStructureModel)
  private
    FObjectList: TPressMVPObjectList;
    function GetObjectList: TPressMVPObjectList;
    function GetObjects(AIndex: Integer): TPressObject;
    function GetSubject: TPressItems;
    procedure ItemsChanged(AEvent: TPressItemsChangedEvent);
    procedure RebuildObjectList;
  protected
    procedure InitCommands; override;
    procedure InternalAssignDisplayNames(const ADisplayNames: string); override;
    procedure InternalCreateAddCommands; virtual;
    procedure InternalCreateEditCommands; virtual;
    procedure InternalCreateRemoveCommands; virtual;
    procedure InternalCreateSelectionCommands; virtual;
    procedure InternalCreateSortCommands; virtual;
    procedure Notify(AEvent: TPressEvent); override;
    property ObjectList: TPressMVPObjectList read GetObjectList;
  public
    constructor Create(AParent: TPressMVPModel; ASubject: TPressSubject); override;
    destructor Destroy; override;
    function Count: Integer;
    function DisplayText(ACol, ARow: Integer): string;
    function IndexOf(AObject: TPressObject): Integer;
    function ItemNumber(ARow: Integer): Integer;
    procedure Reindex(AColumn: Integer);
    function TextAlignment(ACol: Integer): TAlignment;
    property Objects[AIndex: Integer]: TPressObject read GetObjects; default;
    property Subject: TPressItems read GetSubject;
  end;

  TPressMVPPartsModel = class(TPressMVPItemsModel)
  public
    class function Apply(ASubject: TPressSubject): Boolean; override;
  end;

  TPressMVPReferencesModel = class(TPressMVPItemsModel)
  protected
    procedure InternalCreateAddCommands; override;
  public
    class function Apply(ASubject: TPressSubject): Boolean; override;
  end;

  { Object Model }

  TPressMVPModelSelection = class(TPressMVPSelection)
  end;

  TPressMVPObjectModelClass = class of TPressMVPObjectModel;

  TPressMVPObjectModel = class(TPressMVPModel)
  private
    FHookedSubject: TPressStructure;
    FIsIncluding: Boolean;
    FObjectMemento: TPressObjectMemento;
    procedure AfterChangeHookedSubject;
    procedure BeforeChangeHookedSubject;
    function GetIsChanged: Boolean;
    function GetSelection: TPressMVPModelSelection;
    function GetSubject: TPressObject;
    procedure SetHookedSubject(Value: TPressStructure);
  protected
    procedure InitCommands; override;
    procedure InternalChanged(AChangeType: TPressMVPChangeType); override;
    procedure InternalCreateCancelCommand; virtual;
    procedure InternalCreateSaveCommand; virtual;
    function InternalCreateSelection: TPressMVPSelection; override;
    function InternalIsIncluding: Boolean; override;
    procedure Notify(AEvent: TPressEvent); override;
  public
    constructor Create(AParent: TPressMVPModel; ASubject: TPressSubject); override;
    destructor Destroy; override;
    class function Apply(ASubject: TPressSubject): Boolean; override;
    procedure RevertChanges;
    procedure UpdateData;
    property HookedSubject: TPressStructure read FHookedSubject write SetHookedSubject;
    property IsChanged: Boolean read GetIsChanged;
    property IsIncluding: Boolean read FIsIncluding write FIsIncluding;
    property Selection: TPressMVPModelSelection read GetSelection;
    property Subject: TPressObject read GetSubject;
  end;

  TPressMVPQueryModel = class(TPressMVPObjectModel)
  private
    function GetSubject: TPressQuery;
  protected
    procedure InitCommands; override;
  public
    class function Apply(ASubject: TPressSubject): Boolean; override;
    procedure Clear;
    procedure Execute;
    property Subject: TPressQuery read GetSubject;
  end;

implementation

uses
  SysUtils,
  Menus,
  PressConsts,
  PressDialogs,
  PressMetadata,
  PressMVPCommand;

{ TPressMVPObjectModelChangedEvent }

constructor TPressMVPObjectModelChangedEvent.Create(
  AOwner: TObject; AChangeType: TPressMVPChangeType);
begin
  inherited Create(AOwner);
  FChangeType := AChangeType;
end;

{ TPressMVPAttributeModel }

function TPressMVPAttributeModel.GetAsString: string;
begin
  if IsSelected then
    Result := Subject.AsString
  else
    Result := Subject.DisplayText;
end;

function TPressMVPAttributeModel.GetIsSelected: Boolean;
begin
  Result := Parent.Selection.IndexOf(Self) >= 0;
end;

function TPressMVPAttributeModel.GetSubject: TPressAttribute;
begin
  Result := inherited Subject as TPressAttribute;
end;

{ TPressMVPValueModel }

class function TPressMVPValueModel.Apply(ASubject: TPressSubject): Boolean;
begin
  Result := ASubject is TPressValue;
end;

function TPressMVPValueModel.GetSubject: TPressValue;
begin
  Result := inherited Subject as TPressValue;
end;

{ TPressMVPEnumValueItem }

constructor TPressMVPEnumValueItem.Create;
begin
  inherited Create;
end;

{ TPressMVPEnumValueList }

function TPressMVPEnumValueList.Add(
  AObject: TPressMVPEnumValueItem): Integer;
begin
  Result := inherited Add(AObject);
end;

function TPressMVPEnumValueList.CreateIterator: TPressMVPEnumValueIterator;
begin
  Result := TPressMVPEnumValueIterator.Create(Self);
end;

function TPressMVPEnumValueList.Extract(
  AObject: TPressMVPEnumValueItem): TPressMVPEnumValueItem;
begin
  Result := inherited Extract(AObject) as TPressMVPEnumValueItem;
end;

function TPressMVPEnumValueList.First: TPressMVPEnumValueItem;
begin
  Result := inherited First as TPressMVPEnumValueItem;
end;

function TPressMVPEnumValueList.GetItems(
  AIndex: Integer): TPressMVPEnumValueItem;
begin
  Result := inherited Items[AIndex] as TPressMVPEnumValueItem;
end;

function TPressMVPEnumValueList.IndexOf(
  AObject: TPressMVPEnumValueItem): Integer;
begin
  Result := inherited IndexOf(AObject);
end;

procedure TPressMVPEnumValueList.Insert(
  AIndex: Integer; AObject: TPressMVPEnumValueItem);
begin
  inherited Insert(AIndex, AObject);
end;

function TPressMVPEnumValueList.InternalCreateIterator: TPressCustomIterator;
begin
  Result := CreateIterator;
end;

function TPressMVPEnumValueList.Last: TPressMVPEnumValueItem;
begin
  Result := inherited Last as TPressMVPEnumValueItem;
end;

function TPressMVPEnumValueList.Remove(
  AObject: TPressMVPEnumValueItem): Integer;
begin
  Result := inherited Remove(AObject);
end;

procedure TPressMVPEnumValueList.SetItems(AIndex: Integer;
  const Value: TPressMVPEnumValueItem);
begin
  inherited Items[AIndex] := Value;
end;

{ TPressMVPEnumValueIterator }

function TPressMVPEnumValueIterator.GetCurrentItem: TPressMVPEnumValueItem;
begin
  Result := inherited CurrentItem as TPressMVPEnumValueItem;
end;

{ TPressMVPEnumModel }

class function TPressMVPEnumModel.Apply(ASubject: TPressSubject): Boolean;
begin
  Result := ASubject is TPressEnum;
end;

function TPressMVPEnumModel.CreateEnumValueIterator(
  AEnumQuery: string): TPressMVPEnumValueIterator;
var
  VEnumItems: TStrings;
  VEnumValueItem: TPressMVPEnumValueItem;
  I: Integer;
begin
  FEnumValues.Free;
  FEnumValues := TPressMVPEnumValueList.Create(True);
  VEnumItems := Subject.Metadata.EnumMetadata.Items;
  AEnumQuery := AnsiUpperCase(AEnumQuery);
  for I := 0 to Pred(VEnumItems.Count) do
    if (AEnumQuery = '') or
     (Pos(AEnumQuery, AnsiUpperCase(VEnumItems[I])) > 0) then
    begin
      VEnumValueItem := TPressMVPEnumValueItem.Create;
      FEnumValues.Add(VEnumValueItem);
      VEnumValueItem.EnumName := VEnumItems[I];
      VEnumValueItem.EnumValue := I;
    end;
  Result := FEnumValues.CreateIterator;
end;

destructor TPressMVPEnumModel.Destroy;
begin
  FEnumValues.Free;
  inherited;
end;

function TPressMVPEnumModel.EnumOf(AIndex: Integer): Integer;
begin
  if Assigned(FEnumValues) then
    Result := FEnumValues[AIndex].EnumValue
  else
    Result := -1;
end;

function TPressMVPEnumModel.EnumValueCount: Integer;
begin
  if Assigned(FEnumValues) then
    Result := FEnumValues.Count
  else
    Result := 0;
end;

{ TPressMVPDateModel }

class function TPressMVPDateModel.Apply(ASubject: TPressSubject): Boolean;
begin
  Result := (ASubject is TPressDate) or (ASubject is TPressDateTime);
end;

procedure TPressMVPDateModel.InitCommands;
begin
  inherited;
  AddCommand(TPressMVPTodayCommand);
end;

{ TPressMVPPictureModel }

class function TPressMVPPictureModel.Apply(ASubject: TPressSubject): Boolean;
begin
  Result := ASubject is TPressPicture;
end;

procedure TPressMVPPictureModel.InitCommands;
begin
  inherited;
  AddCommands([TPressMVPLoadPictureCommand, TPressMVPRemovePictureCommand]);
end;

{ TPressMVPReferenceQuery }

function TPressMVPReferenceQuery.GetName: string;
begin
  Result := FName.Value;
end;

function TPressMVPReferenceQuery.InternalAttributeAddress(
  const AAttributeName: string): PPressAttribute;
begin
  if SameText(AAttributeName, 'Name') then
    Result := Addr(FName)
  else
    Result := inherited InternalAttributeAddress(AAttributeName);
end;

class function TPressMVPReferenceQuery.InternalMetadataStr: string;
begin
  Result :=
   TPressMVPReferenceQuery.ClassName + ' (' + TPressObject.ClassName + ') (' +
   'Name: String MatchType=mtContains)';
end;

procedure TPressMVPReferenceQuery.SetName(const Value: string);
begin
  FName.Value := Value;
end;

{ TPressMVPObjectSelection }

function TPressMVPObjectSelection.Add(AObject: TPressObject): Integer;
begin
  Result := inherited Add(AObject);
end;

function TPressMVPObjectSelection.CreateIterator: TPressObjectIterator;
begin
  Result := TPressObjectIterator.Create(ObjectList);
end;

function TPressMVPObjectSelection.GetFocus: TPressObject;
begin
  Result := inherited Focus as TPressObject;
end;

function TPressMVPObjectSelection.GetObjects(Index: Integer): TPressObject;
begin
  Result := inherited Objects[Index] as TPressObject;
end;

function TPressMVPObjectSelection.HasStrongSelection(
  AObject: TPressObject): Boolean;
begin
  Result := inherited HasStrongSelection(AObject);
end;

function TPressMVPObjectSelection.IndexOf(AObject: TPressObject): Integer;
begin
  Result := inherited IndexOf(AObject);
end;

procedure TPressMVPObjectSelection.InternalAssignObject(AObject: TObject);
begin
  if AObject is TPressObject then
    TPressObject(AObject).AddRef;
end;

function TPressMVPObjectSelection.InternalCreateIterator: TPressIterator;
begin
  Result := CreateIterator;
end;

function TPressMVPObjectSelection.InternalOwnsObjects: Boolean;
begin
  Result := True;
end;

function TPressMVPObjectSelection.Remove(AObject: TPressObject): Integer;
begin
  Result := inherited Remove(AObject);
end;

procedure TPressMVPObjectSelection.Select(AObject: TPressObject);
begin
  inherited Select(AObject);
end;

procedure TPressMVPObjectSelection.SetFocus(Value: TPressObject);
begin
  inherited Focus := Value;
end;

{ TPressMVPColumnItem }

constructor TPressMVPColumnItem.Create(
  AOwner: TPressMVPColumnData; const AAttributeName: string);
begin
  inherited Create;
  FOwner := AOwner;
  InitColumnItem(AAttributeName);
end;

procedure TPressMVPColumnItem.InitColumnItem(const AAttributeName: string);
var
  VMetadata: TPressAttributeMetadata;
  VPos: Integer;
begin
  AttributeName := AAttributeName;
  VPos := Length(AAttributeName);
  while (VPos > 0) and (AAttributeName[VPos] <> SPressAttributeSeparator) do
    Dec(VPos);
  if VPos > 0 then
    FHeaderCaption := Copy(AAttributeName, 1, VPos - 1)
  else
    FHeaderCaption := AAttributeName;
  VMetadata := FOwner.Map.MetadataByPath(AAttributeName);
  if VMetadata.AttributeClass.InheritsFrom(TPressBoolean) then
    FAttributeAlignment := taCenter
  else if VMetadata.AttributeClass.InheritsFrom(TPressNumeric) then
    FAttributeAlignment := taRightJustify
  else
    FAttributeAlignment := taLeftJustify;
  Width := 8 * VMetadata.Size;
  FHeaderAlignment := taCenter;
end;

procedure TPressMVPColumnItem.ReadColumnItem(const AColumnItem: string);
var
  VToken: string;
  VPToken: PChar;
  VPos: Integer;
begin
  if AColumnItem = '' then
    Exit;
  VPos := Pos(',', AColumnItem);
  if VPos > 0 then
    VToken := Copy(AColumnItem, 1, VPos - 1)
  else
    VToken := AColumnItem;
  try
    if VToken <> '' then
      FWidth := StrToInt(VToken);
  except
    on E: Exception do
      if not (E is EConvertError) then
        raise;
  end;
  if VPos > 0 then
  begin
    VToken := Trim(Copy(AColumnItem, VPos + 1, Length(AColumnItem) - VPos));
    VPToken := PChar(VToken);
    if (VToken[1] in ['''', '"']) and (VToken[1] = VToken[Length(VToken)]) then
      VToken := AnsiExtractQuotedStr(VPToken, VToken[1]);
  end else
    VToken := '';
  if VToken <> '' then
    FHeaderCaption := VToken;
  { TODO : Implement alignments }
end;

procedure TPressMVPColumnItem.SetAttributeName(const Value: string);
var
  VMetadata: TPressAttributeMetadata;
begin
  VMetadata := FOwner.Map.FindMetadata(Value);
  if not Assigned(VMetadata) then
    raise EPressMVPError.CreateFmt(SAttributeNotFound,
     [FOwner.Map.ObjectMetadata.ObjectClassName, Value]);
  if not VMetadata.AttributeClass.InheritsFrom(TPressValue) then
    raise EPressMVPError.CreateFmt(SAttributeIsNotValue,
     [FOwner.Map.ObjectMetadata.ObjectClassName, Value]);
  FAttributeName := Value;
end;

procedure TPressMVPColumnItem.SetWidth(Value: Integer);
begin
  if Value > 8 then
    FWidth := Value
  else
    FWidth := 8;
end;

{ TPressMVPColumnList }

function TPressMVPColumnList.Add(AObject: TPressMVPColumnItem): Integer;
begin
  Result := inherited Add(AObject);
end;

function TPressMVPColumnList.CreateIterator: TPressMVPColumnIterator;
begin
  Result := TPressMVPColumnIterator.Create(Self);
end;

function TPressMVPColumnList.Extract(
  AObject: TPressMVPColumnItem): TPressMVPColumnItem;
begin
  Result := inherited Extract(AObject) as TPressMVPColumnItem;
end;

function TPressMVPColumnList.First: TPressMVPColumnItem;
begin
  Result := inherited First as TPressMVPColumnItem;
end;

function TPressMVPColumnList.GetItems(AIndex: Integer): TPressMVPColumnItem;
begin
  Result := inherited Items[AIndex] as TPressMVPColumnItem;
end;

function TPressMVPColumnList.IndexOf(AObject: TPressMVPColumnItem): Integer;
begin
  Result := inherited IndexOf(AObject);
end;

procedure TPressMVPColumnList.Insert(
  AIndex: Integer; AObject: TPressMVPColumnItem);
begin
  inherited Insert(AIndex, AObject);
end;

function TPressMVPColumnList.InternalCreateIterator: TPressCustomIterator;
begin
  Result := CreateIterator;
end;

function TPressMVPColumnList.Last: TPressMVPColumnItem;
begin
 Result := inherited Last as TPressMVPColumnItem;
end;

function TPressMVPColumnList.Remove(AObject: TPressMVPColumnItem): Integer;
begin
  Result := inherited Remove(AObject);
end;

procedure TPressMVPColumnList.SetItems(
  AIndex: Integer; Value: TPressMVPColumnItem);
begin
  inherited Items[AIndex] := Value;
end;

{ TPressMVPColumnIterator }

function TPressMVPColumnIterator.GetCurrentItem: TPressMVPColumnItem;
begin
  Result := inherited CurrentItem as TPressMVPColumnItem;
end;

{ TPressMVPColumnData }

function TPressMVPColumnData.AddColumn(
  const AAttributeName: string): TPressMVPColumnItem;
begin
  Result := TPressMVPColumnItem.Create(Self, AAttributeName);
  ColumnList.Add(Result);
end;

function TPressMVPColumnData.ColumnCount: Integer;
begin
  if Assigned(FColumnList) then
    Result := FColumnList.Count
  else
    Result := 0;
end;

constructor TPressMVPColumnData.Create(AMap: TPressClassMap);
begin
  inherited Create;
  FMap := AMap;
end;

destructor TPressMVPColumnData.Destroy;
begin
  FColumnList.Free;
  inherited;
end;

function TPressMVPColumnData.GetColumnList: TPressMVPColumnList;
begin
  if not Assigned(FColumnList) then
    FColumnList := TPressMVPColumnList.Create(True);
  Result := FColumnList;
end;

function TPressMVPColumnData.GetColumns(AIndex: Integer): TPressMVPColumnItem;
begin
  Result := ColumnList[AIndex];
end;

{ TPressMVPStructureModel }

procedure TPressMVPStructureModel.AssignColumnData(const AColumnData: string);
var
  VLastDelimiter, VDelimiterPos, VBracket1Pos, VBracket2Pos: Integer;
  VColumnItemStr: string;
begin
  if AColumnData = '' then
    Exit;
  VLastDelimiter := 0;
  VDelimiterPos := 0;
  repeat
    Inc(VDelimiterPos);
    while (VDelimiterPos <= Length(AColumnData)) and
     (AColumnData[VDelimiterPos] <> SPressFieldDelimiter) do
      Inc(VDelimiterPos);
    VColumnItemStr :=
     Copy(AColumnData, VLastDelimiter + 1, VDelimiterPos - VLastDelimiter - 1);
    VBracket1Pos := Pos(SPressBrackets[1], VColumnItemStr);
    VBracket2Pos := Pos(SPressBrackets[2], VColumnItemStr);
    if VBracket1Pos > VBracket2Pos then
      raise EPressMVPError.CreateFmt(SColumnDataParseError,
       [Subject.ClassName, Subject.Name, AColumnData]);
    if VBracket1Pos > 0 then
      ColumnData.
       AddColumn(Copy(VColumnItemStr, 1, VBracket1Pos - 1)).ReadColumnItem(
       Copy(VColumnItemStr, VBracket1Pos + 1, VBracket2Pos - VBracket1Pos - 1))
    else
      ColumnData.AddColumn(VColumnItemStr);
    VLastDelimiter := VDelimiterPos;
  until VDelimiterPos > Length(AColumnData);
end;

procedure TPressMVPStructureModel.AssignDisplayNames(
  const ADisplayNames: string);
begin
  if Assigned(FColumnData) and (FColumnData.ColumnCount > 0) then
    raise EPressMVPError.Create(SDisplayNamesAlreadyAssigned);
  InternalAssignDisplayNames(ADisplayNames);
end;

destructor TPressMVPStructureModel.Destroy;
begin
  FColumnData.Free;
  inherited;
end;

function TPressMVPStructureModel.GetColumnData: TPressMVPColumnData;
begin
  if not Assigned(FColumnData) then
    FColumnData := TPressMVPColumnData.Create(Subject.ObjectClass.ClassMap);
  Result := FColumnData;
end;

function TPressMVPStructureModel.GetSelection: TPressMVPObjectSelection;
begin
  Result := inherited Selection as TPressMVPObjectSelection;
end;

function TPressMVPStructureModel.GetSubject: TPressStructure;
begin
  Result := inherited Subject as TPressStructure;
end;

function TPressMVPStructureModel.InternalCreateSelection: TPressMVPSelection;
begin
  Result := TPressMVPObjectSelection.Create;
end;

{ TPressMVPReferenceModel }

class function TPressMVPReferenceModel.Apply(ASubject: TPressSubject): Boolean;
begin
  Result := ASubject is TPressReference;
end;

constructor TPressMVPReferenceModel.Create(
  AParent: TPressMVPModel; ASubject: TPressSubject);
begin
  inherited Create(AParent, ASubject);
  if HasSubject then
    Selection.Select(Subject.Value);
end;

function TPressMVPReferenceModel.CreateQueryIterator(
  const AQueryString: string): TPressQueryIterator;
begin
  InternalUpdateQueryMetadata(AQueryString);
  Query.UpdateReferenceList;
  if Query.Count > SPressMaxItemCount then
  begin
    PressDialog.DefaultDlg(
     Format(SMaxItemCountReached, [Query.Count, SPressMaxItemCount]));
    Query.Clear;
  end;
  Result := Query.CreateIterator;
end;

function TPressMVPReferenceModel.CreateReferenceQuery: TPressMVPReferenceQuery;
begin
  Result := TPressMVPReferenceQuery.Create(Subject.DataAccess, Metadata);
end;

destructor TPressMVPReferenceModel.Destroy;
begin
  FQuery.Free;
  PressModel.UnregisterMetadata(FMetadata);
  inherited;
end;

function TPressMVPReferenceModel.DisplayText(ACol, ARow: Integer): string;
begin
  Result := InternalObjectAsString(Query[ARow], ACol);
end;

function TPressMVPReferenceModel.GetAsString: string;
begin
  Result := InternalObjectAsString(Subject.Value, -1);
end;

function TPressMVPReferenceModel.GetMetadata: TPressQueryMetadata;
const
  CQueryMetadata =
   '%s(%s) Any Order=%s (Name: String DataName=%2:s MatchType=mtContains)';
begin
  if not Assigned(FMetadata) then
    FMetadata := TPressMetaParser.ParseMetadata(Format(
     CQueryMetadata, [TPressMVPReferenceQuery.ClassName,
     Subject.ObjectClass.ClassName,
     FReferencedAttribute])) as TPressQueryMetadata;
  Result := FMetadata;
end;

function TPressMVPReferenceModel.GetObjectClass: TPressObjectClass;
begin
  Result := InternalObjectClass;
end;

function TPressMVPReferenceModel.GetQuery: TPressMVPReferenceQuery;
begin
  if not Assigned(FQuery) then
    FQuery := CreateReferenceQuery;
  Result := FQuery;
end;

function TPressMVPReferenceModel.GetSubject: TPressReference;
begin
  Result := inherited Subject as TPressReference;
end;

procedure TPressMVPReferenceModel.InitCommands;
begin
  inherited;
  AddCommands([TPressMVPIncludeObjectCommand, TPressMVPEditItemCommand]);
end;

procedure TPressMVPReferenceModel.InternalAssignDisplayNames(
  const ADisplayNames: string);
var
  VPos: Integer;
begin
  VPos := Pos(SPressFieldDelimiter, ADisplayNames);
  if VPos > 0 then
  begin
    FReferencedAttribute := Copy(ADisplayNames, 1, VPos - 1);
    AssignColumnData(
     Copy(ADisplayNames, VPos + 1, Length(ADisplayNames) - VPos));
  end else
  begin
    FReferencedAttribute := ADisplayNames;
    AssignColumnData(ADisplayNames);
  end;
end;

function TPressMVPReferenceModel.InternalObjectAsString(
  AObject: TPressObject; ACol: Integer): string;
var
  VAttributeName: string;
  VAttribute: TPressAttribute;
begin
  Result := '';
  if not Assigned(AObject) then
    Exit;
  if ACol = -1 then
    VAttributeName := FReferencedAttribute
  else
    VAttributeName := ColumnData[ACol].AttributeName;
  VAttribute := AObject.FindPathAttribute(VAttributeName, False);
  if Assigned(VAttribute) then
    Result := VAttribute.DisplayText;
end;

function TPressMVPReferenceModel.InternalObjectClass: TPressObjectClass;
begin
  Result := Subject.ObjectClass;
end;

procedure TPressMVPReferenceModel.InternalUpdateQueryMetadata(
  const AQueryString: string);
begin
  Query.Metadata.ItemObjectClass := InternalObjectClass;
  Query.Name := AQueryString;
end;

procedure TPressMVPReferenceModel.Notify(AEvent: TPressEvent);
begin
  inherited;
  if (AEvent is TPressAttributeChangedEvent) and HasSubject then
    Selection.Select(Subject.Value);
end;

function TPressMVPReferenceModel.ObjectOf(AIndex: Integer): TPressObject;
begin
  Result := Query[AIndex];
end;

function TPressMVPReferenceModel.ReferencedValue(
  AObject: TPressObject): TPressValue;
var
  VAttribute: TPressAttribute;
begin
  VAttribute := AObject.AttributeByPath(FReferencedAttribute);
  if not (VAttribute is TPressValue) then
    raise EPressMVPError.CreateFmt(SAttributeIsNotValue,
     [AObject.ClassName, VAttribute.Name]);
  Result := TPressValue(VAttribute);
end;

function TPressMVPReferenceModel.TextAlignment(ACol: Integer): TAlignment;
begin
  Result := ColumnData[ACol].AttributeAlignment;
end;

{ TPressMVPObjectItem }

function TPressMVPObjectItem.AddAttribute(
  AAttribute: TPressAttribute): Integer;
begin
  { TODO : Assert AAttribute is TPressValue }
  Result := Attributes.Add(AAttribute);
  if Assigned(AAttribute) then
    AAttribute.AddRef;
end;

procedure TPressMVPObjectItem.ClearAttributes;
begin
  FreeAndNil(FAttributes);
end;

constructor TPressMVPObjectItem.Create(
  AOwner: TPressMVPObjectList; AProxy: TPressProxy; AItemNumber: Integer);
begin
  inherited Create;
  FOwner := AOwner;
  FProxy := AProxy;
  FProxy.AddRef;
  FItemNumber := AItemNumber;
end;

destructor TPressMVPObjectItem.Destroy;
begin
  FProxy.Free;
  FAttributes.Free;
  inherited;
end;

function TPressMVPObjectItem.GetAttributes: TPressAttributeList;
begin
  if not Assigned(FAttributes) then
  begin
    FAttributes := TPressAttributeList.Create(True);
    FOwner.CreateAttributes(Self);
  end;
  Result := FAttributes;
end;

function TPressMVPObjectItem.GetDisplayText(ACol: Integer): string;
begin
  { TODO : fix 'out of bounds' exception if DisplayName isn't assigned
    to ListBox views }
  if Assigned(Attributes[ACol]) then
    Result := Attributes[ACol].DisplayText
  else
    Result := '';
end;

function TPressMVPObjectItem.GetInstance: TPressObject;
begin
  Result := Proxy.Instance;
end;

function TPressMVPObjectItem.HasAttributes: Boolean;
begin
  Result := Assigned(FAttributes);
end;

{ TPressMVPObjectList }

function TPressMVPObjectList.Add(AObject: TPressMVPObjectItem): Integer;
begin
  Result := inherited Add(AObject);
end;

function TPressMVPObjectList.AddProxy(AProxy: TPressProxy): Integer;
var
  VObjItem: TPressMVPObjectItem;
begin
  VObjItem := CreateObjectItem(AProxy);
  try
    Result := Add(VObjItem);
  except
    VObjItem.Free;
    raise;
  end;
end;

constructor TPressMVPObjectList.Create(AColumnData: TPressMVPColumnData);
begin
  inherited Create(True);
  FColumnData := AColumnData;
end;

procedure TPressMVPObjectList.CreateAttributes(
  AObjectItem: TPressMVPObjectItem);
var
  I: Integer;
begin
  for I := 0 to Pred(FColumnData.ColumnCount) do
    AObjectItem.AddAttribute(AObjectItem.Instance.
     FindPathAttribute(FColumnData[I].AttributeName, False));
end;

function TPressMVPObjectList.CreateIterator: TPressMVPObjectIterator;
begin
  Result := TPressMVPObjectIterator.Create(Self);
end;

function TPressMVPObjectList.CreateObjectItem(
  AProxy: TPressProxy): TPressMVPObjectItem;
begin
  Result := TPressMVPObjectItem.Create(Self, AProxy, Count + 1);
end;

function TPressMVPObjectList.Extract(
  AObject: TPressMVPObjectItem): TPressMVPObjectItem;
begin
  Result := inherited Extract(AObject) as TPressMVPObjectItem;
end;

function TPressMVPObjectList.GetItems(
  AIndex: Integer): TPressMVPObjectItem;
begin
  Result := inherited Items[AIndex] as TPressMVPObjectItem;
end;

function TPressMVPObjectList.IndexOf(
  AObject: TPressMVPObjectItem): Integer;
begin
  Result := inherited IndexOf(AObject);
end;

function TPressMVPObjectList.IndexOfInstance(
  AObject: TPressObject): Integer;
begin
  for Result := 0 to Pred(Count) do
    with Items[Result].Proxy do
      if HasInstance and (Instance = AObject) then
        Exit;
  Result := -1;
end;

function TPressMVPObjectList.IndexOfProxy(AProxy: TPressProxy): Integer;
begin
  for Result := 0 to Pred(Count) do
    if Items[Result].Proxy = AProxy then
      Exit;
  Result := -1;
end;

procedure TPressMVPObjectList.Insert(Index: Integer;
  AObject: TPressMVPObjectItem);
begin
  inherited Insert(Index, AObject);
end;

procedure TPressMVPObjectList.InsertProxy(
  Index: Integer; AProxy: TPressProxy);
var
  VObjItem: TPressMVPObjectItem;
begin
  VObjItem := CreateObjectItem(AProxy);
  try
    Insert(Index, VObjItem);
  except
    VObjItem.Free;
    raise;
  end;
end;

function TPressMVPObjectList.InternalCreateIterator: TPressCustomIterator;
begin
  Result := CreateIterator;
end;

var
  GOrderColumn: Integer;

function PressCompareItems(Item1, Item2: Pointer): Integer;

  function CompareItemNumbers(AID1, AID2: TPressMVPObjectItem): Integer;
  begin
    if AID1.ItemNumber > AID2.ItemNumber then
      Result := 1
    else if AID1.ItemNumber < AID2.ItemNumber then
      Result := -1
    else
      Result := 0;
  end;

  function CompareStrings(const AStr1, AStr2: string): Integer;
  begin
    Result := AnsiCompareText(AStr1, AStr2);
  end;

  function CompareIntegers(AInt1, AInt2: Integer): Integer;
  begin
    if AInt1 > AInt2 then
      Result := 1
    else if AInt1 < AInt2 then
      Result := -1
    else
      Result := 0;
  end;

  function CompareFloats(AFloat1, AFloat2: Double): Integer;
  begin
    if AFloat1 > AFloat2 then
      Result := 1
    else if AFloat1 < AFloat2 then
      Result := -1
    else
      Result := 0;
  end;

  function CompareEnums(AEnum1, AEnum2: TPressEnum): Integer;
  begin
    if AEnum1.IsEmpty and AEnum2.IsEmpty then
      Result := 0
    else if AEnum1.IsEmpty then
      Result := 1
    else if AEnum2.IsEmpty then
      Result := -1
    else
      Result := CompareStrings(AEnum1.AsString, AEnum2.AsString);
  end;

  function CompareVariants(AVariant1, AVariant2: Variant): Integer;
  begin
    if AVariant1 > AVariant2 then
      Result := 1
    else if AVariant1 < AVariant2 then
      Result := -1
    else
      Result := 0;
  end;

var
  VAttr1, VAttr2: TPressAttribute;
begin
  if (GOrderColumn < 0) or
   (GOrderColumn >= TPressMVPObjectItem(Item1).Attributes.Count) then
    Result :=
     CompareItemNumbers(TPressMVPObjectItem(Item1), TPressMVPObjectItem(Item2))
  else if Item1 <> Item2 then
  begin
    VAttr1 := TPressMVPObjectItem(Item1).Attributes[GOrderColumn];
    VAttr2 := TPressMVPObjectItem(Item2).Attributes[GOrderColumn];
    if not Assigned(VAttr1) and not Assigned(VAttr2) then
      Result := 0
    else if not Assigned(VAttr1) then
      Result := -1
    else if not Assigned(VAttr2) then
      Result := 1
    else if VAttr1.AttributeBaseType <> VAttr2.AttributeBaseType then
      Result := 0
    else
      case VAttr1.AttributeBaseType of
        attString, attBoolean, attMemo:
          Result := CompareStrings(VAttr1.AsString, VAttr2.AsString);
        attInteger:
          Result := CompareIntegers(VAttr1.AsInteger, VAttr2.AsInteger);
        attFloat, attCurrency, attDate, attTime, attDateTime:
          Result := CompareFloats(VAttr1.AsFloat, VAttr2.AsFloat);
        attEnum:
          Result := CompareEnums(TPressEnum(VAttr1), TPressEnum(VAttr2));
        attVariant:
          Result := CompareVariants(VAttr1.AsVariant, VAttr2.AsVariant);
        else
          Result := -1;
      end;
    if Result = 0 then
      Result := CompareItemNumbers(
       TPressMVPObjectItem(Item1), TPressMVPObjectItem(Item2));
  end else
    Result := 0;
end;

procedure TPressMVPObjectList.Reindex(AColumn: Integer);
begin
  GOrderColumn := AColumn;
  Sort(PressCompareItems);
end;

function TPressMVPObjectList.Remove(AObject: TPressMVPObjectItem): Integer;
begin
  Result := inherited Remove(AObject);
end;

function TPressMVPObjectList.RemoveProxy(AProxy: TPressProxy): Integer;
begin
  Result := IndexOfProxy(AProxy);
  if Result >= 0 then
    Delete(Result);
end;

procedure TPressMVPObjectList.SetItems(
  AIndex: Integer; Value: TPressMVPObjectItem);
begin
  inherited Items[AIndex] := Value;
end;

{ TPressMVPObjectIterator }

function TPressMVPObjectIterator.GetCurrentItem: TPressMVPObjectItem;
begin
  Result := inherited CurrentItem as TPressMVPObjectItem;
end;

{ TPressMVPItemsModel }

function TPressMVPItemsModel.Count: Integer;
begin
  if Assigned(FObjectList) then
    Result := FObjectList.Count
  else
    Result := 0;
end;

constructor TPressMVPItemsModel.Create(
  AParent: TPressMVPModel; ASubject: TPressSubject);
begin
  inherited Create(AParent, ASubject);
  RebuildObjectList;
end;

destructor TPressMVPItemsModel.Destroy;
begin
  FObjectList.Free;
  inherited;
end;

function TPressMVPItemsModel.DisplayText(ACol, ARow: Integer): string;
begin
  Result := ObjectList[ARow].DisplayText[ACol];
end;

function TPressMVPItemsModel.GetObjectList: TPressMVPObjectList;
begin
  if not Assigned(FObjectList) then
    FObjectList := TPressMVPObjectList.Create(ColumnData);
  Result := FObjectList;
end;

function TPressMVPItemsModel.GetObjects(AIndex: Integer): TPressObject;
begin
  Result := ObjectList[AIndex].Instance;
end;

function TPressMVPItemsModel.GetSubject: TPressItems;
begin
  Result := inherited Subject as TPressItems;
end;

function TPressMVPItemsModel.IndexOf(AObject: TPressObject): Integer;
begin
  Result := ObjectList.IndexOfInstance(AObject);
end;

procedure TPressMVPItemsModel.InitCommands;
begin
  inherited;
  InternalCreateAddCommands;
  InternalCreateEditCommands;
  InternalCreateRemoveCommands;
  InternalCreateSelectionCommands;
end;

procedure TPressMVPItemsModel.InternalAssignDisplayNames(
  const ADisplayNames: string);
begin
  AssignColumnData(ADisplayNames);
  InternalCreateSortCommands;
end;

procedure TPressMVPItemsModel.InternalCreateAddCommands;
begin
  AddCommand(TPressMVPAddItemsCommand);
end;

procedure TPressMVPItemsModel.InternalCreateEditCommands;
begin
  AddCommand(TPressMVPEditItemCommand);
end;

procedure TPressMVPItemsModel.InternalCreateRemoveCommands;
begin
  AddCommand(TPressMVPRemoveItemsCommand);
end;

procedure TPressMVPItemsModel.InternalCreateSelectionCommands;
begin
  AddCommands([nil, TPressMVPSelectAllCommand, TPressMVPSelectNoneCommand,
   TPressMVPSelectCurrentCommand, TPressMVPSelectInvertCommand]);
end;

procedure TPressMVPItemsModel.InternalCreateSortCommands;

  function CreateSortCommand(AColumn: Integer): TPressMVPSortCommand;
  var
    VShortCut: TShortCut;
    VCaption: string;
    VChar: Char;
  begin
    if AColumn in [0..8] then
      VChar := Chr(Ord('1') + AColumn)
    else if AColumn in [9..Ord('Z') - Ord('A') + 9] then
      VChar := Chr(Ord('A') + AColumn - 9)
    else
      VChar := #0;
    VCaption :=
     Format(SPressSortByCommand, [ColumnData[AColumn].HeaderCaption]);
    if VChar <> #0 then
    begin
      VShortCut := Menus.ShortCut(Ord(VChar), [ssShift, ssCtrl]);
      VCaption := '&' + VChar + ' ' + VCaption;
    end else
      VShortCut := 0;
    Result := TPressMVPSortCommand.Create(Self, VCaption, VShortCut);
    Result.ColumnNumber := AColumn;
  end;

var
  I: Integer;
begin
  AddCommand(nil);
  for I := 0 to Pred(ColumnData.ColumnCount) do
    AddCommandInstance(CreateSortCommand(I));
end;

procedure TPressMVPItemsModel.ItemsChanged(
  AEvent: TPressItemsChangedEvent);

  procedure AddItem;
  begin
    ObjectList.AddProxy(AEvent.Proxy);
    if AEvent.Proxy.HasInstance then
      Selection.Select(AEvent.Proxy.Instance);
  end;

  procedure InsertItem;
  begin
    { TODO : Verify the correct index (when sorted) }
    ObjectList.InsertProxy(AEvent.Index, AEvent.Proxy);
    if AEvent.Proxy.HasInstance then
      Selection.Select(AEvent.Proxy.Instance);
  end;

  procedure ModifyItem;
  var
    VIndex: Integer;
  begin
    VIndex := ObjectList.IndexOfProxy(AEvent.Proxy);
    if VIndex >= 0 then
      ObjectList[VIndex].ClearAttributes;
  end;

  procedure RemoveItem;
  var
    VIndex: Integer;
  begin
    VIndex := ObjectList.RemoveProxy(AEvent.Proxy);
    if (VIndex >= 0) and AEvent.Proxy.HasInstance then
    begin
      if VIndex >= ObjectList.Count then
        VIndex := Pred(ObjectList.Count);
      if Selection.Focus = AEvent.Proxy.Instance then
        if VIndex >= 0 then
          Selection.Focus := ObjectList[VIndex].Instance
        else
          Selection.Focus := nil;
      Selection.Remove(AEvent.Proxy.Instance);
    end;
  end;

  procedure ClearItems;
  begin
    ObjectList.Clear;
    Selection.Clear;
  end;

begin
  case AEvent.EventType of
    ietAdd:
      AddItem;
    ietInsert:
      InsertItem;
    ietModify, ietNotify:
      ModifyItem;
    ietRemove:
      RemoveItem;
    ietClear:
      ClearItems;
    ietRebuild:
      RebuildObjectList;
  end;
  if AEvent.EventType <> ietNotify then
    Changed(ctSubject);
end;

function TPressMVPItemsModel.ItemNumber(ARow: Integer): Integer;
begin
  Result := ObjectList[ARow].ItemNumber;
end;

procedure TPressMVPItemsModel.Notify(AEvent: TPressEvent);
begin
  if AEvent is TPressItemsChangedEvent then
    ItemsChanged(TPressItemsChangedEvent(AEvent))
  else
    inherited;
end;

procedure TPressMVPItemsModel.RebuildObjectList;
var
  I: Integer;
begin
  Selection.BeginUpdate;
  try
    Selection.Clear;
    ObjectList.Clear;
    for I := 0 to Pred(Subject.Count) do
      ObjectList.AddProxy(Subject.Proxies[I]);
    if ObjectList.Count > 0 then
    begin
      Selection.Focus := ObjectList[0].Instance;
      Selection.StrongSelection := False;
    end;
  finally
    Selection.EndUpdate;
  end;
end;

procedure TPressMVPItemsModel.Reindex(AColumn: Integer);
var
  VFocus: TPressObject;
begin
  Selection.BeginUpdate;
  try
    VFocus := Selection.Focus;
    Selection.Focus := nil;
    ObjectList.Reindex(AColumn);
    Selection.Focus := VFocus;
  finally
    Selection.EndUpdate;
  end;
  Changed(ctSubject);
end;

function TPressMVPItemsModel.TextAlignment(ACol: Integer): TAlignment;
begin
  Result := ColumnData[ACol].AttributeAlignment;
end;

{ TPressMVPPartsModel }

class function TPressMVPPartsModel.Apply(ASubject: TPressSubject): Boolean;
begin
  Result := ASubject is TPressParts;
end;

{ TPressMVPReferencesModel }

class function TPressMVPReferencesModel.Apply(ASubject: TPressSubject): Boolean;
begin
  Result := ASubject is TPressReferences;
end;

procedure TPressMVPReferencesModel.InternalCreateAddCommands;
begin
  if HasSubject and (Subject.Owner is TPressQuery) and
   (Subject.Name = SPressQueryItemsString) then
    inherited
   else
    AddCommand(TPressMVPAddReferencesCommand)
end;

{ TPressMVPObjectModel }

procedure TPressMVPObjectModel.AfterChangeHookedSubject;
begin
  if Assigned(FHookedSubject) then
  begin
    FHookedSubject.AddRef;
    Notifier.AddNotificationItem(FHookedSubject,
     [TPressStructureUnassignObjectEvent]);
  end;
end;

class function TPressMVPObjectModel.Apply(ASubject: TPressSubject): Boolean;
begin
  Result := ASubject is TPressObject;
end;

procedure TPressMVPObjectModel.BeforeChangeHookedSubject;
begin
  if Assigned(FHookedSubject) then
  begin
    Notifier.RemoveNotificationItem(FHookedSubject);
    FreeAndNil(FHookedSubject);
  end;
end;

constructor TPressMVPObjectModel.Create(
  AParent: TPressMVPModel; ASubject: TPressSubject);
begin
  inherited Create(AParent, ASubject);
  if Assigned(ASubject) then
    FObjectMemento := (ASubject as TPressObject).CreateMemento;
end;

destructor TPressMVPObjectModel.Destroy;
begin
  FHookedSubject.Free;
  FObjectMemento.Free;
  inherited;
end;

function TPressMVPObjectModel.GetIsChanged: Boolean;
begin
  Result := Assigned(FObjectMemento) and FObjectMemento.SubjectChanged;
end;

function TPressMVPObjectModel.GetSelection: TPressMVPModelSelection;
begin
  Result := inherited Selection as TPressMVPModelSelection;
end;

function TPressMVPObjectModel.GetSubject: TPressObject;
begin
  Result := inherited Subject as TPressObject;
end;

procedure TPressMVPObjectModel.InitCommands;
begin
  inherited;
  InternalCreateSaveCommand;
  InternalCreateCancelCommand;
end;

procedure TPressMVPObjectModel.InternalChanged(
  AChangeType: TPressMVPChangeType);
begin
  if AChangeType = ctDisplay then
  { TODO : or (HasSubject and not (Subject is TPressObject)) }
    TPressMVPObjectModelChangedEvent.Create(Self, AChangeType).Notify;
end;

procedure TPressMVPObjectModel.InternalCreateCancelCommand;
begin
  AddCommand(TPressMVPCancelObjectCommand);
end;

procedure TPressMVPObjectModel.InternalCreateSaveCommand;
begin
  AddCommand(TPressMVPSaveObjectCommand);
end;

function TPressMVPObjectModel.InternalCreateSelection: TPressMVPSelection;
begin
  Result := TPressMVPModelSelection.Create;
end;

function TPressMVPObjectModel.InternalIsIncluding: Boolean;
begin
  Result := IsIncluding;
end;

procedure TPressMVPObjectModel.Notify(AEvent: TPressEvent);
begin
  inherited;
  if (AEvent is TPressStructureUnassignObjectEvent) and
   (TPressStructureUnassignObjectEvent(AEvent).UnassignedObject = Subject) then
    TPressMVPModelCloseFormEvent.Create(Self).Notify;
end;

procedure TPressMVPObjectModel.RevertChanges;
begin
  if Assigned(FObjectMemento) then
    FObjectMemento.Restore;
end;

procedure TPressMVPObjectModel.SetHookedSubject(Value: TPressStructure);
begin
  BeforeChangeHookedSubject;
  FHookedSubject := Value;
  AfterChangeHookedSubject;
end;

procedure TPressMVPObjectModel.UpdateData;
begin
  with Selection.CreateIterator do
  try
    BeforeFirstItem;
    while NextItem do
      (CurrentItem as TPressMVPModel).UpdateData;
  finally
    Free;
  end;
end;

{ TPressMVPQueryModel }

class function TPressMVPQueryModel.Apply(ASubject: TPressSubject): Boolean;
begin
  Result := ASubject is TPressQuery;
end;

procedure TPressMVPQueryModel.Clear;
begin
  Subject.Clear;
end;

procedure TPressMVPQueryModel.Execute;
begin
  Subject.UpdateReferenceList;
  { TODO : BeginUpdate / EndUpdate }
  if HookedSubject is TPressReferences then
    with TPressReferences(HookedSubject).CreateProxyIterator do
    try
      BeforeFirstItem;
      while NextItem do
        Subject.RemoveReference(CurrentItem);
    finally
      Free;
    end;
end;

function TPressMVPQueryModel.GetSubject: TPressQuery;
begin
  Result := inherited Subject as TPressQuery;
  if not Assigned(Result) then
    raise EPressMVPError.Create(SUnassignedSubject);
end;

procedure TPressMVPQueryModel.InitCommands;
begin
  //inherited;
  { TODO : inherited Save can persist all changed objects }
  AddCommand(TPressMVPExecuteQueryCommand);
end;

procedure RegisterModels;
begin
  TPressMVPValueModel.RegisterModel;
  TPressMVPEnumModel.RegisterModel;
  TPressMVPDateModel.RegisterModel;
  TPressMVPPictureModel.RegisterModel;
  TPressMVPReferenceModel.RegisterModel;
  TPressMVPPartsModel.RegisterModel;
  TPressMVPReferencesModel.RegisterModel;
  TPressMVPObjectModel.RegisterModel;
  TPressMVPQueryModel.RegisterModel;
end;

procedure RegisterClasses;
begin
  TPressMVPReferenceQuery.RegisterClass;
end;

initialization
  RegisterModels;
  RegisterClasses;

end.
