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
  if paramstr(1)=('list') then begin
      mylly.readafile('wxw.sca',mylly.wsmat.mat,(n_w+1)*n_c*4);
      mylly.wsmat.list;
    Terminate;
    Exit;
  end;
  if paramstr(1)=('listclusters') then begin
    mylly.csmat:=tmat.create(800,64);
    mylly.readafile('clusters.smat',mylly.csmat.mat,mylly.csmat.rows*mylly.csmat.cols*4);
      mylly.csmat.list;
    Terminate;
    Exit;
  end;
  if paramstr(1)=('layout') then begin
     write('layout');
      mylly.dolayout;
    Terminate;
    Exit;
  end;
  if paramstr(1)=('hiero') then begin
    mylly.readafile('wxw2.smat',mylly.wsmat.mat,n_w*n_c*4);
    mylly.csmat:=tmat.create(800,64);
    mylly.csmat.mymy:=mylly;
    mylly.readafile('clusters.smat',mylly.csmat.mat,mylly.csmat.rows*mylly.csmat.cols*4);
    //mylly.wsmat.list;
    writeln('************ooo************');//,sizeof(csmat.mat^));
    //mylly.csmat.list;
    mylly.hiero;
    //cluscors:=mymy.csmat.sparce2full(mylly.wsmat);

   // mylly.dolayout;
    terminate;exit;
   end;

    if paramstr(1)=('cluster') then begin
    //mylly:=tmylly.create;
    //mylly.readafile('wxw.sca',@mylly.wsmat.mat^[1],n_w*n_c*4);
    mylly.readafile('wxw.sca',mylly.wsmat.mat,n_w*n_c*4);
    writeln('read scarce wrd/wrd mat');
    //mylly.csmat:=tmat.create(800,128);      //hard coded and strange
    //writeln('clusters.smatm rows:',mylly.csmat.rows,' cols:',mylly.csmat.cols,' size:',mylly.csmat.rows*mylly.csmat.cols*4);
    //writeln('************************',sizeof(csmat.mat^));
    //mylly.readafile('clusters.smat',mylly.csmat.mat,mylly.csmat.rows*mylly.csmat.cols*4);

    mylly.wxw;
    //writeln(^j,^j',WXW:',mylly.csmat.rows,' cols:',mylly.csmat.cols,' size:',mylly.csmat.rows*mylly.csmat.cols*4);
    //mylly.wsmat.list;
    writeln('cluster');

    mylly.cluster(500);
    writeln(^j,^j,'CLUST:',mylly.csmat.rows,' cols:',mylly.csmat.cols,' size:',mylly.csmat.rows*mylly.csmat.cols*4);
    //mylly.csmat.list;
    //terminate;exit;
    mylly.w2c(1);
    writeln(^j,^j,'W2c',mylly.csmat.rows,' cols:',mylly.csmat.cols,' size:',mylly.csmat.rows*mylly.csmat.cols*4);
    //mylly.csmat.sparce2full(mylly.wsmat);
    //mylly.hiero;
    mylly.saveafile('clusters.smat',mylly.csmat.mat,mylly.csmat.rows*mylly.csmat.cols*4);
    writeln('clustered',mylly.csmat.rows,'*',mylly.csmat.cols);
    mylly.readafile('clusters.smat',mylly.csmat.mat,mylly.csmat.rows*mylly.csmat.cols*4);
    mylly.csmat.list;
    Terminate;
    Exit;

  end;

  if paramstr(1)=('m') then begin
    //mylly:=tmylly.create;
    //mylly.makematrix;
    Terminate;
    Exit;
  end;


  if paramstr(1)=('create') then begin
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

