unit thread;

interface

uses
  classes, 	// TThread
	stdctrls,	// TMemo
  sysutils,	// IntToStr
  RzCmboBx
  ;

type
  TthreadProcessDir = class(TThread)
	memoOutput : TMemo;
	editPath : TRzMRUComboBox;
  editMask : TRzMRUComboBox;
  procedure processDir(Path: String);
  private
    { Private declarations }
  protected
    procedure Execute; override;
  end;

const
  dirCount: integer = 0;

implementation

procedure TthreadProcessDir.Execute;
begin
  processDir(editPath.Text);
  memoOutput.Lines.Append('');
  memoOutput.Lines.Append(IntToStr(dirCount) + ' directories processed');
  memoOutput.Lines.Append('');
  dirCount := 0;
end;

procedure TthreadProcessDir.processDir(Path: String);
var
  sr: TSearchRec;
  fs: TFileStream;
  playlistOpen: boolean;
begin
  playlistOpen := false;
  dirCount := dirCount + 1;
  memoOutput.Lines.Append(Path+'\');
  if FindFirst(Path+'\*', faAnyFile, sr) = 0 then
  begin
    while FindNext(sr) = 0 do
    begin
      // IF not '..' or '.' AND not SysFile, not Hidden, not VolumeID (eg. System Volume Information, IO.SYS, etc)
      if (not (sr.Name = '..')) and (not (sr.Name = '.')) and (sr.attr and (faSysFile or faHidden or faVolumeID) = 0)  then
      begin
        // if dir, process
        if sr.attr and faDirectory > 0 then
        begin
          processdir(Path+'\'+sr.Name);
        end
        // else file, process
        else
        begin
          // if ends with mask then we need to add it to the playlist
          if CompareText( Copy( sr.Name , Length(sr.Name)-Length(editMask.Text)+1 , Length(editMask.Text) ),editMask.Text) = 0 then
          begin
            // if playlistOpen is false, then...
            // open playlist for destructive writing, create if it doesnt exist
            if playlistOpen = false then
            begin
  	          fs := TFileStream.Create(Path+'\!.m3u',fmCreate);
	            playlistOpen := true;
            end;

            fs.WriteBuffer(sr.Name[1],Length(sr.Name));
            fs.WriteBuffer(#13#10,2);
            //memoOutput.Lines.Append(sr.Name);
          end;
        end;
      end;
    end;
    // close playlist if one was opened
    if playlistOpen then
    begin
	    fs.Free;
    end;
  end;
  FindClose(sr);
end;

end.
