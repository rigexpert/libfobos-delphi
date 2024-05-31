program FobosSDR;

uses
  Vcl.Forms,
  UnitMain in 'UnitMain.pas' {FormMain},
  FobosSDRThread in 'FobosSDRThread.pas',
  Fobos in 'Fobos.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
