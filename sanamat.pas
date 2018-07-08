unit sanamat;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,sanatypes,math;

  type tmat=class(tobject)
     //clusts:p_scarcemat;
  //private
  prOTECTED
       mat:p_scarcemat;
       sums:p_longrow;//array of longword;
  public
     rows,cols:WORD;
     //clustcount:word; //sjhould be here, just a tmp
     mymy:pointer;
     longrow:p_longrow;
     //onerow:array[0..6465] of longword;
     matcol:^ar_matcol;
     //longrow:p_longrow;
    procedure mergewords(resrow,c1,c2:word;var cluscount:word);
    function listc(clu:word):string;

     function scarce2full(wmat:tmat;cc:word):tcluscors;//p_fullmat;  //full cluster cors from clus*words
     //procedure clusterrow(resmat:p_fullmat;wmat:tmat;thisrow,rcount:word);  //full cluster cors from clus*words
     procedure clusterrow(resmat:tcluscors;wmat:tmat;thisrow,rcount:word);  //full cluster cors from clus*words
     procedure mergerow(resmat:p_fullmat;wmat:tmat;old1,old2,row,rcount:word);  //full cluster cors from clus*words
     procedure oldmergerow(resmat:p_fullmat;wmat:tmat;old1,old2,row,rcount:word);  //full cluster cors from clus*words
     function getrow(no:word):p_scarcefield;
     function oldgetrow(no:word):p_scarcefield;
     function topvalueof(r,t,tocount:word):word;
     function oldtopvalueof(r,t,tocount:word):word;
     function valueof(r,t:word):word;
     function oldvalueof(r,t:word):word;
     function addtorow(r,tar,siz:word):word;
     function addtorowsorted(r,tar,siz:word):word;
     function OLDaddtorow(r,tar,siz:word):word;
     function wc(r,c:word):r_scarcefield;
     function readfullmatrix:p_fullmat;
     procedure sortedrow(onerow:p_longrow;rowno:word;toa:pointer;flen,tlen:word);
     function w(r,o:word):word;
     function oldw(r,o:word):word;
     function c(r,o:word):word;
     function oldwc(r,cc:word):r_scarcefield;
     function setval(r,o,tar,siz:word):word;
     function oldsetval(r,o,tar,siz:word):word;
     function setsize(r,o,siz:word):word;
     function oldsetsize(r,o,siz:word):word;
     function fromfull(fulmat:p_fullmat):p_scarcemat;
     function oldfromfull(fulmat:p_fullmat):p_scarcemat;
     function insertat(r,o,tar,siz:word):word;
     function sum(row:word):longint;
     constructor create(rown,coln:word);
     destructor free;
     function sana(wrd:word):string;
     function oldsana(wrd:word):string;
     function getsum(row:word):longword;
     procedure setsum(row:word;val:longword);
     procedure clearmat;
     procedure clearsums;
     procedure incsum(row:word;val:longword);
     procedure list;
     procedure oldlist;
     procedure savefile(fname:string;siz:longword);
     function readfile(fname:string;siz:longword):word;
     procedure savenonzeroes(fn:string);
     procedure swapmat(newmat:p_scarcemat);

   end;

implementation
  uses sanamylly;
procedure tmat.setsum(row:word;val:longword);
begin
   sums^[row-1]:=val;
end;
function tmat.getsum(row:word):longword;
begin
   result:=sums^[row-1];
end;
procedure tmat.incsum(row:word;val:longword);
begin
   sums^[row-1]:=sums^[row-1]+val;
   //write(
end;
procedure tmat.clearsums;
begin
      fillchar(sums^,rows*4,0);

end;
procedure tmat.clearmat;
begin
      fillchar(mat^,rows*cols*4,0);

end;

   procedure tmat.oldmergerow(resmat:p_fullmat;wmat:tmat;old1,old2,row,rcount:word);  //full cluster cors from clus*words
var j,c1,c2,xval:word;reci,recj,rew1,rew2:r_scarcefield;asum,avali:longword;

begin
{ sums^[row]:=0;
 asum:=0;
 //write(^j^j,sana(wc(old1,1).w],old1,'/',sana(wc(old2,1).w],old2,':: ',row,'::;;;;! ',tmylly(mymy).mergecount);
for c1:=0 to rcount-1 do //if row<>j then if sums^[j]>0 then        //for each pair of cluster
 // for j:=1 to rcount do if row<>j then if sums^[j]>0 then        //for each pair of cluster
 if c1<>old1 then if c1<>old2 then
 begin
   //if word((csums+c1*2)^)=0 then continue;
   //RESMAT^[row*cluscount+c1-1]:=(100*resmat^[old1*cluscount+c1-1]*resmat^[old2*cluscount+c1-1]) div (1+word((csums+c1*2)^));
   //avali:=2*min(resmat^[old1*cluscount+c1-1],resmat^[old2*cluscount+c1-1]);
   //write(resmat^[old1*cluscount+c1-1],';',resmat^[old2*1000+c1-1],' ');
   //write(resmat^[old1*cluscount+c1-1],'/',resmat^[old2*cluscount+c1-1],'/',' ');

   avali:=round(sqrt(1+resmat^[old1*cluscount+c1-1]*resmat^[old2*cluscount+c1-1]));//(1+10*(csums[c1]*csums[c2]));
   //avali:=(resmat^[old1*1000+c1-1]+resmat^[old2*1000+c1-1]) div 2;//(1+10*(csums[c1]*csums[c2]));
   //write('==',avali,' ');
   RESMAT^[row*cluscount+c1-1]:=RESMAT^[row*cluscount+c1-1]+avali;// div (1+word((csums+c1*2)^));
   RESMAT^[c1*cluscount+row-1]:=RESMAT^[c1*cluscount+row-1]+avali;// div (1+word((csums+c1*2)^));
   //RESMAT^[c1*1000+rows-1]:=RESMAT^[c1*1000+rows-1]+round(100*log2(1+resmat^[old1*1000+c1-1]*resmat^[old2*1000+c1-1] div (1+word((csums+c1*2)^))));
   //RESMAT^[row*1000+c1-1]:=min(resmat^[old1*1000+c1-1],resmat^[old2*1000+c1-1]);// div 2;
   //RESMAT^[old1*1000+row-1]:=resmat^[row*1000+c1-1];
    //if (old1>cluscount) then if avali>20 then write(sana(wc(c1,1).w],RESMAT^[row*1000+c1-1],' ');

   asum:=asum+resmat^[row*cluscount+c1-1];
  end;
  //if asum>10 then
  //write('[[',asum,'/',word((csums+old1*4)^),'/',word((csums+old2*4)^),']]');
  sums^[row]:=asum;
}
end;

 function tmat.listc(clu:word):string;
 var i:word;
 begin
   result:='';
   for i:=0 to 5 do result:=result+'/'+sana(wc(clu,i).w);
 end;


function tmat.scarce2full(wmat:tmat;cc:word):tcluscors;//p_fullmat;  //full cluster cors from clus*words
   var maxc1,maxc2,i,j,w1,w2,iter:word;reci,recj,rew1,rew2:r_scarcefield;
     ival,jval,maxs,xval:longword;merged:array[0..1001] of word;debug:boolean;
   begin
   //cc:=500; //got to get this from somewhere
   writeln('doful',cc,'*',rows,'**',cc);
     //getmem(result,2000*2000*2);
     result:=tcluscors.create(rows*2);  //2x - room for combined clusters
     //fillchar(result^,2000*2000*2,0);
     //cc:=300;//tmylly(mymy).cluscount;
     tmylly(mymy).cluscount:=cc;
     maxs:=0;
     //////////////  Normalize word/word cors////////////
     {for w1:=1 to wmat.rows do
     begin
       wmat.sums^[w1]:=0;
       for w2:=1 to wmat.cols do if wmat.wc(w1,w2).w=0 then break else
        begin
        wmat.sums^[w1]:=wmat.sums^[w1]+(wmat.wc(w1,w2).s);// div 10); //write(wmat.wc(w1,w2).s,'/');
        end;
        if maxs<wmat.sums^[w1] then maxs:=wmat.sums^[w1];
     end;}

     //for w1:=1 to wmat.rows do wmat.sums^[w1]:=(1000*wmat.sums^[w1]) div maxs;
     maxs:=0;
     //////////////  Normalize clust/clust cors////////////
     for i:=1 to cc do
     begin
       //sums^[i]:=0;
       setsum(i,0);
       for w1:=1 to cols do
       begin
         rew1:=wc(i,w1);  //from
         if rew1.w=0 then break else
         incsum(i,rew1.s);
         //sums^[i]:=sums^[i]+rew1.s;
         if maxs<sum(i) then maxs:=sum(i);
       end;
     end;
     writeln('MAX:',maxs,'/',rows);
     for i:=1 to rows do
     begin
       setsum(i,1000*sum(i) div maxs);
      //sums^[i-1]:=(1000*sums^[i-1]) div maxs;
      //if i<20 then writeln('s[',i,']=',sana(wc(i,1).w),sum(i));

     end;
     writeln('gotsums:',maxs);

     //////////////  calculate clust/clust cors ////////////
     for i:=1 to cc do if sums^[i]>0 then
     begin
       clusterrow(result,wmat,i,cc);  //get to 0-based matrix but note: i is one-based
     end;
     writeln('gotrows',cols,'*',rows,'**',cc);
     //for i:=1 to rows do   write(sum(i),'\ ');
     {for i:=1 to cc do
     begin
       result^[cluscount*i+i-1]:=0;
       for j:=1 to cc do if i<>j then
           result^[i*cluscount+i-1]:=result^[i*cluscount+i-1]+result^[1000*i+j-1];
       for j:=1 to cc do if i<>j then
           result^[i*cluscount+j-1]:=cluscount*(result^[i*cluscount+j-1]) div (1+result^[1000*i+i-1]);
     end;
     for i:=1 to cc do
     begin
       result^[cluscount*i+i-1]:=0;
       for j:=1 to cc do if i<>j then
           result^[i*cluscount+i-1]:=result^[i*cluscount+i-1]+result^[1000*i+j-1];

     end;
     }
     for i:=10000 to cc do
     begin
      write(^j^j,uppercase(sana(wc(i,1).w)),result.get(1,1));
      //[1000*(i-1)+i-1],' ');
      for j:=1 to cc do
      //if result^[(i-1)*1000+(j-1)]>10000 then
       write(j,sana(wc(j,1).w),result.get(i,j),'\/');
     //if xval>0 then
     end;

   end;

function tmat.oldgetrow(no:word):p_scarcefield;
   begin
   result:=p_scarcefield(mat)+no*cols-1;
   end;
procedure tmat.swapmat(newmat:p_scarcemat);
begin
writeln('free:',rows,'*',cols);
freemem(mat,4*(rows+1)*(cols));  //row & cols [0] reserved for special use
writeln('freed');
//mat:=newmat.mat;
mat:=newmat;
writeln('gotnew');
end;

procedure tmat.mergewords(resrow,c1,c2:word;var cluscount:word);
var i,j,val:word;r:r_scarcefield; ws:array[0..15] of word;
  procedure srt(rr:r_scarcefield;src:word);
  var k:word;
  begin
    //if resrow<=500 then exit;
    for k:=2 to 15 do
    //if rr.s>wc(resrow,k).s then
    if rr.s>mat^[(resrow-1)*cols+k].s then
    begin
      move(mat^[(resrow-1)*cols+k],mat^[(resrow-1)*cols+k],4*(16-k));
      //setval(resrow,k,rr.w,rr.s);
      mat^[(resrow-1)*cols+k].w:=rr.w;
      mat^[(resrow-1)*cols+k].s:=rr.s;
      //write(sana(wc(resrow,k+1).w),src,'/');
      break;
    end;
  end;
  begin

     fillchar(mat^[resrow*cols],4*cols,0);
     rows:=rows+1;
     setval(resrow,1,wc(c1,1).w,wc(c1,1).s);
     setval(resrow,2,wc(c2,1).w,wc(c2,1).s);
     //FILLDWORD(mat^[resrow*cols],cols,LONGWORD(EMPTYR));
    //for i:=1 to rows do  ws[wc(c1,i).w]:=ws[wc(c1,i).w]+ws[wc(c1,i).s];
    //WRITE(^j,^j,'MERGEwords:',RESROW, '/ ',rows,sana(wc(c1,1).w),'/',sana(wc(c2,1).w),'::: ');
    for i:=2 to COLS do
    begin
      r:=wc(c1,i);
      //if r.w>cluscount then
      srt(r,1);
             //for j:=1 to 16 do if wc(c2,i).w>0 then if wc(c2,i).w=r.w then write(':',sana(wc(c2,i).w));
      r:=wc(c2,i);
      //if r.w>cluscount then
      srt(r,2);
      //if r1.w=0 then break;
    end;
    //writeln;
    for I:=1 to COLS do
    begin
      IF wc(resrow,i).w=0 THEN BREAK;
      //write(sana(wc(resrow,i).w),'!');
    end;

end;

procedure tmat.savenonzeroes(fn:string);
var f:file;p:^word;i,j,nz:word;
begin
    assign(f,fn);
    Rewrite (F,cols*4);
    writeln('writing');
    nz:=0;
    for i:=1 to rows-1 do   //todo: change to zero-base
    //if  mat.mat^[cols*i].w>0 then
    begin
     if wc(i,2).w>0 then // else // begin write(^j,'*""""""""""""""""""""""""""""""""""');continue;end   else
     begin
      //wcor:=csmat.mat^[cols*i].w;
      p:=pointer(mat);
      p:=p+(2*cols*(i-1));
      //wcor:=word(p^);
      //if wcor>0 then
      nz:=nz+1;
      //if wcor>0 then
      try
      Blockwrite(F,p^,1);except write('failfile');end;
      //try   if i<1000 then  write(^j,i ,'---- ',nz,':',sana(word(p^)));except write('!!!!!!'); end;
      //try  if i<1000  then for j:=1 to 7 do
      //  write(' *',sana(wc(i,j).w));
      //except write('!!!!!!'); end;
      //write('//',sana(csmat.wc(i,2).w));
       //Blockwrite(F,(pointer(csmat.mat)+cols*i*4)^,1);
     end;
    end;
    writeln('didsave nonzeroes:',nz,'/size:',FileSize(f));
    close(f);
end;
procedure tmat.savefile(fname:string;siz:longword);
var f:file;
begin
  if siz=0 then siz:=rows*cols*4;
writeln('save:',fname,siz);
assign(f,fname);
Rewrite (F,siz);
try
Blockwrite (F,mat^,1);
except writeln('could not write matfile ',fname);end;
close (f);
end;
function tmat.readfile(fname:string;siz:longword):word;
var f:file;
begin
   write('matread:',fname,siz);
  assign(f,fname);
  try
  if siz=0 then
  begin
    reset(f,1);
    siz:=filesize(f);   //rows*cols*4;
    close(f);
  end;
  except writeln('could not get size:',fname,siz);end;
  Reset (F,siz);
try
Blockread (F,mat^,1);
except writeln('could not read matfile ',fname,'siz:',siz,'/',filesize(f) );end;
close (f);
result:=siz div (4*cols);
write(^j,'size:',siz,' cols:',cols,' linesread:',result);

end;


{$I sanamat.inc}
{$I sanamatnew.inc}

end.


