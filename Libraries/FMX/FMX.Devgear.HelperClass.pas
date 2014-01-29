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
    procedure LoadFromUrl(AUrl: string);

    procedure LoadThumbnailFromUrl(AUrl: string; const AFitWidth, AFitHeight: Integer);
  end;

implementation

uses
  System.SysUtils, System.Types, IdHttp, IdTCPClient, AnonThread;

procedure TBitmapHelper.LoadFromUrl(AUrl: string);
var
  _Thread: TAnonymousThread<TMemoryStream>;
begin
  _Thread := TAnonymousThread<TMemoryStream>.Create(
    function: TMemoryStream
    var
      Http: TIdHttp;
    begin
      Result := TMemoryStream.Create;
      Http := TIdHttp.Create(nil);
      try
        try
          Http.Get(AUrl, Result);
        except
          Result.Free;
        end;
      finally
        Http.Free;
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
    end
  );
end;

procedure TBitmapHelper.LoadThumbnailFromUrl(AUrl: string; const AFitWidth,
  AFitHeight: Integer);
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

end.
