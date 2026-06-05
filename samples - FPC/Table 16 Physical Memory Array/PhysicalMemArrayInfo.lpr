program PhysicalMemArrayInfo;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}
  {$ENDIF}
  Classes,
  SysUtils,
  uSMBIOS { you can add units after this };

  procedure GetPhysicalMemArrayInfo;
  var
    SMBios: TSMBios;
    LPhysicalMemArr: TPhysicalMemoryArrayInformation;
  begin
    SMBios := TSMBios.Create;
    try
      WriteLn('Physical Memory Array Information');
      WriteLn('--------------------------------');
      if SMBios.HasPhysicalMemoryArrayInfo then
        for LPhysicalMemArr in SMBios.PhysicalMemoryArrayInfo do
        begin
          WriteLn('Location         ' + LPhysicalMemArr.GetLocationStr);
          WriteLn('Use              ' + LPhysicalMemArr.GetUseStr);
          WriteLn('Error Correction ' + LPhysicalMemArr.GetErrorCorrectionStr);
          if LPhysicalMemArr.RAWPhysicalMemoryArrayInformation^.MaximumCapacity <> $80000000 then
            WriteLn(Format('Maximum Capacity %d Kb', [LPhysicalMemArr.RAWPhysicalMemoryArrayInformation^.MaximumCapacity]))
          else
            WriteLn(Format('Maximum Capacity %d bytes', [LPhysicalMemArr.RAWPhysicalMemoryArrayInformation^.ExtendedMaximumCapacity]));

          WriteLn(Format('Memory devices   %d', [LPhysicalMemArr.RAWPhysicalMemoryArrayInformation^.NumberofMemoryDevices]));
          WriteLn;
        end
      else
        WriteLn('No Physical Memory Array Info was found');
    finally
      SMBios.Free;
    end;
  end;


begin
  try
    GetPhysicalMemArrayInfo;
  except
    on E: Exception do
      WriteLn(E.ClassName, ':', E.Message);
  end;
  WriteLn('Press Enter to exit');
  Readln;
end.
