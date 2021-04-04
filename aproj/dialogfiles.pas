unit dialogfiles;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls;

type

  { TfmDialogFiles }

  TfmDialogFiles = class(TForm)
    btCancel: TButton;
    btOk: TButton;
    edFile: TEdit;
    gbFiles: TGroupBox;
    gbFileSelected: TGroupBox;
    lbFiles: TListBox;
    pnlControl: TPanel;
    procedure btCancelClick(Sender: TObject);
    procedure btOkClick(Sender: TObject);
    procedure lbFilesDblClick(Sender: TObject);
    procedure lbFilesSelectionChange(Sender: TObject; User: boolean);
  private
    FIsSave: boolean;
    FPath: string;
    function getFileName: string;
  public
    procedure Init(const APath: string; AIsSave: boolean; const AFileName: string);
    property FileName: string read getFileName;
  end;

var
  fmDialogFiles: TfmDialogFiles;

implementation

{$R *.lfm}

const
  cFilesExt = '.aproj';

{ TfmDialogFiles }

procedure TfmDialogFiles.btCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TfmDialogFiles.btOkClick(Sender: TObject);
begin
  if (not FIsSave) and (lbFiles.ItemIndex = -1) then
    ModalResult := mrNone
  else
    ModalResult := mrOK;
end;

procedure TfmDialogFiles.lbFilesDblClick(Sender: TObject);
begin
  btOkClick(btOk);
end;

procedure TfmDialogFiles.lbFilesSelectionChange(Sender: TObject; User: boolean);
begin
  if lbFiles.ItemIndex <> -1 then
    edFile.Text := lbFiles.Items[lbFiles.ItemIndex];
end;

function TfmDialogFiles.getFileName: string;
begin
  Result := FPath + edFile.Text + cFilesExt;
end;

procedure TfmDialogFiles.Init(const APath: string; AIsSave: boolean; const AFileName: string);
var
  sr: TSearchRec;
begin
  FPath := APath;
  // fill list of files
  lbFiles.Clear;
  if FindFirst(FPath + '*' + cFilesExt, faAnyFile, sr) = 0 then
  begin
    repeat
      lbFiles.Items.Add(ChangeFileExt(ExtractFileName(sr.Name), ''));
    until FindNext(sr) <> 0;
    FindClose(sr);
  end;

  FIsSave := AIsSave;
  if FIsSave then
  begin
    ActiveControl := edFile;
    Caption := 'Сохранить проект';
  end
  else
  begin
    ActiveControl := lbFiles;
    Caption := 'Открыть проект';
  end;
  edFile.Text := ChangeFileExt(ExtractFileName(AFileName), '');
  gbFileSelected.Visible := FIsSave;
end;

end.

