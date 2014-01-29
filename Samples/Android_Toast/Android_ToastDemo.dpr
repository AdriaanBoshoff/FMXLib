program Android_ToastDemo;

uses
  System.StartUpCopy,
  FMX.MobilePreview,
  FMX.Forms,
  ToastMain in 'ToastMain.pas' {Form3},
  Android.JNI.Toast in '..\..\Libraries\rtl\Android\Android.JNI.Toast.pas',
  FMX.Devgear.HelperClass in '..\..\Libraries\FMX\FMX.Devgear.HelperClass.pas',
  Android.JNI.Gravity in '..\..\Libraries\rtl\Android\Android.JNI.Gravity.pas',
  FMX.Devgear.Android.Toast in '..\..\Libraries\FMX\FMX.Devgear.Android.Toast.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
