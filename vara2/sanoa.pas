program sanoa;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cmem,
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp, sano;
  { you can add units after this }

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
  ErrorMsg: String; mylly:tmylly;j:word;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('h', 'help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;
  mylly:=tmylly.create;
  // parse parameters
  if HasOption('h', 'help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;
  if paramstr(1)=('c') then begin
    //mylly:=tmylly.create;
    mylly.readafile('wxw.sca',mylly.wsmat.mat,n_w*n_c*4);
    //for j:=0 to mylly.cols do  write('*#########',            mylly.mat^[9*mylly.cols+j].w);
    for j:=0 to mylly.cols do  write('*#',mylly.sanat[mylly.mat^[9*mylly.cols+j].w]
    ,'/',mylly.mat^[7*mylly.cols+j].s);
    mylly.wsmat.getsums;
    mylly.wsmat.list;
    mylly.wxw;
    // mylly.cluster;

    Terminate;
    Exit;
  end;

  if paramstr(1)=('m') then begin
    mylly:=tmylly.create;
    mylly.makematrix;
    Terminate;
    Exit;
  end;
  if paramstr(1)=('s') then begin
    mylly:=tmylly.create;
    //mylly.scarcemat;
    //mylly.smallm;
    mylly.readwords;
    write('Filesizetobe;',n_w*n_c*4);
    write('makescarce');
    mylly.full2scarce;
    mylly.saveafile('wxw.sca',mylly.wsmat.MAT,n_w*n_c*4);
    Terminate;
    Exit;
  end;
  { add your program here }

  // stop program loop
  //mylly:=tmylly.create;
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
  Application.Title:='My Application';
  Application.Run;
  Application.Free;
end.

