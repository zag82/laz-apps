unit aboutproj;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, ComCtrls;

type

  { TfmAboutProj }

  TfmAboutProj = class(TForm)
    btOK: TButton;
    gbInfo: TGroupBox;
    imgInfo: TImage;
    lbHelp: TLabel;
    lbInfo: TLabel;
    lbName: TLabel;
    pcInfo: TPageControl;
    pnlControl: TPanel;
    tsAbout: TTabSheet;
    tsControl: TTabSheet;
    procedure btOKClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
  end;

var
  fmAboutProj: TfmAboutProj;

implementation

{$R *.lfm}

{ TfmAboutProj }

procedure TfmAboutProj.btOKClick(Sender: TObject);
begin
  Close;
end;

procedure TfmAboutProj.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  CloseAction := caFree;
  fmAboutProj := nil;
end;

procedure TfmAboutProj.FormCreate(Sender: TObject);
begin
  pcInfo.ActivePageIndex := 0;
end;

end.

