unit nominoi;

{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils,nomutils,strutils;
 var  lvcount,lkcount,avcount:integer;
//  procedure doit;
 type ttrylist=record
  count:integer;
  alut,loput:array[0..100] of shortstring;//array[0..16] of ansichar;
  vahvako,sija:array[0..100] of byte;
  lka:byte;
end;
procedure addhits(var trys:ttrylist;alku,loppu:ansistring;s:byte);
type tsana=record
   lla:byte;
end;
type tmatchmaker=class(tobject)
   //tothits,lkahits, vokhits,avhits,stem
     hits,lookfors:tstringlist;
     vahvaluokka,heikkovahva,vahvaheikko:boolean;
     cuts:word;
     haku:ansistring;
     taka,debug:boolean;
     function matchsija(snum:integer;haettu,ending:ansistring;var hitit:ttrylist):boolean;

   constructor create;
end;

type tsmatches=record num:byte;st:ansistring;end;


type
  t_taivlka=class;
  t_lopkon=class;
  t_lopvok=class;
  t_av=class;
  tsanaluokka=class;
tsija=class(tobject)
  vv,hv:boolean;
  num,vparad,hparad:byte;

  //vmuomids,hmuomids:array[1..12] of byte;
  ending:ansistring;
 { constructor create(vahvalka:boolean;tpl,mu:byte);
  constructor createst(str:ansistring);
  procedure list(s:pointer);
  procedure save(u:word;s:pointer);}
  function match(tofind:ansistring;rlist:tstringlist):boolean;

 end;

//type
  t_taivlka=class(tobject)
     wcount,astecount:word;
     num,kotus:word;
     vahva:boolean;hasav:boolean;
     example,expl:ansistring;
     midsbef,midsaft,xtra:array[1..80] of ansistring;  //make more efficient later
     mids:array[0..24] of ansistring;
     lkons:tstringlist;
     constructor create(v:ansistring;slk:tsanaluokka);
     procedure match(alku,loppu:ansistring;sija:byte;mm:tmatchmaker);
     //procedure match(var uphits:ttrylist;mm:tmatchmaker);
     //procedure list;
     //procedure pilko(inf,mid,vahk,heik,sija:ansistring;var stem,loplet,kk:ansistring);
     //function match(alkuosa,loppuosa:ansistring;sija:tsija;mm:tmatchmaker):boolean;
  end;

 t_lopkon=class(tobject)
    parentlka:t_taivlka;
    kon:ansistring;  //muutetaan array[0..x] of ansichar;
    lvoks:tstringlist;  //muutetaan jotenkin ekaluokka,vikaluokka:word; indeksejä taulukkoon jossa pointteri av-luokkiin
    //function matches(alkuosa,loppuosa:ansistring;vahvako:boolean;mm:tmatchmaker):boolean;
    constructor create(v:ansistring;lkap:t_taivlka);
    procedure match(alku,loppu:ansistring;avvahvat:boolean;cut:byte;lopkon:ansistring;mm:tmatchmaker);
    //procedure match(var uphits:ttrylist;mm:tmatchmaker);
    //procedure list;
end;

t_lopvok=class(tobject)
    parentkon:t_lopkon;
    vok:ansistring;
    lavs:tstringlist;  //muutetaan jotenkin ekaluokka,vikaluokka:word; indeksejä taulukkoon jossa pointteri av-luokkiin
    //function matches(alkuosa,loppuosa:ansistring;vahvako:boolean;mm:tmatchmaker):boolean;
  //match(alku,loppu,avvahvat,mm);
   procedure match(alku,loppu:ansistring;avvahva:boolean;cut:byte;mm:tmatchmaker);
   //procedure match(var uphits:ttrylist;mm:tmatchmaker);
    constructor create(v:ansistring;konp:t_lopkon);
    //procedure list;
end;
t_av=class(tobject)//subsection of a ttaivlka
  parentvok:t_lopvok;
  id:byte;  //kotus-muodossa A,B,..,H? joku oma
  heikko,vahva:ansistring;
  kind:byte;
  sanat:ansistring;// taas: ekasana.vikasana
    procedure match(alku,loppu:ansistring;avvahva:boolean;cut:byte;mm:tmatchmaker);
    //procedure match(var uphits:ttrylist;mm:tmatchmaker);
  constructor create(v:ansistring;vokp:t_lopvok);
   //procedure list;
   //function matches(alkuosa,loppuosa:ansistring;vahvako:boolean;mm:tmatchmaker;veks:integer):boolean;
 end;

 //type

tsanaluokka=class(tobject)
var sanafile,muotofile,listafile:textfile;
luokat,tavus:tstringlist;
taivluokkia:integer;
luomuo:array[0..50] of tstringlist;
  constructor create;
  //procedure listaa;
  procedure puu;
  function etsi(wlist:ansistring):boolean;
  procedure luolista;
  procedure korjaa;
  procedure listaa;
  procedure yksikoi;
end;
type triimitin=class(tobject)
  var sanafile,muotofile,listafile:textfile;
  nominit:tsanaluokka;
  constructor create;
end;
var rx:triimitin;
procedure fixmonikot;
procedure takavokaaleiksi;
procedure listaaoudot;
implementation
procedure addhits(var trys:ttrylist;alku,loppu:ansistring;s:byte);
begin
 trys.alut[trys.count]:=alku;
 trys.loput[trys.count]:=loppu;
 trys.sija[trys.count]:=s;
 trys.count:=trys.count+1;
 //writeln('++',alku,'|',loppu,trys.count);
end;
function tmatchmaker.matchsija(snum:integer;haettu,ending:ansistring;var hitit:ttrylist):boolean;
var i,p:integer;//myhits:ttrylist;
begin
 writeln('<li>HIT?',haettu,'|',ending,'#',snum,')');
  if ending='' then
  begin result:=true;
   addhits(hitit,haettu,'',snum);
  end else
  if copy(haettu,length(haettu)-length(ending)+1)=ending then
  begin
   result:=true;
   addhits(hitit,copy(haettu,1,length(haettu)-length(ending)),ending,snum);
  end else
  begin result:=false;//rlist.add('-');
  end;
  //writeln('((((',haettu,':;',ending,'))))');
end;

constructor tmatchmaker.create;
var i:integer;
begin
 hits:=tstringlist.create;
 lookfors:=tstringlist.create;
 //haku:=h;
end;

constructor triimitin.create;
//var ms:tstringlist;i,j:integer;
begin
  nominit:=tsanaluokka.create;

end;

constructor tsanaluokka.create;
var ms:tstringlist;i,j,mu1,mu2,lu:integer;
  matrix:array[0..12] of array[0..12] of integer;
  titles:array[0..12] of array[0..12] of ansistring;
  lumumi:array[0..49] of array[0..22] of ansistring;
begin
  //fixmonikot;exit;
  fillchar(matrix,sizeof(matrix),0);
 tavus:=tstringlist.create;
 luokat:=tstringlist.create;
  writeln('sanapuus');

 // puu;exit;
 // korjaa;exit;

  writeln('<table border="1">');
  MS:=TSTRINGLIST.CREATE;
  ms.loadfromfile('muodot3.lst');
  taivluokkia:=ms.count;
 { for i:=0 to ms.count-1 do
  begin
     luomuo[i]:=tstringlist.create;
     luomuo[i].commatext:=ms[i];
     for j:=0 to luomuo[i].count-1 do
      write(copy(trim(luomuo[i][j])+',           ',1,8));
     if  luomuo[i].count<26 then     write(copy(trim(luomuo[i][24])+'           ',1,8));
     //write('///',luomuo[i].count,'/');

     writeln;
  end;
  writeln('</pre><hr>');]]}
  for i:=0 to ms.count-1 do
   begin
     //writeln('<tr><td>',i+1,'</td>');
     luomuo[i]:=tstringlist.create;
     luomuo[i].commatext:=ms[i];
     try
     luomuo[i].delete(0);
     //writeln('<li>',i);
     except end;
     if i mod 10=0 then begin writeln('<tr><td> xx</td>');for j:=0 to 24 do writeln('<td><b>',j,'</b></td> ');writeln('</tr>');end;
     writeln('<tr><td>',i,'</td>');
     for j:=0 to luomuo[i].count-1 do
      begin
       //if pos('/',luomuo[i][j])>0 then
       // luomuo[i][j]:=trim(copy(luomuo[i][j],1,pos('/',luomuo[i][j])-1));
      writeln('<td>',luomuo[i][j],'|',paatteet[j],'</td> ');
    end;
     writeln('</tr>');
   end;
  writeln('</table><hr><hr><hr><hr><hr>');;
  exit;
  for lu:=0 to 48 do
  //for lu:=31 to 48 do
  //for lu:=0 to 31 do
  for mu1:=0 to 12 do
  for mu2:=0 to 12 do
     if luomuo[lu][mu1]=luomuo[lu][mu2] then
      matrix[mu1][mu2]:=matrix[mu1][mu2]+1 else
      titles[mu1][mu2]:=titles[mu1][mu2]+' -'+inttostr(lu+1)+luomuo[lu][mu1]+'.'+luomuo[lu][mu2]+') ';
  writeln('XXXXXXXXXXXXXXXX<table border="1"><tr><td>_</td>');
  for mu1:=0 to 24 do
    writeln('<td>',mu1,'<b>',paatteet[mu1],'</b></td> ');

  for mu1:=0 to 24 do
  begin
    writeln('<tr><td>',mu1,' ',paatteet[mu1],'</td>');
    for mu2:=0 to 12 do
      if matrix[mu1][mu2]>40 then
      writeln('<td title="',titles[mu1][mu2]+'"><b>',matrix[mu1][mu2],'</b></td> ')
     else writeln('<td title="',titles[mu1][mu2]+'">',matrix[mu1][mu2],'</td> ');
    writeln('</tr>');

  end;
  writeln('</table><hr><hr><hr><hr><hr>');;
  //for mu1:=0
end;
{
constructor tsanaluokka.create;
var ms:tstringlist;i,j,mu1,mu2,lu:integer;
  matrix:array[0..12] of array[0..12] of integer;
  titles:array[0..12] of array[0..12] of ansistring;
begin
  //fixmonikot;exit;
  fillchar(matrix,sizeof(matrix),0);
 tavus:=tstringlist.create;
 luokat:=tstringlist.create;
  writeln('sanapåuu');
 // puu;exit;
 // korjaa;exit;

  writeln('<table border="1">');
  MS:=TSTRINGLIST.CREATE;
  ms.loadfromfile('muodot2.lst');
  taivluokkia:=ms.count;
  for i:=0 to ms.count-1 do
   begin
     writeln('<tr><td>',i+1,'</td>');
     luomuo[i]:=tstringlist.create;
     luomuo[i].commatext:=ms[i];
     try
     luomuo[i].delete(0);
     //writeln('<li>',i);
     except end;
     if i mod 10=0 then begin writeln('<tr><td> x</td>');for j:=0 to 12 do writeln('<td><b>',j,'</b></td> ');writeln('<tr>');end;
     for j:=0 to luomuo[i].count-1 do
      begin
     if pos('/',luomuo[i][j])>0 then
     luomuo[i][j]:=trim(copy(luomuo[i][j],1,pos('/',luomuo[i][j])-1));
     writeln('<td>',luomuo[i][j],'</td> ');
    end;
     writeln('</tr>');
   end;
  writeln('</table><hr><hr><hr><hr><hr>');;
  for lu:=0 to 48 do
  //for lu:=31 to 48 do
  //for lu:=0 to 31 do
  for mu1:=0 to 12 do
  for mu2:=0 to 12 do
     if luomuo[lu][mu1]=luomuo[lu][mu2] then
      matrix[mu1][mu2]:=matrix[mu1][mu2]+1 else
      titles[mu1][mu2]:=titles[mu1][mu2]+' -'+inttostr(lu+1)+luomuo[lu][mu1]+'.'+luomuo[lu][mu2]+') ';
  writeln('XXXXXXXXXXXXXXXX<table border="1"><tr><td>_</td>');
  for mu1:=0 to 12 do
    writeln('<td>',mu1,'<b>',yhtlops[mu1],'</b></td> ');

  for mu1:=0 to 12 do
  begin
    writeln('<tr><td>',mu1,' ',yhtlops[mu1],'</td>');
    for mu2:=0 to 12 do
      if matrix[mu1][mu2]>40 then
      writeln('<td title="',titles[mu1][mu2]+'"><b>',matrix[mu1][mu2],'</b></td> ')
     else writeln('<td title="',titles[mu1][mu2]+'">',matrix[mu1][mu2],'</td> ');
    writeln('</tr>');

  end;
  writeln('</table><hr><hr><hr><hr><hr>');;
  //for mu1:=0
end;
}
procedure tsanaluokka.luolista;  //tuotti sanalistan, jatkossa se luetaan tiedostosta
var sfile,mfile,outfile:textfile;
Ms,mls:tstringlist;
mymid,mylop,sana,runko,lka,prevlka,itesana,av,v,h,lopvok,lopkon:ansistring;
osa,vc:byte;
i,j,k,lknum,cut:integer;
ast:taste;
ontaka,thisvahva,konstikas:boolean;
lopvoks:ansistring;
lopvoklist:tstringlist;
begin
 lopvoklist:=tstringlist.create;
  writeln('</table>,LUOLISTA',yhtlopsold[6]);
 ifs(true,'','');

  //puu;exit;
  //assign(sfile,'nomsall2.csv');
  //assign(sfile,'nomsfixed1.lst');
 // assign(sfile,'nomsall.lst');
  assign(sfile,'noms3_fixed.lst');
  reset(sfile);
  assign(outfile,'noms3.csv');
  rewrite(outfile);
 TRY
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
    itesana:=takako(itesana,ontaka);
    ast:=getastekons(av[1],v,h);
    lknum:=strtointdef(lka,999);
    konstikas:=false;

   if lka<>prevlka then
   begin
    //writeln('<tr style="height:3em"><td style="display:inline-block;width:8em;margin-top:3em"><b>',lopvoks,'</b>:</td> ');
    lopvoklist.add(lopvoks);lopvok:='|';
    //writeln('<tr style="height:3em"><td style="display:inline-block;width:8em;margin-top:3em"><b>',lka,'/',lknum,'\',prevlka,'</b>:</td> ');
    writeln('<li><b>',lka,'/',lknum,'\',prevlka,'</b>: ');
       for j:=0 to luomuo[lknum-1].count-1 do write(' <td><b> ',luomuo[lknum-1][j],'</b></td> ');
      //  writeln('</tr>');
   end;
   prevlka:=lka;
   //continue;
   lopvok:='';
   lopkon:='';
   if lknum<32 then
   begin
    if pos(itesana[length(itesana)],vokaalit)<1 then
    if (itesana[length(itesana)]='t') or (lka='010') then
    begin
          konstikas:=true;

      if pos(luomuo[lknum-1][5]+'t',itesana)<1 then writeln('<li>+++',itesana,'|',luomuo[lknum-1][5]+'t');

     lopkon:=itesana[length(itesana)];delete(itesana,length(itesana),1);
     //writeln('<h4>lopkon',lopkon,'</h4>');
    end else if lknum in [005,006,020] then
    begin
     itesana:=itesana+'i';
    end else continue;

      for j:=length(itesana) downto 0 do if pos(itesana[j],vokaalit)>0 then begin lopvok:=itesana[j]+lopvok;end else break;
      if v='' then    for j:=length(itesana) downto 1 do if pos(itesana[j],vokaalit)<1 then begin v:=itesana[j];h:=v;break; end;
      runko:=copy(itesana,1,length(itesana)-length(v+lopvok));

      if pos('|'+lopvok+'|',lopvoks)<1 then lopvoks:=lopvoks+lopvok+'|';
      for j:=099 to luomuo[lknum-1].count-1 do
      begin
            if j in [2,4,5,6,10,11,12] then thisvahva:=true else thisvahva:=false;
            mylop:=ansireplacetext(luomuo[lknum-1][j],'*',lopvok); //ei kylläkään tähtiä vahvoissa;:
            sana:=runko+ifs((lknum>31)=thisvahva,v,h)+lopvok;
            while (length(mylop)>0) and (mylop[1]='-') do begin delete(mylop,1,1);delete(sana,length(sana),1);end;
            write('<td>',sana,'<b>',mylop,'</b>',yhtlopsold[j],'</td>');//;,AV,v,h, ' ');
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
       mylop:=ansireplacetext(yhtlopsold[j],'*',lopvok);
       mylop:=yhtlopsold[j];
       while (length(mymid)>0) and (mymid[1]='-') do begin delete(mymid,1,1);delete(sana,length(sana),1);end;
       write('<td>',sana,'<b>',mymid,'</b>',mylop,'</td>');//;,AV,v,h, ' ');

     end;
     except writeln('<td>FAIL</td>');end;
   end;
     // writeln('</tr>');
   i:=i+1;
   if ((length(lopvok)=2)  //paljon vokaaleja
     and (not isdifto(lopvok[1],lopvok[2])))// then
       or (length(lopvok)>2) then
   begin
     if isdifto(lopvok[1],lopvok[2]) then cut:=2 else cut:=1;
     if v=h then
     begin
       runko:=runko+v;
       v:='';h:='';
     end;
     runko:=runko+copy(lopvok,1,cut);
     lopvok:=copy(lopvok,cut+1);

     //writeln('<h2>LV:',lka,',',ifs(lopkon='','_',lopkon),',',lopvok,',',v,h,',',ifs(takako,'0','1'),',',runko,'</h2>');
     //writeln('<li>X:',aw[0]+','+aw[1]+','+aw[2]+','+aw[3]+','+aw[4]+','+aw[5]);
   end;
   if runko='' then
   begin
      if (v='') or (h='') or (h<>v) then writeln('<h1>outosana:',sana);
       runko:=v;v:='';h:='';
   end;
  //?????????? if lka='041' then runko:=runko+lopkon;
   if konstikas then
   //if itesana[LENGTH(itesana)]='t' then write('<li><b>',itesana,':',runko,'|',lopvok,'/',lopkon,'[',v,h,']</b>')
    write('<li>',itesana,':',runko,'|',lopvok,'/',lopkon,'[',v,h,']');
   writeln(outfile,lka,',',ifs(lopkon='','_',lopkon),',',lopvok,',',v,h,',',ifs(ontaka,'0','1'),',',runko);
 end;

 writeln('</table><h4>',lopvoklist.commatext+'</h4>');
 FINALLY
 closefile(outfile);
 closefile(sfile);END;
end;

function tsanaluokka.etsi(wlist:ansistring):boolean;
var mm:tmatchmaker;i,j,lk:integer;mylop,sana:ansistring;//alut,loput:tstringlist;
 hitit:ttrylist;etuko,p:boolean;
 reslist:tstringlist;
begin
 reslist:=tstringlist.create;
  mm:=tmatchmaker.create;
  mm.lookfors.commatext:=wlist;//'ruutana,huusin,pallas,kusisin';
  writeln('<li>matching:'+mm.lookfors.commatext);
  mm.hits.clear;
 for i:=0 to mm.lookfors.count-1 do
 begin
    try
    write(' <b>[[',mm.lookfors[i],'/',mm.lookfors[i],']]</b> ');
    sana:=mm.lookfors[i];
    if sana='' then continue;
    etuko:=sana[1]='1';
    delete(sana,1,1);
    writeln('<hr>etsi::::', sana,i);
    //for j:=0 to 12 do
    for j:=0 to 24 do
     begin
        mylop:=paatteet[j]; //hanskaa '*' sijamuodon päätteessä!
        writeln('-------------',j,sana,'/',mylop);
        if pos('*',mylop)=1 then mylop[1]:=sana[length(sana)-1];
       if matchend(sana,mylop) then
        for lk:=0 to 48   do  //to 48 !!
        begin

           //if (lk>21) and (lk<30) then continue;
           writeln('<h4>Etsi::',lk,sana,' [',mylop,']','</h4>');
           try
           t_taivlka(luokat.objects[lk]).match(copy(sana,1,length(sana)-length(mylop)),mylop,j,mm);
           except writeln('<li>((',luokat[lk],':',t_taivlka(luokat.objects[lk]).num,'))');end;
          //t_taivlka(luokat.objects[lk]).match(hitit,mm);
        end;
     end;
    except writeln('failsana:',sana,i);end;
    tsekkaatavut(sana,etuko,mm.hits,reslist);
    mm.hits.clear;

  end;
  writeln('<hr>riimit');
  writeln('<li>:::', reslist.commatext);
        {
        //writeln('<li>--',mylop);
        if not mm.matchsija(j,mm.lookfors[i],mylop,hitit) then continue;
        mm.vahvaheikko:=j in [2,4,5,6,10,11,12];
        //1-31:   telki telkia 2**teljen telkiin 4:teljille 5:teljitta 6:teljet telkia telkien telkiin 10:teljille 11:teljin 12:teljitta
        mm.heikkovahva:=j in [0,1];  //32-49:
     end;
    //if mm.hits[j]<>'-' then //writeln('[',j,mm.hits[j],'/',yhtlops[j],'] ');
 end;
  for i:=0 to hitit.count-1 do
  begin writeln(' //',i,hitit.alut[i],'|',hitit.loput[i],'\\ ');
  end;
  for lk:=0 to 48   do  //to 48 !!
  begin
     writeln('<h1>',hitit.alut[0],'</h1>');
    //writeln('<li>((',luokat[lk],':',t_taivlka(luokat.objects[lk]).num,'))');
    //t_taivlka(luokat.objects[lk]).match(hitit,mm);
  end;}
  writeln('<hr><hr><hr>');
  //for i:=0 12 do
  //for i:=0 to taivluokkia do
   //sisältö puusta muokaten
end;

procedure tsanaluokka.listaa;  //opetallaan lukemaan listausta tehokkaasti
var //ifile:textfile;
aw,ow:tstringlist;i,j,dif,c,ccc,lka,maxlen:integer;
thisvahva,eka:boolean;
sana,runko,v,h,lopvok,myvok,mymid,lopkon,mylop,mto,av:ansistring;
otuscounts:array[0..4] of integer;
lkas:t_taivlka;akos:t_lopkon;lvos:t_lopvok;avs:t_av;   p:boolean;
begin
   lvcount:=0;lkcount:=0;avcount:=0;

  assign(listafile,'noms4.csv');
  //nomsall3.csv
  reset(listafile);
  for j:=0 to 4 do otuscounts[j]:=0;
  i:=0;
  maxlen:=0;
 aw:=tstringlist.create;
 ow:=tstringlist.create;
 readln(listafile,sana);
 ow.commatext:=sana;
 //writeln('<ul style="line-height: 90%"><li>001<ul><ul><li>_<ul><li>*<ul><li>',sana);
 ccc:=0;
 lka:=0;p:=true;
 eka:=true;
 writeln('<ul>');
 while not eof(listafile) do
 begin
    try
    //write('%');
   try
    ccc:=ccc+1;
    //if ccc>10000 then break;
    readln(listafile,sana);
    if eof(listafile) then continue;
    aw.commatext:=sana;
    //if not aw[1] in ['','']:='_';
    //ow[1]:='_';
    //writeln('-',lka);//,'!',sana);
    //if aw[0]='028' then writeln('<li>',sana);
    if aw.count<5 then continue;
    //if maxlen<length(aw[5]) then maxlen:=length(aw[5]);    if length(aw[5])>15 then writeln('<li>',aw[5]);continue;
    dif:=4;
    //if aw[5]='pee' then writeln('<h1>',sana,'</h1>');

    for i:=0 to 3 do
     if aw[i]<>ow[i] then begin dif:=i;break;end;
     //if p then    if dif<1 then  writeln('<li>zxc:',dif,':::<b>  ',aw[0],'</b>');
    if (dif<1) or eka then
       lkas:=t_taivlka.create(aw[0],self);
    if (dif<2) or eka then
    akos:=t_lopkon.create(aw[1],lkas);
    if (dif<3) or eka then
    lvos:=t_lopvok.create(aw[2],akos);
    if (dif<4) or eka then
     avs:=t_av.create(aw[3],lvos);
    eka:=false;
    avs.sanat:=avs.sanat+','+aw[4]+aw[5];

   except writeln('bbbb');end;
   if (dif=4) then //and (aw[0]<>'028') // pidempi lista jostain luokasta
   begin c:=c+1;end
   else
   begin
      try
      av:=ow[3];
      v:='';h:='';
      //if aw[0]='028' then v:='z' else //writeln('<li>');
     if length(av)>0 then v:=av[1];
     if length(av)>1 then h:=av[2];
     //if lka=28 then if h='l' then begin h:='s';v:='s';end;
     //if v<>h then
      if p then     write(lka,' <b>',ifs(ow[4]='1', etu(ow[5]),ow[5]),'</b> ');//,'! ',luomuo[lka].commatext);
      c:=1;
      //if ow[3]='' then writeln('xxxxxxxxxxx:',sana);
     //if h=v then continue;
      except writeln('zzzz');end;
      //try
      //if v<>h then
      //if lka<48 then
      for j:=0 to luomuo[lka].count-1 do
       begin
          try
         lka:=strtointdef(ow[0],0);
         lopkon:=ow[1];
         lopvok:=ow[2];
         runko:=ow[5];
         if (lka<32) then if j in [0,2,5,9,13,14,17,21] then thisvahva:=true else thisvahva:=false;
         if (lka>31) then if (j in [0,2]) then thisvahva:=false else thisvahva:=true;
         //if (lka<32) then if j in [2,4,5,6,10,11,12] then thisvahva:=false else thisvahva:=true;
         //if (lka<32) then if runko<>'' then if pos(runko[length(runko)],vokaalit)<1 then lopkon:=runko[length(runko)];  //ei pitäis loppua konsonanttiin alaluokissa
         // write('<td>',runko,'<b>',ifs((lknum>31)=thisvahva,v,h),'</b>',lopvok,'<b>',ansireplacetext(luomuo[lknum-1][j],'*',lopkon),'</b>',yhtlops[j],'</td>');//;,AV,v,h, ' ');
          //mymid:=ansireplacetext(luomuo[lknum-1][j],'*',lopkon);
          //getastekons(av[1],v,h);
          mto:=runko+ifs(thisvahva,v,h)+lopvok;
        //lopvok:=runko[length(runko)];
         //if lka>32 then
         mymid:=ansireplacetext(luomuo[lka-1][j],'*',lopkon);
         //pitäis olla vaain parissa heikossa luokassa. Ne vois jakaa
         //lka32 54kpl R (-tar), 18 N, 2N (nivel, sävel)
         // ja 49: 10R, 9L, 2N
         //laittamani asteriksit luokissa 10 ja 28 ovat mysteeri.. 28 yritetty J*LSI hanskaamista (joutaa pois kokonaan)
        //if lopvok<>'' then
        mymid:=ansireplacetext(mymid,'_',copy(lopvok,length(lopvok)));
        //mymid:=ansireplacetext(mymid,'_',lopvok[length(lopvok)]);
       //  mymid:=ansireplacetext(mymid,'_',lopvok);
         myvok:=lopvok[length(lopvok)];
         if mymid<>''  then if pos(mymid[length(mymid)],vokaalit)>0 then myvok:=mymid[length(mymid)];
        //except myvok:='';end;
         mylop:=ansireplacetext(paatteet[j],'*',myvok);
         //mylop:=paatteet[j];
         while (length(mymid)>0) and (mymid[1]='-') do begin delete(mymid,1,1);delete(mto,length(mto),1);end;
         if p then         write('<b>',j,'</b> <small> ',mto,'<b>',mymid,'</b>',mylop,'</small> ');//;,AV,v,h, ' ');
         except writeln('LKA=',lka);end;
       end;
    end;
    //try
    //    if lka>48 then break;
    try
    for i:=3 downto dif do  writeln('</ul>');
    for i:=dif to 3 do
    begin
      if p then        writeln('<li>:',aw[i],':<ul title="',sana,'"><li>');
    end;
    ow.commatext:=sana;
    except writeln('%%%%%%%%%%%'); end;
    except writeln('???????????',sana); end;
 end;
 writeln('<hr>DIDIDIDsomethign - try lkob',luokat.count);
  writeln('<h2>av:',avcount,' lk:',lkcount,' lv:',lvcount,'</h2>');exit;

 for i:=0 to luokat.count-1 do for j:=0 to 24 do t_taivlka(luokat.objects[i]).mids[j]:=luomuo[i][j];
 //for i:=0 to luokat.count-1 do for j:=0 to 12 do writeln('<li>lx:',i,' ',j,' ',luomuo[i][j],'', t_taivlka(luokat.objects[i]).mids[j],'#', t_taivlka(luokat.objects[i]).NUM);
 //for j:=0 to 4 do writeln('<li>LKA',j,':',otuscounts[j],'<li>');
 writeln('<li>MAXLEN:',maxlen);
 //etsi('jumbo');//,dille,maitta,aikoa,dille');
 etsi(paramstr(2));//,dille,maitta,aikoa,dille');
end;

procedure tsanaluokka.puu;  //debuggaukseen sanapuun katseluun
var //ifile:textfile;
aw,ow:tstringlist;i,dif,c,ccc:integer;
sana:ansistring;
begin
  assign(listafile,'nomsort.csv');
  reset(listafile);
 i:=0;
 aw:=tstringlist.create;
 ow:=tstringlist.create;
 readln(listafile,sana);
 ow.commatext:=sana;
 writeln('<ul style="line-height: 70%"><li>001<ul><ul><li>_<ul><li>*<ul><li>',sana);
 ccc:=0;
 while not eof(listafile) do
 begin
    ccc:=ccc+1;
    //if ccc>10000 then break;
    readln(listafile,sana);
    aw.commatext:=sana;

    dif:=4;
    for i:=0 to 3 do
     if aw[i]<>ow[i] then begin dif:=i;break;end;
   if dif=4 then c:=c+1 else begin write(ifs(ow[4]='1', etu(ow[5]),ow[5]),' ',c,' '); c:=1;
       if ow[3]='' then writeln('xxxxxxxxxxx');end;
    for i:=3 downto dif do  writeln('</ul>');
    for i:=dif to 3 do
    begin
        writeln('<li>',aw[i],'<ul><li>');
    end;
    ow.commatext:=sana;

 end;
end;
// 049,r,aue,  ,  0,
//  0  1  2  3   4    5
// lk  k  v  av  aä   runko
procedure tsanaluokka.korjaa;  //siivoaa vähän listaa (vois tehdä joskus kerralla kuntoon
var ifile:textfile;aw,ow:tstringlist;
i,dif,c,ccc,lk,cut:integer;
sana,runko,prev,thisav:ansistring;uusfile:textfile;
begin
 assign(listafile,'nomsort2.csv');
 reset(listafile);
 assign(uusfile,'noms.csv');
 rewrite(uusfile);
 i:=0;
 aw:=tstringlist.create;
 while not eof(listafile) do
 begin
    readln(listafile,sana);
    aw.commatext:=sana;
    {if (length(aw[3])=2) and (aw[3][1]=aw[3][2]) then
    begin
      aw[5]:=aw[5]+aw[3][1]+aw[2];aw[3]:='';aw[2]:='';
      writeln('<li><b>',sana,'</b>',' ',aw[5]+aw[3]+aw[2]+aw[1]);
      continue;
    end;}
    //if length(aw[3])>1 then aw[3]:=aw[3][2]+aw[3][1];  //had them wrong ord
    lk:=strtointdef(aw[0],99);
    thisav:=aw[3];
   if length(thisav)=1 then thisav:=ifs(lk<32,thisav[1],'') else
   if length(thisav)=2 then thisav:=ifs(lk<32,thisav[1],thisav[2]);
    //else ii length(thisav)=1 then
    //if (strtointdef(aw[0],99)<32) then thisav:=thisav[1] else
    //thisav:=ifs(length(thisav)>1,thisav[2],'');

    if ((length(aw[2])=2)  //paljon vokaaleja
    and (not isdifto(aw[2][1],aw[2][2])))// then
    or (length(aw[2])>2)
    or (aw[5]='') then //tyhjä runko
     begin
     if isdifto(aw[2][1],aw[2][2]) then cut:=2 else cut:=1;
     writeln('<li><b>',sana,'</b>',': ',aw[5]+thisav+aw[2]+aw[1],'/');
     //if (length(aw[3])<>2) or
     if (aw[3][1]<>aw[3][2]) then writeln('%%%',aw[3]='',aw[3],'|');
     aw[5]:=aw[5]+ifs(aw[3]='','',thisav)+copy(aw[2],1,cut);
     aw[3]:='';
     aw[2]:=copy(aw[2],cut+1);  //astevaihtelu x/x siirretään runkoon
     writeln('<li>X:',aw[0]+','+aw[1]+','+aw[2]+','+aw[3]+','+aw[4]+','+aw[5]);
     //aw[5]:=aw[5]+ifs(aw[3]='','','aw[3][1]')+aw[2];aw[3]:='';aw[2]:='';

     end
     ;//else if prev<>aw[0]+aw[1]+aw[2]+aw[3] then
       //write('<li>',sana,' ',aw[5]+thisav+aw[2]+aw[1]+'  '+thisav);

    writeln(uusfile,aw[0]+','+aw[1]+','+aw[2]+','+aw[3]+','+aw[4]+','+aw[5]);
    prev:=aw[0]+aw[1]+aw[2]+aw[3];
    if length(aw[2])>2 then writeln('!!?');
    //then   begin writeln('<li>',ifsaw[5]+aw[5]+aw[5]+aw[5]+   end:
   // dif:=4;
 end;
 close(uusfile);
 close(listafile);
end;
procedure fixmonikot;
var f1,f2,outs:textfile;
 line1,line2:ansistring;
 i,j,cc,sp:integer;
 parts1,parts2:tstringlist;
begin
 parts1:=tstringlist.create;
 parts2:=tstringlist.create;
 //par.StrictDelimiter := True
 assign(f1,'nomfix.lst');
 reset(f1);
 assign(f2,'nomsall.lst');
 reset(f2);
 assign(outs,'noms3_fixed.lst');
 writeln('editoi nomsall2_fixt.lst käsin monikkomuotojen ja vierasperäisten t-loppusten erottelemiseksi');
 writeln('rivit joilla ei muutosta -> poistetaan lopputee. Muut korvataan sana rivin loppun lisätyllä.');
 // vierasperäisiin pitää lisätä perusmuotoon loppuvokaali joka tekee ne säännöllisiksi
 rewrite(outs);
 writeln('FIX<ul>');
 cc:=0;
 while not eof(f1) do
 begin
    readln(f1,line1);
    line1:=trim(line1);
    parts1.commatext:=line1;
    //if length(line1)<8 then continue;
    try
    if parts1.count>3 then
    write('<li>',parts1[0],': ',parts1[1],' <b> ',parts1[3],'</b>: ')
    else write('<li>',parts1[0],'; ',parts1[1],' <b>',copy(parts1[2],1,length(parts1[2])-1),'</b>: ');
    if parts1.count>3 then  if trim(parts1[3])='-' then begin writeln('SKIP:',parts1[2]);continue;end;
    except write('<h3>fail</h3>');end;
    //if cc>500 then break;
    cc:=cc+1;
    while not eof(f2) do
    begin
       readln(f2,line2);
       //if length(line2)<8 then continue;
       line2:=trim(line2);
       parts2.commatext:=line2;
       //write('.');//line2);
       //break;
       //if pos(copy(line2,1,length(line2)-1),line1)>0 then
       if parts2[2]=parts1[2] then
       begin
          //writeln('==',line2);  //the longone
         //j:=length(line2);   while j>0 do       begin        for j:=1 to length(
        //writeln('<li>',parts.count,parts.commatext);

        if parts1.count>3 then
         writeln(outs,parts1[0],' ',parts1[1],' ',parts1[3]) else
         writeln(outs,parts1[0],' ',parts1[1],' ',copy(parts1[2],1,length(parts1[2])-1));

        writeln(' <small>',parts2[2],'</small>');
        line2:='';parts2.clear;
        line1:='';parts1.clear;
        break; //
       end else
       writeln(outs,line2);  //the longone
       //write('-');
    end;
 end;
 close(f1);close(f2);CLOSE(OUTS);
end;
procedure listaaoudot;
var f1,outs:textfile;
 line1,line2:ansistring;
 i,j,cc,sp,lknum,prevlka:integer;
 normit,parts1,parts2:tstringlist;
 fit:boolean;
begin
 normit:=tstringlist.create;
 normit.commatext:=',uo,uo,o,o,i,i,i,e,a,a,a,a,a,a,a,i,uao,uieyao,oe,uaioe,eu,,i,i,i,i,i,i,i,i,i,nrl,n,n,n,n,n,n,s,s,s,s,t,t,s,t,t,eiu,lnr';
 parts1:=tstringlist.create;
 parts2:=tstringlist.create;
 //par.StrictDelimiter := True
 assign(f1,'nomsall.lst');
 reset(f1);
 assign(outs,'nomsall2_fixt.lst');
 writeln('editoi nomsall2_fixt.lst käsin monikkomuotojen ja vierasperäisten t-loppusten erottelemiseksi');
 writeln('rivit joilla ei muutosta -> poistetaan lopputee. Muut: korvataan sana rivin loppUun lisätyllä.');
 // vierasperäisiin pitää lisätä perusmuotoon loppuvokaali joka tekee ne säännöllisiksi
 rewrite(outs);
 writeln('LISTAAOUDOT<ul>');
 cc:=0;
 while not eof(f1) do
 begin
    readln(f1,line1);


    parts1.commatext:=taka(trim(line1));
    //if length(line1)<8 then continue;
    lknum:=strtointdef(parts1[0],99);
    if prevlka<>lknum then write('<h3> ***',lknum,' ',normit[lknum],'</h3>');
    prevlka:=lknum;
    fit:=false;
    if normit[lknum]='' then fit:=true else
    for i:=1 to length(normit[lknum]) do
     if normit[lknum][i]=parts1[2][length(parts1[2])] then fit:=true;// else write(normit[lknum][i],parts1[2][length(parts1[2])],' ');
    if not fit then
    begin
     if parts1[2][length(parts1[2])]<>'t' then line1:=line1+' '+parts1[2]+normit[lknum];
       writeln('<li>',line1);
       writeln(outs,line1);  //the longone
    end;
       //write('-');
 end;
 close(f1);;CLOSE(OUTS);
end;
procedure takavokaaleiksi;
var f1,outs:textfile;
 line1,line2:ansistring;
 i,j,cc,sp:integer;turha:boolean;
begin
 assign(f1,'nomsall.lst');
 reset(f1);
 assign(outs,'tmp');
 rewrite(outs);
 writeln('TAKAA<ul>');
 while not eof(f1) do
 begin
    readln(f1,line1);
    line1:=trim(line1);

    writeln(' ',taka(line1));
    writeln(outs,taka(line1));
 end;
 close(f1);CLOSE(OUTS);
end;

procedure tsanaluokka.yksikoi;  //debuggaukseen taivutusmuotojen katseluun
var //ifile:textfile;
aw,ow:tstringlist;i,j,dif,c,ccc,lka:integer;
thisvahva:boolean;
sana,runko,v,h,lopvok,myvok,mymid,lopkon,mylop,mto,av:ansistring;
begin
  assign(listafile,'nomssort3.csv');
  //nomsall3.csv
  reset(listafile);
 i:=0;
 aw:=tstringlist.create;
 ow:=tstringlist.create;
 readln(listafile,sana);
 ow.commatext:=sana;
 writeln('<ul style="line-height: 70%"><li>001<ul><ul><li>_<ul><li>*<ul><li>',sana);
 ccc:=0;
 lka:=0;
 while not eof(listafile) do
 begin
    //write('%');
    ccc:=ccc+1;
    //if ccc>10000 then break;
    readln(listafile,sana);
    aw.commatext:=sana;
    //writeln('-',lka);//,'!',sana);
   //if aw[0]='028' then writeln('<li>',sana);
    if aw.count<5 then continue;
    dif:=4;
    if aw[0]<>ow[0] then
    //if aw[5]='pee' then writeln('<h1>',sana,'</h1>');
    for i:=0 to 3 do
     if aw[i]<>ow[i] then begin dif:=i;break;end;
   if (dif=4) and (aw[0]<>'028')
       then c:=c+1
   else
   begin
      try
      av:=ow[3];
      v:='';h:='';
      //if aw[0]='028' then v:='z' else //writeln('<li>');
     if length(av)>0 then v:=av[1];
     if length(av)>1 then h:=av[2];
     //if lka=28 then if h='l' then begin h:='s';v:='s';end;
     //if v<>h then
     write(lka,' <b>',ifs(ow[4]='1', etu(ow[5]),ow[5]),'</b> ',c,' ',dif);//,'! ',luomuo[lka].commatext);
      c:=1;
      //if ow[3]='' then writeln('xxxxxxxxxxx:',sana);
     //if h=v then continue;
      except writeln('zzzz');end;
      try
      //if v<>h then
      for j:=0 to luomuo[lka].count-2 do
      //for j:=3 to 3 do
       begin
         lka:=strtointdef(ow[0],0);
         lopkon:=ow[1];
         lopvok:=ow[2];
         runko:=ow[5];
         if (lka>31) then if (j in [0,1]) then thisvahva:=false else thisvahva:=true;
         if (lka<32) then if j in [2,4,5,6,10,11,12] then thisvahva:=false else thisvahva:=true;
         if (lka<32) then if runko<>'' then if pos(runko[length(runko)],vokaalit)<1 then lopkon:=runko[length(runko)];
         // write('<td>',runko,'<b>',ifs((lknum>31)=thisvahva,v,h),'</b>',lopvok,'<b>',ansireplacetext(luomuo[lknum-1][j],'*',lopkon),'</b>',paatteet[j],'</td>');//;,AV,v,h, ' ');
          //mymid:=ansireplacetext(luomuo[lknum-1][j],'*',lopkon);
          //getastekons(av[1],v,h);
          mto:=runko+ifs(thisvahva,v,h)+lopvok;
        //lopvok:=runko[length(runko)];
         mymid:=ansireplacetext(luomuo[lka-1][j],'*',lopkon);
        //if lopvok<>'' then
        mymid:=ansireplacetext(mymid,'_',copy(lopvok,length(lopvok)));
        //mymid:=ansireplacetext(mymid,'_',lopvok[length(lopvok)]);
       //  mymid:=ansireplacetext(mymid,'_',lopvok);
        try
         myvok:=lopvok[length(lopvok)];
         if mymid<>''  then if pos(mymid[length(mymid)],vokaalit)>0 then myvok:=mymid[length(mymid)];
        except myvok:='';end;
         mylop:=ansireplacetext(paatteet[j],'*',myvok);
         //mylop:=yhtlops[j];
         while (length(mymid)>0) and (mymid[1]='-') do begin delete(mymid,1,1);delete(mto,length(mto),1);end;
         write(' <small> ',mto,'<b>',mymid,'</b>',mylop,'</small> ');//;,AV,v,h, ' ');
       end;
      except writeln('LKA=',lka);end;
     try
      except writeln('bbbb');end;
    end;
    for i:=3 downto dif do  writeln('</ul>');
    for i:=dif to 3 do
    begin
        writeln('<li>:',aw[i],':<ul title="',sana,'"><li>');
    end;
    ow.commatext:=sana;
    //writeln('%');

 end;
end;

procedure t_taivlka.match(alku,loppu:ansistring;sija:byte;mm:tmatchmaker);
var i,j:integer;downhits:ttrylist;ahit,avvahvat:boolean;cut:byte;
 mymid,lopkon:ansistring;
begin
 mymid:=mids[sija];
 cut:=0;lopkon:='';
 while pos('-',mymid)=1 do begin delete(mymid,1,1);cut:=cut+1;end;
 try
 if pos('*',mymid)=1 then begin lopkon:=alku[length(alku)];delete(mymid,1,1);end;
 if alku<>'' then if pos('_',mymid)>0 then  mymid[pos('_',mymid)]:=alku[length(alku)];
except writeln('==============',sija);raise;end;
 if mymid<>'' then if not matchend(alku,mymid) then exit;
  alku:=copy(alku,1,length(alku)-length(mymid));

  loppu:=mymid+loppu;
 if (num<32) then if sija in [0,2,5,9,13,14,17,21] then avvahvat:=true else avvahvat:=false;
 if (num>31) then if (sija in [0,2]) then avvahvat:=false else avvahvat:=true;
  writeln('<hr><li>LKA',num,' #',sija,' ', alku,'|',loppu,' [',mymid,'=',mids[sija],avvahvat,']--',cut,'/',sija,paatteet[sija],'==',lkons.count,matchend(alku,mymid));
  writeln('<ul>');
  for i:=0 to lkons.count-1 do
   t_lopkon(lkons.objects[i]).match(alku,loppu,avvahvat,cut,lopkon,mm);
 writeln('</ul>');
end;




procedure t_lopkon.match(alku,loppu:ansistring;avvahvat:boolean;cut:byte;lopkon:ansistring;mm:tmatchmaker);
var i,j:integer;downhits:ttrylist;myvok:ansistring;
begin
 //if kon=('_') or () then
 writeln('<li><b>Kon:',kon,'/',lopkon,'</b>: ',alku,'|',loppu,avvahvat,lvoks.count,lvoks.commatext);//lvoks[j]+downhits.alut[i],'/'+downhits.loput[i]);
 if lopkon<>'' then if kon=alku[length(alku)] then
 begin
     alku:=copy(alku, 1,length(alku)-1);
     loppu:=kon+loppu;
 end else exit;

 for j:=0 to lvoks.count-1 do
 t_lopvok(lvoks.objects[j]).match(alku,loppu,avvahvat,cut,mm);
 exit;

 if kon='_' then kon:='';

 if (kon='') or (alku[length(alku)]=kon) then
 begin
   loppu:=kon+loppu;
   alku:=copy(alku,1,length(alku)-length(kon));
  writeln('<ul>');
   for j:=0 to lvoks.count-1 do
   begin
      //writeln('<li><b>toVok:',lvoks[j],'</b>: ',alku,'|',loppu);//lvoks[j]+downhits.alut[i],'/'+downhits.loput[i]);
      t_lopvok(lvoks.objects[j]).match(alku,loppu,avvahvat,cut,mm);
   end;
    writeln('</ul>');

 end;
end;
procedure t_lopvok.match(alku,loppu:ansistring;avvahva:boolean;cut:byte;mm:tmatchmaker);
//match(var uphits:ttrylist; mm:tmatchmaker);
var i:integer;downhits:ttrylist;myvok:ansistring;
begin writeln('/cut:',cut,'/v:',vok);
 myvok:=vok;
 if myvok='_' then myvok:='';

 while cut>0 do if myvok<>'' then begin delete(myvok,length(myvok),1);cut:=cut-1;end else break;
 writeln('<li><b>Vok:[',vok,']</b>: ',alku,'|',loppu,'+',myvok+'|-',cut);//lvoks[j]+downhits.alut[i],'/'+downhits.loput[i]);
 if (myvok='') or (matchend(alku,myvok)) then
 begin
   loppu:=myvok+loppu;
   alku:=copy(alku,1,length(alku)-length(myvok));
  writeln(lavs.count,'=<ul>');
  for i:=0 to lavs.count-1 do
  begin
     //writeln('<li><b>toAV:',lavs[i],'</b>: ',alku,'|',loppu);//lvoks[j]+downhits.alut[i],'/'+downhits.loput[i]);
    try
     t_av(lavs.objects[i]).match(alku,loppu,avvahva,cut,mm);
     except writeln('<li>FAILAVS:',i);end;
  end;
  //t_lopvok(lvoks.objects[j]).match(alku,loppu,avvahvat,mm);
  writeln('</ul>');

 end;

end;



procedure t_av.match(alku,loppu:ansistring;avvahva:boolean;cut:byte;mm:tmatchmaker);
            //procedure t_av.match(var uphits:ttrylist;mm:tmatchmaker);
var i,j:integer;downhits:ttrylist;thisav:ansistring; slst:tstringlist;
  asana,konstiton:ansistring;sanalist:tstringlist;
begin
 writeln(vahva,heikko,'__',cut);

 thisav:=ifs(avvahva,vahva,heikko);writeln('.',thisav);
 while cut>0 do if thisav<>'' then begin delete(thisav,length(thisav),1);cut:=cut-1;end else break;
 //while cut>0 do if alku<>'' then begin delete(alku,length(alku),1);cut:=cut-1;end else break;
 if (thisav='') or (alku[length(alku)]=thisav) then
 begin
  konstiton:=alku;
  try
  while (konstiton<>'') and (pos(konstiton[1],konsonantit)>0) do delete(konstiton,1,1);
  except writeln('<li>FAILoneAV:',alku,'|',loppu);end;
  writeln('<li>AV:',alku,'|',loppu,' <b>[',vahva,heikko,'=',thisav,']</b>:',avvahva,': ',konstiton,':',cut);
  //           AV:    t   |  aria             [t         =  t       ]      :TRUE     :              :0 %,54
  //if thisav='s' then writeln('///'+sanat+'///');
  sanalist:=tstringlist.create;
  sanalist.commatext:=sanat;
  writeln('%,',sanalist.count);

  for i:=1 to sanalist.count-1 do
  begin
     asana:=copy(sanalist[i],1,length(sanalist[i])-cut);
     //write('(',asana,')');
     if (length(asana)=1)
     or (konstiton='')
     or (
     pos(konstiton,asana+thisav)>0)
     or (pos(asana+thisav,konstiton)>0)
    then
    begin
     writeln('<b>htx:',asana,thisav,loppu,'</b>',i);
     mm.hits.add(asana+thisav+loppu);
    end;
  end;
   sanalist.free;
 end;
 //for i:=0 to uphits.count-1 do writeln(' {',uphits.alut[i],'/',uphits.loput[i],uphits.sija[i],'}');
 //fillchar(downhits,sizeof(downhits),0);
 {for i:=0 to uphits.count-1 do
 begin
   if uphits.lka<32 then if (uphits.sija[i] in [2,4,5,6,10,11,12])
     then thisav:=heikko else thisav:=vahva;
   if uphits.lka>31 then if (uphits.sija[i] in [0,1])
     then thisav:=vahva else thisav:=heikko;
   if uphits.alut[i][length(uphits.alut[i])]=thisav then
   begin
    writeln('<li>HIT:',thisav,'/',vahva, heikko,':');
      slst:=tstringlist.create;
      slst.commatext:=sanat;
      for j:=0 to slst.count-1 do writeln(slst[j]+'<b>'+thisav+uphits.loput[i]+'</b>, ');
      for j:=0 to slst.count-1 do mm.hits.add(slst[j]+thisav+uphits.loput[i]);
   end;
    // writeln('<li>HIT:',sanat);
   //writeln('%',
 end;}
end;

constructor t_taivlka.create(v:ansistring;slk:tsanaluokka);
begin
  num:=strtointdef(v,99);
  astecount:=0;wcount:=0;
 lkons:=tstringlist.create;
 writeln('####',v,self.num);
 slk.luokat.addobject(v,self);
end;
constructor t_lopkon.create(v:ansistring;lkap:t_taivlka);
begin
 writeln('###',v);
   parentlka:=lkap;
   kon:=v;
   lvoks:=tstringlist.create;
   parentlka.lkons.addobject(kon,self);
   lkcount:=lkcount+1;
end;
constructor t_lopvok.create(v:ansistring;konp:t_lopkon);
begin
 writeln('##',v);
   parentkon:=konp;
   vok:=v;
   parentkon.lvoks.addobject(vok,self);
   lavs:=tstringlist.create;
   lvcount:=lvcount+1;
end;
constructor t_av.create(v:ansistring;vokp:t_lopvok);
begin
   parentvok:=vokp;
   vahva:='';
   heikko:='';
   case length(v) of
      1: vahva:=v[1];
      2: begin vahva:=v[1];heikko:=v[2];end;
    end;
   writeln('#.',v,length(v),'/',vahva,heikko);
   parentvok.lavs.addobject(v,self);
   avcount:=avcount+1;
end;


function tsija.match(tofind:ansistring;rlist:tstringlist):boolean;
var i,p:integer;myend:ansistring;
begin
 for i:=0 to 12 do
  writeln('<li>match:',tofind,' to ', num, ending,'/',tofind);
  result:=false;
  //writeln('testzyxx!!!!!!!!!!!!!!!!!!!!');
  //if length(ending)>=length(tofind) then exit;
  if copy(tofind,length(tofind)-length(ending)+1)=ending then result:=true else exit;
  write('<li>[[',ending,'!',tofind,num,' ');
  rlist.add(copy(tofind,1,length(tofind)-length(ending)));
  rlist.objects[rlist.count-1]:=(self);
  //writeln('<li>sija: ',num,ending, result,' [',copy(tofind,1,length(tofind)-length(ending)),'|');
  //self.save(rlist.count-1,mystems);
  writeln('tmp!!!');//now we are listing all, not just matches
end;

{function tstemmer.matchsijat(tofind:ansistring;rlist:tstringlist):boolean;
var i,j:integer;
begin
writeln('<li>mätsää ',tofind);
//for i:=1 to 10 do tsija(sijat[i]).save(self);
for i:=0 to 65 do
 begin
 try
 if tsija(sijat[i]).match(tofind,rlist) then
 tsija(rlist.objects[rlist.count-1]).save(i,mystems);
 except writeln('<li>',i);end;
 end;
writeln('<hr><hr><hr>',rlist.commatext,'<hr><hr><hr>');
//for i:=0 to 77 do tsija(sijat[i]).save(self);

end;}


end.




procedure t_taivlka.match(var uphits:ttrylist;mm:tmatchmaker);
var i,j:integer;downhits:ttrylist;ahit:boolean;alku,loppu:ansistring;
begin
 writeln('<li>LKA',num,':');
 //for j:=0 to 12 do writeln('_',mids[j]);
 for i:=0 to uphits.count-1 do writeln(' {',uphits.alut[i],'/',uphits.loput[i],' #',uphits.sija[i],'[');//,mids[uphits.sija[i]],']}');
 fillchar(downhits,sizeof(downhits),0);
 downhits.lka:=num;
 mm.vahvaluokka:=vahva;
 for i:=0 to uphits.count-1 do
   begin
     alku:=copy(uphits.alut[i],1,length(uphits.alut[i])-length(mids[uphits.sija[i]]));
     loppu:=mids[uphits.sija[i]]+uphits.loput[i];
     //writeln('<li>TRY:',alku,'|',loppu,'#',uphits.sija[i],'//',uphits.alut[i],length(mids[uphits.sija[i]]));
     ahit:=matchend(uphits.alut[i],mids[uphits.sija[i]]);
     if ahit then
      addhits(downhits,
        copy(uphits.alut[i],1,length(uphits.alut[i])-length(mids[uphits.sija[i]])),
        loppu,uphits.sija[i]);
     //writeln('<li> *',uphits.alut[i],'|',mids[uphits.sija[i]],uphits.sija[i],copy(uphits.alut[i],1,length(uphits.alut[i])-length(mids[uphits.sija[i]])));
  end;
 writeln('<li>HITZ:',num, '/',uphits.count,'>',downhits.count,' : ',lkons.count,' ');
  if downhits.count=0 then exit;
  for i:=0 to downhits.count do writeln(' {',downhits.alut[i],'/',downhits.loput[i],'}');
  writeln('<ul>');
  for i:=0 to lkons.count-1 do
   t_lopkon(lkons.objects[i]).match(downhits,mm);
  writeln('</ul>');
end;
procedure t_lopkon.match(var uphits:ttrylist;mm:tmatchmaker);
var i,j:integer;downhits:ttrylist;
begin
 fillchar(downhits,sizeof(downhits),0);
 writeln('<li>KON:',kon,':');
 if kon='_' then kon:='';
 for i:=0 to uphits.count do writeln(' {',uphits.alut[i],'/',uphits.loput[i],'}');
 for i:=0 to uphits.count-1 do
 if (kon='') or (uphits.alut[i][length(uphits.alut[i])]=kon) then
  addhits(downhits,
     copy(uphits.alut[i],1,length(uphits.alut[i])-length(kon)),
     kon+uphits.loput[i],uphits.sija[i]);
  writeln('<li>',kon, '/',uphits.count,'>',downhits.count);
  //for i:=0 to downhits.count-1 do
   writeln('<li>dowtov:',kon);
     for i:=0 to downhits.count do writeln(' {',downhits.alut[i],'/',downhits.loput[i],'}');
   writeln('<ul>');
     for j:=0 to lvoks.count-1 do
          //writeln(lvoks[j]+downhits.alut[i],'/'+downhits.loput[i]);
        t_lopvok(lvoks.objects[j]).match(downhits,mm);
     writeln('</ul>');

end;
procedure t_lopvok.match(var uphits:ttrylist; mm:tmatchmaker);
var i:integer;downhits:ttrylist;
begin
 fillchar(downhits,sizeof(downhits),0);
 writeln('<li>VOK:',vok,':');
 if vok='_' then vok:='';
 for i:=0 to uphits.count do writeln(' {',uphits.alut[i],'/',uphits.loput[i],'}');
 for i:=0 to uphits.count-1 do
 if (vok='') or (matchend(uphits.alut[i],vok)) then
  addhits(downhits,
     copy(uphits.alut[i],1,length(uphits.alut[i])-length(vok)),
     vok+uphits.loput[i],uphits.sija[i]);
  writeln('<li>',vok, '/',uphits.count,'>',downhits.count);
  {for i:=0 to downhits.count-1 do
    for j:=0 to lvoks.count-1 do
       writeln(lvoks[j]+downhits.alut[i],'/'+downhits.loput[i]);
     //t_lopvok(lvoks.objects[j]).match(downhits,mm);
     }
   if downhits.count=0 then exit;

   writeln('<li>dowtoav:',vok);
   for i:=0 to downhits.count do writeln(' {',downhits.alut[i],'/',downhits.loput[i],'}');
  writeln('<ul>');
 for i:=0 to lavs.count-1 do
  t_av(lavs.objects[i]).match(downhits,mm);
 writeln('</ul>');


end;
procedure t_av.match(var uphits:ttrylist;mm:tmatchmaker);
var i,j:integer;downhits:ttrylist;thisav:ansistring; slst:tstringlist;
begin
 fillchar(downhits,sizeof(downhits),0);
 //writeln('<li>AV:[',vahva,heikko,']:');

 //for i:=0 to uphits.count-1 do writeln(' {',uphits.alut[i],'/',uphits.loput[i],uphits.sija[i],'}');
 for i:=0 to uphits.count-1 do
 begin
   if uphits.lka<32 then if (uphits.sija[i] in [2,4,5,6,10,11,12])
     then thisav:=heikko else thisav:=vahva;
   if uphits.lka>31 then if (uphits.sija[i] in [0,1])
     then thisav:=vahva else thisav:=heikko;
   if uphits.alut[i][length(uphits.alut[i])]=thisav then
   begin
    writeln('<li>HIT:',thisav,'/',vahva, heikko,':');
      slst:=tstringlist.create;
      slst.commatext:=sanat;
      for j:=0 to slst.count-1 do writeln(slst[j]+'<b>'+thisav+uphits.loput[i]+'</b>, ');
      for j:=0 to slst.count-1 do mm.hits.add(slst[j]+thisav+uphits.loput[i]);
   end;
    // writeln('<li>HIT:',sanat);
   //writeln('%',
 end;
end;

