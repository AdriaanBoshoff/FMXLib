program Android_ToastDemo;

uses
  System.StartUpCopy,
  FMX.MobilePreview,
  FMX.Forms,
  Unit3 in 'Unit3.pas' {Form3},
  Android.JNI.Toast in 'Android.JNI.Toast.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
