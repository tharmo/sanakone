unit sanatypes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,math;
var n_c:integer=64;n_w:integer=6461;noword:WORD=(high(word));EMPTYR:ARRAY[0..1] OF WORD=(HIGH(WORD),0);
tmppointer:pointer;//tmylly;

type r_scarcefield=record  w,s:word;end;
type p_scarcefield=^r_scarcefield;

//type r_scarcerow=array[0..64] of r_scarcefield;
//type a_scarcerow=array of r_scarcefield;
type ar_matcol=array[0..9999] of word;
type ar_longrow=array[0..999999] of longword;
 type p_matcol=^ar_matcol;
type a_scarcemat=array[0..999999]  of r_scarcefield;//array of a_scarcerow; techically 1D, in effect 2D
type p_scarcemat=^a_scarcemat;
type p_longrow=^ar_longrow;
type ar_fullmat=packed array[0..99999] of word;
type p_fullmat=^ar_fullmat;
 type wpoint=^word;
 type tcluscors=class(tobject)
 mat:p_fullmat;  //zero based
 siz:word;
 function square:tcluscors;
 procedure list(pcsmat:pointer);
 function get(r,c:word):word; //one-based
 procedure setval(r,c,val:word);
 procedure addval(r,c,val:word);
 function sum(r:word):longword;
 procedure savefile(fn:string);
 function readfile(fn:string):word;
 constructor create(matsiz:word);
 constructor createfrom(fn:string);
end;

 type a_mergehistory=array[0..3000] of array[1..3] of word;p_mergehistory=^a_mergehistory;
 //type tmylly=class;

implementation
uses sanamat;

procedure tcluscors.list(pcsmat:pointer);
var i,j:word;csmat:tmat;
begin
   csmat:=tmat(pcsmat);
   writeln('LIST:',siz);
   for i:=1 to 20 do
   begin
       writeln(^j,i,csmat.listc(i),' ::: ',j,csmat.listc(j),' :',get(i,j));// else write(cluscors.get(i,j),':');
   end;
   writeln(^j,'===================================================');
   for i:=1 to siz do
   begin
     for j:=1 to siz do if get(i,j)>3000 then
     begin
       writeln(^j,i,csmat.listc(i),' ::: ',j,csmat.listc(j),' :',get(i,j));// else write(cluscors.get(i,j),':');
     end;
   end;
end;

procedure tcluscors.savefile(fn:string);
 var f:file;
 begin
 assign(f,fn);
 Rewrite (F,siz*siz*2);
 writeln('*******write:',fn,'*',siz,'/FSIZE:',SIZ*SIZ*2);
 try
 Blockwrite (F,mat^,1);
 except writeln('could not write matfile ',fn);end;
 close (f);
end;
function tcluscors.readfile(fn:string):word;
 var f:file;
 begin
  // if siz=0 then siz:=rows*cols*4;

 assign(f,fn);
 writeln('checksize:',fn,siz,'/',siz*siz*2);
 try
 Reset(F,1);
 siz:=round(sqrt(filesize(f))/ 2);   //rows*cols*4;
 writeln(^J,^J,'*******REAd:',fn,'*',siz,'/FSIZE:',FILESIZE(F));
 close(f);
 reset(f,siz*siz*2);
 Blockread (F,mat^,1);
 except writeln('could not read matfile ',fn);end;
 close (f);
end;

function tcluscors.get(r,c:word):word;
begin
  result:=mat^[siz*(r-1)+(c-1)];
end;

procedure tcluscors.setval(r,c,val:word);
begin
 mat^[((r-1)*siz)+c-1]:=val;
end;
procedure tcluscors.addval(r,c,val:word);
begin
 try
 mat^[(r-1)*siz+c-1]:=mat^[((r-1)*siz)+(c-1)]+val;

 except writeln('failaddval:',r,':',c,'=',val,':',(r-1)*siz+(c-1),'/',siz );end;
end;
function tcluscors.sum(r:word):longword;
var i:word;
begin
  result:=0;
  for i:=0 to siz-1 do
   result:=result+mat^[siz*(r-1)+i];

end;
function tcluscors.square:tcluscors;
var i,j,k:word;sm,ij:longword;half:word;sums:array[1..2000] of longword;
begin
  result:=tcluscors.create(siz);
  half:=siz div 2;
  writeln('squaring:',half,'*',siz);
  for i:=0 to half-1 do begin sums[i]:=0;   for j:=0 to half-1 do sums[i]:=sums[i]+mat^[siz*i+j];end;

  for i:=0 to half-1 do
  begin
  writeln('XX****************');
    writeln(i,' :');
    for j:=0 to half-1 do  //if j<>i then
    begin
      //ij:=mat^[siz*i+j];
      write('.');
      sm:=0;
       //result.mat[i,j]:=0;
      for k:=0 to half-1 do  //do  if k<>i then
      sm:=sm+10*min(mat^[i*siz+j],mat^[i*siz+j]);
        //sm:=sm+mat^[i*siz+j]*mat^[i*siz+j];
      result.mat^[i*siz+j]:=sm div (1+sums[i]);
      write(sm div (1+sums[i]),' ');
    end;
  end;

end;

constructor tcluscors.createfrom(fn:string);
 var f:file;i,j:word;
 begin
  // if siz=0 then siz:=rows*cols*4;

 assign(f,fn);
 writeln('checksize:',fn,siz,'/',siz*siz*2);
 try
 Reset(F,1);
 siz:=round(sqrt(filesize(f)/ 2));   //rows*cols*4;
 writeln(^J,^J,'*******REAd:',fn,'*',siz,'/FSIZE:',FILESIZE(F));
 close(f);
 getmem(mat,siz*siz*2);
 reset(f,siz*siz*2);
 Blockread (F,mat^,1);
 except writeln('could not read matfile ',fn);end;
 close (f);
 writeln('created full clusmat of ',siz,' /mem:',siz*siz*2);
end;
constructor tcluscors.create(matsiz:word);
begin
   siz:=matsiz;       // n of cols (and of rows) of square full matrix
   getmem(mat,siz*siz*2);
   fillchar(mat^,siz*siz*2,0);
   writeln('created full clusmat of ',matsiz,' /mem:',siz*siz*2);


end;


end.

