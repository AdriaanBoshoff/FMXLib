unit uMain;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, IdBaseComponent,
  IdComponent, IdIOHandler, IdIOHandlerSocket, IdIOHandlerStack, IdSSL,
  IdSSLOpenSSL, FMX.Controls.Presentation, FMX.StdCtrls, FMX.ListView.Types, FMX.ListView.Appearances,
  FMX.ListView.Adapters.Base, FMX.ListView, IdTCPConnection, IdTCPClient, IdHTTP,
  system.ioutils;

type
  TForm1 = class(TForm)
    btn1: TButton;
    lv1: TListView;
    procedure btn1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

  TLoadPlugins = class(TThread)
  protected
    procedure Execute; override;
  end;

var
  Form1: TForm1;

implementation

uses
  djson, FMX.Devgear.HelperClass;

{$R *.fmx}

{ TLoadPlugins }

procedure TLoadPlugins.Execute;
var
  http: TIdHTTP;
  ssl: TIdSSLIOHandlerSocketOpenSSL;
  jdata, jplugin: TdJSON;
  LItem: TListViewItem;
begin
  http := TIdHTTP.Create(nil);
  try
    ssl := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
    try
      ssl.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
      http.IOHandler := ssl;
      http.Request.UserAgent := 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:62.0) Gecko/20100101 Firefox/62.0';

      jdata := TdJSON.Parse(http.Get('https://umod.org/plugins/search.json?query='));
      try
        for jplugin in jdata['data'] do
        begin
          Synchronize(
            procedure
            begin
              LItem := Form1.lv1.Items.Add;
              LItem.Text := jplugin['name'].AsString;
              LItem.Detail := jplugin['author'].AsString;

              if jplugin['icon_url'].AsString <> '' then
                LItem.Bitmap.LoadFromUrl(jplugin['icon_url'].AsString);
            end);
        end;
      finally
        jdata.Free;
      end;
    finally
      ssl.Free;
    end;
  finally
    http.Free;
  end;
end;

procedure TForm1.btn1Click(Sender: TObject);
begin
  {$IFDEF  ANDROID}
  SetDevgearSSLPath(TPath.GetDocumentsPath);
  {$ENDIF}

  with TLoadPlugins.Create do
    FreeOnTerminate := True;
end;

end.

