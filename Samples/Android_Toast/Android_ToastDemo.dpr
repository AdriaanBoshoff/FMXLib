program Android_ToastDemo;

uses
  System.StartUpCopy,
  FMX.MobilePreview,
  FMX.Forms,
  ToastMain in 'ToastMain.pas' {Form3},
  Android.JNI.Toast in '..\..\Libraries\rtl\Android\Android.JNI.Toast.pas',
  FMX.Devgear.Extensions in '..\..\Libraries\FMX\FMX.Devgear.Extensions.pas',
  Android.JNI.Gravity in '..\..\Libraries\rtl\Android\Android.JNI.Gravity.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
