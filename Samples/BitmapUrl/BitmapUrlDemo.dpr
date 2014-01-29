program BitmapUrlDemo;

uses
  System.StartUpCopy,
  FMX.MobilePreview,
  FMX.Forms,
  BitmapUrlMain in 'BitmapUrlMain.pas' {Form3},
  FMX.Devgear.HelperClass in '..\..\Libraries\FMX\FMX.Devgear.HelperClass.pas',
  AnonThread in '..\..\Libraries\rtl\AnonThread.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
