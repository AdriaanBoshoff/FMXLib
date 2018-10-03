{*****************************************************************************}
{ @unit   FMX.Devgear.HelperClass                                             }
{ @data   2013/12/15                                                          }
{ @author Humphery(hjfactory@gmail.com) of devgear.co.kr                      }
{         - http://blog.hjf.pe.kr/                                            }
{ @description                                                                }
{  파이어몽키 기능확장 라이브러리                                             }
{*****************************************************************************}
unit FMX.Devgear.HelperClass;

interface

uses
  System.Classes, FMX.Graphics;

type
  TBitmapHelper = class helper for TBitmap
  public
    procedure LoadFromUrl(const AUrl: string);
    procedure LoadThumbnailFromUrl(const AUrl: string; const AFitWidth, AFitHeight: Integer);
  end;

procedure SetDevgearSSLPath(const aPath: string);

implementation

uses
  System.SysUtils, System.Types, IdHttp, IdTCPClient, AnonThread,
  IdIOHandlerSocket, IdIOHandlerStack, IdSSL, IdSSLOpenSSL, IdSSLOpenSSLHeaders;

procedure TBitmapHelper.LoadFromUrl(const AUrl: string);
var
  _Thread: TAnonymousThread<TMemoryStream>;
begin
  _Thread := TAnonymousThread<TMemoryStream>.Create(
    function: TMemoryStream
    var
      Http: TIdHttp;
      ssl: TIdSSLIOHandlerSocketOpenSSL;
    begin
      Result := TMemoryStream.Create;
      Http := TIdHttp.Create(nil);
      ssl := TIdSSLIOHandlerSocketOpenSSL.Create(nil);
      ssl.SSLOptions.SSLVersions := [sslvTLSv1, sslvTLSv1_1, sslvTLSv1_2];
      Http.IOHandler := ssl;
      Http.Request.UserAgent := 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:62.0) Gecko/20100101 Firefox/62.0';
      Http.HandleRedirects := True;
      try
        try
          Http.Get(AUrl, Result);
        except
          Result.Free;
        end;
      finally
        Http.Free;
        ssl.Free;
      end;
    end,
    procedure(AResult: TMemoryStream)
    begin
      if AResult.Size > 0 then
        LoadFromStream(AResult);
      AResult.Free;
    end,
    procedure(AException: Exception)
    begin
    end);
end;

procedure TBitmapHelper.LoadThumbnailFromUrl(const AUrl: string; const AFitWidth, AFitHeight: Integer);
var
  Bitmap: TBitmap;
  scale: Single;
begin
  LoadFromUrl(AUrl);
  scale := RectF(0, 0, Width, Height).Fit(RectF(0, 0, AFitWidth, AFitHeight));
  Bitmap := CreateThumbnail(Round(Width / scale), Round(Height / scale));
  try
    Assign(Bitmap);
  finally
    Bitmap.Free;
  end;
end;

procedure SetDevgearSSLPath(const aPath: string);
begin
  IdOpenSSLSetLibPath(aPath);
end;

end.

