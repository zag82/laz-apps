unit createnav;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TfmCreateNav }

  TfmCreateNav = class(TForm)
    btCancel: TButton;
    btOk: TButton;
    edPass: TEdit;
    lbCapPwd: TStaticText;
    pnlPassword: TPanel;
    procedure btCancelClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure edPassChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  private
    FPass: string;
    FPassEdit: string;
    FStep: integer;
    procedure UpdatePanelState;
    procedure nextStep();
  public

  end;

var
  fmCreateNav: TfmCreateNav;

implementation

uses
  navdata, settings;

{$R *.lfm}

{ TfmCreateNav }

procedure TfmCreateNav.FormCreate(Sender: TObject);
begin
  FPass := '';
  FPassEdit := '';
  FStep := 0;
  UpdatePanelState();
end;

procedure TfmCreateNav.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
end;

procedure TfmCreateNav.edPassChange(Sender: TObject);
begin
  btOk.Enabled := edPass.Text <> '';
end;

procedure TfmCreateNav.btOkClick(Sender: TObject);
begin
  nextStep();
end;

procedure TfmCreateNav.btCancelClick(Sender: TObject);
begin
  Close;
end;

procedure TfmCreateNav.UpdatePanelState;
begin
  edPass.Text := '';
  edPassChange(edPass);

  pnlPassword.Left := (ClientWidth - pnlPassword.Width) div 2;
  pnlPassword.Top := (ClientHeight - pnlPassword.Height) div 2;

  if FStep = 0 then
    lbCapPwd.Caption := 'Password'
  else if FStep = 1 then
    lbCapPwd.Caption := 'Confirm password'
  else if FStep = 2 then
    lbCapPwd.Caption := 'Editing password';
end;

procedure TfmCreateNav.nextStep();
var
  goNext: boolean;
  nav: TNavData;
begin
  // check and fill conditions
  goNext := False;

  if FStep = 0 then
  begin
    // pass
    FPass := edPass.Text;
    goNext := True;
  end
  else if FStep = 1 then
  begin
    // pass confifm
    goNext := FPass = edPass.Text;
  end
  else if FStep = 2 then
  begin
    // edit pass
    FPassEdit := edPass.Text;

    // create new file
    nav := TNavData.Create(navSettings.FileName, False);
    nav.CreateNew(FPass, FPassEdit);
    nav.Free;
  end;

  // go to next stage
  if goNext then
  begin
    FStep += 1;
    UpdatePanelState;
  end
  else
    Close;
end;

end.

