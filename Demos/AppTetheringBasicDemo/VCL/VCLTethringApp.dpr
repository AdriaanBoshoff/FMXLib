program VCLTethringApp;

uses
  Vcl.Forms,
  VCLForm in 'VCLForm.pas' {Form2},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Emerald');
  Application.CreateForm(TForm2, Form2);
  Application.Run;
end.
