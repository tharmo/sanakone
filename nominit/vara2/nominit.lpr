program nominit;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp, nominoi, nomutils
  { you can add units after this };

type

  { TMyApplication }

  TMyApplication = class(TCustomApplication)
  protected
    procedure DoRun; override;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
    procedure WriteHelp; virtual;
  end;

{ TMyApplication }

procedure TMyApplication.DoRun;
var
  ErrorMsg: String;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('h', 'help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;

  // parse parameters
  if HasOption('h', 'help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;
  //if HasOption('f', 'fixteet') then begin
  if paramstr(1)='fixmonikot' then  begin
    fixmonikot;
    writeln('<h1>fiksattiiin monikkosanoja</h1>');
    Terminate;
    Exit;
  end;
  if paramstr(1)='puu' then  begin
    fixmonikot;
    writeln('<h1>fiksattiiin monikkosanoja</h1>');
    Terminate;
    Exit;
  end;
  if paramstr(1)='taka' then  begin
    takavokaaleiksi;
    writeln('<h1>��t aiksi tiedostoon "tmp"</h1>');
    Terminate;
    Exit;
  end;
  if paramstr(1)='listaaoudot' then  begin
    listaaoudot;
    writeln('<h1>ei talletettu tiedostoon ""</h1>');
    Terminate;
    Exit;
  end;
  if paramstr(1)='listaa' then  begin
    rx:=triimitin.create;
    rx.nominit.listaa;
    Terminate;
    Exit;
  end;
  rx:=triimitin.create;
  rx.nominit.luolista;
  Terminate;
end;

constructor TMyApplication.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);
  StopOnException:=True;
end;

destructor TMyApplication.Destroy;
begin
  inherited Destroy;
end;

procedure TMyApplication.WriteHelp;
begin
  { add your help code here }
  writeln('Usage: ', ExeName, ' -h');
end;

var
  Application: TMyApplication;
begin
  Application:=TMyApplication.Create(nil);
  Application.Run;
  Application.Free;
end.

