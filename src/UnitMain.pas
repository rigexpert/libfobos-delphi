unit UnitMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls

  , fobos
  , FobosSDRThread

  ;

type
  TFormMain = class(TForm)
    ButtonEnumerate: TButton;
    ComboBoxDevices: TComboBox;
    ButtonOpen: TButton;
    EditApiInfo: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    EditBoardInfo: TEdit;
    Label3: TLabel;
    EditSerial: TEdit;
    ButtonClose: TButton;
    ComboBoxSampleRate: TComboBox;
    Label4: TLabel;
    EditFrequency: TEdit;
    Label5: TLabel;
    ButtonSetFrequency: TButton;
    ScrollBarLNA: TScrollBar;
    Label6: TLabel;
    Label7: TLabel;
    ScrollBarVGA: TScrollBar;
    PaintBox1: TPaintBox;
    Timer1: TTimer;
    Label8: TLabel;
    EditRxCount: TEdit;
    Label9: TLabel;
    EditSampleRate: TEdit;
    Timer2: TTimer;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    ButtonStart: TButton;
    ButtonStop: TButton;
    ButtonStartSync: TButton;
    ButtonReadSync: TButton;
    ButtonStopSync: TButton;
    CheckBoxLoop: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure ButtonEnumerateClick(Sender: TObject);
    procedure ButtonOpenClick(Sender: TObject);
    procedure ScrollBarLNAChange(Sender: TObject);
    procedure ScrollBarVGAChange(Sender: TObject);
    procedure ButtonStartClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure ComboBoxSampleRateChange(Sender: TObject);
    procedure ButtonSetFrequencyClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure ButtonCloseClick(Sender: TObject);
    procedure ButtonStartSyncClick(Sender: TObject);
    procedure ButtonReadSyncClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ButtonStopSyncClick(Sender: TObject);
  private
    { Private declarations }
    procedure ReadSamples(Sender: TObject; ComplexSamplesF32: Pointer; Count: Cardinal);
  public
    { Public declarations }
    Device: Pointer;
    Thread: TFobosSDRThread;
    SampleRates: array of Double;
    ComplexSamples: array of Single;
    Points: array of TPoint;
    NewData: Boolean;
    RxBufsCount: Cardinal;
    RxSamplesCount: Cardinal;
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

procedure TFormMain.ButtonCloseClick(Sender: TObject);
begin
  Timer1.Enabled:=False;
  Timer2.Enabled:=False;
  if Assigned(Device) then
    fobos_rx_close(Device);
  Device:=nil;
  EditApiInfo.Clear();
  EditBoardInfo.Clear();
  EditSerial.Clear();
  EditRxCount.Clear();
  EditSampleRate.Clear();
  ButtonOpen.Enabled:=True;
  ButtonClose.Enabled:=False;
  ComboBoxSampleRate.Clear();
  ComboBoxSampleRate.Enabled:=False;
  EditFrequency.Enabled:=False;
  ButtonSetFrequency.Enabled:=False;
  ScrollBarLNA.Enabled:=False;
  ScrollBarVGA.Enabled:=False;
  ButtonStart.Enabled:=False;
  ButtonStopSync.Enabled:=False;
  ButtonReadSync.Enabled:=False;
end;

procedure TFormMain.ButtonEnumerateClick(Sender: TObject);
var Serials: array [0..255] of AnsiChar;
    Count: Integer;
begin
  FillChar(serials[0], sizeof(Serials), 0);
  Count:=fobos_rx_list_devices(@Serials[0]);
  if Count>0 then
  begin
    ComboBoxDevices.Items.BeginUpdate();
    ComboBoxDevices.Items.Delimiter:=' ';
    ComboBoxDevices.Items.DelimitedText:=Serials;
    ComboBoxDevices.Items.EndUpdate();
    ComboBoxDevices.ItemIndex:=0;
    ButtonOpen.Enabled:=True;
  end;

end;

procedure TFormMain.ButtonOpenClick(Sender: TObject);
var Result, i: integer;
    lib_version: array [0..63] of AnsiChar;
    drv_version: array [0..63] of AnsiChar;
    hw_revision: array [0..63] of AnsiChar;
    fw_version:  array [0..63] of AnsiChar;
    hw_serial:  array [0..63] of AnsiChar;
    Count: Cardinal;
begin
  if Assigned(Device) then Exit;
  Result:=fobos_rx_open(Device, ComboBoxDevices.ItemIndex);
  if (Result=0) and Assigned(Device)
    then
      begin
        if (fobos_rx_get_api_info(@lib_version[0], @drv_version[0]) = 0)
          then
            begin
              EditApiInfo.Text:='lib v.'+lib_version+' drv '+drv_version;
            end;
        if (fobos_rx_get_board_info(Device, @hw_revision[0], @fw_version[0], 0, 0, @hw_serial[0]) = 0)
          then
            begin
              EditBoardInfo.Text:='HW: rev.'+hw_revision+' FV: v.'+fw_version;
              EditSerial.Text:=hw_serial;
            end;
        if (fobos_rx_get_samplerates(Device, nil, Count)=0)
          then
            begin
              SetLength(SampleRates, Count);
              fobos_rx_get_samplerates(Device, @SampleRates[0], Count);
              ComboBoxSampleRate.Clear();
              ComboBoxSampleRate.Items.BeginUpdate();
              for i := 0 to Count-1 do
                begin
                  ComboBoxSampleRate.Items.Add(FloatToStr(SampleRates[i]));
                end;
              ComboBoxSampleRate.Items.EndUpdate();
              ComboBoxSampleRate.ItemIndex:=0;
            end;

        fobos_rx_set_frequency(Device, StrToFloat(EditFrequency.Text)*1E6, 0);
        fobos_rx_set_samplerate(Device, SampleRates[ComboBoxSampleRate.ItemIndex], 0);
        fobos_rx_set_lna_gain(Device, ScrollBarLNA.Position);
        fobos_rx_set_vga_gain(Device, ScrollBarVGA.Position);

        ButtonOpen.Enabled:=False;
        ButtonClose.Enabled:=True;
        ComboBoxSampleRate.Enabled:=True;
        EditFrequency.Enabled:=True;
        ButtonSetFrequency.Enabled:=True;
        ScrollBarLNA.Enabled:=True;
        ScrollBarVGA.Enabled:=True;
        ButtonStart.Enabled:=True;
        ButtonStartSync.Enabled:=True;
        CheckBoxLoop.Enabled:=True;
      end
    else
      begin
        Result:=-1;
      end;
end;

procedure TFormMain.ButtonReadSyncClick(Sender: TObject);
var Result: Integer;
    Ancual: Cardinal;
begin
  while True do
    begin
      if Assigned(Device) then
        begin
          Result:=fobos_rx_read_sync(Device, @ComplexSamples[0], @Ancual);
          if Result=0 then
            begin
              Inc(RxBufsCount);
              inc(RxSamplesCount, Ancual);
              NewData:=true;
            end;
        end;
      Application.ProcessMessages();
      if not ButtonReadSync.Enabled then
        Break;
      if not CheckBoxLoop.Checked then
        Break;
    end;
end;

procedure TFormMain.ButtonSetFrequencyClick(Sender: TObject);
begin
  if Assigned(Device) then
    fobos_rx_set_frequency(Device, StrToFloat(EditFrequency.Text)*1E6, 0);
end;

procedure TFormMain.ButtonStartClick(Sender: TObject);
begin
  if Assigned(Thread) then exit;
  if Assigned(Device) then
    begin
      RxBufsCount:=0;
      RxSamplesCount:=0;


      Thread:= TFobosSDRThread.Create(Device, 65536, ReadSamples);
      ComboBoxSampleRate.Enabled:=False;
      ButtonStart.Enabled:=False;
      ButtonStop.Enabled:=True;
      ButtonClose.Enabled:=False;
      ButtonStartSync.Enabled:=False;
    end;
end;

procedure TFormMain.ButtonStartSyncClick(Sender: TObject);
var Result: Integer;
begin
  if Assigned(Device) then
    begin
      Result:=fobos_rx_start_sync(Device, 65536);
      if Result=0 then
        begin
          SetLength(ComplexSamples, 65536*2);
          ButtonStartSync.Enabled:=False;
          ButtonStart.Enabled:=False;
          ButtonStopSync.Enabled:=True;
          ButtonReadSync.Enabled:=True;
          CheckBoxLoop.Enabled:=True;
        end;
    end;
end;

procedure TFormMain.ButtonStopClick(Sender: TObject);
begin
  if Assigned(Device) then
    begin
      fobos_rx_cancel_async(Device);
      FreeAndNil(Thread);
      ButtonStart.Enabled:=True;
      ButtonStop.Enabled:=False;
      ComboBoxSampleRate.Enabled:=True;
      ButtonClose.Enabled:=True;
      ButtonStartSync.Enabled:=True;
    end;
end;

procedure TFormMain.ButtonStopSyncClick(Sender: TObject);
begin
  if Assigned(Device) then
    begin
      fobos_rx_stop_sync(Device);
      ButtonStopSync.Enabled:=False;
      ButtonReadSync.Enabled:=False;
      ButtonStart.Enabled:=True;
      CheckBoxLoop.Enabled:=False;
    end;
end;

procedure TFormMain.ComboBoxSampleRateChange(Sender: TObject);
begin
  if Assigned(Device) then
    fobos_rx_set_samplerate(Device, SampleRates[ComboBoxSampleRate.ItemIndex], 0);
end;

procedure TFormMain.FormCreate(Sender: TObject);
begin
  Device:=nil;
  Caption:='Fobos SDR x'+IntToStr(SizeOf(Pointer)*8);
  ButtonEnumerateClick(Self);
end;

procedure TFormMain.FormDestroy(Sender: TObject);
begin
  if Assigned(Device) then
    fobos_rx_close(Device);
  Device:=nil;
end;

procedure TFormMain.ReadSamples(Sender: TObject; ComplexSamplesF32: Pointer; Count: Cardinal);
begin
  if Length(ComplexSamples)<>Count*2 then
    SetLength(ComplexSamples, Count*2);
  Move(ComplexSamplesF32^, ComplexSamples[0], Count*2*SizeOf(Single));
  Inc(RxBufsCount);
  inc(RxSamplesCount, Count);
  NewData:=True;
end;

procedure TFormMain.ScrollBarLNAChange(Sender: TObject);
begin
  if Assigned(Device) then
    fobos_rx_set_lna_gain(Device, ScrollBarLNA.Position);
end;

procedure TFormMain.ScrollBarVGAChange(Sender: TObject);
begin
  if Assigned(Device) then
    fobos_rx_set_vga_gain(Device, ScrollBarVGA.Position);
end;

procedure TFormMain.Timer1Timer(Sender: TObject);
var i, Count: Integer;
    ScaleY: Single;
begin
  Count:=Length(ComplexSamples) div 2;
  if Assigned(Device) and
     NewData and
     (Count<>0) then
    begin
      ScaleY:=PaintBox1.Height;
      NewData:=false;
      if Length(Points)<>PaintBox1.Width then
        SetLength(Points, PaintBox1.Width);
      for i := 0 to PaintBox1.Width-1 do
        begin
          Points[i].X:=i;
          Points[i].y:=Round((ComplexSamples[i*2+0]+0.5)*ScaleY);
        end;
      PaintBox1.Canvas.FillRect(PaintBox1.Canvas.ClipRect);
      PaintBox1.Canvas.Polyline(Points);
      EditRxCount.Text:=IntToStr(RxBufsCount);
    end;
end;

procedure TFormMain.Timer2Timer(Sender: TObject);
begin
  EditSampleRate.Text:=IntToStr(RxSamplesCount);
  RxSamplesCount:=0;
end;

end.
