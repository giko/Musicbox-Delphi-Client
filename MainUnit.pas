unit MainUnit;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Objects, FMX.Ani,
  FMX.ExtCtrls, FMX.Effects, FMX.Colors, FMX.Layouts, FMX.TreeView,
  FMX.TabControl;

const
 ColChecked=$AA0040FF;//Интенсивность, RGB

type
  TMainForm = class(TForm)
    CornerButton1: TCornerButton;
    CB1: TColorButton;
    BlurEffect1: TBlurEffect;
    ButLabel: TLabel;
    Button1: TButton;
    FloatAnimation1: TFloatAnimation;
    CenterVSB: TVertScrollBox;
    Panel1: TPanel;
    LeftVSB: TVertScrollBox;
    PLabel1: TLabel;
    PLabel2: TLabel;
    InnerGlowEffect1: TInnerGlowEffect;
    LBImage: TImage;
    TC1: TTabControl;
    TabItem1: TTabItem;
    TabItem2: TTabItem;
    TabItem3: TTabItem;
    TabControl1: TTabControl;
    TabItem5: TTabItem;
    TabItem6: TTabItem;
    TabItem7: TTabItem;
    StyleBook1: TStyleBook;
    TabControl2: TTabControl;
    TabItem4: TTabItem;
    TabItem8: TTabItem;
    procedure CornerButton1Click(Sender: TObject);
    procedure CornerButton1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Single);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;
 TLeftButton=Record
   But:TColorButton;
   Cap:TLabel;
   img:TImage;
 End;
 TCenterPanel=record
  cap1,cap2:TLabel;
  Panel:Tpanel;
 end;
 TPositionModeLBCap=record
   X,W:single;
 end;
 TLeftButClickClass=class(TPersistent)
  public
    procedure Proc1(Sender: TObject);
 end;

var
  MainForm: TMainForm;
  StartLeftButtonColor:cardinal;
  LeftButsWithPic:boolean;//Выводить картинки в левых кнопках
  leftButtonChecked:integer;//Номер выбранной в данный момент клавиши
  LBPObj:TLeftButClickClass;
  StartMode,ModePictOn:TPositionModeLBCap;//Расположение и размеры Label'ов слева, в зав-ти от наличия фоток
  LButs:array of TLeftButton;//Левые кнопки (в смысле дислокации)
  CPanels:array of TCenterPanel;

implementation

{$R *.fmx}

uses SearchUnit;


procedure TLeftButClickClass.Proc1(Sender: TObject);
//Общая процедура обработки нажатия всех клавиш и панелей (№ клавиши\панели - t)
var
 t,i:integer;
begin
 if Sender is TColorButton then
 begin
  t:=TColorButton(Sender).Tag;
  if leftButtonChecked=t then exit;
  leftButtonChecked:=t;
  for i:=0 to high(LButs)do
   LButs[i].But.Color:=StartLeftButtonColor;
  mainform.InnerGlowEffect1.Enabled:=false;
  Lbuts[t].but.Color:=ColChecked;
  mainform.InnerGlowEffect1.Parent:=Lbuts[t].Cap;
  mainform.BlurEffect1.Parent:=Lbuts[t].Cap;
  mainform.BlurEffect1.Enabled:=true;
  mainform.InnerGlowEffect1.Enabled:=true;
  application.ProcessMessages;
  sleep(250);                {}
  mainform.BlurEffect1.Enabled:=false;{}
 end else//Нажата панель
 begin
  t:=TPanel(Sender).Tag;
  showmessage('Нажата панель №'+inttostr(t));{}
 end;
end;


Procedure NewLeftButton(Caption:string);
//Создание ещё одной кнопки слева
begin
 setlength(LButs,high(LButs)+2);
 with LButs[high(LButs)] do
 begin
  but:=TColorButton.Create(nil);
  but.Parent:=MainForm.LeftVSB;
  cap:=TLabel.Create(nil);
  cap.Parent:=but;
  but.Width:=LButs[0].But.Width;
  but.Height:=LButs[0].But.Height;
  but.Color:=LButs[0].But.Color;
  cap.Position:=LButs[0].Cap.Position;
  cap.Width:=LButs[0].Cap.Width;
  cap.Height:=LButs[0].Cap.Height;
  but.Position.X:=LButs[0].But.Position.X;
  but.Position.Y:=LButs[high(LButs)-1].But.Position.Y+LButs[0].But.Height;
  cap.Font:=Lbuts[0].Cap.Font;
  cap.TextAlign:=Lbuts[0].Cap.TextAlign;
  cap.Text:=caption;
  but.Tag:=LButs[high(LButs)-1].But.Tag+1;
  But.OnClick:=LBPObj.Proc1;
  img:=TImage.Create(nil);
  img.Parent:=but;
  img.Position:=MainForm.LBImage.Position;
  img.Width:=MainForm.LBImage.Width;
  img.Height:=MainForm.LBImage.Height;
 end;
 MainForm.LeftVSB.Realign;
end;

Procedure SetKolvoLeftBut(k:integer);
//Создаёт нужное k левых кнопок, остальные нещадно удаляет
var
 i:integer;
  procedure SetModeLCap(var C:TLabel;M:TPositionModeLBCap);
  begin
   c.Position.X:=m.X;
   c.Width:=m.W;
  end;
begin
 while high(LButs)+1<k do NewLeftButton('');//Досоздали
 for i:=k to high(LButs)do
 begin
  LButs[i].Cap.Free;
  LButs[i].img.Free;
  LButs[i].But.Free;
 end;
 setlength(LButs,k);
 for i:=0 to k-1 do
  if LeftButsWithPic then
   SetModeLCap(LButs[i].Cap,ModePictOn)
  else
   SetModeLCap(LButs[i].Cap,StartMode);//Располагаем Надписи, в зав-ти от наличия картинок
 MainForm.LeftVSB.Realign;
end;

Procedure NewCenterPanel(Caption1,caption2:string);
//Создание ещё одной панели в центре
begin
 setlength(CPanels,high(CPanels)+2);
 with CPanels[high(CPanels)] do
 begin
  Panel:=tPanel.Create(nil);
  Panel.Width:=CPanels[0].Panel.Width;
  Panel.Height:=CPanels[0].Panel.Height;
  Panel.Position.Y:=CPanels[high(CPanels)-1].Panel.Position.Y+CPanels[0].Panel.Height;
  panel.Parent:=MainForm.CenterVSB;
  cap1:=TLabel.Create(nil);
  cap1.Parent:=Panel;
  cap2:=TLabel.Create(nil);
  cap2.Parent:=Panel;
  cap1.Text:=Caption1;
  cap2.Text:=Caption2;
  cap1.Align:=CPanels[0].cap1.Align;
  cap2.Align:=CPanels[0].cap2.Align;
  cap1.Font:=CPanels[0].cap1.font;
  cap2.Font:=CPanels[0].cap2.font;
  cap1.VertTextAlign:=CPanels[0].cap1.VertTextAlign;
  cap2.VertTextAlign:=CPanels[0].cap2.VertTextAlign;
  cap1.Width:=CPanels[0].cap1.Width;
  cap2.Height:=CPanels[0].cap2.Height;
  Panel.Tag:=CPanels[high(CPanels)-1].Panel.Tag+1;
  panel.OnDblClick:=LBPObj.Proc1;
 end;
 MainForm.CenterVSB.Realign;
end;

Procedure SetKolvoCenterPanels(k:integer);
//Создаёт нужное k центральных панелей
var
 i:integer;
begin
 while high(CPanels)+1<k do NewCenterPanel('','');//Досоздали
 for i:=k to high(CPanels)do
 begin
  CPanels[i].Cap1.Free;
  CPanels[i].Cap2.Free;
  CPanels[i].Panel.Free;
 end;
 setlength(CPanels,k);
 MainForm.CenterVSB.Realign;
end;

procedure TMainForm.Button1Click(Sender: TObject);
begin
 close;
end;

procedure TMainForm.CornerButton1Click(Sender: TObject);
begin
 form1.show;
end;

procedure TMainForm.CornerButton1MouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Single);
begin
 form1.Top:=round(CornerButton1.Height+CornerButton1.Position.Y+top);{}
 form1.Left:=round(CornerButton1.Width/2+CornerButton1.Position.X+left-form1.COP.Width/2);{}
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
 StartLeftButtonColor:=cb1.Color;
 setlength(LButs,1);//Задание первого элемента массива левых кнопок
 LButs[0].But:=CB1;
 Lbuts[0].Cap:=ButLabel;
 cb1.OnClick:=LBPObj.Proc1;
 leftButtonChecked:=-1;
 setlength(CPanels,1);//Задание первого элемента массива левых кнопок
 CPanels[0].Panel:=Panel1;
 CPanels[0].cap1:=PLabel1;
 CPanels[0].cap2:=PLabel2;
 panel1.Width:=CenterVSB.Width-20;
 panel1.OnDblClick:=LBPObj.Proc1;
 with StartMode do
 begin
  X:=ButLabel.Position.X;
  w:=ButLabel.Width;
 end;
 with ModePictOn do
 begin
  X:=ButLabel.Position.X+LBImage.Width+LBImage.Position.X;
  w:=ButLabel.Width-(x-ButLabel.Position.X);
 end;

 LeftButsWithPic:=LBImage.Visible;{}

 SetKolvoLeftBut(5);{}

 NewCenterPanel('NEW','PANEL');{}

end;

end.
