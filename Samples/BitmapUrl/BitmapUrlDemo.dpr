program BitmapUrlDemo;

uses
  System.StartUpCopy,
  FMX.MobilePreview,
  FMX.Forms,
  BitmapUrlMain in 'BitmapUrlMain.pas' {Form3},
  FMX.Devgear.Extensions in '..\..\Libraries\FMX\FMX.Devgear.Extensions.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
