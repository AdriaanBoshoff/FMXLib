program BitmapUrlDemo;

uses
  System.StartUpCopy,
  FMX.MobilePreview,
  FMX.Forms,
  Unit3 in 'Unit3.pas' {Form3},
  FMX.Devgear.Extensions in 'FMX.Devgear.Extensions.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
