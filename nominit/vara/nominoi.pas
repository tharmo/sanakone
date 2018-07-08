unit nominoi;

{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils,nomutils,strutils;
procedure doit;


type tsanaluokka=class(tobject)
var sanafile,muotofile,listafile:textfile;
tavus:tstringlist;
  constructor create;
  procedure listaa;
  procedure puu;
  procedure luo;
end;
type triimitin=class(tobject)
  var sanafile,muotofile,listafile:textfile;
  luomuo:array[0..50] of tstringlist;
  nominit:tsanaluokka;
end;

implementation
procedure tsanaluokka.puu;
var //ifile:textfile;aw,ow:tstringlist;i,dif,c,ccc:integer;
i:integer;
sana:ansistring;
begin
  assign(listafile,'nomsort.csv');
  reset(listafile);
 i:=0;
 aw:=tstringlist.create;
 ow:=tstringlist.create;
 readln(ifile,sana);
 ow.commatext:=sana;
 writeln('<ul style="line-height: 70%"><li>001<ul><ul><li>_<ul><li>*<ul><li>',sana);
 ccc:=0;
 while not eof(ifile) do
 begin
    ccc:=ccc+1;
    //if ccc>10000 then break;
    readln(ifile,sana);
    aw.commatext:=sana;

    dif:=4;
    for i:=0 to 3 do
     if aw[i]<>ow[i] then begin dif:=i;break;end;
   if dif=4 then c:=c+1 else begin write(ifs(ow[4]='1', etu(ow[5]),ow[5]),' ',c,' '); c:=1;end;
    for i:=3 downto dif do  writeln('</ul>');
    for i:=dif to 3 do
    begin
        writeln('<li>',aw[i],'<ul><li>');
    end;
    ow.commatext:=sana;
 end;
end;

constructor tsanaluokka.create;

begin
  tavus:=tstringlist.create;
  writeln('<table border="1">');
  MS:=TSTRINGLIST.CREATE;
  muotofile.loadfromfile('muodot2.lst');
  for i:=0 to ms.count-1 do
   begin
     writeln('<tr><td>',i+1,'</td>');
     luomuo[i]:=tstringlist.create;
     luomuo[i].commatext:=ms[i];
     try
     luomuo[i].delete(0);
     writeln('<li>',i);
     except end;
     for j:=0 to luomuo[i].count-1 do
      begin
     if pos('/',luomuo[i][j])>0 then
     luomuo[i][j]:=trim(copy(luomuo[i][j],1,pos('/',luomuo[i][j])-1));
     writeln('<td>',luomuo[i][j],'</td> ');
    end;
     writeln('</tr>');

  end;
end;

procedure tsanaluokka.luo;
var sfile,mfile,ofile:textfile;
Ms,mls:tstringlist;
mymid,mylop,sana,runko,lka,prevlka,itesana,av,v,h,lopvok,lopkon:ansistring;
osa,vc:byte;
i,j,k,lknum:integer;
luomuo:array[0..50] of tstringlist;
tavus:tstringlist;
ast:taste;
takako,thisvahva:boolean;               procedure tsanaluokka.listaa;
begin
  writeln('</table>');
 ifs(true,'','');
  puu;exit;
  assign(sfile,'nomsall.lst');
  reset(sfile);
  assign(ofile,'nomsall.csv');
  rewrite(ofile);
 i:=0;
 writeln('<table border="1">');
 while not eof(sfile) do
 begin
    readln(sfile,sana);
    osa:=0;
    lka:='';
    itesana:='';
    av:='';
    for j:=1 to length(sana) do
    if sana[j]=' ' then osa:=osa+1 else
    case osa of
       0: lka:=lka+sana[j];
       1: av:=av+sana[j];
       2: itesana:=itesana+sana[j];
    end;
    itesana:=taka(itesana,takako);
    ast:=getastekons(av[1],v,h);
    lknum:=strtointdef(lka,999);

   if lka<>prevlka then
   begin
       writeln('<tr style="height:3em"><td style="display:inline-block;width:8em;margin-top:3em"><b>',lknum,'</td> </b>:</td> ');
       for j:=0 to luomuo[lknum-1].count-1 do write(' <td><b> ',luomuo[lknum-1][j],'</b></td> ');
        writeln('</tr>');
   end;
   prevlka:=lka;
   lopvok:='';
   if lknum<32 then
   begin
     for j:=length(itesana) downto 0 do if pos(itesana[j],vokaalit)>0 then begin lopvok:=itesana[j]+lopvok;end else break;
     if v='' then    for j:=length(itesana) downto 1 do if pos(itesana[j],vokaalit)<1 then begin v:=itesana[j];h:=v;break; end;
     runko:=copy(itesana,1,length(itesana)-length(v+lopvok));
     for j:=099 to luomuo[lknum-1].count-1 do
     begin
          if j in [2,4,5,6,10,11,12] then thisvahva:=true else thisvahva:=false;
          mylop:=ansireplacetext(luomuo[lknum-1][j],'*',lopvok);
          sana:=runko+ifs((lknum>31)=thisvahva,v,h)+lopvok;
          while (length(mylop)>0) and (mylop[1]='-') do begin delete(mylop,1,1);delete(sana,length(sana),1);end;
          write('<td>',sana,'<b>',mylop,'</b>',yhtlops[j],'</td>');//;,AV,v,h, ' ');
     end;
   end else
   begin
     runko:=itesana;
     lopkon:=itesana[length(itesana)];
     if pos(lopkon,vokaalit)<1 then begin delete(runko,length(runko),1) end else lopkon:='';
     try
     if av='D' then
       begin try //writeln('<td>DDD</td>');
        lopvok:=runko[length(runko)];delete(runko,length(runko),1);
       except writeln('xxxxxxxxxxxxxxxxxxxxxxxxxxx');end;
       end else
     for j:=length(runko) downto 1 do if pos(runko[j],vokaalit)>0 then
      begin lopvok:=runko[j]+lopvok;delete(runko,length(runko),1);end else break;
     if v='' then    for j:=length(runko) downto 1 do if pos(runko[j],vokaalit)<1 then begin v:=runko[j];h:=v;break; end;
     runko:=copy(itesana,1,length(itesana)-length(h+lopvok+lopkon));
//!!     writeln('<tr><td>',av,'<b> ',runko,' [',v,'|',h,']',lopvok,'+',lopkon,'</b>:</td> ');
     for j:=099 to luomuo[lknum-1].count-1 do
     begin
       if j in [0,1] then thisvahva:=false else thisvahva:=true;
       // write('<td>',runko,'<b>',ifs((lknum>31)=thisvahva,v,h),'</b>',lopvok,'<b>',ansireplacetext(luomuo[lknum-1][j],'*',lopkon),'</b>',yhtlops[j],'</td>');//;,AV,v,h, ' ');
        //mymid:=ansireplacetext(luomuo[lknum-1][j],'*',lopkon);
       sana:=runko+ifs(thisvahva,v,h)+lopvok;
       //lopvok:=runko[length(runko)];
       mymid:=ansireplacetext(luomuo[lknum-1][j],'*',lopkon);
       mymid:=ansireplacetext(luomuo[lknum-1][j],'_',lopvok);
       mylop:=ansireplacetext(yhtlops[j],'*',lopvok);
       mylop:=yhtlops[j];
       while (length(mymid)>0) and (mymid[1]='-') do begin delete(mymid,1,1);delete(sana,length(sana),1);end;
       write('<td>',sana,'<b>',mymid,'</b>',mylop,'</td>');//;,AV,v,h, ' ');

     end;
     except writeln('<td>FAIL</td>');end;
   end;

      writeln('</tr>');
   i:=i+1;
   writeln(ofile,lka,',',ifs(lopkon='','_',lopkon),',',lopvok,',',h,v,',',ifs(takako,'0','1'),',',runko);
 end;
 writeln('</table>');
 closefile(ofile);
 closefile(sfile);
end;
procedure doit;
 begin
   writeln('doit:'+paramstr(1));
   test;
   end;
end.

