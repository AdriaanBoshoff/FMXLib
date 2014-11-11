unit VCLForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, IPPeerClient, IPPeerServer,
  System.Tether.Manager, System.Tether.AppProfile, Vcl.ComCtrls, Vcl.StdCtrls,
  Vcl.Imaging.jpeg, Vcl.ExtCtrls;

type
  TForm2 = class(TForm)
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TetheringManager: TTetheringManager;
    TetheringAppProfile: TTetheringAppProfile;
    btnDiscoverManager: TButton;
    mmoInfo: TMemo;
    btnPairManager: TButton;
    cbxRemoteManagers: TComboBox;
    cbxRemoteProfiles: TComboBox;
    btnPairProfile: TButton;
    edtPassword: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    mmoLog: TMemo;
    Label6: TLabel;
    btnSendStrHello: TButton;
    btnSendStrRS: TButton;
    Label7: TLabel;
    TabSheet3: TTabSheet;
    Image1: TImage;
    btnSendStreamImage: TButton;
    btnRunRemoteAction: TButton;
    TabSheet4: TTabSheet;
    Image2: TImage;
    OpenDialog1: TOpenDialog;
    Label8: TLabel;
    procedure btnPairManagerClick(Sender: TObject);
    procedure btnDiscoverManagerClick(Sender: TObject);
    procedure TetheringManagerEndManagersDiscovery(const Sender: TObject;
      const ARemoteManagers: TTetheringManagerInfoList);
    procedure TetheringManagerEndProfilesDiscovery(const Sender: TObject;
      const ARemoteProfiles: TTetheringProfileInfoList);
    procedure TetheringManagerAuthErrorFromLocal(const Sender: TObject;
      const AManagerIdentifier: string);
    procedure TetheringManagerAuthErrorFromRemote(const Sender: TObject;
      const AManagerIdentifier: string);
    procedure TetheringManagerRequestManagerPassword(const Sender: TObject;
      const ARemoteIdentifier: string; var Password: string);
    procedure TetheringManagerPairedFromLocal(const Sender: TObject;
      const AManagerInfo: TTetheringManagerInfo);
    procedure TetheringManagerPairedToRemote(const Sender: TObject;
      const AManagerInfo: TTetheringManagerInfo);
    procedure btnPairProfileClick(Sender: TObject);
    procedure TetheringManagerNewManager(const Sender: TObject;
      const AManagerInfo: TTetheringManagerInfo);
    procedure TetheringManagerRemoteManagerShutdown(const Sender: TObject;
      const AManagerIdentifier: string);
    procedure btnSendStrHelloClick(Sender: TObject);
    procedure btnSendStrRSClick(Sender: TObject);
    procedure TetheringAppProfileResourceReceived(const Sender: TObject;
      const AResource: TRemoteResource);
    procedure btnSendStreamImageClick(Sender: TObject);
    procedure btnRunRemoteActionClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image1Click(Sender: TObject);
  private
    { Private declarations }
    procedure InitControls;
    procedure LogAndInfo(ALog: string);
    procedure Log(ALog: string);
    procedure LoadImage(AStream: TStream);
  public
    { Public declarations }
  end;

var
  Form2: TForm2;

implementation

{$R *.dfm}

procedure TForm2.FormShow(Sender: TObject);
begin
  InitControls;
  PageControl1.TabIndex := 0;
end;

procedure TForm2.btnDiscoverManagerClick(Sender: TObject);
begin
  InitControls;

  LogAndInfo('동일 서브넷에서 접속대상을 찾습니다.');
  // (#1) 주변에서 TetheringManager 발견명령
  TetheringManager.DiscoverManagers;

  // (#2) TetheringAppProfile의 Group 기반으로 자동 연결
//  TetheringManager.AutoConnect(3000);

  //  (#3) 대상을 지정해 접속할 수 있습니다.
//  TetheringManager.DiscoverManagers(3000, 127.0.0.1);
end;

// 매니저 발견완료 이벤트
procedure TForm2.TetheringManagerEndManagersDiscovery(const Sender: TObject;
  const ARemoteManagers: TTetheringManagerInfoList);
var
  Info: TTetheringManagerInfo;
begin
  cbxRemoteManagers.Items.Clear;
  for Info in ARemoteManagers do
  begin
    Log(Format('[검색된 매니저]'#13#10#9'%s'#13#10#9'%s'#13#10#9'%s'#13#10#9'%s', [
      Info.ManagerIdentifier,
      Info.ManagerName,
      Info.ManagerText,
      Info.ConnectionString
    ]));
    cbxRemoteManagers.Items.Add(Format('%s(%s)', [Info.ManagerText, Info.ConnectionString]));
  end;
  if cbxRemoteManagers.Items.Count > 0 then
  begin
    cbxRemoteManagers.ItemIndex := 0;
    btnPairManager.Enabled := True;
  end;
  LogAndInfo(Format('접속 대상이 [%d]건 발견되었습니다.', [ARemoteManagers.Count]));
end;

// 선택한 매니저와 연결
procedure TForm2.btnPairManagerClick(Sender: TObject);
var
  N: Integer;
begin
  if cbxRemoteManagers.ItemIndex < 0 then
    Exit;

  N := cbxRemoteManagers.ItemIndex;
  LogAndInfo(TetheringManager.RemoteManagers[N].ManagerText + ' - 매니저와 페어링 시도');
  TetheringManager.PairManager(TetheringManager.RemoteManagers[N]);
end;

// 매니저 비밀번호 설정
procedure TForm2.TetheringManagerRequestManagerPassword(const Sender: TObject;
  const ARemoteIdentifier: string; var Password: string);
begin
  Password := edtPassword.Text;

  TThread.Synchronize(TThread.CurrentThread,
    procedure begin
      LogAndInfo('[비밀번호 요청] - ' + edtPassword.Text);
    end);
end;

// 프로필 발견완료 이벤트
procedure TForm2.TetheringManagerEndProfilesDiscovery(const Sender: TObject;
  const ARemoteProfiles: TTetheringProfileInfoList);
var
  Info: TTetheringProfileInfo;
begin
//  Log('TetheringManagerEndProfilesDiscovery');
  cbxRemoteProfiles.Items.Clear;
  for Info in ARemoteProfiles do
  begin
    Log(Format('[앱 프로필]'#13#10#9'%s'#13#10#9'%s'#13#10#9'%s'#13#10#9'%s'#13#10#9'%s', [
      Info.ManagerIdentifier,
      Info.ProfileIdentifier,
      info.ProfileText,
      Info.ProfileGroup,
      Info.ProfileType

    ]));
    cbxRemoteProfiles.Items.Add(Format('%s(%s)', [Info.ProfileText, Info.ProfileType]));
  end;
  if cbxRemoteProfiles.Items.Count > 0 then
  begin
    cbxRemoteProfiles.ItemIndex := 0;
    btnPairProfile.Enabled := True;
  end;
  LogAndInfo(Format('대상 프로필 [%d]건 발견되었습니다.', [ARemoteProfiles.Count]));
end;

// 선택한 프로필과 연결
procedure TForm2.btnPairProfileClick(Sender: TObject);
var
  N: Integer;
begin
  if cbxRemoteProfiles.ItemIndex < 0 then
    Exit;

  N := cbxRemoteProfiles.ItemIndex;
  LogAndInfo(TetheringManager.RemoteProfiles[N].ProfileText + ' - 프로필과 페어링 시도');
  if TetheringAppProfile.Connect(TetheringManager.RemoteProfiles[N]) then
  begin
    LogAndInfo('페어링 성공!!');
    InitControls;
  end;
end;

procedure TForm2.btnSendStrHelloClick(Sender: TObject);
begin
  LogAndInfo('문자열 전달 - 동반자 모바일앱에 Hello 전달');
  TetheringAppProfile.SendString(
    TetheringAppProfile.ConnectedProfiles.First,
    'HELLO',
    '안녕? App Tethering!!!');
end;

procedure TForm2.btnSendStrRSClick(Sender: TObject);
begin
  LogAndInfo('문자열 전달 - 동반자 모바일앱에 ReverseString 전달');
  TetheringAppProfile.SendString(
    TetheringAppProfile.ConnectedProfiles.First,
    'ReverseString',
    '반갑습니다.');
end;

procedure TForm2.TetheringAppProfileResourceReceived(const Sender: TObject;
  const AResource: TRemoteResource);
begin
  case AResource.ResType of
  // 데이터(SendString)
  TRemoteResourceType.Data:
    begin
      // ReverseString을 받은 모바일에서 전송한 응답
      if AResource.Hint = 'EchoString' then
        LogAndInfo('EchoString : ' + AResource.Value.AsString)
    end;
  // 스트림(SendStream)
  TRemoteResourceType.Stream:
    begin
      // 모바일에서 전송한 이미지
      if AResource.Hint = 'FMXIMG' then
      begin
        LogAndInfo('이미지 수신');
        LoadImage(AResource.Value.AsStream);
      end;
    end;
  end;
end;

procedure TForm2.btnSendStreamImageClick(Sender: TObject);
var
  Stream: TMemoryStream;
begin
  LogAndInfo('데이터 전달 - 이미지 데이터를 TStream으로 동반자 모바일앱에 전달');
  Stream := TMemoryStream.Create;
  try
    Image1.Picture.Graphic.SaveToStream(Stream);
      TetheringAppProfile.SendStream(TetheringManager.RemoteProfiles.First,
      'VCLIMG',
      Stream
    );
  finally
    Stream.Free;
  end;
  PageControl1.TabIndex := 2;
//  TetheringAppProfile.SendStream()
end;

// 원격지의 액션 호출
procedure TForm2.btnRunRemoteActionClick(Sender: TObject);
begin
  LogAndInfo('원격 명령 호출 - 원격지(동방자 모바일 앱)의 ActionSendImg 액션 호출');
  TetheringAppProfile.RunRemoteAction(
    TetheringManager.RemoteProfiles.First,
    'ActionSendImg'
  );
  PageControl1.TabIndex := 3;
end;

////////////////////////////////////////

procedure TForm2.LoadImage(AStream: TStream);
var
  wic: TWICImage; // Microsoft Windows Imaging Component
begin
  if AStream.Size > 10 then
  begin
    wic := TWICImage.Create;
    try
      wic.LoadFromStream(AStream);
      Image2.Picture.Assign(wic);
    finally
      wic.Free;
    end;
  end;
end;

procedure TForm2.Log(ALog: string);
begin
  mmoLog.Lines.Add(ALog);
end;

procedure TForm2.LogAndInfo(ALog: string);
begin
  mmoInfo.Lines.Add(ALog);
  mmoLog.Lines.Add(ALog);
end;

procedure TForm2.Image1Click(Sender: TObject);
begin
  if OpenDialog1.Execute then
    Image1.Picture.LoadFromFile(OpenDialog1.FileName);
end;

procedure TForm2.InitControls;
var
  B: Boolean;
begin
  B := TetheringManager.PairedManagers.Count > 0;

  btnPairManager.Enabled := B;
  btnPairProfile.Enabled := B;
  btnSendStrHello.Enabled := B;
  btnSendStrRS.Enabled := B;
  btnSendStreamImage.Enabled := B;
  btnRunRemoteAction.Enabled := B;
end;

procedure TForm2.TetheringManagerAuthErrorFromLocal(const Sender: TObject;
  const AManagerIdentifier: string);
begin
  // TetheringManager 비밀번호 인증 실패
  LogAndInfo('Local 인증실패 / ' + AManagerIdentifier);
end;

procedure TForm2.TetheringManagerAuthErrorFromRemote(const Sender: TObject;
  const AManagerIdentifier: string);
begin
  // TetheringManager 비밀번호 인증 실패
  LogAndInfo('Remote 인증실패 / ' + AManagerIdentifier);
end;

procedure TForm2.TetheringManagerNewManager(const Sender: TObject;
  const AManagerInfo: TTetheringManagerInfo);
begin
  LogAndInfo('접속 대상이 발견되었습니다.' + AManagerInfo.ManagerText);
end;

procedure TForm2.TetheringManagerPairedFromLocal(const Sender: TObject;
  const AManagerInfo: TTetheringManagerInfo);
begin
  LogAndInfo('TetheringManagerPairedFromLocal');
end;

procedure TForm2.TetheringManagerPairedToRemote(const Sender: TObject;
  const AManagerInfo: TTetheringManagerInfo);
begin
  LogAndInfo('TetheringManagerPairedToRemote');
end;

procedure TForm2.TetheringManagerRemoteManagerShutdown(const Sender: TObject;
  const AManagerIdentifier: string);
begin
  LogAndInfo('접속이 끊어졌습니다. / ' + AManagerIdentifier);
  InitControls;
end;

end.
