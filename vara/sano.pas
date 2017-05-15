unit sano;

{$mode objfpc}{$H+}

interface
uses
  Classes, math,SysUtils;
  var n_c:integer=64;n_w:integer=6461;
  type r_scarcefield=record  w,s:word;end;
  //type r_scarcerow=array[0..64] of r_scarcefield;
  //type a_scarcerow=array of r_scarcefield;
  type ar_matcol=array[1..999999] of word;
  type ar_longrow=array[1..999999] of longword;
   //type ar_fullrow=array[1..999999] of longword;
   //type p_fullrow=^ar_fullrow;
   type p_matcol=^ar_matcol;
  type a_scarcemat=array[1..9999]  of r_scarcefield;//array of a_scarcerow; techically 1D, in effect 2D
  type p_scarcemat=^a_scarcemat;
  type p_longrow=^ar_longrow;
  type ar_fullmat=packed array[0..99999] of word;
  type p_fullmat=^ar_fullmat;
   //tricks.. could not get fillchars blockreads etc to work with dyn arrays, so just made big enough 1D abs array. Jus needed memory allocate, tho
  type tmylly=class;
  type tmat=class(tobject)
     mat:p_scarcemat;
     //clusts:p_scarcemat;
     rows,cols:WORD;
     sums:p_longrow;//array of longword;
     mymy:tmylly;
     longrow:p_longrow;
     //onerow:array[0..6465] of longword;
     matcol:^ar_matcol;
     //longrow:p_longrow;
     function valueof(r,t:word):word;
     function addtorow(r,tar,siz:word):word;
     function wc(r,c:word):r_scarcefield;
     function readfullmatrix:p_fullmat;
    procedure sortedrow(onerow:p_longrow;rowno:word;toa:pointer;flen,tlen:word);
     function w(r,o:word):word;
     function c(r,o:word):word;
     function setval(r,o,tar,siz:word):word;
     function setsize(r,o,siz:word):word;
     function fromfull(fulmat:p_fullmat):p_scarcemat;
     constructor create(rown,coln:word);
     function sana(wrd:word):string;
     procedure getsums;
     procedure list;
   end;
  type tmylly=class(tobject)
    sanat:array of ansistring;  //NOTE: 0 IS 'NULL'
    mat:p_scarcemat;
    rows,cols:WORD;
    wsmat:tmat;//a_scarcemat;
    csmat:tmat;
    isinclus:p_matcol;//array of word;
    //fullmat:p_fullmat;  //remove
    //sums:array of longword;
     procedure makematrix;
     constructor create;
     function full2scarce:a_scarcemat;
     procedure readwords;
     procedure cluster;
     procedure wxw;
     procedure w2c;
     //procedure cc;
    procedure readafile(fname: string; cnt: pointer; siz: longword);
    procedure saveafile(fname: string; cnt: pointer; siz: longword);
    //procedure scarcesort(froa: array of longint; toa: array of r_scarcefield;    flen,tlen: word);
    //procedure scarcesort(froa:array of longword;toa:pointer;flen,tlen:word);
 end;
   var  tmppointer:tmylly;

implementation
constructor tmylly.create;

//var arow:a_scarcerow; aval:r_scarcefield;
begin
 tmppointer:=self;
 readwords;
 wsmat:=tmat.create(n_w,n_c);
 wsmat.mymy:=self;
 getmem(isinclus,rows*2);
 //for i:=1 to wsmat.rows-1 do isinclus^[i]:=0;
 fillchar(isinclus^,2*wsmat.rows,0);

 mat:=wsmat.mat;
 rows:=wsmat.rows;
 cols:=wsmat.cols;
 write('mylly with mat created');

end;




procedure tmylly.makematrix;
begin
  //from runnoa later...
end;
{$R *.lfm}
{$I outofsight.inc}
{$I current.inc}
{$I sanamylly.inc}
{$I sanamat.inc}
end.

