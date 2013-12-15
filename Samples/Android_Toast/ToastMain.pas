unit ToastMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, FMX.Layouts;

type
  TForm3 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    CheckBox1: TCheckBox;
    GridLayout1: TGridLayout;
    TopLeft: TCornerButton;
    CornerButton2: TCornerButton;
    CornerButton3: TCornerButton;
    CornerButton4: TCornerButton;
    CornerButton5: TCornerButton;
    CornerButton6: TCornerButton;
    CornerButton7: TCornerButton;
    CornerButton8: TCornerButton;
    CornerButton9: TCornerButton;
    edtX: TEdit;
    edtY: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure CornerButtonClick(Sender: TObject);
  private
    { Private declarations }
    FToastPosition: Integer;
    procedure ClearPressed;
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

uses
  FMX.Devgear.Extensions;

{$R *.fmx}

procedure TForm3.Button1Click(Sender: TObject);
begin
{$IFDEF ANDROID}
  if CheckBox1.IsChecked then
    ToastMessage(Edit1.Text)
  else
  begin
    ToastMessage(Edit1.Text, TToastDuration.tdLengthLong, TToastPosition(FToastPosition), StrToIntDef(edtX.Text), StrToIntDef(edtY.Text));
  end;
{$ENDIF}
end;

procedure TForm3.ClearPressed;
var
  I: Integer;
begin
  for I := 0 to GridLayout1.ChildrenCount - 1 do
  begin
    TButton(GridLayout1.Children.Items[I]).IsPressed := False;
  end;
end;

procedure TForm3.CornerButtonClick(Sender: TObject);
begin
  Checkbox1.IsChecked := False;
  ClearPressed;
  FToastPosition := TButton(Sender).Tag;
  TButton(Sender).IsPressed := True;
end;

end.
