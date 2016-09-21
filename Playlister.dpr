program Playlister;

uses
  Forms,
  main in 'main.pas',
  thread in 'thread.pas';

// transwnd in 'transwnd.pas'

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := 'Playlister';
  Application.CreateForm(TformPlaylister, formPlaylister);
  Application.Run;
end.
