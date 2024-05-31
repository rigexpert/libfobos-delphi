unit FobosSDRThread;

interface

uses
  System.Classes

  , Fobos

  ;

type
  TReadSamplesEvent = procedure(Sender: TObject; ComplexSamplesF32: Pointer; Count: Cardinal) of object;

  TFobosSDRThread = class(TThread)
    protected
      FDevice: pointer;
      FBufferLength: Cardinal;
      FOnReadSamples: TReadSamplesEvent;
      procedure Execute(); override;
      procedure ReadSamples(ComplexSamplesF32: Pointer; Count: Cardinal);
    public
      constructor Create(Device: pointer; BufferLength: Cardinal; OnReadSamples: TReadSamplesEvent);
  end;

implementation

function RxCallback(ComplexSamplesF32: Pointer; Count: Cardinal; ctx: Pointer): Integer; cdecl;
var Thread: TFobosSDRThread;
begin
  Thread:=TFobosSDRThread(ctx);
  if Assigned(Thread)
    then
      Thread.ReadSamples(ComplexSamplesF32, Count);
end;

{ TFobosSDRThread }

constructor TFobosSDRThread.Create(Device: Pointer; BufferLength: Cardinal; OnReadSamples: TReadSamplesEvent);
begin
  inherited Create(True);
  FDevice:=Device;
  FBufferLength:=BufferLength;
  FOnReadSamples:=OnReadSamples;
  Resume();
end;

procedure TFobosSDRThread.Execute();
var Result: Integer;
begin
  Result:=fobos_rx_read_async(FDevice, RxCallback, Self, 32, FBufferLength);
end;

procedure TFobosSDRThread.ReadSamples(ComplexSamplesF32: Pointer;  Count: Cardinal);
begin
  if Assigned(FOnReadSamples) then
    FOnReadSamples(self, ComplexSamplesF32, Count);
end;

end.
