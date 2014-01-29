FMX.Devgear
===========

Firemonkey(Delphi) libraries and sample

* BitmapUrl : 웹상의 Image를 Bitmap에 할당하기 위한 Class helper
  * http://blog.hjf.pe.kr/99
* Android Toast : 안드로이드용 Toast Message
  * http://blog.hjf.pe.kr/101

설명
====
BitmapUrl
----

![ScreenShot](https://github.com/hjfactory/FMX.Devgear/blob/master/Samples/BitmapUrl/BitmapUrl.jpg?raw=true)

 * procedure LoadFromUrl(AUrl: string; var outSize: Int64); overload;
 * procedure LoadFromUrl(AUrl: string); overload;
 * procedure LoadThumbnailFromUrl(AUrl: string; const AFitWidth, AFitHeight: Integer);

Toast(Android only)
----

![ScreenShot](https://github.com/hjfactory/FMX.Devgear/blob/master/Samples/Android_Toast/ToastMessage.png?raw=true)

 * procedure ToastMessage(const AMsg: string; ADuration: TToastDuration = tdLengthShort); overload;
 * procedure ToastMessage(const AMsg: string; ADuration: TToastDuration; APosition: TToastPosition; AXOffset, AYOffset: Integer); overload;
  * Gravity가 적용되어 Toast Message의 위치설정 가능
