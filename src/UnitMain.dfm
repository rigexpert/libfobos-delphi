object FormMain: TFormMain
  Left = 0
  Top = 0
  Caption = 'Fobos SDR'
  ClientHeight = 412
  ClientWidth = 604
  Color = clBtnFace
  Constraints.MinHeight = 450
  Constraints.MinWidth = 620
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  DesignSize = (
    604
    412)
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 8
    Top = 38
    Width = 15
    Height = 13
    Caption = 'Api'
  end
  object Label2: TLabel
    Left = 7
    Top = 65
    Width = 28
    Height = 13
    Caption = 'Board'
  end
  object Label3: TLabel
    Left = 7
    Top = 92
    Width = 26
    Height = 13
    Caption = 'Serial'
  end
  object Label4: TLabel
    Left = 296
    Top = 38
    Width = 57
    Height = 13
    Caption = 'Sample rate'
  end
  object Label5: TLabel
    Left = 296
    Top = 65
    Width = 78
    Height = 13
    Caption = 'Frequency, MHz'
  end
  object Label6: TLabel
    Left = 296
    Top = 92
    Width = 43
    Height = 13
    Caption = 'LNA Gain'
  end
  object Label7: TLabel
    Left = 296
    Top = 119
    Width = 44
    Height = 13
    Caption = 'VGA Gain'
  end
  object PaintBox1: TPaintBox
    Left = 8
    Top = 240
    Width = 588
    Height = 164
    Anchors = [akLeft, akTop, akRight, akBottom]
  end
  object Label8: TLabel
    Left = 7
    Top = 119
    Width = 13
    Height = 13
    Caption = 'Rx'
  end
  object Label9: TLabel
    Left = 7
    Top = 146
    Width = 13
    Height = 13
    Caption = 'SR'
  end
  object ButtonEnumerate: TButton
    Left = 8
    Top = 8
    Width = 75
    Height = 21
    Hint = 'Enimerate devices'
    Caption = '>>>'
    TabOrder = 0
    OnClick = ButtonEnumerateClick
  end
  object ComboBoxDevices: TComboBox
    Left = 89
    Top = 8
    Width = 345
    Height = 21
    Style = csDropDownList
    TabOrder = 1
  end
  object ButtonOpen: TButton
    Left = 440
    Top = 8
    Width = 75
    Height = 21
    Caption = 'Open'
    Enabled = False
    TabOrder = 2
    OnClick = ButtonOpenClick
  end
  object EditApiInfo: TEdit
    Left = 41
    Top = 35
    Width = 212
    Height = 21
    ReadOnly = True
    TabOrder = 3
  end
  object EditBoardInfo: TEdit
    Left = 41
    Top = 62
    Width = 212
    Height = 21
    ReadOnly = True
    TabOrder = 4
  end
  object EditSerial: TEdit
    Left = 41
    Top = 89
    Width = 212
    Height = 21
    ReadOnly = True
    TabOrder = 5
  end
  object ButtonClose: TButton
    Left = 521
    Top = 8
    Width = 75
    Height = 21
    Caption = 'Close'
    Enabled = False
    TabOrder = 6
    OnClick = ButtonCloseClick
  end
  object ComboBoxSampleRate: TComboBox
    Left = 391
    Top = 35
    Width = 205
    Height = 21
    Style = csDropDownList
    Enabled = False
    TabOrder = 7
    OnChange = ComboBoxSampleRateChange
  end
  object EditFrequency: TEdit
    Left = 391
    Top = 62
    Width = 108
    Height = 21
    Enabled = False
    TabOrder = 8
    Text = '100.0'
  end
  object ButtonSetFrequency: TButton
    Left = 521
    Top = 62
    Width = 75
    Height = 21
    Caption = 'Set'
    Enabled = False
    TabOrder = 9
    OnClick = ButtonSetFrequencyClick
  end
  object ScrollBarLNA: TScrollBar
    Left = 391
    Top = 89
    Width = 205
    Height = 21
    Enabled = False
    Max = 3
    PageSize = 0
    TabOrder = 10
    OnChange = ScrollBarLNAChange
  end
  object ScrollBarVGA: TScrollBar
    Left = 391
    Top = 116
    Width = 205
    Height = 21
    Enabled = False
    Max = 15
    PageSize = 0
    TabOrder = 11
    OnChange = ScrollBarVGAChange
  end
  object EditRxCount: TEdit
    Left = 41
    Top = 116
    Width = 212
    Height = 21
    ReadOnly = True
    TabOrder = 12
  end
  object EditSampleRate: TEdit
    Left = 41
    Top = 143
    Width = 212
    Height = 21
    ReadOnly = True
    TabOrder = 13
  end
  object GroupBox1: TGroupBox
    Left = 8
    Top = 170
    Width = 359
    Height = 55
    Caption = 'Synchronous mode'
    TabOrder = 14
    object ButtonStartSync: TButton
      Left = 16
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Start'
      Enabled = False
      TabOrder = 0
      OnClick = ButtonStartSyncClick
    end
    object ButtonReadSync: TButton
      Left = 97
      Top = 16
      Width = 105
      Height = 25
      Caption = 'Read'
      Enabled = False
      TabOrder = 1
      OnClick = ButtonReadSyncClick
    end
    object ButtonStopSync: TButton
      Left = 272
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Stop'
      Enabled = False
      TabOrder = 2
      OnClick = ButtonStopSyncClick
    end
    object CheckBoxLoop: TCheckBox
      Left = 213
      Top = 20
      Width = 41
      Height = 17
      Caption = 'Loop'
      Enabled = False
      TabOrder = 3
    end
  end
  object GroupBox2: TGroupBox
    Left = 378
    Top = 170
    Width = 215
    Height = 55
    Caption = 'Asynchronous mode'
    TabOrder = 15
    object ButtonStart: TButton
      Left = 17
      Top = 19
      Width = 85
      Height = 25
      Caption = 'Start'
      Enabled = False
      TabOrder = 0
      OnClick = ButtonStartClick
    end
    object ButtonStop: TButton
      Left = 116
      Top = 19
      Width = 85
      Height = 25
      Caption = 'Stop'
      Enabled = False
      TabOrder = 1
      OnClick = ButtonStopClick
    end
  end
  object Timer1: TTimer
    Interval = 20
    OnTimer = Timer1Timer
    Left = 248
    Top = 80
  end
  object Timer2: TTimer
    OnTimer = Timer2Timer
    Left = 248
    Top = 128
  end
end
