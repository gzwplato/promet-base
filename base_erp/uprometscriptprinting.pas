unit uprometscriptprinting;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,uprometpascalscript,LR_Class,LR_BarC;

type
  TFakePrintingObject = class
  private
    procedure FReportGetValue(const ParName: String; var ParValue: Variant);
  end;

implementation

uses uData,db,uBaseApplication,dateutils;

var
  FReport : TfrReport;
  aFObj : TFakePrintingObject;
  Barc : TfrBarCodeObject;

procedure TFakePrintingObject.FReportGetValue(const ParName: String;
  var ParValue: Variant);
begin
  if Assigned(FReportVariables) and (FReportVariables.IndexOfName(ParName)>-1) then
    ParValue:=FReportVariables.Values[ParName];
  if uppercase(ParName) = 'WEEKNO' then
    ParValue := IntToStr(WeekOfTheYear(Now()))
  else if uppercase(ParName) = 'WEEKDAY' then
    ParValue := IntToStr(DayOfTheWeek(Now()))
    ;
end;

function PrometScriptPrint(aType,Reportname,Printer : string;Copies : Integer) : Boolean;
var
  NotPrintable: Boolean = False;
begin
  if not Assigned(FReport) then
    FReport := TfrReport.Create(nil);
  FReport.ShowProgress:=False;
  Data.Reports.Filter(Data.QuoteField('TYPE')+'='+Data.QuoteValue(aType));
  Result := Data.Reports.DataSet.Locate('NAME',Reportname,[loCaseInsensitive]);
  if Result then
    begin
      FReport.OnGetValue:=@aFObj.FReportGetValue;
      with Data.Reports.FieldByName('REPORT') as TBlobField do
        if not Data.Reports.FieldByName('REPORT').IsNull then
          begin
            NotPrintable := False;
            try
              with BaseApplication as IBaseApplication do
                begin
                  Data.BlobFieldToFile(Data.Reports.DataSet,'REPORT',GetInternalTempDir+'preport.lrf');
                  FReport.LoadFromFile(GetInternalTempDir+'preport.lrf');
                end;
            except
              NotPrintable := True;
            end;
          end;
      if NotPrintable then result := False
      else
        begin
          Result := FReport.PrepareReport;
          if Result then
            FReport.PrintPreparedReport('',Copies);
        end;
    end;
end;

initialization
  uprometpascalscript.OnInternalPrint:=@PrometScriptPrint;
  Barc := TfrBarCodeObject.Create(nil);
end.

