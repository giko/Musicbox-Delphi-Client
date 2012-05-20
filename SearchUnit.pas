unit SearchUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Edit, FMX.Effects,
  FMX.Ani;

type
  TForm1 = class(TForm)
    COP: TCalloutPanel;
    Edit1: TEdit;
    Button1: TButton;
    ShadowEffect1: TShadowEffect;
    FA1: TFloatAnimation;
    procedure FormActivate(Sender: TObject);
    procedure FormDeactivate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.fmx}

procedure TForm1.FormActivate(Sender: TObject);
begin
 fa1.Start;
 edit1.Text:='';
 edit1.SetFocus;
end;

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 cop.Height:=89;
end;

procedure TForm1.FormDeactivate(Sender: TObject);
begin
 close;
end;

end.
