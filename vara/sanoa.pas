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
  ErrorMsg: String; mylly:tmylly;j:word;test:word;
begin
  // quick check parameters
  ErrorMsg:=CheckOptions('h', 'help');
  if ErrorMsg<>'' then begin
    ShowException(Exception.Create(ErrorMsg));
    Terminate;
    Exit;
  end;
  mylly:=tmylly.create;
  mylly.readwords;
  // parse parameters
  if HasOption('h', 'help') then begin
    WriteHelp;
    Terminate;
    Exit;
  end;
  if paramstr(1)=('l') then begin
    write('sddsdsdsdsd');
      mylly.readafile('wxw.sca',mylly.wsmat.mat,(n_w+1)*n_c*4);  //cannot understand why +1 is needed, but it is!
      mylly.wsmat.list;
    Terminate;
    Exit;
  end;
  if paramstr(1)=('c') then begin
    //mylly:=tmylly.create;
    //mylly.readafile('wxw.sca',@mylly.wsmat.mat^[1],n_w*n_c*4);
    mylly.readafile('wxw.sca',mylly.wsmat.mat,n_w*n_c*4);


    mylly.wxw;
    //mylly.wsmat.list;
    mylly.cluster;

    Terminate;
    Exit;
  end;

  if paramstr(1)=('m') then begin
    //mylly:=tmylly.create;
    //mylly.makematrix;
    Terminate;
    Exit;
  end;


  if paramstr(1)=('s') then begin
    //mylly:=tmylly.create;
    //mylly.scarcemat;
    //mylly.smallm;
    write('Filesizetobe;',n_w*n_c*4);
    write('makescarce');
    mylly.full2scarce;
    mylly.wsmat.list;
    writeln(^j^j,'****wsmat.wc');
    for j:=1 to mylly.cols do  write('*#',mylly.sanat[mylly.mat^[(mylly.rows)*(mylly.cols)+j].w] ,'/',mylly.mat^[mylly.rows*64+j].w);
    writeln(^j^j,'****wsmat.wc');
    for j:=1 to mylly.cols do  write('Z ',mylly.sanat[mylly.wsmat.wc(mylly.rows,j).w]);

    writeln(^j^j,'****prevrow,wsmat ');
    for j:=1 to mylly.cols do  write('*#',mylly.sanat[mylly.mat^[(1)*(mylly.cols)+j].w] ,'/',mylly.mat^[1*64+j].w);
    writeln(^j^j,'****prevrow.ws ');
    for j:=1 to mylly.cols do  write('X ',mylly.sanat[mylly.wsmat.wc(1,j).w]);



    //for j:=1 to mylly.cols do  write('*#',mylly.sanat[mylly.mat^[(mylly.rows-1)*(mylly.cols)+j].w] ,'/',mylly.mat^[mylly.rows-1)*cols+j].w);
    //mylly.wsmat.list;
    //mylly.saveafile('wxw.sca',mylly.wsmat.MAT,n_w*n_c*4);
     //mylly.wsmat.list;
  writeln(n_w*n_c*4);
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
