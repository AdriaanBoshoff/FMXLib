{*****************************************************************************}
{ @class  TJGravity                                                           }
{ @data   2013/12/15                                                          }
{ @author Humphery(hjfactory@gmail.com) of devgear.co.kr                      }
{ @brief  http://developer.android.com/reference/android/view/Gravity.html    }
{*****************************************************************************}

unit Android.JNI.Gravity;

interface

{$IFDEF ANDROID}
uses
  Androidapi.JNIBridge,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.GraphicsContentViewText;

type
  JGravity = interface;

  JGravityClass = interface(JObjectClass)
  ['{B1D16C00-E6FC-4FBD-9D7B-CAE9933DC449}']
    {Property methods}
      function _GetAXIS_CLIP: Integer; cdecl;
      function _GetAXIS_PULL_AFTER: Integer; cdecl;
      function _GetAXIS_PULL_BEFORE: Integer; cdecl;
      function _GetAXIS_SPECIFIED: Integer; cdecl;
      function _GetAXIS_X_SHIFT: Integer; cdecl;
      function _GetAXIS_Y_SHIFT: Integer; cdecl;
      function _GetBOTTOM: Integer; cdecl;
      function _GetCENTER: Integer; cdecl;
      function _GetCENTER_HORIZONTAL: Integer; cdecl;
      function _GetCENTER_VERTICAL: Integer; cdecl;
      function _GetCLIP_HORIZONTAL: Integer; cdecl;
      function _GetCLIP_VERTICAL: Integer; cdecl;
      function _GetDISPLAY_CLIP_HORIZONTAL: Integer; cdecl;
      function _GetDISPLAY_CLIP_VERTICAL: Integer; cdecl;
      function _GetEND: Integer; cdecl;
      function _GetFILL: Integer; cdecl;
      function _GetFILL_HORIZONTAL: Integer; cdecl;
      function _GetFILL_VERTICAL: Integer; cdecl;
      function _GetHORIZONTAL_GRAVITY_MASK: Integer; cdecl;
      function _GetLEFT: Integer; cdecl;
      function _GetNO_GRAVITY: Integer; cdecl;
      function _GetRELATIVE_HORIZONTAL_GRAVITY_MASK: Integer; cdecl;
      function _GetRELATIVE_LAYOUT_DIRECTION: Integer; cdecl;
      function _GetRIGHT: Integer; cdecl;
      function _GetSTART: Integer; cdecl;
      function _GetTOP: Integer; cdecl;
      function _GetVERTICAL_GRAVITY_MASK: Integer; cdecl;
    {Methods}
      procedure apply(gravity, w, h: Integer; container, outRect: JRect; layoutDirection: Integer); cdecl; overload;
      procedure apply(gravity, w, h: Integer; container: JRect; xAdj, yAdj: Integer; outRect: JRect); cdecl; overload;
      procedure apply(gravity, w, h: Integer; container, outRect: JRect); cdecl; overload;
      procedure apply(gravity, w, h: Integer; container: JRect; xAdj, yAdj: Integer; outRect: JRect; layoutDirection: Integer); cdecl; overload;
      procedure applyDisplay(gravity: Integer; container, outRect: JRect); cdecl; overload;
      procedure applyDisplay(gravity: Integer; container, outRect: JRect; layoutDirection: Integer); cdecl; overload;
      function getAbsoluteGravity(gravity, layoutDirection: Integer): Integer; cdecl;
      function isHorizontal(gravity: Integer): Boolean; cdecl;
      function isVertical(gravity: Integer): Boolean; cdecl;
    {Properties}
      property AXIS_CLIP: Integer read _GetAXIS_CLIP;
      property AXIS_PULL_AFTER: Integer read _GetAXIS_PULL_AFTER;
      property AXIS_PULL_BEFORE: Integer read _GetAXIS_PULL_BEFORE;
      property AXIS_SPECIFIED: Integer read _GetAXIS_SPECIFIED;
      property AXIS_X_SHIFT: Integer read _GetAXIS_X_SHIFT;
      property AXIS_Y_SHIFT: Integer read _GetAXIS_Y_SHIFT;
      property BOTTOM: Integer read _GetBOTTOM;
      property CENTER: Integer read _GetCENTER;
      property CENTER_HORIZONTAL: Integer read _GetCENTER_HORIZONTAL;
      property CENTER_VERTICAL: Integer read _GetCENTER_VERTICAL;
      property CLIP_HORIZONTAL: Integer read _GetCLIP_HORIZONTAL;
      property CLIP_VERTICAL: Integer read _GetCLIP_VERTICAL;
      property DISPLAY_CLIP_HORIZONTAL: Integer read _GetDISPLAY_CLIP_HORIZONTAL;
      property DISPLAY_CLIP_VERTICAL: Integer read _GetDISPLAY_CLIP_VERTICAL;
      property &END: Integer read _GetEND;
      property FILL: Integer read _GetFILL;
      property FILL_HORIZONTAL: Integer read _GetFILL_HORIZONTAL;
      property FILL_VERTICAL: Integer read _GetFILL_VERTICAL;
      property HORIZONTAL_GRAVITY_MASK: Integer read _GetHORIZONTAL_GRAVITY_MASK;
      property LEFT: Integer read _GetLEFT;
      property NO_GRAVITY: Integer read _GetNO_GRAVITY;
      property RELATIVE_HORIZONTAL_GRAVITY_MASK: Integer read _GetRELATIVE_HORIZONTAL_GRAVITY_MASK;
      property RELATIVE_LAYOUT_DIRECTION: Integer read _GetRELATIVE_LAYOUT_DIRECTION;
      property RIGHT: Integer read _GetRIGHT;
      property START: Integer read _GetSTART;
      property TOP: Integer read _GetTOP;
      property VERTICAL_GRAVITY_MASK: Integer read _GetVERTICAL_GRAVITY_MASK;
  end;

  [JavaSignature('android/view/Gravity')]
  JGravity = interface(JObject)
  ['{E3894385-455C-4F06-9704-A6C2708CA188}']
    {Methods}
  end;

  TJGravity = class(TJavaGenericImport<JGravityClass, JGravity>) end;
{$ENDIF}

implementation

end.
