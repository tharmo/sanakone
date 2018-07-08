procedure tmylly.wxw;//(ncors,ntargs:pscarcemat);
  // sparce  matrix 'multiplication'
var itarg,j,jtarg,m,commij,k:WORD; sims:^ar_fullrow;
  maxes:array[1..6461] of longword;
  maxw2,maxs2,
  smallest,sum,maksi:longword;
  fixi:double;ch:char;
  isiz:word;
  oli:word;
  recMID,RECJ:r_scarcefield; // cosizes,cowhats:array[1..64] of longword; //should be local vars
 //onerow:^ar_fullrow;
 inclust:array of word;
 newmat:tmat;
 resp:pointer;
begin
  try
//getmem(sims,sizeof(sims^));
//for itarg:=1 to wrds do
//for jtarg:=1 to corc do write(' ',sanat[targs^[3,jtarg]]);
maksi:=0;//for itarg:=1 to wrds do maksi:=max(maksi,cors^[itarg,1]);
//fillchar(sims,sizeof(sims),0);
setlength(inclust,rows+1);
sims:=getmem(4*(rows+1));
try
newmat:=tmat.create(rows,cols);
newmat.mymy:=self;
for itarg:=1 to rows do
begin
  fillchar(sims^,4*(rows+1),0);
  //write(^j,sanat[itarg],'???');
  if inclust[itarg]<>0 then continue;
  maxes[itarg]:=0;maxs2:=0;maxw2:=0;
   for k:=1 to rows do sims^[k]:=0;
   //writeln(itarg,':::',sanat[itarg],targs^[itarg,1]);
   for m:=1 to cols do
   begin
     RECMID:=WSMAT.WC(itarg,M);
     commij:=RECMID.W;//mAT^[itarg,m];
     //if inclust[maybeij]<>0 then continue;
     if commij=0 then continue;
     isiz:=RECmid.S;//cors^[itarg,m];
     if isiz=0 then continue else
 {   a b c d e
   a 9 0 3 3 3
   b 0 9 3 3 0
   c 3 3 9 0 0
   d 3 3 0 9 0
   e 3 0 0 0 9
   a: a,c,d,e
   b: b,c,d
   c: c,a,b
   d: d,a,b
   e: e,a
   a*b= cb,ca }
     for j:=1 to coLS do
     //if mat^[itarg,
     begin
      try
         recj:=wsmat.wc(commij,j);
         jtarg:=recj.w;  //targs^[maybeij,j];
         if jtarg=0 then continue;
         //if inclust[jtarg]<>0 then continue;
          {oli:=0;
          for k:=1 to cols do if wsmat.wc(jtarg,k).w=maybeij then //targs^[jtarg,k]=maybeij then
          //if cors^[maybeij,j]<>cors^[jtarg,k] then
          begin
            //if itarg=3 then if jtarg=1 then write('******',isiz,'**************',sanat[recj.w],'/',isiz,'*');
            oli:=k;break;
          end;
         if oli<>0 then}
         begin
          sims^[jtarg]:=sims^[jtarg]+min(isiz,recj.s);// sums[k]**2;
          if itarg=7 then if jtarg=9 then //SIMS^[JTARG]>300 then
          writeln('* [',sanat[jtarg],sanat[recmid.w],sims^[jTARG],'] ');
         //   sims[jtarg]:=sims[jtarg]+min(isiz,cors^[MAYBEIJ,j]);// sums[k]**2;
           if maksi<sims^[jtarg] then
           begin
           maksi:=sims^[jtarg];
           maxes[itarg]:=jtarg;
           end else
           if maxs2<sims^[jtarg] then
           begin
           maxs2:=sims^[jtarg];
           maxw2:=jtarg;
           end;
         end;
         except writeln(commij,'zzzzzzzzzzzz:',jtarg,'!');raise; end;
      end;
    end;
    resp:=pointer(newmat.mat);
    resp:=resp+(itarg)*(cols)*4;
    //writeln(^j,'N:',newmat.wc(itarg,1).w,'#',word((2+resp)^));
    newmat.sortedrow(sims,itarg,resp,rows,cols);
    write(^j^j,itarg,'**************************',^j,sanat[itarg],':',sanat[maxes[itarg]],maksi,'..',sanat[maxw2],maxs2,': ');
  if itarg=7 then
  begin
  for j:=1 to cols do
      write(' ',sanat[newmat.mat^[itarg*cols+j].w],newmat.mat^[itarg*cols+j].s);
    writeln(^j,'<<<');
    for j:=1 to cols do
      write(' ',sanat[mat^[itarg*cols+j].w],mat^[itarg*cols+j].s);
    //matrow(itarg,sims,maxes[itarg],ncors,ntargs);
  // if itarg=2200 then begin
    //for j:=1 to 32 do write(sanat[newmat.wc(itarg,j).w],'+');
    smallest:=1;sum:=0;
  end;
 end; //of one word
 {try
 if maksi>0 then
 for itarg:=1 to rows do
 if maxes[itARG]>0 THEN
 for j:=1 to cols do
   //if ncors^[itarg,j]>0 then ncors^[itarg,j]:=round(255*ncors^[itarg,j]/maksi);
    //if ncors^[itarg,j]>0 then ncors^[itarg,j]:=round(255*ncors^[itarg,j]/maxes[itarg]);
//function tmat.setval(r,o,tar,siz:word):word;
  if wsmat.wc(itarg,j).s>0 then
  wsmat.setsize(itarg,j,round(255*wsmat.wc(itarg,j).s/maxes[itarg]));

except  writeln('failed normalize');end;
}
  except  writeln('failed multiply');end;
  finally   freemem(sims,4*(rows+1));end;
  mat:=newmat.mat;  //shold free!
  wsmat.mat:=mat;
end;


procedure tmylly.cluster;
var i,j,w,c,w_c,iters,maxs,maxw,cluscount:word;rec:r_scarcefield;p:pointer;st:string;
  //clusterpot:array of longword;
  wccount,clusmax:word;done:boolean;
  onerow:p_fullrow;
begin
    //getmem(csmat.mat,4*wsmat.rows*wsmat.cols);
    //getmem(onerow,4*rows);

    onerow:=wsmat.fullrow;
    setlength(isinclus,wsmat.rows+1);
    for i:=0 to wsmat.rows-1 do isinclus[i]:=0;
    //fillchar(isinclus,2*wsmat.rows,0);

    csmat:=tmat.create(100,wsmat.cols);
    //writeLN(^J,'oksetlen',wsmat.rows);
    cluscount:=0;
    wccount:=0;
    writeln(^j,'************************************************************');
    for iters:=1 to 250 do
    begin
     fillchar(onerow^,rows*4,0);
      //wsmat.sums[w]:=0;
      for i:=0 to wsmat.rows do
       wsmat.sums[i]:=0;
      //exit;
      //fillchar(wsmat.sums,wsmat.rows,0);
      for w:=1 to wsmat.rows do
      if isinclus[w]=0 then
      begin
         //write('**',w,wsmat.wc(w,);
         for c:=1 to 31 do  //note, [0] is for the row itself (taking place of sums after rewrite, perhaps)
         begin
             rec:=wsmat.wc(w,c);
             if rec.s=0 then continue;
             if isinclus[rec.w]=0 then wsmat.sums[w]:=wsmat.sums[w]+rec.s;
         end;
      end;
      //write(^j,'SUMSOK');
      maxs:=0;maxw:=0;done:=true;
      for w:=1 to wsmat.rows do
      if isinclus[i]=0 then
      if WSMAT.sums[w]>maxs then
      begin
            maxs:=WSMAT.sums[w];
            maxw:=w;
            done:=false;
            //write(sanat[w],'*');
      end;
      //if maxw=0 then continue;
      //if done then break;
      //writeln('MAX:',maxw,sanat[maxw],maxs,maxs=0);
      //clusmax:=wsmat.sums[maxw];
      write(^j^j,cluscount,' (',wccount,')', sanat[maxw],'/', wsmat.sums[maxw]);
      cluscount:=cluscount+1;
      isinclus[maxw]:=cluscount;
      csmat.setval(cluscount,1,maxw,1000);
      for w_c:=0 to 31 do  //including 0?
      begin
          rec:=wsmat.wc(maxw,w_c);
          if w_c=0 then clusmax:=rec.s;
          if rec.w=0 then continue;
          if isinclus[rec.w]>0 then continue;
          if wsmat.sums[rec.w]=0 then continue;
          wccount:=wccount+1;
          //if w_c=0 then firstitem:=rec.s;
          if 2*rec.s<clusmax then continue;
          write(sanat[rec.w], 10000*rec.s div wsmat.sums[rec.w],' ');
          csmat.addtorow(cluscount,rec.w,1000*rec.s div wsmat.sums[rec.w]);
          isinclus[rec.w]:=cluscount;
      end;

     end;
    wccount:=0;
    for i:=0 to wsmat.rows-1 do if isinclus[i]>0 then wccount:=wccount+1;
    writeln('Words in clusters;',wccount,'  /clusters:',cluscount);
end;
procedure tmylly.readwords;
var f:textfile;i:integer;s:string;
begin try
  setlength(sanat,n_w+1);
  assign(f,'sanat.iso');
  reset(f);
  i:=1;
  while not eof(f) do
  begin
    readln(f,sanat[i]);
    //write(' .',i,sanat[i]);
    i:=i+1;

  end;
  //for i:=0 to n_w do write(i,sanat[i]);
  write('Xread ',i,'words');
except   writeln('noreadgo____________');end;
end;

procedure tmylly.saveafile(fname:string;cnt:pointer;siz:longword);
var f:file;
begin
writeln('save:',fname,siz);
assign(f,fname);
Rewrite (F,siz);
try
Blockwrite (F,cnt^,1);
except writeln('could not write file');end;
close (f);
end;
procedure tmylly.readafile(fname:string;cnt:pointer;siz:longword);

var f:file;j:word;
begin
//writeln(^j,'tryread:',fname,siz);
assign(f,fname);
Reset (F,siz);
//writeln('OKreset:',fname,siz);
try
Blockread (F,cnt^,1);
except writeln('FAILREAD');end;
  //writeln('OK:',fname,siz);
close (f);

end;



function tmylly.full2scarce:a_scarcemat;
var i,j:word;
  //ONErow:array of longword;
  ascar:array of word;prevp:pointer;
  ip:qword;  full:p_fullmat;
begin
writeln('read fullmatrix');

 full:=wsmat.readfullmatrix;

 writeln('fullmatrix read');
 wsmat.fromfull(full);
 wsmat.list;
 exit;
end;

