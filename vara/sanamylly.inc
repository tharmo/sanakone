procedure tmylly.w2c;//(ncors,ntargs:pscarcemat);
begin
end;
procedure tmylly.wxw;//(ncors,ntargs:pscarcemat);
  // sparce  matrix 'multiplication'
var itarg,j,jtarg,m,commij,k:WORD; sims:^ar_longrow;
  maxes:array[1..6461] of longword;
  maxw2,maxs2,
  smallest,sum,maksi:longword;
  fixi:double;ch:char;
  isiz:word;
  oli:word;
  recMID,RECJ:r_scarcefield; // cosizes,cowhats:array[1..64] of longword; //should be local vars
 //onerow:^ar_fullrow;
 inclust:p_matcol;//array of word;
 newmat:tmat;
 resp:pointer;
 test1,test2:byte;
begin
  try
//getmem(sims,sizeof(sims^));
// write(^j,itarg,':',jtarg,' > ',wsmat.wc(itarg,jtarg).w);
maksi:=0;//for itarg:=1 to wrds do maksi:=max(maksi,cors^[itarg,1]);
//fillchar(sims,sizeof(sims),0);
inclust:=getmem(rows*2);
fillchar(inclust^,rows*2,0);
//setlength(inclust,rows+1);
sims:=getmem(4*(rows+1));
fillchar(sims^,4*(rows+1),0);
try
newmat:=tmat.create(rows,cols);
newmat.mymy:=self;
for itarg:=1 to rows do
begin
 if itarg mod 1000=1 then write(itarg,' ');
 fillchar(sims^,4*(rows+1),0);
 fillchar(wsmat.sums^,4*(rows),0);
 //writeln(^j,sanat[itarg],'???');
  //if inclust^[itarg]<>0 then continue;
  maxes[itarg]:=0;maxs2:=0;maxw2:=0;
  for k:=1 to rows do sims^[k]:=0;
  for m:=1 to cols do           //a: c,d,e
  begin
       RECMID:=WSMAT.WC(itarg,M);            //recmid=c^
       commij:=RECMID.W;//mAT^[itarg,m];
       //if inclust[maybeij]<>0 then continue;
       if commij=0 then continue;
       if commij>rows then writeln('failed at ', itarg);
       isiz:=RECmid.S;//cors^[itarg,m];
       if isiz=0 then continue else
       for j:=1 to coLS do          //   c: a,b,e
       //if mat^[itarg,
       begin
        try
           try
           recj:=wsmat.wc(commij,j);
           except writeln('faiu '); end;
           jtarg:=recj.w;          //  jtarg=a from c:a,b,e
           if jtarg=0 then continue;
           //if inclust[jtarg]<>0 then continue;
           begin                                      //>
            sims^[jtarg]:=sims^[jtarg]+min(isiz,recj.s);// sums[k]**2;       //if itarg=7 then if jtarg=9 then //SIMS^[JTARG]>300 then
           end;
           except writeln(commij,'zzzzzzzzzzzz:',jtarg,'!');raise; end;
      end;
    end;
   for j:=1 to rows do
    if sims^[j]>newmat.mat^[itarg*cols+cols-1].s then
     for k:=1 to cols   do
      if sims^[j]>newmat.wc(itarg,k).s then
      begin
         move(newmat.mat^[itarg*cols+k-1],newmat.mat^[itarg*cols+k],4*(cols-k));
         newmat.setval(itarg,k,j,sims^[j]);
         break;
      end;
  //for j:=1 to 16 do  write('  :',j,sanat[newmat.wc(itarg,j).w],newmat.wc(itarg,j).s,'');
 end; //of one word
  except  writeln('failed multiply');end;
  finally   freemem(sims,4*(rows+1));end;
  mat:=newmat.mat;  //shold free!
  wsmat.mat:=mat;
end;


procedure tmylly.cluster;
var i,j,w,c,k,w_c,iters,cluscount,hits:word;
  rec:r_scarcefield;p:pointer;st:string;
  //clusterpot:array of longword;
  wccount,clusmax:word;had:boolean;
  maxs,maxw:longword;
  onerow:p_longrow;
  var xline:array[0..128] of longword;

  function linexline(r:word):boolean;
  var i,j,k,x,iter:word;reci,recj:r_scarcefield;
     smalmat,smalmat2:array[1..32] of array[1..32] of longword;
     xlinep:p_longrow;resp:pointer;
  begin
  fillchar(smalmat,sizeof(smalmat),0);
  fillchar(smalmat2,sizeof(smalmat),0);
  for i:=1 to 16 do
   begin
     reci:=wsmat.wc(r,i);
     if i=1 then reci.s:=reci.s div 3;
     if  wsmat.sums^[reci.w]=0 then begin write(''); continue;end;
     xline[i]:=0;
     for j:=1 to wsmat.cols do
     if i<>j then
     begin
         recj:=wsmat.wc(r,j);
         try
         if  wsmat.sums^[recj.w]=0 then begin write('');smalmat[i,j]:=0;continue;end;
         //write('~');
         //xline[i]:=xline[i]+min(reci.s,wsmat.valueof(recj.w,reci.w)) div (wsmat.sums^[recj.w]+10);
         smalmat[i,j]:=reci.s*wsmat.valueof(recj.w,reci.w) div (wsmat.sums^[recj.w]+wsmat.sums^[reci.w]+1);
         //if i<2 then write('+++',sanat[recj.w],'_',sanat[reci.w],'_',smalmat[i,j]);
         //xline[i]:=xline[i]+reci.s*wsmat.valueof(recj.w,reci.w) div (wsmat.sums^[recj.w]+wsmat.sums^[reci.w]+1);
         except writeln('faillinexline');end;
     end;
   end;

   for iter:=1 to 0 do
   begin
    for i:=1 to 16 do
    begin
     xline[i]:=0;
     for j:=1 to 16 do
       xline[i]:=xline[i]+smalmat[i,j];
    end;
    for i:=1 to 16 do
     for j:=1 to 16 do
     begin
        smalmat2[i,j]:=0;
        for k:=1 to 16 do
        begin
          smalmat2[i,j]:=smalmat2[i,j]+(smalmat[i,k]*smalmat[j,k]) div 2000;//(xline[i]*xline[j]+1);
        end;
     end;
     for i:=1 to 16 do  for j:=1 to 16 do         smalmat[i,j]:=smalmat2[i,j];
    end;

    for i:=1 to 16 do
    begin
     xline[i]:=0;
     for j:=1 to 16 do
       xline[i]:=xline[i]+smalmat[i,j] div 10;
    end;
    xline[1]:=xline[1] div 2;
    //writeln;
   //for i:=1 to 16 do write(xline[i],'\');
   //writeln;
     //xlinep:=@xline;
     //resp:=pointer(csmat.mat);
     //resp:=pointer(resp+(cluscount*cols*4));
     //csmat.sortedrow(xlinep,cluscount,resp,16,16);

     for i:=1 to 16 do //write(' -',sanat[csmat.wc(cluscount,i).w],csmat.wc(cluscount,i).s);
     begin
        for k:=1 to 16 do
        if xline[i]>csmat.wc(cluscount,k).s then
        begin
           // write(^j,i,'dooset:',k,sanat[wsmat.wc(r,i).w],xline[i],'-->',sanat[csmat.wc(cluscount,k).w],'!',csmat.wc(cluscount,k).s,';',csmat.mat^[cols*cluscount+k-1].s,':::');
           move(csmat.mat^[cluscount*csmat.cols+k-1],csmat.mat^[cluscount*csmat.cols+k],4*(16-k));//*cols); //WHY "*cols"
           csmat.setval(cluscount,k,wsmat.wc(r,i).w,xline[i]);
           if isinclus^[wsmat.wc(r,i).w]<1 then
           begin
           wccount:=wccount+1;
           //for x:=1 to 16 do begin rec:=csmat.wc(cluscount,x); write(x,sanat[rec.w],rec.s,'|');end;
           //writeln('  ///:',k,':',sanat[csmat.wc(cluscount,k).w],csmat.wc(cluscount,k).s,'-->',sanat[csmat.wc(cluscount,k+1).w],csmat.wc(cluscount,k+1).s);
           //writeln('didset:',cluscount,':',k,sanat[wsmat.wc(r,i).w],'=',xline[i]);
           isinclus^[wsmat.wc(r,i).w]:=cluscount;
           end;
           break;
        end;
     end;
    // for i:=1 to 16 do write(' -',sanat[csmat.wc(cluscount,i).w],csmat.wc(cluscount,i).s);
   end;

begin
    onerow:=wsmat.longrow;
    csmat:=tmat.create(700,wsmat.cols);
    cluscount:=0;
    wccount:=0;
    writeln(^j,'************************************************************');
    for iters:=1 to 555 do
    begin
      fillchar(onerow^,rows*4,0);
      fillchar(wsmat.sums^,wsmat.rows*4,0);
      for w:=1 to wsmat.rows do
      //if isinclus^[w]=0 then
      begin
         wsmat.sums^[w]:=0;
         //write('**',w,wsmat.wc(w,);
         for c:=2 to 16 do
         begin
             rec:=wsmat.wc(w,c);
             if rec.s=0 then continue;
             if isinclus^[rec.w]=0 then
              wsmat.sums^[w]:=wsmat.sums^[w]+rec.s;
         end;
      end;
      //for w:=1 to 100 do write(sanat[w],wsmat.sums^[w],' ');
      //write(^j,'SUMSOK',wsmat.sums^[);                                   cols
      maxs:=0;maxw:=0;had:=true;
      for w:=1 to wsmat.rows do  //find the biggest one
      if isinclus^[w]=0 then
      if WSMAT.sums^[w]>maxs then
      begin //if w<>5702 then
          //writeln('MAX:',sanat[w],sanat[w],'/sum:',wsmat.sums^[w],' /omax:',maxs,' ', WSMAT.sums^[w]>maxs);
            maxs:=WSMAT.sums^[w];
            maxw:=w;
      end;
        if maxw=0 then break;
        //for j:=1 to 5 do   write('________',sanat[wsmat.wc(maxw,j).w]);
      //    for i:=1 to 16 do write(sanat[wsmat.wc(maxw,i).w]);

      //  writeln;
      cluscount:=cluscount+1;
      wccount:=wccount+1;
      hits:=0;
      writeln(^j^j,cluscount,' (',wccount,')', sanat[maxw],'/', wsmat.sums^[maxw],'[',isinclus^[maxw],']',':::');
      linexline(maxw);
      for w_c:=1 to 16 do //cols do
      begin
      //if 15*xline[w_c]<xline[1] then
      //if xline[w_c]=0 then
        if isinclus^[csmat.wc(cluscount,w_c).w]<>cluscount  then write('[',isinclus^[csmat.wc(cluscount,w_c).w],']');
        write(sanat[csmat.wc(cluscount,w_c).w],csmat.wc(cluscount,w_c).s,' ');
      end;
      writeln;
      //had:=false;
      //for k:=1 to 16 do if 180*xline[k]<wsmat.sums^[wsmat.wc(maxw,k).s] then had:=true;
      //had:=true;
      //clusmax:=wsmat.sums^[maxw] div 32;
      //if had then

      {for w_c:=1 to 16 do //cols do
      begin
          rec:=wsmat.wc(maxw,w_c);
          if rec.w=0 then continue;
          if wsmat.sums^[rec.w]=0 then continue;
          hits:=hits+1;
          if 15*xline[w_c]< xline[1] then continue;
          //if xline[w_c]=0 then
          //  write('       &&&&&&&&       ');
          //if had then
          write(sanat[rec.w],': ',
            10000*rec.s div wsmat.sums^[rec.w],
            '/',xline[w_c] div 1,' ');
          csmat.addtorow(cluscount,rec.w,1000*rec.s div wsmat.sums^[rec.w]);
          isinclus^[rec.w]:=cluscount;
          wccount:=wccount+1;
      end;

      }
     end;
    wccount:=0;
    for i:=0 to wsmat.rows-1 do if isinclus^[i]>0 then wccount:=wccount+1;
    writeln(^j,'Words in clusters;',wccount,'  /clusters:',cluscount);
end;


procedure tmylly.readwords;
var f:textfile;i:integer;s:string;
begin try
  setlength( sanat,n_w+1);
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
writeln('read:',fname,siz);
assign(f,fname);
Reset (F,siz);
writeln('OKreset:',fname,siz,':',sanat[word(cnt^)],word(cnt^),'!');
try
Blockread (F,cnt^,1);
except writeln('FAILREAD');end;
  //writeln('OK:',fname,siz);
close (f);

end;



function tmylly.full2scarce:a_scarcemat;
var i,j:word;
  //ONErow:array of longword;
  ip:qword;  full:p_fullmat;
begin
writeln('read fullmatrix');

 full:=wsmat.readfullmatrix;

 writeln('fullmatrix read');
 //for j:=0 to 10 do writeln(full^[j],' ');
 wsmat.fromfull(full);
 //wsmat.list;
 exit;
end;
    //writeln(itarg,':::',sanat[itarg],targs^[itarg,1]);
                                   {   a b c d e
                                     a 3   3 3 3
                                     b     3 3
                                     c 3 3     3
                                     d 3 3
                                     e 3   3

                                     a*b= c d
                                     a*c= e
                                     a*e=c

                                     b*a= c d
                                     b*e= c

                                     c*a=  e
                                     c*d= a b
                                     c*e= a

                                     d*c= a b
                                     d*e= a
                                     e*c=  a
                                   ************************************
          1itarg,3jta                a: c,d,e
                                     b: c,d
           2mid                      c: a,b,e
                                     d: a,b
                                     e: a,c

                                     a
                                       a/c: ab, ae
                                       a/d: ab
                                       a/e: c
                                      ab+c+d, ac+e ae+c
                                      b
                                        b/c= a e
                                        b/d= a
                                      ba+c+d   be+c
                                      c
                                        c/a: d e
                                        c/b: d
                                        c/e: a
                                      ca+e cd+a+b ce+a

                                     }

