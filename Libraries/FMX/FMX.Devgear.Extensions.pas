{*****************************************************************************}
{ @unit   FMX.Devgear.Extensions                                              }
{ @data   2013/12/15                                                          }
{ @author Humphery(hjfactory@gmail.com) of devgear.co.kr                      }
{         - http://blog.hjf.pe.kr/                                            }
{ @description                                                                }
{  ���̾��Ű ���Ȯ�� ���̺귯��                                             }
{*****************************************************************************}
unit FMX.Devgear.Extensions;

interface

uses
  System.Classes, System.Types, FMX.Graphics
  ;

type
  TBitmapHelper = class helper for TBitmap
  private
    function LoadStreamFromUrl(AUrl: string): TMemoryStream;
  public
    procedure LoadFromUrl(AUrl: string; var outSize: Int64); overload;
    procedure LoadFromUrl(AUrl: string); overload;

    procedure LoadThumbnailFromUrl(AUrl: string; const AFitWidth, AFitHeight: Integer);
  end;

{$IFDEF ANDROID}

type
  TToastDuration = (tdLengthShort, tdLengthLong);
  TToastPosition = (tpDefault, tpTopLeft, tpTop, tpTopRight,
                tpLeft, tpCenter, tpRight,
                tpBottomLeft, tpBottom, tpBottomRight,
                tpVertCenter, tpHorzCenter
                );

procedure ToastMessage(const AMsg: string; ADuration: TToastDuration = tdLengthShort); overload;
procedure ToastMessage(const AMsg: string; ADuration: TToastDuration; APosition: TToastPosition; AXOffset, AYOffset: Integer); overload;
{$ENDIF}

implementation

uses
  IdHttp, IdTCPClient
{$IFDEF ANDROID}
  , FMX.Helpers.Android, Android.JNI.Toast, Android.JNI.Gravity
{$ENDIF}
  ;

function TBitmapHelper.LoadStreamFromUrl(AUrl: string): TMemoryStream;
var
  Http: TIdHttp;
begin
  Result := TMemoryStream.Create;
  Http := TIdHttp.Create(nil);
  try
    try
      Http.Get(AUrl, Result);
    except
    end;
  finally
    Http.Free;
  end;
end;

procedure TBitmapHelper.LoadFromUrl(AUrl: string; var outSize: Int64);
var
  Stream: TMemoryStream;
begin
  Stream := LoadStreamFromUrl(AUrl);
  outSize := Stream.Size;
  try
    if Stream.Size > 0 then
    begin
      LoadFromStream(Stream);
    end
  finally
    Stream.Free;
  end;
end;

procedure TBitmapHelper.LoadFromUrl(AUrl: string);
var
  tmp: Int64;
begin
  LoadFromUrl(AUrl, tmp);
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

{$IFDEF ANDROID}
procedure ToastMessage(const AMsg: string; ADuration: TToastDuration);
begin
  ToastMessage(AMsg, ADuration, tpDefault, 0, 0);
end;

procedure ToastMessage(const AMsg: string; ADuration: TToastDuration; APosition: TToastPosition; AXOffset, AYOffset: Integer);
  function _GetDuration: Integer;
  begin
    if ADuration = tdLengthLong then
      Result := TJToast.JavaClass.LENGTH_LONG
    else
      Result := TJToast.JavaClass.LENGTH_SHORT
    ;
  end;

  function _GetPosition: Integer;
  begin
    Result := TJGravity.JavaClass.NO_GRAVITY;

    case APosition of
    tpVertCenter: Result := TJGravity.JavaClass.CENTER_VERTICAL;
    tpHorzCenter: Result := TJGravity.JavaClass.CENTER_HORIZONTAL;
    tpCenter: Result := TJGravity.JavaClass.CENTER;
    end;

    // Vertical
    case APosition of
    tpTopLeft, tpTop, tpTopRight:  Result := Result or TJGravity.JavaClass.TOP;
    tpBottomLeft, tpBottom, tpBottomRight: Result := Result or TJGravity.JavaClass.BOTTOM;
    end;

    // Horizontal
    case APosition of
    tpTopLeft, tpLeft, tpBottomLeft: Result := Result or TJGravity.JavaClass.LEFT;
    tpTopRight, tpRight, tpBottomRight: Result := Result or TJGravity.JavaClass.RIGHT;
    end;
  end;
var
  Toast: JToast;
  D, P: Integer;
begin
  D := _GetDuration;
  P := _GetPosition;

  CallInUiThread(procedure
  begin
    Toast := TJToast.JavaClass.makeText(SharedActivityContext, StrToJCharSequence(AMsg), D);
    if APosition <> tpDefault then
      Toast.setGravity(P, AXOffset, AYOffset);
    Toast.show;
  end);
end;
{$ENDIF}
end.
