procedure tmat.sortedrow(onerow:p_fullrow;rowno:word;toa:pointer;flen,tlen:word);
vAR J,k,resw,ress:word;maks,maksw:longWORD;
begin
 try
  maks:=0;maksw:=0;
  word(toa^):=rowno;
  word((toa+2)^):=sums[rowno];
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
    for k:=1 to tlen do  //note: [0] filled above with the sum
    begin
      if ress>word((2+toa+k*4)^) then
      begin

           //if k<4 then write(' +',mymy.sanat[j],'>',k,'=',ress,' ');
           move((toa+k*4)^,(4+toa+k*4)^,(tlen-k)*4);
           move(j,     (toa+k*4)^,2);
           move(ress,(2+toa+k*4)^,2);
           break;

      end;
    end;
   except writeln(^j,j,'Could not sort',QWORD(TOA-MAT));end;
   end;
  //writeln(^j,'max:',tmylly(mymylly).sanat[maksw+1],maks)
end;
procedure tmat.list;
var i,j:word;rec:r_scarcefield;p:pointer;st:string;
begin
//for i:=0 to rows-1 do
for i:=7 to 7 do
    begin
      //if sums[i]<10000 then continue;
      write(^j^j,sana(i),sums[i],'::');
      for j:=0 to cols do
      begin
        rec:=wc(i,j);
        //write('-',rec.w);

        //if rec.w=0 then continue;
        try
         //if rec.s>100 then
         write(j,sana(rec.w),mymy.sanat[mat^[i*cols+j].w],rec.s,'_ ');
        except writeln('nogolist',rec.w);end;
       //p:=wsmat;
       //p:=p+i*wsmat.cols+j;
      end;
    end;
end;
function tmat.sana(wrd:word):string;
begin
   result:=mymy.sanat[wrd];
end;
function tmat.wc(r,c:word):r_scarcefield;
var p:pointer;
begin
  try
  p:=pointer(mat);
  p:=p+(r*cols+c)*4;
  //writeln('/get:',r,':',c,' from:',r*cols+c,'=',word(p^));
  result.w:=word(p^);
  result.s:=word((p+2)^);
  except writeln('failgetcw');end;
end;

type wpoint=^word;

function tmat.fromfull(fulmat:p_fullmat):p_scarcemat;
var i,j:word;resp:pointer;fullw:wpoint;
  onerow:p_fullrow;
  //onerow:^ar_fullrow;

 begin
//note-fullmat is implemented as a 1D array to keep it in one memory block
   //and fullmat is 0-based, whereas product is 1-based (item 0 reserverved for other use)
  //fullp:=pointer(fulmat);
  //fullw:=pointer(fulmat);
   onerow:=fullrow;
  writeln('nosort');
  //getmem(fullrow,4*rows);
  //getmem(onerow,500);
   writeln('nosort');
  try
  for i:=1 to rows do
  begin
     sums[i]:=0;
    try;
     for j:=1 to rows do  if i<>j then
     sums[i]:=sums[i]+fulmat^[rows*(i-1)+(j-1)];
     except  write('NOSUM:',i,':',j,'/sums!!!  ');end;
     end;
  //for i:=1 to rows do for j:=1 to cols do onerow^[i]:=0;
  //   if sums[i]>40000 then writeln(i,mymy.sanat[i],sums[i]);
  for i:=1 to ROWS do
   begin
     try
     fillchar(onerow^,4*(rows),0);
     if sums[i]>0 then
     for j:=1 to rows do if i<>j then
     if sums[j]>0 then
     begin
       onerow^[j]:=round((1000000000*fulmat^[rows*(i-1)+(j-1)])/((sums[j]*sums[i]+100000000))); //ADDED CONST TO DENOMINATOR TO PUNISH RARE WORDS
       //if i=7 then if j=9 then write(' //////////',onerow^[j],'/',fulmat^[rows*(i-1)+(j-1)]);
     end else onerow^[j]:=0;
     except  write(i,'nogo','xxxx',j,'/');end;
     try
     //write(^j^j,sana(i),':',i);
     resp:=pointer(mat);
     resp:=resp+(i*cols*4);
     sortedrow(onerow,i,resp,ROWS,cols);
     if i=7 then for j:=0 to cols do write(j,mymy.sanat[mat^[i*cols+j].w],mat^[i*cols+j].s,';;; ');
     //write('***',word((fullp)^));
     if (i=7) or (i=8) then writeln(^j);
     if i=8 then for j:=0 to cols do write(j,mymy.sanat[mat^[7*cols+j].w],mat^[7*cols+j].s,';;; ');
     except write('FAILSORT');end;
  end;
  //for i:=1 to rows do if wc(i,0).s>40000 then writeln(mymy.sanat[i],':',wc(i,0).s,'!');

  for i:=1 to rows do begin sums[i]:=0;for j:=1 to cols do sums[i]:=sums[i]+wc(i,j).s;end;
   //writeln(mymy.sanat[i],sums[i],mymy.sanat[wc(i,1).w],'/',wc(i,0).s);end;
  //list;
  result:=mat;
 // freemem(fullmat,2*n_w*n_w);
 finally   freemem(onerow,4*(rows));end;

end;

procedure tmat.getsums;
var i,j:word; r:r_scarcefield;
begin
 for i:=1 to rows do
 begin
   sums[i]:=0;
  for j:=1 to cols do
  begin
   r:=wc(i,j);
   if r.w=0 then continue;
   sums[i]:=sums[i]+r.s;
  end;
 end;

end;

function tmat.w(r,o:word):word;
begin
    result:=1;//mat[
end;
function tmat.c(r,o:word):word;
var p:pointer;
begin
 p:=pointer(mat);
 p:=p+(r*cols+c)*4;
 //writeln('/get:',r,':',c,' from:',r*cols+c,'=',word(p^));
 result:=word((p+2)^);
end;

function tmat.addtorow(r,tar,siz:word):word;
var i,place:word;
begin
 place:=rows;
 for i:=0 to cols do if w(r,i)=0 then
 begin  place:=i;break;end;
 mat^[cols*r+place].w:=tar;
 mat^[rows*r+place].s:=siz;
 result:=1;//mat[
end;

function tmat.setval(r,o,tar,siz:word):word;
begin
 mat^[cols*r+o].w:=r;
 mat^[cols*r+o].s:=siz;
 result:=1;//mat[
end;
function tmat.setsize(r,o,siz:word):word;
begin
 //mat^[cols*r+o].w:=r;
 mat^[cols*r+o].s:=siz;
 result:=1;//mat[
end;

constructor tmat.create(rown,coln:word);
var i,j:word;  p:^word;pi:word;
begin
 //writeln('gotmammmmmmmmmmm');
 rows:=rown;
 cols:=coln;
 mat:=getmem(4*(rows)*(cols));  //row & cols [0] reserved for special use
 fullrow:=getmem(4*rows);
 //setlength(onerow,rows);
 fillchar(mat^,2*(rows)*(cols),0);
 setlength(sums,rows);

end;

function tmat.readfullmatrix:p_fullmat;
var f:file;i,j:longword;    fullmat:p_fullmat;
  p:^word;val:word;
  rawsums:array[0..6461] of longword;
  rowsum:longword;
  //p:pointer;

begin
 try
  getmem(fullmat,rows*rows*2);
  // fillchar(fullmat^,sizeof(fullmat^),#0); //setlength(fullmat,n_w*n_w);
  assign(f,'bigmat.bin');
  Reset (F,rows*rows*2);
  fillchar(fullmat^,rows*rows*2,0);
  Blockread (F,fullmat^,1);
  close (f);
  RESULT:=FULLMAT;
  except  write('********',rows*rows*2);end;
  writeln('did .',rows*rows*2);
  for i:=0 to rows do  begin rawsums[i]:=0;  for j:=1 to rows do  if i<>j then rawsums[i]:=rawsums[i]+fullmat^[i*rows+j]; end;
   for i:=0 to rows do if rawsums[i]>0 then
    for j:=0 to rows do  if i<>j then if rawsums[j]>0 then
      fullmat^[i*rows+j]:=round((1000000000*fullmat^[i*rows+j])/((rawsums[j]*rawsums[i]+100000000))); //ADDED CONST TO DENOMINATOR TO PUNISH RARE WORDS
end;

