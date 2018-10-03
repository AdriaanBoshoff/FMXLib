program FMXLib;

uses
  System.StartUpCopy,
  FMX.Forms,
  uMain in 'uMain.pas' {Form1},
  FMX.Devgear.HelperClass in 'Libraries\FMX\FMX.Devgear.HelperClass.pas',
  djson in 'djson.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
