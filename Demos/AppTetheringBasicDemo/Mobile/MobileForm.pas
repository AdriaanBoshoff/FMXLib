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

// ActionSendImg ���� �� �����̹��� ������ ����
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
  Log('�����͸� �����մϴ�.');
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
// ���� �ܼ� �α�

procedure TForm3.Log(ALog: string);
begin
  Memo1.Lines.Add(ALog);
end;

procedure TForm3.TetheringAppProfile1AcceptResource(const Sender: TObject;
  const AProfileId: string; const AResource: TCustomRemoteItem;
  var AcceptResource: Boolean);
begin
  Log('���ҽ� ���� ��� - ' + AResource.Hint);
  AcceptResource := True;
end;

procedure TForm3.TetheringAppProfile1ActionUpdated(const Sender: TObject;
  const AResource: TRemoteAction);
begin
  Log('���ݸ��(Action)�� ������Ʈ �Ǿ����ϴ�.');
end;

procedure TForm3.TetheringAppProfile1Disconnect(const Sender: TObject;
  const AProfileInfo: TTetheringProfileInfo);
begin
  Log('������ ������ ���������ϴ�.');
end;

procedure TForm3.TetheringAppProfile1RemoteProfileUpdate(const Sender: TObject;
  const AProfileId: string);
begin
  Log('������ �������� ������Ʈ�Ǿ����ϴ�.');
end;

procedure TForm3.TetheringAppProfile1ResourceUpdated(const Sender: TObject;
  const AResource: TRemoteResource);
begin
  Log('���� ���ҽ��� ����Ǿ����ϴ�.');
end;

procedure TForm3.TetheringManager1AuthErrorFromLocal(const Sender: TObject;
  const AManagerIdentifier: string);
begin
  Log('������ ���� ����');
end;

procedure TForm3.TetheringManager1AuthErrorFromRemote(const Sender: TObject;
  const AManagerIdentifier: string);
begin
  Log('�������� ���� ����');
end;

procedure TForm3.TetheringManager1EndAutoConnect(Sender: TObject);
begin
  Log('�ڵ� ���� �Ϸ�');
end;

procedure TForm3.TetheringManager1EndManagersDiscovery(const Sender: TObject;
  const ARemoteManagers: TTetheringManagerInfoList);
begin
  Log('�Ŵ��� Ž�� �۾� �Ϸ�');
end;

procedure TForm3.TetheringManager1EndProfilesDiscovery(const Sender: TObject;
  const ARemoteProfiles: TTetheringProfileInfoList);
begin
  Log('������ Ž�� �۾� �Ϸ�');
end;

procedure TForm3.TetheringManager1NewManager(const Sender: TObject;
  const AManagerInfo: TTetheringManagerInfo);
begin
  Log('���ο� �Ŵ����� �߰ߵǾ����ϴ�.');
end;

procedure TForm3.TetheringManager1PairedFromLocal(const Sender: TObject;
  const AManagerInfo: TTetheringManagerInfo);
begin
  Log('������ �Ŵ����� ���Ǿ����ϴ�.');
end;

procedure TForm3.TetheringManager1PairedToRemote(const Sender: TObject;
  const AManagerInfo: TTetheringManagerInfo);
begin
  Log('������ �޴����� ���Ǿ����ϴ�.');
end;

procedure TForm3.TetheringManager1RemoteManagerShutdown(const Sender: TObject;
  const AManagerIdentifier: string);
begin
  Log('���� �Ŵ��� ��������');
end;

procedure TForm3.TetheringManager1RequestManagerPassword(const Sender: TObject;
  const ARemoteIdentifier: string; var Password: string);
begin
  Log('�Ŵ��� ��й�ȣ ��û');
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
  Log('�Ŵ��� ���� �����Ǿ����ϴ�. - ' + AManagerInfo.ManagerText);
end;

end.
