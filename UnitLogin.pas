unit UnitLogin;

interface

uses
  System.SysUtils, System.Classes, JS, Web, WEBLib.Graphics, WEBLib.Controls,
  WEBLib.Forms, WEBLib.Dialogs, Vcl.StdCtrls, WEBLib.StdCtrls, Vcl.Controls,
  WEBLib.ExtCtrls;

type
  TLoginForm = class(TWebForm)
    editUsername: TWebEdit;
    editPassword: TWebEdit;
    btnLogin: TWebButton;
    labelLoginTitle: TWebLabel;
    [async] procedure btnLoginClick(Sender: TObject);
    procedure WebFormCreate(Sender: TObject);
    procedure WebFormKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  LoginForm: TLoginForm;

implementation

uses UnitMain;

{$R *.dfm}

procedure TLoginForm.btnLoginClick(Sender: TObject);
var
  LoginCheck: String;
begin
  btnLogin.Caption := 'Wait...';

  LoginCheck := await(MainForm.XDataLogin(editUSername.Text, editPassword.Text));

  if LoginCheck <> 'Success' then
  begin
    console.log(LoginCheck);
    btnLogin.Caption := 'Retry';
    LoginCheck := StringReplace(LoginCheck,': ',':<br />',[]);
    LoginCheck := StringReplace(LoginCheck,'. ','.<br />',[]);
    if Trim(LoginCheck) = '/'
    then LoginCheck := 'System Error / Server connection could not be established.';
    MainForm.Toast(Copy(LoginCheck,1,Pos('/',LoginCheck) -2),Copy(LoginCheck, Pos('/',LoginCheck)+2,Length(LoginCheck)));
  end;
end;

procedure TLoginForm.WebFormCreate(Sender: TObject);
begin
  // Update Title
  labelLoginTitle.Caption := MainForm.Caption;

  // Update Icons
  asm
    const IconSet = pas.UnitIcons.DMIcons;
    document.getElementById('ticon-username').innerHTML = IconSet.Username;
    document.getElementById('ticon-password').innerHTML = IconSet.Password;
  end;
end;

procedure TLoginForm.WebFormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin

  if (Key = VK_RETURN) then btnLoginClick(Sender);
  
end;

end.
