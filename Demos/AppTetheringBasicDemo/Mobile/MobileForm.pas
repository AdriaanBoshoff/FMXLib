unit MobileForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, IPPeerClient,
  IPPeerServer, System.Tether.Manager, System.Tether.AppProfile, FMX.Layouts,
  FMX.Memo, FMX.Objects, System.Actions, FMX.ActnList, FMX.StdCtrls,
  FMX.TabControl;

type
  TForm3 = class(TForm)
    TetheringManager1: TTetheringManager;
    TetheringAppProfile1: TTetheringAppProfile;
    ActionList1: TActionList;
    ActionSendImg: TAction;
    OpenDialog1: TOpenDialog;
    TabControl1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    Memo1: TMemo;
    imgRecv: TImage;
    imgSend: TImage;
    Button1: TButton;
    Layout1: TLayout;
    Button2: TButton;
    Button3: TButton;
    procedure TetheringAppProfile1ResourceReceived(const Sender: TObject;
      const AResource: TRemoteResource);
    procedure ActionSendImgExecute(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure TetheringManager1UnPairManager(const Sender: TObject;
      const AManagerInfo: TTetheringManagerInfo);
    procedure TetheringManager1RequestStorage(const Sender: TObject;
      var AStorage: TTetheringCustomStorage);
    procedure TetheringManager1RequestManagerPassword(const Sender: TObject;
      const ARemoteIdentifier: string; var Password: string);
    procedure TetheringManager1RemoteManagerShutdown(const Sender: TObject;
      const AManagerIdentifier: string);
    procedure TetheringManager1PairedToRemote(const Sender: TObject;
      const AManagerInfo: TTetheringManagerInfo);
    procedure TetheringManager1PairedFromLocal(const Sender: TObject;
      const AManagerInfo: TTetheringManagerInfo);
    procedure TetheringManager1NewManager(const Sender: TObject;
      const AManagerInfo: TTetheringManagerInfo);
    procedure TetheringManager1EndProfilesDiscovery(const Sender: TObject;
      const ARemoteProfiles: TTetheringProfileInfoList);
    procedure TetheringManager1EndManagersDiscovery(const Sender: TObject;
      const ARemoteManagers: TTetheringManagerInfoList);
    procedure TetheringManager1EndAutoConnect(Sender: TObject);
    procedure TetheringManager1AuthErrorFromRemote(const Sender: TObject;
      const AManagerIdentifier: string);
    procedure TetheringManager1AuthErrorFromLocal(const Sender: TObject;
      const AManagerIdentifier: string);
    procedure TetheringAppProfile1AcceptResource(const Sender: TObject;
      const AProfileId: string; const AResource: TCustomRemoteItem;
      var AcceptResource: Boolean);
    procedure TetheringAppProfile1ActionUpdated(const Sender: TObject;
      const AResource: TRemoteAction);
    procedure TetheringAppProfile1Disconnect(const Sender: TObject;
      const AProfileInfo: TTetheringProfileInfo);
    procedure TetheringAppProfile1RemoteProfileUpdate(const Sender: TObject;
      const AProfileId: string);
    procedure TetheringAppProfile1ResourceUpdated(const Sender: TObject;
      const AResource: TRemoteResource);
  private
    { Private declarations }
    procedure Log(ALog: string);
  public
    { Public declarations }
  end;

var
  Form3: TForm3;

implementation

{$R *.fmx}

uses
  System.StrUtils, PhotoFrame;

// ActionSendImg 실행 시 전송이미지 데이터 전송
procedure TForm3.ActionSendImgExecute(Sender: TObject);
var
  Stream: TMemoryStream;
begin
  Stream := TMemoryStream.Create;
  try
    imgSend.Bitmap.SaveToStream(Stream);

    TetheringAppProfile1.SendStream(TetheringManager1.RemoteProfiles.First, 'FMXIMG', Stream);
  finally
    Stream.Free;
  end;
end;

procedure TForm3.Button1Click(Sender: TObject);
begin
  imgRecv.Bitmap.Assign(nil);
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
{$IF Defined(ANDROID) OR Defined(IOS)}
  TfrPhoto.CreateAndShow(
    Self,
    procedure(ABitmap: TBitmap)
    begin
      imgSend.Bitmap.Assign(ABitmap);
    end);
  //
{$ELSE}
  if OpenDialog1.Execute then
  begin
    imgSend.Bitmap.LoadFromFile(OpenDialog1.FileName);
  end;
{$IFEND}
end;

procedure TForm3.TetheringAppProfile1ResourceReceived(const Sender: TObject;
  const AResource: TRemoteResource);
begin
  Log('데이터를 수신합니다.');
  case AResource.ResType of
  TRemoteResourceType.Data:
    begin
      if AResource.Hint = 'HELLO' then
        Log(AResource.Value.AsString)
      else if AResource.Hint = 'ReverseString' then
      begin
        Log(AResource.Value.AsString);
        TetheringAppProfile1.SendString(TetheringManager1.RemoteProfiles.First, 'EchoString', ReverseString(AResource.Value.AsString));
      end;
      TabControl1.TabIndex := 0;
    end;
  TRemoteResourceType.Stream:
    begin
      if AResource.Hint = 'VCLIMG' then
      begin
        imgRecv.Bitmap.LoadFromStream(AResource.Value.AsStream);
      end;
      TabControl1.TabIndex := 1;
    end;
  end;
end;

////////////////////////////////////////////////////////////////////////////////
// 이하 단순 로그

procedure TForm3.Log(ALog: string);
begin
  Memo1.Lines.Add(ALog);
end;

procedure TForm3.TetheringAppProfile1AcceptResource(const Sender: TObject;
  const AProfileId: string; const AResource: TCustomRemoteItem;
  var AcceptResource: Boolean);
begin
  Log('리소스 수신 허락 - ' + AResource.Hint);
  AcceptResource := True;
end;

procedure TForm3.TetheringAppProfile1ActionUpdated(const Sender: TObject;
  const AResource: TRemoteAction);
begin
  Log('원격명령(Action)이 업데이트 되었습니다.');
end;

procedure TForm3.TetheringAppProfile1Disconnect(const Sender: TObject;
  const AProfileInfo: TTetheringProfileInfo);
begin
  Log('프로필 연결이 끊어졌습니다.');
end;

procedure TForm3.TetheringAppProfile1RemoteProfileUpdate(const Sender: TObject;
  const AProfileId: string);
begin
  Log('원격지 프로필이 업데이트되었습니다.');
end;

procedure TForm3.TetheringAppProfile1ResourceUpdated(const Sender: TObject;
  const AResource: TRemoteResource);
begin
  Log('공유 리소스가 변경되었습니다.');
end;

procedure TForm3.TetheringManager1AuthErrorFromLocal(const Sender: TObject;
  const AManagerIdentifier: string);
begin
  Log('로컬의 인증 오류');
end;

procedure TForm3.TetheringManager1AuthErrorFromRemote(const Sender: TObject;
  const AManagerIdentifier: string);
begin
  Log('원격지의 인증 오류');
end;

procedure TForm3.TetheringManager1EndAutoConnect(Sender: TObject);
begin
  Log('자동 접속 완료');
end;

procedure TForm3.TetheringManager1EndManagersDiscovery(const Sender: TObject;
  const ARemoteManagers: TTetheringManagerInfoList);
begin
  Log('매니저 탐색 작업 완료');
end;

procedure TForm3.TetheringManager1EndProfilesDiscovery(const Sender: TObject;
  const ARemoteProfiles: TTetheringProfileInfoList);
begin
  Log('프로필 탐색 작업 완료');
end;

procedure TForm3.TetheringManager1NewManager(const Sender: TObject;
  const AManagerInfo: TTetheringManagerInfo);
begin
  Log('새로운 매니저가 발견되었습니다.');
end;

procedure TForm3.TetheringManager1PairedFromLocal(const Sender: TObject;
  const AManagerInfo: TTetheringManagerInfo);
begin
  Log('로컬의 매니저와 페어링되었습니다.');
end;

procedure TForm3.TetheringManager1PairedToRemote(const Sender: TObject;
  const AManagerInfo: TTetheringManagerInfo);
begin
  Log('원격의 메니저와 페어링되었습니다.');
end;

procedure TForm3.TetheringManager1RemoteManagerShutdown(const Sender: TObject;
  const AManagerIdentifier: string);
begin
  Log('원격 매니저 연결해제');
end;

procedure TForm3.TetheringManager1RequestManagerPassword(const Sender: TObject;
  const ARemoteIdentifier: string; var Password: string);
begin
  Log('매니저 비밀번호 요청');
  Password := '1234';
end;

procedure TForm3.TetheringManager1RequestStorage(const Sender: TObject;
  var AStorage: TTetheringCustomStorage);
begin
  Log('');
end;

procedure TForm3.TetheringManager1UnPairManager(const Sender: TObject;
  const AManagerInfo: TTetheringManagerInfo);
begin
  Log('매니저 페어링이 해제되었습니다. - ' + AManagerInfo.ManagerText);
end;

end.
