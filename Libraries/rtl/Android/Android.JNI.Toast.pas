{*****************************************************************************}
{ @class  TJToast                                                             }
{ @data   2013/12/15                                                          }
{ @author Humphery(hjfactory@gmail.com) of devgear.co.kr                      }
{         - http://blog.hjf.pe.kr/                                            }
{ @brief  http://developer.android.com/reference/android/widget/Toast.html    }
{*****************************************************************************}
unit Android.JNI.Toast;

interface

{$IFDEF ANDROID}
uses
  Androidapi.JNIBridge,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.GraphicsContentViewText;

type
  JToast = interface;

  JToastClass = interface(JObjectClass)
  ['{F227353E-DCE9-404B-8129-6B1BEFE68151}']
    {Property methods}
    function _GetLENGTH_LONG: Integer; cdecl;
    function _GetLENGTH_SHORT: Integer; cdecl;
    {Methods}
    function init(context: JContext): JToast; cdecl; overload;
    function makeText(context: JContext; text: JCharSequence; duration: Integer): JToast; cdecl;
    {Properties}
    property LENGTH_LONG: Integer read _GetLENGTH_LONG;
    property LENGTH_SHORT: Integer read _GetLENGTH_SHORT;
  end;

  [JavaSignature('android/widget/Toast')]
  JToast = interface(JObject)
  ['{FC9B3DFD-38CC-4693-9F11-7F3E3647683F}']
    {Methods}
    procedure cancel; cdecl;
    function getDuration: Integer; cdecl;
    function getGravity: Integer; cdecl;
    function getHorizontalMargin: Single; cdecl;
    function getVerticalMargin: Single; cdecl;
    function getView: JView; cdecl;
    function getXOffset: Integer; cdecl;
    function getYOffset: Integer; cdecl;
    procedure setDuration(value: Integer); cdecl;
    procedure setGravity(gravity, xOffset, yOffset: Integer); cdecl;
    procedure setMargin(horizontalMargin, verticalMargin: Single); cdecl;
    procedure setText(s: JCharSequence); cdecl;
    procedure setView(view: JView); cdecl;
    procedure show; cdecl;
  end;
  TJToast = class(TJavaGenericImport<JToastClass, JToast>) end;
{$ENDIF}

implementation

end.
