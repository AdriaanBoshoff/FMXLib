{*****************************************************************************}
{ @unit   FMX.Devgear.Extensions                                              }
{ @data   2013/12/15                                                          }
{ @author Humphery(hjfactory@gmail.com) of devgear.co.kr                      }
{         - http://blog.hjf.pe.kr/                                            }
{ @description                                                                }
{  파이어몽키 기능확장 라이브러리                                             }
{*****************************************************************************}
unit FMX.Devgear.Android.Toast;

interface

uses
  System.Classes, System.Types;

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

{$IFDEF ANDROID}
uses
  FMX.Helpers.Android, Android.JNI.Toast, Android.JNI.Gravity;
{$ENDIF}

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
