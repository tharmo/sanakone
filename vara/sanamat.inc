procedure tmat.sortedrow(onerow:p_longrow;rowno:word;toa:pointer;flen,tlen:word);
vAR J,k,resw,ress:word;maks,maksw:longWORD;
begin
 try
  maks:=0;maksw:=0;
  //word(toa^):=rowno;
  //word((toa+2)^):=sums^[rowno];
  except writeln('nosort');end;
  try
  //writeln(^j,^j,'???',mymy.sanat[rowno],word((2+toa+4)^),' ');
  except writeln('wthef',rowno);end;
  //WRITELN(mymy.sanat[ROWNO],'_');//,INTEGER(2+TOA+K*4-POINTER(MAT)),'|',INTEGER(MAT-TOA));
  for j:=1 to flen do
  begin
   try
    ress:=onerow^[j];
    //if ress>500 then write('?',ress,mymy.sanat[j],'\',word(2+toa));
   // if ress>maks then begin maksw:=j;;maks:=ress;end;
     //continue;
     for k:=0 to tlen-1 do
     //for k:=1 to tlen do
    begin
      if ress>word((2+toa+k*4)^) then
      begin
           move((toa+k*4)^,(4+toa+k*4)^,(tlen-k-1)*4);
           move(j,     (toa+k*4)^,2);
           move(ress,(2+toa+k*4)^,2);
           if k=0 then maks:=ress;
           if k=0 then maksw:=j;
           if k=0 then writeln(' +',rowno,mymy.sanat[j],mymy.sanat[maksw],'>',k,'=',ress,'/clu:',wc(rowno,1).w,mymy.sanat[word(toa^)],' ');
           if k=0 then if rowno=1 then write('***',@mat-toa,'!');
           break;

      end;
    end;
   except writeln(^j,j,'Could not sort',QWORD(TOA-MAT));end;
   end;
  writeln(^j,'max:',mymy.sanat[maksw],maks)
end;

procedure tmat.list;
var i,j:word;rec:r_scarcefield;p:pointer;st:string;
begin
//for i:=0 to rows-1 do
for i:=1 to rows do
    begin
      //if sums[i]<10000 then continue;
      write(^j^j,sana(i),sums^[i],'::   ');
      for j:=1 to cols do
      begin
       write(' ',mymy.sanat[mat^[cols*i+j-1].w],'/',mat^[cols*i+j-1].s);
       { rec:=wc(i,j);
        //write(' _',rec.w);
        if rec.w=0 then write('!','!') else
        try
           //p:=pointer(mat);
           //p:=p+(r*cols+c)*4;

         //if rec.s>100 then
         write(' ',j,sana(rec.w),'/',rec.s,' ');
        except writeln('nogolist',rec.w);readln;end;
       //p:=wsmat;
       //p:=p+i*wsmat.cols+j;
       }
      end;
    end;
end;
function tmat.sana(wrd:word):string;
begin
   result:=mymy.sanat[wrd];
end;
function tmat.wc(r,c:word):r_scarcefield;
var p:pointer;rec:r_scarcefield;
begin
  try
   rec:=mat^[cols*r+c-1];
   result.w:=rec.w;
   result.s:=rec.s;
   exit;
  {p:=pointer(mat);
  p:=p+((r)*cols+c-1)*4;           //why  "-1" for c but not r?
  //mat^[(i*cols)+j].w],rec.s,')');
  //writeln('/get:',r,':',c,' from:',r*cols+c,'=',word(p^));
  result.w:=word(p^);
  result.s:=word((p+2)^);
  }
  except writeln('failgetcw',r,' ',c);raise
  ;end;
end;
function tmat.valueof(r,t:word):word;
var p:pointer;i:byte;
begin
  result:=0;
  try
   for i:=1 to cols do
    if mat^[r*cols+i-1].w=t then
    begin
     result:=mat^[r*cols+i-1].s;
     exit;
    end;
  except writeln('failgetval',r,' ',t);raise
  ;end;
end;

type wpoint=^word;

function tmat.fromfull(fulmat:p_fullmat):p_scarcemat;
var i,j,k:word;resp:pointer;fullw:wpoint;
  onerow:p_longrow;test1,test2:byte;mysum:longword;
  //onerow:^ar_fullrow;

 begin
//note-fullmat is implemented as a 1D array to keep it in one memory block
   //and fullmat WAS 0-based, whereas product is 1-based (item 0 reserverved for other use)
  //fullp:=pointer(fulmat);
  //fullw:=pointer(fulmat);
   onerow:=longrow;
   fillchar(onerow^,rows*4,0);
   writeln('nosort');
 //onerow:=getmem(rows*4);
  //getmem(fullrow,4*rows+1);
  //            getmem(onerow,500);
  try
  for i:=1 to rows do
  begin
     sums^[i]:=0;
    try;
     for j:=1 to rows do // if i<>j then
     sums^[i]:=sums^[i]+fulmat^[rows*(i-1)+ (j-1)];
     except  write('NOSUM:',i,':',j,'/sums!!!  ');end;
     end;
  //for j:=1 to rows do writeln(j,mymy.sanat[j],sums^[j]);

  for i:=1 to rows do onerow^[i]:=0;
  writeln('sMAT:',rows);//,' c',longword(mat),'-',longword(@mat^[10]),'-',longword(@mat^[10])-longword(mat));exit;
  //for i:=1 to ROWS do  write('_');
  for i:=1 to ROWS do
   begin
     try
      //write(i);
     fillchar(onerow^,4*(rows),0);
     if sums^[i]>0 then
     for j:=1 to rows do  //if i<>j then
     if sums^[j]>0 then
     begin
       onerow^[j]:=round((1000000000*fulmat^[rows*(i-1)+(j-1)])/((sums^[j]*sums^[i]+100000000))); //ADDED CONST TO DENOMINATOR TO PUNISH RARE WORDS
       //if j=3400 then if onerow^[j]>50 then write('//  ',mymy.sanat[i],onerow^[j],'/',fulmat^[rows*(i-1)+(j-1)],'  ');
     end else onerow^[j]:=0;
     onerow^[i]:=0;
     except  write(i,'nogo','xxxx',j,'/');end;
     try
     //if write(^j^j,sana(i),':',i);
     //resp:=pointer(mat);
     //resp:=resp+(i*cols*4);
     //nosortedrow(onerow,i,resp,ROWS,cols);
     for j:=1 to rows do
     if onerow^[j]>mat^[i*cols+cols-1].s then
     for k:=2 to cols   do
      if onerow^[j]>wc(i,k).s then
      begin
         move(mat^[i*cols+k-1],mat^[i*cols+k],4*(cols-k));
         setval(i,k,j,onerow^[j]);
         break;
      end;
     mysum:=0;
     for j:=1 to cols do mysum:=mysum+wc(i,j).s;
     setval(i,1,i,mysum);

     //if i=rows-0 then for j:=1 to cols do write('{',mymy.sanat[wc(i,j).w],':',wc(i,j).w,'} ');
     //write('***',word((fullp)^));
     //if (i=7) or (i=8) then writeln(^j);
     //if i=rows then for j:=i to cols do write(j,mymy.sanat[mat^[rows*cols+j].w],mat^[rows*cols+j].s,';;; ');

except write('FAILSORT');end;
  end;
  //for i:=1 to rows do if wc(i,0).s>40000 then writeln(mymy.sanat[i],':',wc(i,0).s,'!');

  for i:=1 to rows do begin sums^[i]:=0;for j:=1 to cols do sums^[i]:=sums^[i]+wc(i,j).s;end;
   //writeln(mymy.sanat[i],sums[i],mymy.sanat[wc(i,1).w],'/',wc(i,0).s);end;
  //list;
  result:=mat;
 // freemem(fullmat,2*n_w*n_w);
 finally   //freemem(onerow,4*(rows+1));
  // halt;
 end;
 for j:=1 to cols do
 begin
  //write(' [',sanat[wsmat.wc(rows-1,j).w],' ',inttohex(wsmat.wc(rows-1,j).s,4),']');
  write(' [',inttohex(wc(rows,j).w,4),' ',inttohex(wc(rows,j).s,4),']');
   if j mod 4 =0 then writeln;
 end;
 writeln;writeln;
 for j:=1 to cols do
 begin
  //write(' [',sanat[wsmat.wc(rows-1,j).w],' ',inttohex(wsmat.wc(rows-1,j).s,4),']');
  write(' (',(wc(rows,j).w),' ',(wc(rows,j).s),')');
   if j mod 4 =0 then writeln;
 end;
  writelN; writelN;
   writelN; writelN;
//for itarg:=rows to rows do //1 to rows do
//for jtarg:=1 to cols  do if itarg=rows then //  wsmat.wc(itarg,jtarg).w>rows then
 //write(^j,itarg,':',jtarg,' > ',mat^[itarg*rows+jtarg].w);
 {for i:=1 to rows do
 begin
  writeln(mymy.sanat[i],i);
 for j:=1 to cols do write('{',mymy.sanat[wc(i,j-1).w],'} ');//,wsmat.wc(rows,j).s,' ');
 writeln;
 writeln;
 end;}
  //writeln(rows);
  for j:=1 to cols do write('[!',mymy.sanat[wc(rows,j).w],'::::',wc(rows,j).w,']');
  mymy.saveafile('wxw.sca',MAT,(rows+1)*cols*4);
  //fillchar(mat^,4*(rows+1)*(cols),0);
  //mymy.readafile('wxw.sca',MAT,n_w*n_c*4);

  //for j:=1 to cols do write('[!',mymy.sanat[wc(rows,j).w],':',wc(6461,j).w,']');
  for j:=1 to cols do begin write('[!',mymy.sanat[wc(rows,j).w],':',wc(6461,j).w,']');end;
      //halt;
  writeln;
end;

procedure tmat.getsums;
var i,j:word; r:r_scarcefield;
begin
 for i:=1 to rows do
 begin
   sums^[i]:=0;
  for j:=1 to cols do
  begin
   r:=wc(i,j);
   if r.w=0 then continue;
   sums^[i]:=sums^[i]+r.s;
  end;
 end;

end;

function tmat.w(r,o:word):word;
begin
    result:=mat^[r*cols+o-1].w;
end;
function tmat.c(r,o:word):word;
var p:pointer;
begin
 result:=mat^[r*cols+o-1].s;
 //p:=pointer(mat);
 //p:=p+(r*cols+c)*4;
 //writeln('/get:',r,':',c,' from:',r*cols+c,'=',word(p^));
 //result:=word((p+2)^);
end;

function tmat.addtorow(r,tar,siz:word):word;
var i,place:word;
begin
 place:=rows;
 for i:=1 to cols do if w(r,i)=0 then
 begin  place:=i;break;end;
 mat^[cols*r+place-1].w:=tar;
 mat^[cols*r+place-1].s:=siz;
 result:=1;//mat[
end;

function tmat.setval(r,o,tar,siz:word):word;
begin
 mat^[cols*r+o-1].w:=tar;
 mat^[cols*r+o-1].s:=siz;
 result:=1;//mat[
 //writeln('ddiset:',r,':',o,mymy.sanat[mat^[cols*r+o-1].w],'=',mat^[cols*r+o-1].s);
 //writeln('iddset:',r,':',o,mymy.sanat[tar],'=',siz);

end;
function tmat.setsize(r,o,siz:word):word;
begin
 //mat^[cols*r+o].w:=r;
 mat^[cols*r+o-1].s:=siz;
 result:=1;//mat[
end;

constructor tmat.create(rown,coln:word);
var i,j:word;  p:^word;pi:word;
begin
 mymy:=tmppointer;
 rows:=rown;
 cols:=coln;
 getmem(sums,rows*4);
 fillchar(sums^,rows*4,0);
 getmem(longrow,4*rows);  //for some reason crashes if mem reserved later on
 //setlength(onerow,rows);
 getmem(mat,4*(rows+1)*(cols));  //row & cols [0] reserved for special use
 writeln('gotmem',4*(rows+1)*(cols),' R:',rows,' C:',cols);
 fillchar(mat^,4*(rows+1)*(cols),0);
 //setlength(sums,rows+1);
     //tmppointer.readafile('wxw.sca',mat,n_w*n_c*4);

     //writeln(^j^j,'****xxxxxxxxxxx',tmppointer.sanat[1]);
     //for j:=1 to cols do  write('M ',mymy.sanat[wc(rows-1,j).w],wc(rows,j).w);
     //for j:=1 to cols do  writeln(wc(rows-1,j).w,';:  ',mymy.sanat[wc(rows-1,j).w]);
     //for j:=1 to cols do  writeln(tmppointer.sanat[wc(rows-0,j).w],wc(rows-0,j).w,';:  ');
     //for j:=1 to cols do  writeln(tmppointer.sanat[wc(2-0,j).w],wc(2-0,j).w,';:  ');
//halt;
end;

function tmat.readfullmatrix:p_fullmat;
var f:file;i,j:longword;    fullmat:p_fullmat;
  p:^word;val:word;
  rawsums:array[1..6461] of longword;
  rowsum:longword;
  //p:pointer;

begin
 try
  fullmat:=getmem(rows*rows*2);
  // fillchar(fullmat^,sizeof(fullmat^),#0); //setlength(fullmat,n_w*n_w);
  assign(f,'bigmat.bin');
  Reset (F,rows*rows*2);
  fillchar(fullmat^,rows*rows*2,0);
  Blockread (F,fullmat^,1);
  close (f);
  RESULT:=FULLMAT;
  except  write('********',rows*rows*2);end;
  writeln('did .',rows*rows*2);
  for i:=1 to rows do  begin rawsums[i]:=0;  for j:=1 to rows do  if i<>j then rawsums[i]:=rawsums[i]+fullmat^[i*rows+j]; end;
   for i:=1 to rows do if rawsums[i]>0 then
    for j:=1 to rows do  if i<>j then if rawsums[j]>0 then
      fullmat^[i*rows+j]:=round((1000000000*fullmat^[i*rows+j])/((rawsums[j]*rawsums[i]+100000000))); //ADDED CONST TO DENOMINATOR TO PUNISH RARE WORDS
end;

