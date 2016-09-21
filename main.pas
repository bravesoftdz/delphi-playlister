// TODO:
// if editPath ends in slash then remove it, probably do this onchange?
unit main;

interface

uses
	StdCtrls, Buttons, Classes, Controls,
  forms, 		// TForm
  sysutils, // GetCurrentDir
	filectrl, // SelectDirectory
  thread, RzCommon, RzSelDir, RzCmboBx, RzBckgnd, ToolWin, ComCtrls,
  RzPanel, RzButton, ExtCtrls, dialogs;
  // transwnd

type
  TformPlaylister = class(TForm)
    memoOutput: TMemo;
    selectDirDialog: TRzSelDirDialog;
    editMask: TRzMRUComboBox;
    editPath: TRzMRUComboBox;
    RzToolbarButton1: TRzToolbarButton;
    RzToolbarButton2: TRzToolbarButton;
    RzToolbarButton3: TRzToolbarButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RzToolbarButton1Click(Sender: TObject);
    procedure RzToolbarButton2Click(Sender: TObject);
    procedure RzToolbarButton3Click(Sender: TObject);
  private
    threadProcessDir: TthreadProcessDir;
  public
    { Public declarations }
  end;

var
  formPlaylister: TformPlaylister;
const
  playlisterVersion: integer = 111;
  //mytranswnd: TTransWnd2000;

implementation

{$R *.DFM}

procedure TformPlaylister.FormCreate(Sender: TObject);
begin
  editMask.Text := '.mp3';
  //editPath.Text := GetCurrentDir;
  memoOutput.Clear;
  //mytranswnd := TTransWnd2000.Create(nil);
  //mytranswnd.alphalevel := 80;
  //mytranswnd.ApplyTrans(formPlaylister.handle);
end;

procedure TformPlaylister.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  editPath.UpdateMRUList;
  editPath.SaveMRUData;
  editMask.UpdateMRUList;
  editMask.SaveMRUData;
end;

procedure TformPlaylister.RzToolbarButton1Click(Sender: TObject);
begin
  selectDirDialog.Directory := editPath.Text;
  if selectDirDialog.Execute then
  begin
    editPath.Text := selectDirDialog.Directory;
  end;
end;

procedure TformPlaylister.RzToolbarButton2Click(Sender: TObject);
begin
  threadProcessDir := TthreadProcessDir.Create(true);
  threadProcessDir.memoOutput := memoOutput;
  threadProcessDir.editPath := editPath;
  threadProcessDir.editMask := editMask;
  threadProcessDir.Resume;
end;

procedure TformPlaylister.RzToolbarButton3Click(Sender: TObject);
begin
  showmessage('Playlister ('+format('%n',[playlisterVersion/100])+')'+#13#10+'Copyright © 2001 REDACT'+#13#10+'http://REDACT.org/software');
end;

end.
