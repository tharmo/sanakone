program sanoa;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cmem,
  cthreads,
  {$ENDIF}{$ENDIF}
  Classes, SysUtils, CustApp,// sano,
  sanamat, sanatypes, sanamylly;
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

procedure testi;
var i:longword;l:double;
begin
  for i:=1 to 10000000 do

end;

procedure TMyApplication.DoRun;

var
  ErrorMsg: String; mylly:tmylly;i,j:word;test:word;cc:tcluscors;
begin
    if paramstr(1)=('test') then
    begin
      testi;
      Terminate;
      Exit;
   end;

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
    mylly.wsmat.readfile('wxw.smat',(n_w+1)*n_c*4);
    //mylly.readafile('wxw.sca',mylly.wsmat.mat,(n_w+1)*n_c*4);
      mylly.wsmat.list;
    for i:=1 to 10 do  //THIS IS 1-BASED (WC GIVES RES FROM ZERO-BASED)
      write('--',i,mylly.sana(mylly.wsmat.wc(5095,i).w));
    Terminate;
    Exit;
  end;
  if paramstr(1)=('listc') then begin
    mylly.csmat:=tmat.create(2000,64);
    //mylly.csmat.rows:=mylly.csmat.readfile('merged.smat',0);//mylly.csmat.rows*mylly.csmat.cols*4);
    mylly.csmat.rows:=mylly.csmat.readfile('clustersx.smat',0);//mylly.csmat.rows*mylly.csmat.cols*4);
    write('(((((((((((((((((((');
    writeln(^j,'gotCLUS ',mylly.csmat.rows,' clusteers');
    //mylly.readafile('clusters.smat',mylly.csmat.mat,mylly.csmat.rows*mylly.csmat.cols*4);
      mylly.csmat.list;

      //writeln(mylly.sana(5095));
      //writeln(mylly.wsmat.sana(5095));
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
    for i:=1 to 0 do
    begin
      //mylly.wsmat.list;
      writeln(^j^j,'****wsmat.wc');
      mylly.wxw;
    end;
    mylly.wsmat.savefile('wxw.smat',n_w*n_c*4);
     //mylly.wsmat.list;
   writeln(n_w*n_c*4);
    Terminate;
    Exit;
  end;

  if paramstr(1)=('cluster') then begin
  //mylly:=tmylly.create;
  //mylly.readafile('wxw.sca',mylly.wsmat.mat^[1],n_w*n_c*4);
  mylly.wsmat.readfile('wxw.smat',n_w*n_c*4);
  writeln('read scarce wrd/wrd mat',mylly.wsmat.rows,'"');
  //mylly.csmat:=tmat.create(800,128);      //hard coded and strange
  //writeln('clusters.smatm rows:',mylly.csmat.rows,' cols:',mylly.csmat.cols,' size:',mylly.csmat.rows*mylly.csmat.cols*4);
  //writeln('************************',sizeof(csmat.mat^));
  //mylly.readafile('clusters.smat',mylly.csmat.mat,mylly.csmat.rows*mylly.csmat.cols*4);

  for i:=1 to 1 do
  begin
    //mylly.wsmat.list;
    //readln;
    mylly.wxw;
  end;

  // mylly.wsmat.list;
  //readln;
  //writeln(^j,^j',WXW:',mylly.csmat.rows,' cols:',mylly.csmat.cols,' size:',mylly.csmat.rows*mylly.csmat.cols*4);
  //mylly.wsmat.list;
  writeln('cluster');

  mylly.cluster(1000);
  writeln(^j,^j,'CLUST:',mylly.csmat.rows,' cols:',mylly.csmat.cols,' size:',mylly.csmat.rows*mylly.csmat.cols*4);
  //readln;
  //mylly.csmat.list;
  //terminate;exit;
  writeln(^j,^j,'W2c',mylly.csmat.rows,' cols:',mylly.csmat.cols,' size:',mylly.csmat.rows*mylly.csmat.cols*4);
  mylly.csmat.savenonzeroes('clusters2.smat');
  //mylly.csmat.sparce2full(mylly.wsmat);
  //mylly.hiero;
  //mylly.saveafile('clusters.smat',mylly.csmat.mat,mylly.csmat.rows*mylly.csmat.cols*4);
  writeln('clustered',mylly.csmat.rows,'*',mylly.csmat.cols);
  //mylly.readafile('clusters.smat',mylly.csmat.mat,mylly.csmat.rows*mylly.csmat.cols*4);
  //mylly.csmat.list;
  Terminate;
  Exit;

  end;
  if paramstr(1)=('w2c') then begin
    mylly.csmat:=tmat.create(1000,64);
    writeln('<li>words to clusters');
    mylly.csmat.rows:=mylly.csmat.readfile('clusters2.smat',0);
    mylly.cluscount:=mylly.csmat.rows;
    mylly.wsmat.rows:=mylly.wsmat.readfile('wxw.smat',n_w*n_c*4);
    writeln('<li>startin w2c');
      mylly.w2c(1);
      mylly.wsmat.savefile('cxc.smat',0);
      mylly.csmat.savenonzeroes('clustersx.smat');

      Terminate;
      Exit;
   end;
 if paramstr(1)=('ccor') then begin
    writeln('************cluster cors************');//,sizeof(csmat.mat^));
    mylly.wsmat.readfile('wxw.smat',n_w*n_c*4);  //wxw2.smat ???
    //mylly.readafile('wxw2.smat',mylly.wsmat.mat,n_w*n_c*4);
    mylly.csmat:=tmat.create(1000,64);
    mylly.csmat.mymy:=mylly;
    writeln('rows:',mylly.csmat.rows);
    //mylly.csmat.rows:=create
    mylly.cluscount:=mylly.csmat.readfile('clustersx.smat',0);
   // mylly.cluscount:=mylly.csmat.readfile('clusters2.smat',0);
    mylly.csmat.rows:=mylly.cluscount;
    //mylly.csmat.list;
    //mylly.readafile('clusters.smat',mylly.csmat.mat,43264);//mylly.csmat.rows*mylly.csmat.cols*4);
    //mylly.csmat.list;
    writeln('************hieroo************');//,sizeof(csmat.mat^));
    //mylly.csmat.list;
    mylly.clustcors(cc);
    cc.savefile('clustcors.bin');
    cc.list(mylly.csmat);
    writeln('************correttu************');//,sizeof(csmat.mat^));
    //cluscors:=tmylly(mymy).csmat.sparce2full(mylly.wsmat);
//    mylly.csmat.savenonzeroes('clusters3.smat');

   // mylly.dolayout;
    terminate;exit;
   end;

  if paramstr(1)=('hiero') then begin
    writeln('************hierooo************');//,sizeof(csmat.mat^));
    mylly.wsmat.readfile('wxw.smat',n_w*n_c*4);  //wxw2.smat ???
    //mylly.readafile('wxw2.smat',mylly.wsmat.mat,n_w*n_c*4);
    mylly.csmat:=tmat.create(4000,64);
    mylly.csmat.mymy:=mylly;
    writeln('ros:',mylly.csmat.rows);
    //mylly.csmat.rows:=create
    mylly.cluscount:=mylly.csmat.readfile('clustersx.smat',0);
   // mylly.cluscount:=mylly.csmat.readfile('clusters2.smat',0);
    mylly.csmat.rows:=mylly.cluscount;
    cc:=tcluscors.createfrom('clustcors.bin');
    //cc.readfile('clustcors.bin');
    //mylly.readafile('clusters.smat',mylly.csmat.mat,43264);//mylly.csmat.rows*mylly.csmat.cols*4);
    //mylly.csmat.list;
    writeln('************hieroo************');//,sizeof(csmat.mat^));
    //mylly.csmat.list;
    mylly.hiero(cc);
    writeln('************hierottu************');//,sizeof(csmat.mat^));
    mylly.csmat.list;
    mylly.csmat.savefile('merged.smat',0);
    //cluscors:=tmylly(mymy).csmat.sparce2full(mylly.wsmat);
//    mylly.csmat.savenonzeroes('clusters3.smat');

   // mylly.dolayout;
    terminate;exit;
   end;
  if paramstr(1)=('lout') then begin
     write('layout');
     mylly.csmat:=tmat.create(2000,64);
     //mylly.csmat.readfile('clusters3.smat',0);
     //mylly.csmat.rows:=mylly.csmat.readfile('clustersx.smat',0);//mylly.csmat.rows*mylly.csmat.cols*4);
     mylly.csmat.rows:=mylly.csmat.readfile('merged.smat',0);//mylly.csmat.rows*mylly.csmat.cols*4);
     mylly.cluscount:=mylly.csmat.rows;
     writeln('nodecount:',mylly.cluscount);
     //mylly.csmat.list;
      mylly.dolayout;
      writeln('didlayouts');
    Terminate;
    Exit;
  end;

  if paramstr(1)=('m') then begin
    //mylly:=tmylly.create;
    //mylly.makematrix;
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

