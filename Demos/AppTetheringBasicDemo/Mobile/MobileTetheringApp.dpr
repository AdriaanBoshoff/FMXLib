program MobileTetheringApp;

uses
  System.StartUpCopy,
  FMX.Forms,
  MobileForm in 'MobileForm.pas' {Form3},
  PhotoFrame in 'PhotoFrame.pas' {frPhoto: TFrame};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm3, Form3);
  Application.Run;
end.
