unit BitmapUrlMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Objects,
  FMX.StdCtrls, FMX.Layouts, FMX.Memo, FMX.Edit;

type
  TForm3 = class(TForm)
    Button1: TButton;
    Memo1: TMemo;
    Button2: TButton;
    Button3: TButton;
    Layout1: TLayout;
    Image1: TImage;
    edtUrl: TEdit;
    Label1: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses
  FMX.Devgear.HelperClass;

{$R *.fmx}

{ TImageHelper }

procedure TForm3.Button1Click(Sender: TObject);
var
  Size: Int64;
begin
{
  Image1.Bitmap.LoadFromUrl(edtUrl.Text, Size);

  Memo1.Lines.Add('1 : ' + Format('W: %d, H: %d, S: %d', [Image1.Bitmap.Width, Image1.Bitmap.Height, Size]))
}
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  Image1.Bitmap.LoadFromUrl(edtUrl.Text);

  Memo1.Lines.Add('2 : ' + Format('W: %d, H: %d', [Image1.Bitmap.Width, Image1.Bitmap.Height]))
end;

procedure TForm3.Button3Click(Sender: TObject);
begin
  Image1.Bitmap.LoadThumbnailFromURL(edtUrl.Text, 100, 100);

  Memo1.Lines.Add('3 : ' + Format('W: %d, H: %d', [Image1.Bitmap.Width, Image1.Bitmap.Height]))
end;

end.
