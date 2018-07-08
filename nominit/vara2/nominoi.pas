unit nominoi;

{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils,nomutils,strutils;

//  procedure doit;

type tsana=record
   lla:byte;
end;
type tsanaluokka=class(tobject)
var sanafile,muotofile,listafile:textfile;
tavus:tstringlist;
luomuo:array[0..50] of tstringlist;
  constructor create;
  //procedure listaa;
  procedure puu;
  function etsi(wrd:ansistring;res:tstringlist):boolean;
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
constructor triimitin.create;
//var ms:tstringlist;i,j:integer;
begin
  nominit:=tsanaluokka.create;
end;

constructor tsanaluokka.create;
var ms:tstringlist;i,j:integer;
begin
  //fixmonikot;exit;
  tavus:=tstringlist.create;
  writeln('sanapåuu');
 // puu;exit;
 // korjaa;exit;

  writeln('<table border="1">');
  MS:=TSTRINGLIST.CREATE;
  ms.loadfromfile('muodot2.lst');
  for i:=0 to ms.count-1 do
   begin
     writeln('<tr><td>',i+1,'</td>');
     luomuo[i]:=tstringlist.create;
     luomuo[i].commatext:=ms[i];
     try
     luomuo[i].delete(0);
     //writeln('<li>',i);
     except end;
     for j:=0 to luomuo[i].count-1 do
      begin
     if pos('/',luomuo[i][j])>0 then
     luomuo[i][j]:=trim(copy(luomuo[i][j],1,pos('/',luomuo[i][j])-1));
     writeln('<td>',luomuo[i][j],'</td> ');
    end;
     writeln('</tr>');

  end;
  writeln('</table><hr>');;
  //luolista;
end;

procedure tsanaluokka.luolista;  //tuotti sanalistan, jatkossa se luetaan tiedostosta
var sfile,mfile,ofile:textfile;
Ms,mls:tstringlist;
mymid,mylop,sana,runko,lka,prevlka,itesana,av,v,h,lopvok,lopkon:ansistring;
osa,vc:byte;
i,j,k,lknum,cut:integer;
ast:taste;
takako,thisvahva,konstikas:boolean;
lopvoks:ansistring;
lopvoklist:tstringlist;
begin
 lopvoklist:=tstringlist.create;
  writeln('</table>,LUOLISTA',yhtlops[6]);
 ifs(true,'','');

  //puu;exit;
  //assign(sfile,'nomsall2.csv');
  //assign(sfile,'nomsfixed1.lst');
  assign(sfile,'nomsall.lst');
  reset(sfile);
  assign(ofile,'nomsall4.csv');
  rewrite(ofile);
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
    itesana:=taka(itesana,takako);
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
   if konstikas then
   //if itesana[LENGTH(itesana)]='t' then write('<li><b>',itesana,':',runko,'|',lopvok,'/',lopkon,'[',v,h,']</b>')
    write('<li>',itesana,':',runko,'|',lopvok,'/',lopkon,'[',v,h,']');
   writeln(ofile,lka,',',ifs(lopkon='','_',lopkon),',',lopvok,',',v,h,',',ifs(takako,'0','1'),',',runko);
 end;

 writeln('</table><h4>',lopvoklist.commatext+'</h4>');
 FINALLY
 closefile(ofile);
 closefile(sfile);END;
end;
function tsanaluokka.etsi(wrd:ansistring;res:tstringlist):boolean;
begin
   //sisältö puusta muokaten
end;


procedure tsanaluokka.listaa;  //debuggaukseen taivutusmuotojen katseluun
var //ifile:textfile;
aw,ow:tstringlist;i,j,dif,c,ccc,lka:integer;thisvahva:boolean;
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
      //for j:=6 to 6 do
       begin
         lka:=strtointdef(ow[0],0);
         lopkon:=ow[1];
         lopvok:=ow[2];
         runko:=ow[5];
         if (lka>31) then if (j in [0,1]) then thisvahva:=false else thisvahva:=true;
         if (lka<32) then if j in [2,4,5,6,10,11,12] then thisvahva:=false else thisvahva:=true;
         if (lka<32) then if runko<>'' then if pos(runko[length(runko)],vokaalit)<1 then lopkon:=runko[length(runko)];
         // write('<td>',runko,'<b>',ifs((lknum>31)=thisvahva,v,h),'</b>',lopvok,'<b>',ansireplacetext(luomuo[lknum-1][j],'*',lopkon),'</b>',yhtlops[j],'</td>');//;,AV,v,h, ' ');
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
         mylop:=ansireplacetext(yhtlops[j],'*',myvok);
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
 assign(outs,'nomsall2_fixt.lst');
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
    write('<li> ***',line1,'</li>');
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

        if parts1.count>5 then
         writeln(outs,parts1[0],' ',parts1[1],' ',parts1[5]) else
         writeln(outs,parts1[0],' ',parts1[1],' ',copy(parts1[2],1,length(parts1[2])-1));

        writeln('<li>',parts1.commatext);
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


    parts1.commatext:=taka(trim(line1),fit);
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

    writeln(' ',taka(line1,turha));
    writeln(outs,taka(line1,turha));
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
         // write('<td>',runko,'<b>',ifs((lknum>31)=thisvahva,v,h),'</b>',lopvok,'<b>',ansireplacetext(luomuo[lknum-1][j],'*',lopkon),'</b>',yhtlops[j],'</td>');//;,AV,v,h, ' ');
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
         mylop:=ansireplacetext(yhtlops[j],'*',myvok);
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

end.

