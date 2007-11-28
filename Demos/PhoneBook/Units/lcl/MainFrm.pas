unit MainFrm;

{$mode objfpc}{$H+}

interface

uses
  LResources, Forms, Classes, Controls, StdCtrls, ExtCtrls, Menus, Buttons, Grids;

type
  TMainForm = class(TForm)
    QueryPanel: TPanel;
    ItemsPanel: TPanel;
    NameQueryEdit: TEdit;
    NameQueryLabel: TLabel;
    QuerySpeedButtonPanel: TPanel;
    QuerySpeedButton: TSpeedButton;
    ItemsStringGrid: TStringGrid;
    BottomLinePanel: TPanel;
    MainMenu: TMainMenu;
    FileMenuGroup: TMenuItem;
    ConnectorMenuItem: TMenuItem;
    N1: TMenuItem;
    CloseMenuItem: TMenuItem;
    TopLinePanel: TPanel;
  end;

var
  MainForm: TMainForm;

implementation

initialization
  {$i MainFrm.lrs}

end.