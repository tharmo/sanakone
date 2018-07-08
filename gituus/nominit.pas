unit nominit;
interface
uses
  Classes, SysUtils,strutils,riimiutils,math,etsi;

{$mode objfpc}{$H+}
{type tnomlka=record kot,ekasis,vikasis:word;vahva:boolean;end;
type tnomsis=record ekaav,vikaav:word;sis:string[8];end;
//type tverlvok=record ekaav,vikaav:word;vok:array[0..1] of char;end;
type tnomav=record ekasana,takia,vikasana:word;h,v,av:string[1];end;  //lis�� viek� .takia - se josta etuvokaalit alkavat
}
type tnomlka=record esim:string;kot,ekasis,vikasis:word;vahva:boolean;end;

type tnomsis=record ekaav,vikaav:word;sis:string[8];end;
//type tverlvok=record ekaav,vikaav:word;vok:array[0..1] of char;end;
type tnomav=record ekasana,takia,vikasana:word;h,v,av:string[1];end;  //lis�� viek� .takia - se josta etuvokaalit alkavat
type tnsana=record san:string[15];akon:string[4];takavok:boolean;end;

{type tsija=record
  vv,hv:boolean;
  num:byte;//vparad,hparad:byte;
  //vmuomids,hmuomids:array[1..12] of byte;
  ending:string[15];
end;
}

type tnominit=class(tobject)
    lmmids:array[0..49] of array[0..33] of string[15];
    clka,csis,cav,csan:integer;
    nhitlist:tlist;
    //protomids:array[0..49] of array[0..11] of string[15];
     // lk:60 lv:130 av:683
     lkat,lktot,latot,avtot,taivluokkia:word;
     //sijat:array[0..49] of array[0..75] of string[8];
     sijat:array[0..33] of tsija;
     lUOKS:array[0..49] of tnomlka; //78-52+1:+1 varalla
     sisS:array[0..255] of tnomsis;
     AVS:array[0..1023] of tnomav;
     //lks:49 sis:130 av:617 /w:27809
     //VOKS:array[0..160] of tverlvok;
     //sanat:array[0..27816] of tnsana;
     //hakueitaka,hakueietu:boolean;
     sanat:array[0..30000] of tnsana;
   // procedure etsi(hakunen:tvhaku;aresu:tstringlist;onjolist:tlist);
    procedure etsi(hakunen:thakunen;aresu:tstringlist;onjolist:tlist);
    procedure etsiold(hakunen:thakunen;aresu:tstringlist;onjolist:tlist);
    procedure generate(runko,sis,astva:str16;luokka:integer;aresu:tstringlist;hakutakvok:boolean);
    procedure luesanat(fn:string);
    procedure luemids(fn:string);
    procedure siivoosijat;
    procedure listaa;
    constructor create(wfile,midfile:string);
    procedure haesijat(haku:ansistring;sikalauma:tstringlist);
end;

const nbaseendings:array[0..11] of ansistring =('a','a', 'n', '', 'a', 'ut', 'i', 'tu', 'en', 'isi', 'kaa', 'emme');
scount=33;
const nendings:array[0..33] of ansistring=('','n','a','ssa','sta','*n','lla','lta','lle','na','ksi','tta','t','en','a','issa','ista','in','illa','ilta','ille','ina','iksi','itta','in','en','iden','itten','in','ten','in','ihin','a','ita');
//const navexamples:array[1..49] of ansistring=('abo','hiomo','avio','elikko','cup','agar','ovi','byte','eka','boa','itara','urea','aluna','urakka','upea','kumpi','keruu','j��','suo','bukee','gay','buffet','lohi','uni','liemi','veri','mesi','kansi','lapsi','peitsi','yksi','aamen','astin','alaston','l�mmin','alin','vasen','�inen','ajos','etuus','oras','mies','ohut','kev�t','sadas','tuhat','mennyt','ane','huhmar');
//const navexamples:array[1..49] of ansistring=('ukko','hiomo','avio','elikko','cup','agar','kaikki','byte','eka','boa','itara','urea','aluna','urakka','upea','kumpi','keruu','j��','suo','bukee','gay','buffet','lohi','uni','liemi','veri','mesi','j�lsi','lapsi','peitsi','yksi','tyt�r','astin','alaston','l�mmin','alin','vasen','�inen','ajos','etuus','rakas','mies','immyt','kev�t','sadas','tuhat','mennyt','hake','kinner');

const nexamples:array[1..49] of ansistring=('ukko','hiomo','avio','elikko','h�kki','agar','kaikki','nukke','ankka','fokka','itara','urea','aluna','ulappa','upea','kumpi','keruu','j��','suo','bukee','gay','buffet','lohi','uni','liemi','veri','mesi','j�lsi','lapsi','peitsi','yksi','tyt�r','asetin','hapan','l�mmin','alin','vasen','�inen','ajos','etuus','rakas','mies','immyt','kev�t','sadas','tuhat','mennyt','hake','kinner');
const nsijnams:array[1..34]of ansistring =('N Nom Sg','N Gen Sg','N Par Sg','N Ine Sg','N Ela Sg','N Ill Sg','N Ade Sg','N Abl Sg','N All Sg','N Ess Sg','N Tra Sg','N Abe Sg','N Nom Pl','N Gen Pl','N Par Pl','N Ine Pl','N Ela Pl','N Ill Pl','N Ade Pl','N Abl Pl','N All Pl','N Ess Pl','N Tra Pl','N Abe Pl','N Ins Pl','N Gen Pl','N Gen Pl','N Gen Pl','N Gen Pl','N Gen Pl','N Ill Pl','N Ill Pl','N Par Pl','N Par Pl ');

const nsijesims:array[1..34]of ansistring =('ilo','ilon','iloa','ilossa','ilosta','iloon','ilolla','ilolta','ilolle','ilona','iloksi','ilotta','ilot','ilojen','iloja','iloissa','iloista','iloihin','iloilla','iloilta','iloille','iloina','iloiksi','iloitta','iloin','ilojen','omenoiden','omenoitten','ulappain','unten','uniin','iloihin','iloja','omenoita');



const
nvahvanvahvat =[0,2,5,9,13,14,17,21,25,28,31,32];
nheikonheikot= [0,2,29];
//if (lka<32) then if j in [0,2,5,9,13,14,17,21] then thisvahva:=true else thisvahva:=false;

{$mode objfpc}{$H+}

procedure fixlista(fnin,fnout:string);



implementation
uses riimitys;
procedure tnominit.siivoosijat;
var
  i,j,k,lu,sis:integer;
  svok,mm:string[5];ss:string;
  //gens,mygens:tstringlist;
begin


  //gens:=tstringlist.create;
  //mygens:=tstringlist.create;
  //gens.loadfromfile('gen.csv');
  writeln('<hr>LISTAApasSIJAT:::');
  write('<pre>         :::::');
  for j:=0 to scount do
   write(',',copy(inttostr(j)+'              ',1,8));
  write(^j,'             ');
  for j:=0 to scount do
   write(',',copy(nsijesims[j]+'              ',1,8));
  write(^j,'             ');
  for j:=0 to scount do
   begin
    ss:=copy(nsijnams[j],2);
    ss:=stringreplace(ss,' ','',[rfReplaceAll]);
   write(',',copy(ss+'              ',1,8));
  end;
  write(^j,'             ');
  for j:=0 to scount do
   write(',',copy(sijat[j].ending+'              ',1,8));
  write(^j);

  for i:=0 to 48 do
  begin
     write(i+1,'  ;',copy(nexamples[i+1]+'                ',1,12));

     for j:=0 to scount do
     begin
        mm:=reversestring(lmmids[i,j]);
        if length(mm)>1 then for k:=1 to length(mm) do if pos(mm[1],'-_*')<1 then break else begin mm:=mm+mm[1];delete(mm,1,1);  end;
       //if i+1>31 then if pos('-',mm)=1 then delete(mm,1,1);
       //if i+1 in [33,34,35,36,37] then if pos('n',mm)=1 then delete(mm,1,1);
       //if i+1 in [39,40,41,42] then if pos('s',mm)=1 then delete(mm,1,1);
       //if i+1 in [43,44] then if pos('t',mm)=1 then delete(mm,1,1);
       //if mm=lmmids[i,j] then write(',',copy(mm+'                    ',1,8))
       //else write(',',copy(mm+'/'+copy(lmmids[i,j],1,length(lmmids[i,j])-length(mm))+'                    ',1,8));
       write(',',copy(string(mm)+'              ',1,8));

     end;

     //mygens.commatext:=gens[i];
     {try
     FOR J:=2 TO 5 DO
     write(COPY(mygens[j]+'                 ',1,6));
     except       write('FAIL%',i,'#',gens.count);end;
     }

     writeln;
  end;
  writeln('</pre>LISLOPPU</pre></pre>juu');
end;

procedure fixlista(fnin,fnout:string);  //just once as a fast cure ... gotta rewrite the creator of old listfile later, now just quick cure;
var i,j,jj:integer;fin,fout:textfile;
 rivi,uus,sisus,v,h,vs,sana,alkkon:string;w:tstringlist;
 lka:integer;
  lopvok,lopkon:string;
begin
  assign(fin,fnin);
  reset(fin);
  assign(fout,fnout);
  rewrite(fout);
  w:=tstringlist.create;
  writeln('<pre>');
  i:=0;
  while not eof(fin) do
  begin
        readln(fin,rivi);
        w.commatext:=rivi;
        alkkon:='';
       {if w[0]='042' then w[2]:='ei';  ///pelkk� MIES, loppu-s pois .. temppuilua, mutta ok?
       if w[0]='044' then w[2]:='a';  ///pelk�t kev�t, ven�t, loppu-t pois .. temppuilua, mutta ok?
       if w[0]='045' then w[1]:='';  ///ordinaalilukuja, loppu-s pois ..
       if w[0]='046' then w[1]:='';  ///vain TUHAT, loppu-t pois ..
       if w[0]='047' then begin w[1]:='';w[2]:='';end;  ///,-ut p��t. partisiippej� loppu-ut pois ..    //liittoutuneet virheen� .. korjaantuu samalla
       }
       lka:=strtointdef(w[0],999);
       if lka=42 then writeln('<li>',rivi, ' ',fnin,'  mies on jotenkin tuhrittu tiedostossa. k�sin korjattu, mutta nomit.luolista rikki');
       if w[0]='038' then if w[3]<>'nn' then continue //pois: minunlaiseni.. voi muokatakin > minunlainen
        else
        begin //shitty thing to have to do at this stage, should be handled previously .. well, the whole fixlista is shitty
         lopvok:='';lopkon:='';
           for j:=length(w[5]) downto 1 do
            if (pos(w[5][j],vokaalit)<1) then /// or (j+2<length(w[5])) then
            begin
               jj:=j;
                if j+2<length(w[5]) then jj:=j+1;

              //w[1]:=reversestring(copy(w[5],j+1))+'';
              w[1]:=copy(w[5],jj+1)+'';
              w[2]:=''; w[3]:='';//w[5][j]+w[5][j];
              w[5]:=copy(w[5],1,jj);
              if j<>jj then writeln(':::',w.commatext);
              break;
            end;// else writeln(w[5][j],j);
        end; //  nen-p��tteet sanasta pois
        if w[5]='' then sana:='' else if pos(w[5][1],konsonantit)>0 then begin alkkon:=w[5][1];sana:=copy(w[5],2) end else sana:=w[5];
        sana:=reversestring(sana);
        sisus:=reversestring(w[2]+ifs(w[1]='_','',w[1]));
        if length(w[3])=2 then begin v:=w[3][1]; h:=w[3][2];if h=v then v:='a';end;
        if length(w[3])=1 then begin v:=w[3][1]; h:='';end;
        if length(w[3])=0 then begin h:='';v:='a';end;
        vs:=w[4];
       uus:=w[0]+','+sisus+','+v+','+h+','+vs+','+sana+','+alkkon;
        if lka=42 then writeln('<li>',uus);
       if  w[0]='005' then if w[5]='rem' then writeln('<h1>:::',rivi,' //',uus,'</h1>');
       if lka<32 then if w[1]<>'_' then writeln(rivi,'   ',uus);
       writeln(fout,uus);
   end;
  closefile(fin);closefile(FOUT);
end;

procedure tnominit.haesijat(haku:ansistring;sikalauma:tstringlist);
var i,lk,hitpos:integer;mylop:ansistring;j:ptrint;a:ansichar;
begin
 // KAIKKI ON JO REVERSOITU
  //writeln('haesija:',haku,scount);
//for j:=0 to scount do
for j:=0 to scount do
 begin

    mylop:=reversestring(sijat[j].ending); ////VERBEISSA EI loppup��tteiss� toistoja kuten nominien illatiiviss�
      // kuuhun:   *h -> h* ; h* ->hh  nuhuuk
//     if pos('*',mylop)>0 then if length(haku)>2 then begin mylop[length(mylop)]:=haku[length(mylop)+1];end;
     //p�hk��, vain illatiivissa ja siin� aina "*n", eli ei ole mit��n yleiss��nt�� miten * pit�is hanskata
    if mylop='' then hitpos:=1 else
    //if matchendvar(haku,mylop,alku) then  //EIIK� T�T� KUN KAIKKI ON K��NNETTU
    hitpos :=POS(mylop,haku);
    //writeln('<li>sija?',haku,'=',mylop,'@',hitpos);
     if pos('*',mylop)>0 then if haku[1]='n' then begin hitpos:=1;mylop:='n';end;
    //writeln(' [',mylop, hitpos,'] ');
    //writeln('<li>XZ:',haku, '//',mylop);
    if hitpos=1 then  //EIIK� T�T� KUN KAIKKI ON K��NNETTU
   begin

    sikalauma.addobject(copy(haku,length(mylop)+1),tobject(j));//@sijat[j]));  //TEMPPUILUA, NUMERO PANNAAN OBJEKTIPOINTTERIIN
    //writeln('+',j,reversestring(haku));
   end;
 end;
end;

procedure tnominit.luesanat(fn:string);
var sl:tstringlist;
 ms:tsija;sanafile:textfile;
 sana,konsti,mysis,myav,mysana,mysija,sss:ansistring;i:word;differ:byte;
  prevsl:tstringlist;
  //clka,csis,cav,csan,
    cut:integer;
  prlim:word;
  //lk,sis,av,san,sija:integer;
begin
   prlim:=0;
  clka:=-1;csis:=0;cav:=0;csan:=0;
  assign(sanafile,fn);//'verbsall.csv');
  reset(sanafile);
  sl:=tstringlist.create;
  prevsl:=tstringlist.create;
  prevsl.commatext:='000,o,a,,0,igada,';
  //lk:=-1;sis:=-1;av:=-1;san:=0;sija:=-1;

  luoks[0].vahva:=true;
  while not eof(sanafile) do
  begin
     if clka>=50 then break;
     readln(sanafile,sana);
     //writeln('xxx');
     sl.commatext:=sana;
     konsti:=sl[6]+ ansireversestring(sl[1]+sl[2]+sl[5]);
     konsti:=ifs(sl[4]='1',etu(konsti),konsti);
     differ:=4;
     for i:=0 to sl.count-1 do if prevsl[i]<>sl[i] then begin differ:=i;break; end;
     if differ=3 then differ:=2;
    if (differ<1) then   //UUSI TAIVUTUSLUOKKA
     try
     begin
      if clka>=0 then
      luoks[clka].vikasis:=csis;
      clka:=clka+1;
      luoks[clka].kot:=strtointdef(sl[0],99);
      luoks[clka].ekasis:=csis+1;
      if (clka<31) then  luoks[clka].vahva:=true else  luoks[clka].vahva:=false;
      prlim:=0;
      //writeln('</UL><li>luokka:',clka,'  ',sana,'<UL>');
      //luoks[clka].kot:=strtointdef(awl[0],99);
    end;

    except writeln('faillka');end;
    try
    if (differ<2) then   //UUDET SISUSKALUT
    begin
        siss[csis].vikaav:=cav;
        csis:=csis+1;
        siss[csis].ekaav:=cav+1;
        //siss[csis].sis:=reversestring(sl[1]);
        siss[csis].sis:=(sl[1]);
//        if (clka>31) and (clka+1<48) AND  (clka+1<>38)   //this sucks!  loppukons otetaan joskus luokasta, joskus sisuskalusta. pit�� korjata sanalistaan .. fixlista
//        then siss[csis].sis:=copy(siss[csis].sis,2,99);
        //if (siss[csis].sis='') or (pos(siss[csis].sis[length(siss[csis].sis)],vokaalit)<1) then
          //writeln('<li>S:',clka,'/:',siss[csis].sis,'/',CSAN,': ', siss[csis].ekaav);
        prlim:=0;
        //writeln('</UL><li>SIS:',clka,' <b>',siss[csis].sis,'</b> ',Siss[csis].ekaav,'<UL>');//<ul>');
    end;
    except writeln('failsis');end;

    try
    if (differ<4) then //UUSI ASTEVAIHTELULUOKKA
    begin
       if csan>0 then avs[cav].vikasana:=csan-1;
       cav:=cav+1;
       //if sl[4]='0' then begin avs[cav].ekasana:=csan+1;end else  begin avs[cav].ekasana:=9999; avs[cav].takia:=csan+1;end;
       avs[cav].ekasana:=csan;
       avs[cav].takia:=0;
       avs[cav].v:=sl[2];
       avs[cav].h:=sl[3];
       if avs[cav].v='_' then avs[cav].v:=avs[cav].h  //"a" k�ytettiin aastevaihtelun puuttumisen merkkaamiseen. sorttautuu siistimmin
       else prlim:=0;
       //writeln('<li>AV//',CAV,avs[cav].v,avs[cav].h,avs[cav].ekasana,'__',avs[cav].vikasana);
       //if prlim<3 then     begin writeln('<li><small>av:',sl.commatext+' ',cav,'<b> [',avs[cav].v,avs[cav].h,']</b>','#',avs[cav].ekasana,'</small>');end;
    end;//  else      deb:=deb+'___';
    //if sl[4]='0' then avs[cav].takia:=csan+1; //pit�is olla sortattu vokaalisoinnun mukaan, eli ei tarttis laittaa  joka sanalle talteen

    //virhe listan teossa, alkukonsonantit eiv�t kaikki oikeassa paikassa. Pit�is korjata listan tekovaiheessa, ei en�� t��ll�.
    sss:=sl[5];
    for i:=length(sss) downto 1 do
      if pos(sss[i],vokaalit)>0 then break
      else begin sl[6]:=sss[i]+sl[6];delete(sss,i,1);end;
    sanat[csan].san:=sss;
    sanat[csan].takavok:=sl[4]='0';
    //sanat[csan].akon:=reversestring(sl[6]);
    sanat[csan].akon:=(sl[6]);
    if sl[4]='0' then avs[cav].takia:=avs[cav].takia+1;  //lasketaan takavokaalisten m��r�� av-luokassa hakujen tehostamiseksi
    csan:=csan+1;
    //if clka=48 then writeln('<li>',sana,' ---',differ,' SISekaav:',siss[csis].ekaav,'=',avs[cav].v,avs[cav].h,     '/AVekaS:',avs[siss[csis].ekaav].av);

    prevsl.commatext:=sana;  //t�h�n taas seuraavaa sanaa verrataan
    prlim:=prlim+1;
    except writeln('failav');end;
    //if clka>=12  then myav:=avs[cav].h else myav:=avs[cav].v;   //heikot muotot
    //if (clka<12) or (clka>23) then myav:=avs[cav].v else myav:=avs[cav].h;   //12 ekaa ja pari vikaa ovat vahvoja
   end;
  luoks[clka].vikasis:=csis;
  siss[csis].vikaav:=cav;
  avs[cav].vikasana:=csan;
  //writeln('<h1>lks:',clka,' sis:',csis,' av:',cav,' /w:',csan,'</h1>');
  for i:=0 to csis do writeln('/',siss[i].sis);
  // exit;
 // writeln('<ul style="line-height:95%"><ul>') ;

end;
procedure tnominit.listaa;
var lk,sis,av,san,sija,prlim,x:integer;
  //((lk,sis,av,san,sija:integer;
  mysis,myav,mysana,mysija:string;
begin
 luoks[0].ekasis:=0;
for lk:=0 to 48 do //clka do

begin
    writeln('<li><b>lk: ',lk+1,' ',luoks[lk].ekasis,'...',luoks[lk].vikasis,' ',luoks[lk].kot,'</b>');//,'<ul>');
    for sis:=luoks[lk].ekasis to luoks[lk].vikasis  do write(siss[sis].sis,' /');
    write('<pre>');
    for sis:=luoks[lk].ekasis to luoks[lk].vikasis  do
      begin     prlim:=0;
        //if lk=38 then mysis:='' else
        mysis:=siss[sis].sis;
        //writeln('<li> ',reversestring(mysis),'<ul><pre>');
        for av:=siss[sis].ekaav to siss[sis].vikaav  do
        begin   // if avs[av].v=avs[av].h then if prlim>2 then if lk<>38 then continue;
          //if lk=38 then begin avs[av].v:='';avs[av].h:='';end; //pit�� muuttaa l�ht�tiedostoon
          //writeln('<li>',avs[av].v,avs[av].h,'<hr><pre>');//'<ul><li>');

          for san:=avs[av].ekasana to avs[av].vikasana   do
          //for san:=avs[av].ekasana to min(avs[av].ekasana+3,avs[av].vikasana)   do
          begin  if san>avs[av].ekasana+10 then continue;
            if (prlim<4) or  (avs[av].h<>avs[av].v) or (lk=0) then
            begin
            //        writeln('<li>',reversestring(sanat[san].san+sanat[san].akon),', ');
               writeln;
            for sija:=0 to scount do
            begin
              mysija:=LMMIDS[LK,SIJA];
              if (lk<31) or (lk+1=489) then myav:=ifs(sijat[sija].vv,avs[av].v,avs[av].h)
              else myav:=ifs(sijat[sija].hv,avs[av].v,avs[av].h);
              //else myav:=ifs(sijat[sija].hv,avs[av].hxxx,avs[av].vxxx);
              mysana:=sanat[san].san;
              if pos('*',mysija)>0 then
              begin //write(':',mysija,'[',myav,']');
                //delete(mysija,length(mysija),1);
                mysija[length(mysija)]:='-';
                myav:=mysana[1];//write(':',mysija,'[',myav,']');
              end;
              mysana:=mysis+''+myav+''+mysana+sanat[san].akon;
              //writeln(mysana+' ');continue;
              //myssis:=sanat[san].san;
              //while pos('-',mySIJA)=1 do begin write('*');delete(mysija,1,1);delete(mysana,1,1);end;
              if (lk+1=19) and (pos('-',mysija)>0) then begin delete(mysana,2,1);delete(mysija,length(mysija),1);
              // tie / suo sy�d��nkin eka vokaali, ei vikaa kuten muissa
              end  else
              while (mysija<>'') and (mySIJA[length(mysija)]='-') do begin write('.');delete(mysija,length(mysija),1);delete(mysana,1,1);end;
              //while (mysija<>'') and (pos('-',mySIJA)>0) do begin x:=pos('-',mySIJA);  write(x);delete(mysija,x,1);delete(mysana,x,1);end;
              //while pos('-',mysis)=length(mysi) do begin delete(mysis,,1)end;
              //write(' ',reversestring(mysana),'<B>',mysija,'</B>'+sijat[sija].ending,',');
              write(copy(reversestring(mysija+mysana)+''+''+sijat[sija].ending+'                      ',1,16));
              //writeln(' ',reversestring(mysana+sanat[san].akon),'',myav,siss[sis].sis,'<B>',LMMIDS[LK-1,SIJA],'</B>'+sijat[sija].ending);
              prlim:=prlim+1;
            end;
            end;
          end; //writeln('</pre><hr>');
        end; // writeln('</pre></ul>');
      end;  writeln('</pre>');
end;  writeln('</ul>');
end;


constructor tnominit.create(wfile,midfile:string);
begin
writeln('luemids');
luemids('nmids.csv');
writeln('luettu,luesanat');
//luesanat('nomsall.csv');
luesanat(wfile);
writeln('luettu,etsi:');
nhitlist:=tlist.create;
//listaasijat;
exit;
writeln('<hr>etsi<hr>');
//etsi;
//  writeln('<hr>listaakaikki<hr>');
//   listaasanat;
writeln('<hr>listaSkaikki<hr>');
end;


procedure tnominit.luemids(fn:string);  //hanskaa samalla sijojen luonti luettavat sisuskalut on 1/1 sijoihin (todin kuin verbeill�, joilla on "protot")
var i,j:integer;
 slist,mlist:tstringlist;d:boolean;
begin
d:=true;
slist:=tstringlist.create;
mlist:=tstringlist.create;
  slist.loadfromfile(fn);//'nmids.csv');
  //writeln('<pre>luettu ',fn,'=',^m,slist.text,'</pre>');
  slist.delete(0); slist.delete(0);
  slist.delete(0); slist.delete(0);
  //write('<hr>',i,':',slist.commatext,'<hr><pre>');
  //if d then  writeln(slist.commatext);
  for i:=0 to slist.count-1 do
  begin
    //if i=27 then writeln('2222222222222228888888:',slist[i]);
    // if i=27 then slist[i]:='28,     ,*e  ,--tt  ,*e  ,*e  ,*-te  ,*e  ,*e  ,*e  ,*-te  ,*e  ,*e  ,*e  ,      ,      ,-     ,-     ,      ,-     ,-     ,-     ,-     ,-     ,-     ,-';

     mlist.commatext:=slist[i];
     mlist.delete(0);
     mlist.delete(0);
     for j:=0 to scount do
     begin
        try
      lmmids[i][j]:=reversestring(mlist[j]);
      //WRITELN(' ',J,lmmids[i][j]);
      except writeln('???fail;',i,' ',j);end;
      //sijat[j].
      //protomids[i,j]:=trim(mlist[j]);
     end;
  end;
  IF D THEN writeln('<hr>LISTSIJAT:::');
  for i:=0 to scount do
  begin
    sijat[i].vv:=i in nvahvanvahvat;
    sijat[i].hv:=not (i in nheikonheikot);
    sijat[i].ending:=trim(nendings[i]);
    sijat[i].num:=i;
    //if d then
    //writeln('<li>sija:',i,' /',sijat[i].ending,' /v:',sijat[i].vv, '/h:',sijat[i].hv);
  end;
  writeln('<hr>LISTedSIJAT');
  writeln('<hr></pre>');
 // if d then for i:=990
 for i:=099 to  49 do
  begin
     write(i);
     for j:=0 to 33 do write(',*',copy(lmmids[i,j]+'              ',1,6));
     writeln;
  end;
  writeln('</pre></pre></pre><hr><hr><hr>');

end;
function red(st:string):string;
begin result:='<b style="color:red">'+st+'</b>';
end;
function blue(st:string):string;
begin result:='<b style="color:blue">'+st+'</b>';
end;

procedure tnominit.etsi(hakunen:thakunen;aresu:tstringlist;onjolist:tlist);
var sanasopi,sanajatko,avsopi,avjatko,sissopi,sisjatko,lkasopi,lkajatko,sikaloppu,sikasopi,xvok:string;
    curlka:tnomlka;cursis:tnomsis;curav:tnomav;cursan:tnsana;
    cutvok,cutav,hits,tries:integer;
    //cut_si,cut_av,cut_lka,cut_san,i,j:integer;
    tc,hakutc:integer;
     d,hakueitaka,hakueietu,heikkomuoto:boolean;
     siat,sikanum,lu:integer;sika:tsija;//sikaloppu:string;

//procedure checkhit(yht,sanax,hakux:string;sa:integer);
procedure checkhit(yht,sanax,hakux:string;sa:integer);
var thishit:thit;sana,color:string;
begin

  sana:=sanat[sa].san;
//     if hakueitaka then if sanat[sa].takavok then exit;
//     if hakueietu then if not sanat[sa].takavok then exit;
     if hakux=sanax then color:='green'
     else if hakux='' then color:='blue'
     else if sanax='' then color:='purple'
     else color:='red';
     if not sanat[sa].takavok then sana:=etu(sana);
    // if hakueitaka then todo:=etu(todo);
    //if d then
    writeln('<li style="color:',color,'">%',curlka.kot,'#',sika.num,'/<em>',
    sanat[sa].akon, reversestring(sikasopi+'.'+lkasopi+'/'+sissopi+'\'+avsopi+'|'+sana),'/</em>',sa,
     ' ',sanat[sa].akon,'<b>',reversestring(sanax+'/'+hakux+':'+yht),'</b> ');
   // writeln('<li style="color:',color,'">',sopi,'|',sanax,hakux);
  exit;
  thishit:=thit.Create;
  with thishit.sana do
  begin
    alku:=cursan.san;
    akon:=cursan.akon;
    v:=curav.v;
    h:=curav.h;
    sis:=cursis.sis;
    luokka:=curlka.kot;
    sloppu:=lmmids[luokka,0];
    takvok:=not hakueitaka;
    sananum:=sa;   if d then writeln('xxx:',alku,'.',akon,'.',v,h,'.',sis,'.',luokka);
  end;
  nhitlist.add(thishit);
end;

procedure fullhit(sana,haku:string;sa:integer);
var kokosana:string;
begin
  KOKOsana:=reversestring(''+lkasopi+'|'+sissopi+'|'+avsopi+'|'+sana+sanat[sa].akon)+sikasopi;
  if not (sanat[sa].takavok) then kokosana:=etu(kokosana);
  if sanat[sa].akon=hakunen.akon then
  begin
 writeln('==<b style="color:green" title="',inttostr(curlka.kot)+'#',inttostr(sika.num)+'##'+inttostr(sa),'">HIT:/',KOKOSANA ,'</b>',sa,'#',nsijnams[sikanum+1]);
 hits:=hits+1;
 end;
end;

procedure shorthit(sana,haku:string;sa:integer);
var epos:word;kokosana:string;
begin
 //write('<li>[',sana,'/',haku,']',kokosana,':');

  // if sana='' then write('<hr>empty:',sana);
  epos:=length(sana)+1;
  //kokosana:=sikasopi+'.'+lkasopi+'.'+sissopi+''+avsopi+''+sanat[sa].san+sanat[sa].akon;
  KOKOsana:=reversestring(''+lkasopi+''+sissopi+''+avsopi+''+sana+sanat[sa].akon)+sikasopi;
   if not (sanat[sa].takavok) then kokosana:=etu(kokosana);
  //avsopi+''+(sissopi)+''+lkasopi+''+sikasopi;
 haku:=copy(haku,epos-1);
 //writeln('<li>::::',kokosana,'  :  ',sana,'\',haku,'!',epos);
 //sana:=copy(sana,epos);
 //write('[',copy(hsana,'/',haku,']',epos);//,kokosana,'  . <b>',kokosana[1],'/',haku[1],'+</b>:',lkajatko+'+',lkasopi, ' ',sanat[sa].san);
 //writeln('long:',sanat[sa].akon,reversestring(sikasopi+'.'+lkasopi+'/'+sissopi+'\'+avsopi+'|'+sana)+' --',sana[epos],'\',sana,'\',kokohaku[1],sana,' ',haku);
 writeln('<li><b style="color:blue"  title="',inttostr(curlka.kot)+'#',inttostr(sika.num)+'##'+inttostr(sa),'">Shit:',
 string(kokosana),'/</b>');//,sa,haku);
 if (sana<>'') and ((pos(haku[1],vokaalit)>0) and (pos(haku[2],vokaalit)>0) and
  (isdifto(haku[2],haku[1]))) then
 //if pos(kokosana[2],vokaalit)<1 then
 else //writeln('NOGO:',haku[1],kokosana[1], isdifto(haku[1],kokosana[1]))
 writeln('<li><b style="color:blue"  title="',inttostr(curlka.kot)+'#',inttostr(sika.num)+'##'+inttostr(sa),'">Shit:',
 string(kokosana),'/</b>');//,sa,haku);
end;


procedure longhit(sana,haku:string;sa:integer);
var epos:word;kokohaku,kokosana:string;i,tc:integer;olivok:string[2];
begin

kokohaku:=haku+''+avsopi+''+reversestring(sissopi)+''+reversestring(lkasopi)+''+reversestring(sikasopi);
kokosana:=sikasopi+''+lkasopi+''+sissopi+''+avsopi+''+sanat[sa].san+sanat[sa].akon;
if not (sanat[sa].takavok) then kokosana:=etu(kokosana);
//if sa=376 then
 //writeln('<li>::::',kokohaku,':',sana,'\',haku,'!');
 epos:=length(haku)+1;
 haku:=copy(haku,epos);
 sana:=copy(sana,epos);
 //write('<span>[',reversestring(sana),'/',reversestring(haku),']',string(kokohaku),'  <b>',reversestring(kokosana),'</b>:');
 //writeln('long:',sanat[sa].akon,reversestring(sikasopi+'.'+lkasopi+'/'+sissopi+'\'+avsopi+'|'+sana)+' --',sana[epos],'\',sana,'\',kokohaku[1],sana,' ',haku);
 try               // [u/]usi uusi: [u/]usi       [uo/]husi kuohusi:
 if  (sana<>'') and ((pos(sana[1],vokaalit)>0) and (pos(kokohaku[1],vokaalit)>0) and (isdifto(sana[1],kokohaku[1]))
 and (pos(kokohaku[2],vokaalit)<1))
  then writeln('<!--NOGO:',kokohaku,'?',sana,'-->')
 else
 begin
     tc:=1;//pit�is olla tavurajalla, eli tavu on aloitettu.. ei ei: saa uurtaa   -> RUU   aie he > ia   kapusta  ja -> SUPA
     //if pos(kokohaku[1],vokaalit)>0 then olivok:=kokohaku[1] else
     olivok:=''; //
     for i:=1 to length(sana) do
     begin
       if pos(sana[i],vokaalit)<1 then //konsonantti
       begin
        if olivok<>'' then begin tc:=tc+1;olivok:='';end  //konsonanti vokaalin edell�
        else //kaksoiskonsonantti .. ei mit��n
       end
       else //vokaali
       begin
         if olivok<>'' then  if isdifto(olivok[1],sana[i]) then begin tc:=tc+1;olivok:='';end;
         //else
          olivok:=sana[i];

       end;
       //write(' ',sana[i],olivok,'%',tc);
     end;
     if not (sanat[sa].takavok) then kokosana:=etu(kokosana);
     if (tc mod 2)= 0 then
     writeln('<li><b style="color:#888"  title="',inttostr(curlka.kot)+'#',inttostr(sika.num)+'##'+inttostr(sa),'">',  reversestring(kokosana),'/</b>');//,sana,'%',tc,',');//,sa,haku);
     //writeln('<li style="color:purple">%',curlka.kot,'#',sika.num,'/<em><b>', reversestring(sikasopi+''+lkasopi+'/'+sissopi+''+avsopi+''+sanat[sa].san+sanat[sa].akon),'/</b></em>',sa,kokohaku[2]);
 end;
 except writeln('FAIL:',kokohaku,'!');end;
end;

function sana_f(san:integer;koita,passed:string):boolean;
var i,j:word;hakujatko,sana:string;yhtlen,slen,hlen:word;
begin
cursan:=sanat[san];sana:=cursan.san;
 if d then if sana=koita then writeln('/S:',red(koita),blue(reversestring(cursan.san+cursan.akon)),san,' ',xvok,
 cursan.takavok,'/eitaka:',hakueitaka,'/ei��:',hakueietu);
 if hakueietu then if not (cursan.takavok) then exit;
 if hakueitaka then if cursan.takavok then exit;  //pyynt� FALSE eitaka: TRUE  eiety FALSE
// if d=d then writeln('+:',hakueitaka,hakueietu,cursan.takavok);
result:=false;
if xvok<>'' then if length(sana)>0 then delete(sana,1,1);//sana[1]:=xvok[1];
if xvok<>'' then writeln(' [**',xvok,'/',sana,']');
//if sana=koita then //if cursan.akon=hakunen.akon then
if sana=koita then fullhit(sana,koita,san)
;//else if (sana='') or (pos(sana,koita)=1) then shorthit(sana,koita,san)
//else if (koita='') or (pos(koita,sana)=1) then longhit(sana,koita,san)
//else if cursan.san='' then}
//writeln('<span  style="color:white">%',curlka.kot,'#',sika.num,'/<em><b style="color:blue">',
//reversestring(sikasopi+''+lkasopi+''+sissopi+''+avsopi+''+sanat[san].san+sanat[san].akon),'/</b></em>',san,'</span>');//,kokohaku[2]);

end;

function av_f(av:integer;koita,passed:string):boolean;
var san,i,j:integer;myav:string;
begin
  curav:=avs[av];
  result:=false;;
  myav:=ifs(heikkomuoto,curav.h,curav.v);
  if d then writeln('<li>{',myav,'}',red(koita+'-'+xvok),blue(myav),' :',curav.v,curav.h);
  if cutav>0 then if myav<>'' then begin myav:='';end;
  if d then writeln('(',myav,'/',curav.v+'/',curav.h,'\',cutav,')');
  if koita='' then begin result:=true;avsopi:=myav;avjatko:=koita;if d then writeln('<li>AVX:',red(koita+xvok),blue(myav)) end else
  begin
    if (myav='') or (pos(myav,koita)=1)  then result:=true
    else  begin  if pos(myav,koita)=1 then if d then writeln('<li>AVLOPPU:',koita,myav);  exit;
          end;
    avjatko:=copy(koita,length(myav)+1,99);//xvok;
    avsopi:=copy(koita,1,length(myav));//xvok;
  end;
  //avsopi:=myav;

    if d then writeln(av,'/AV:',red(avjatko+xvok),blue(avsopi),curav.ekasana,'..',curav.vikasana);
    try
    //if d then  for san:=curav.ekasana to min(curav.vikasana,curav.ekasana+50) do write('/',sanat[san].san);
    for san:=curav.ekasana to curav.vikasana do //!!!
          sana_f(san,avjatko,passed);
  except writeln('faILAV!!!');end;
end;
function sis_f(sis:integer;koita,passed:string;dbl:boolean):boolean;
var av,i,j:integer;mysis,mysika,tupvok:string;
begin
  cursis:=siss[sis];
  mysis:=cursis.sis; ;
  if dbl then MYSIS:=MYSIS[1]+MYSIS;
  if sika.num=5 then
    begin
       try           write('**********',mysis,dbl);
        if pos(mysis[1],konsonantit)>0 then
          begin mysis:=mysis[2]+mysis[1]+mysis[2];end
         else begin mysis:=mysis[1]+mysis;end;
        //if pos(tupvok,koita)<1 then
           //  mysis:=tupvok+mysis;
          //delete(sikasopi,1,1);
          //mysika:='n';
    if d then        writeln(':',red(koita),'/',blue(mysis),'|',sikasopi,'+',mysis,'_',tupvok,pos(tupvok,koita));
        //if (length(koita)>1) and (length(mysis)>1) then if (mysis[1]<>tupvok) or (1=0) then  ;//exit ;
        //writeln(':',red(koita),'/',blue(mysis),'|',sikasopi,'+',mysis,'_',tupvok);
        //if mysis<>'' then sikasopi[1]:=tupvok[1];
        except    writeln('!!?!',red(koita),'/',blue(mysis),'|',sikasopi,'+',mysis+'|');
end;// else mysika:=sikasopi;
        //:levi/le|en ==
    end;// else;end;;
  if d then
  writeln('<li>sisu:',red(koita),'/',blue(mysis),cutvok,xvok,'!<b>','</b>',sikasopi,'!');

  if koita='' then BEGIN sisjatko:=koita+mysis; sissopi:='';END
  ELSE
  begin
    //while (cut>0) and (mysis<>'') {and(koita<>'')} do
    if cutvok=1 then  begin if d then write('?/',koita,cutvok);delete(mysis,1,1);delete(koita,1,0);END;
    if cutvok=2 then  begin mysis:=mysis[1];END;

    result:=false;;
    if d then writeln('<li>Sisu:',red(koita),'/',blue(mysis+'!'),cutvok,cutav,xvok);
    if (mysis='') or (pos(mysis,koita)=1) then result:=true
    else  begin  if pos(koita,mysis)=1 then if d then writeln('<li>EOW:',curlka.kot,'/',red(koita),'|',blue(mysis));  exit;
    end;
    sisjatko:=copy(koita,length(mysis)+1,99);
    sissopi:=copy(koita,1,length(mysis));
    //sissopi:=mysis;
  END;
   if  d then   write('<b>/',sisjatko,'|',sissopi,'\</b>');
    if d then for av:=cursis.ekaav to cursis.vikaav do write('[',avs[av].v,'.',avs[av].h,']');
    if d then writeln('<ul>');
    tries:=tries+1;
  for av:=cursis.ekaav to cursis.vikaav do
   av_f(av,sisjatko,passed);
    if d then writeln('</ul>');

end;
function lka_f(lka,sija:integer;koita,passed:string):boolean;
  var sisus,i,j,para:integer;luokka:word;mid:string;dbl:boolean;
begin
  curlka:=luoks[lka-1];
  //if curlka.kot<>62 then exit;
  dbl:=false;
  if curlka.vahva then para:=sijat[sija].vparad else para:=sijat[sija].hparad ;
  mid:=lmmids[lka-1,sija];
  //!!if (lu=71) then if ((sijat[sija].hparad=2) and  (sija>10)) then begin IF D THEN writeln('!!!???');mid:='ek-' end else if  (sija in [23,28]) then begin IF D THEN writeln('!!!');mid:='k-'; end;
  //aint it pretty?

  result:=false;
  cutav:=0;cutvok:=0;xvok:='';
  if mid='*' then begin mid:='';dbl:=true;end;
  //if pos('_',lust)>0 then if pos('__',lust)>0 then cut:=2 else cut:=1;
  //if pos('_',mid)>0 then if pos(koita[1],vokaalit)>0 then
  // begin xvok:=koita[1];mid:='';writeln('xxxxxxxxxxxxxx',xvok,lka+51,curlka.esim);end;//if pos(,koita)begin
  while (mid<>'') and (mid[length(mid)]='_') do begin if d then write('?',mid);cutvok:=cutvok+1;delete(mid,length(mid),1);end;
  //v�livokaaleissa pihistell��n
  while (length(mid)>0) and (length(koita)>0) and (mid[length(mid)]='-') do
   begin cutav:=cutav+1;delete(mid,length(mid),1);delete(koita,1,0);; end;
   //av-konsonanttia ei vaadita kun on joku vakkari (s) tilalla
  if d then writeln('<li>lka:',lka,curlka.esim,' #',sija,'/',ifs(curlka.vahva,'vahva','heikko'),':',para,red(koita),' / ', blue(mid),':',cutvok,cutav);//,curlka.ekasis,'-',curlka.vikasis,'::');
  //write('<b>');
  if d then for sisus:=curlka.ekasis to curlka.vikasis do writeln('((',siss[sisus].sis,'))');
  //write('</b>');
  if (mid='') or (koita='') OR (pos(mid,koita)=1) then result:=true
  else
  begin
       //62naida a / -12-12:: /ei:a-
     if pos(koita,mid)=1 then if d then writeln('//EOW:',koita,mid);   if d then write('/ei:',blue(koita),red(mid),lmmids[lka-1,sija]); exit;
  end;
  //if pos(koita,mid)=1 then writeln('//EOW:',koita,mid);
  lkajatko:=copy(koita,length(mid)+1,99);
  lkasopi:=copy(koita,1,length(mid));
  //lkasopi:=mid;
  heikkomuoto:=false;
  if curlka.vahva then begin if  not( sija in nvahvanvahvat) then heikkomuoto:=true;end
  else  if  sija in nheikonheikot then heikkomuoto:=true;
  //heikkomuoto:=true;!!!
  if d then   writeln('<li>LK:',curlka.kot,(lkajatko),' / ', blue(lkasopi), curlka.ekasis,'-',curlka.vikasis,koita,'(',mid,')',heikkomuoto,curlka.ekasis,' to ',curlka.vikasis,'</li>');
  if d then   writeln('<ul>');
  for sisus:=curlka.ekasis to curlka.vikasis do
   sis_f(sisus,lkajatko,passed,dbl);
  if d then writeln('</ul>');

end;
var sikalauma:tstringlist;passed:string;
begin
try
///writeln('ykshaku');
nhitlist.clear;
d:=false;
//d:=true;
   sikalauma:=tstringlist.create;
     try
     sikalauma.clear;
     haesijat(hakunen.loppu,sikalauma);  //sijamuodot joiden p��te m�ts�� hakusanaan
    // writeln('<li>hakisijat:',sikalauma.text);   exit;
     if d then
       for siat:=0 to sikalauma.count-1 do writeln('<li>--',sikalauma[siat],ptrint(sikalauma.objects[siat]),sijat[ptrint(sikalauma.objects[siat])].ending);
     if d then   writeln('<li>uoto:',hakunen.akon,'|<b>',reversestring(hakunen.koko),'</b>:',sikalauma.count,'<ul></li>');
     except writeln('faildosiat');end;
     hits:=0;tries:=0;
     for siat:=0 to sikalauma.count-1 do
     begin   //SIJAMUOTO
        sikanum:=ptrint(sikalauma.objects[siat]);
        if sikanum<>5 then begin continue; end;
        //if sikanum in [13] then continue;
        //if sikanum<>0 then continue;
        sika:=sijat[sikanum];
        sikaloppu:=sikalauma[siat];
        if sikaloppu='' then begin writeln('aaaaaaaaaa');continue;passed:=copy(sika.ending,1,length(hakunen.loppu));
        sikasopi:=copy(sika.ending,length(hakunen.loppu),999);writeln('<li>HAKLO:',passed,'/',hakunen.loppu,'/',sikasopi);end
        ;//else continue;
        sikasopi:=sika.ending;//(sikaloppu,length(sikaloppu)-length(sika.ending)+1);
        hakutc:=tavucount(hakunen.koko);
        if d then writeln('<li>HAKU::',reversestring(sikaloppu),'#',sika.num,'><b>/',nsijesims[sika.num+1],' ',nsijnams[sika.num+1],'\</b> ',sikaloppu,'/:',hakueitaka,'/e�',hakueietu);
        //if d then
        //writeln('<li>muoto:',reversestring(sikaloppu),'|',reversestring(sikasopi),' //<b>',reversestring(sika.ending),'#</b>',sika.num,'! ',hakunen.koko,hakutc);
        hakutc:=hakutc mod 2;
        hakueitaka:=hakunen.eitaka;
        hakueietu:=hakunen.eietu;
        if d then writeln('<ul>');
        for lu:=1 to 49 do
          lka_f(lu,sikanum,sikaloppu,passed);
        if d then writeln('</ul>');
        //writeln('<li>hakunenloppu');
      end;
    if d=d then if hits<1 then //if hakunen.koko[length(hakunen.koko)]='n'
    //then if hakunen.koko[length(hakunen.koko)-1]=hakunen.koko[length(hakunen.koko)-2]then
    if tries<99990 then   writeln('<li>HAKU::',(hakunen.koko),'#',sika.num,'><b>/',nsijesims[sika.num+1],' ',nsijnams[sika.num+1],'\</b> ',sikaloppu,'/:',hakueitaka,'/e�',hakueietu);
     if d then writeln('</ul>');

except writeln('<li>failetsi');end;
//writeln('<li>hakusetloppu');
end; //etsi

//procedure tnominit.etsi(hakunen:tvhaku;aresu:tstringlist;onjolist:tlist);
procedure tnominit.etsiold(hakunen:thakunen;aresu:tstringlist;onjolist:tlist);
var lukn,sijax,prlim,x,lk,si:integer;
  {$H-}
  //((lk,sis,av,san,sija:integer;
  //hakunen:tvhaku;
 //hakunen:thakunen;
  //haku,hakukonst,
    mysis,myav,mysana,mysija,lopvok:string;
  did_sija,todo_lka,did_lka,todo_sis,did_sis,todo_av,did_av,todo_sana,did_sana:str16;
  cut_sija,cut_lka,cut_sis,cut_av,cut_san:word;
  xkon,d:boolean;
   sikalauma, riimit,xxresu:tstringlist;
   tc,hakutc:word;
   ahit:tkokosana;

function red(st:string):string;
   begin result:='<b style="color:red">'+st+'</b>';
   end;
function blue(st:string):string;
   begin result:='<b style="color:blue">'+st+'</b>';
   end;

function muotosopii(koko,pala:str16):boolean;
  //var todost:string;
  begin
   try
   result:=false;   todo_lka:='';did_lka:='';  cut_lka:=0;  xkon:=false;
   if pos('*',pala)>0 then //if pos(koko[length(pala)],konsonantit)>0 then
   begin     //tuplakonsonantti tulossa sanan alussa luokan m��reiden mukaan, viel� ei tiedet� mik�, pannaan muistiin ett� osataan tsekata seuraavassa vaiheessa
       //pala[length(pala)]:='-';////by���.. pit�sk� muuttaa merkint�jen j�rjestyst�..? ;
       delete(pala,length(pala),1);
       xkon:=true;
       //write('M:',pala,cut,xkon);
    end;
   while (pala<>'') and (pala[length(pala)]='-') do
   begin
     if lukn=19 then begin  //suo -> soita  -a=soit ??->s
      cut_lka:=2;
      //writeln('<li>oioi',lukn,'/',pala,'\',koko);
      //did_lka:=pala[1];todo_lka:=
      delete(pala,length(pala),1);
      break;
     end;
     //write('%',pala,cut,'>');
     cut_lka:=cut_lka+1;    delete(pala,length(pala),1);
      //write('<li>cut:',pala,cut,koko,'%');
   end; //*e--
   if (pala<>'') and  (pala[length(pala)]='_') then
   begin
     if d then write('<b>(',pala,'>',cut_lka,koko,'=');
     if koko[length(pala)]=koko[length(pala)+1] then pala[length(pala)]:=koko[length(pala)];
    //pala[1]:=koko[2];
      if d then write(pala,'</b>)');
   end; //*e--
   if koko='' then  begin result:=true;did_lka:=pala;end //riimi oli jo l�ydetty pelk�st� p��tteest� (konsanansa/ansa yms). Pit�is ehk� tallettaa tuloslistaan. Voi tulla aika p�tk�
   else
    if (pala='') or (pos(pala,koko)=1) then
     begin
      result:=true;
      //todost:='';
      todo_lka:=copy(koko,length(pala)+1,16);
      //todo:=copy(koko,2);
      //length(pala)+1);
      did_lka:=trim(pala);
     end;
   except writeln('<li>failmuoto:',koko,'/',pala);end;
  end;

function sopii(koko,pala:str16;var todo,done:str16;var cut:word):boolean;
  begin
   try
   //loppu reversoitu, mik� ei kai hyv� ...
   // done = pala joka todetaan sopivaksi ja poistetaan hausta , todo= j�ljelle j��v� (sanan alku, kun reversoitu).
  //if luk=28 then
   //write('[=',koko,'//',pala,cut,'=]');
   result:=false;   todo:='';
   //[nnak//*1= \\nnak\nnak\\0]TRUE
   WHILE (pala<>'') AND (cut>0) do BEGIN delete(koko,1,0);delete(pala,1,1);cut:=cut-1;//write('\\',koko,'\',pala,'!');
   END;
   if koko='' then
   begin  //PIR�IS PANNA TULOKSENA TALTEEN
    todo:='';
    done:=pala;
    result:=TRUE;//
    //RESULT:=false;
   end else
   if (pala='') or (pos(pala,koko)=1) OR (pala='*') then
   begin
    try
    result:=true;
    todo:=copy(koko,length(trim(pala))+1,16);
    done:=pala;
    except writeln('failillat');end;
   end;
   //if luk=28 then
   //writeln('\',koko,'\',pala,'>',todo,'>',done,cut,']',result);
   except writeln('<li>failsovitus:',koko,'/',pala);end;
  end;


function ykssana(todo,done:str16;san:word):boolean;
var target:str16;i,j,ml:word;newhit:tkokosana; thishit:thit;
begin
  RESULT:=false;
  if  onjolist<>nil then if onjolist.indexof(pointer(san))>=0 then exit;
  //saman sanan eri muotoja ei tutkita. ongelma: verbit ja nominit p��llekk�isiss� lukualueiessa ja samassa onjo-listassa
 // if sanat[san].takavok then if hakunen.eitaka then exit;  //verta merta veress� meresss� .. VOIPIKAA VOIVITTU!
 // if not sanat[san].takavok then if hakunen.eietu then exit;  //verta merta veress� meresss� .. VOIPIKAA VOIVITTU!
  target:=sanat[san].san;
  //if sanat[san].takavok=false then target:=etu(target);
  //if hakunen.eitaka then todo:=etu(todo);
  if d then writeln('<li>:',red(todo),' ',blue(target),sanat[san].takavok,hakunen.eitaka,hakunen.eietu);
  //if myav='' then if todo_san<>'' then if pos(todo_san,vokaalit)>0 then begin  writeln('<b>(((',todo_san,'))</b>');continue; end;
  //if xkon then if
  cut_san:=cut_av;
  while (cut_san>0) and (target<>'') do begin delete(target,1,1);cut_san:=cut_san-1;end;
  if target=todo then begin end else
  if length(target)>=length(todo) then //haettava on lyhyempi ... kaikkien pit�� m�ts�t�, paitsi haettavan viimeisten konsonanttien (sanan alkukons)
  begin                  // target: tr-aan  h-alutaan  todo: saan
    //if d=d then writeln('[',target,'/',todo,'/',sanat[san].san,'+',pos(target[length(todo)+1],vokaalit)>0,']');
    for i:=1 to length(todo) do
    begin
      if target[i]<>todo[i] then
      begin  //!aa/ap! \*ap
        //for j:=i to length(todo) do
        //if (pos(target[length(todo)+1],vokaalit)>0) //or (pos(target[j],vokaalit)>0) then
        //writeln('[-',target,'/',todo,']');
         exit;// else writeln('+',todo[i]);
      end;
    end;
    if (pos(target[length(todo)+1],vokaalit)>0) or (pos(target[j],vokaalit)>0) then
     begin
     if d then writeln('<li>NO::\*',target,'/',todo,'+',sanat[san].akon);
      exit;// else writeln('+',todo[i]);

     end;
     if pos(target[length(todo)+1],vokaalit)>0 then
     //if  pos(todo[length(todo)],vokaalit)>0 then
      if not isdifto(target[length(todo)],target[length(todo)+1]) then
       begin writeln('ZZ:',hakunen.koko,'/',sanat[san].akon,
         reversestring(did_lka+did_sis+did_av+target)+did_sija,'/',target[length(todo)+1],target[length(todo)],san,'/',lk+1,'#',si,' ');
      exit;end;
    //diftongit?
  end else //haettava pidempi - kaikkien m�ts�tt�v� (sana.san ei sis�ll� alkukonsonanttia)     amme saamme
  begin
    for i:=1 to length(target) do // todo: traan  halutaan  target: s-aan
    if target[i]<>todo[i] then
      exit;
 //   writeln('<b>///',todo,'|',target,sanat[san].akon,'\\\</b>');
    if pos(todo[length(target)+1],vokaalit)>0 then
     begin //writeln('QZ:',hakunen.koko,'/',sanat[san].akon,reversestring(did_lka+did_sis+did_av+target)+did_sija,san,' ');
     exit;end;
  end;
  target:=reversestring(did_lka+did_sis+did_av+target)+did_sija;
  //if hakunen.eitaka then if (pos('a',target)>0) or (pos('o',target)>0) or (pos('u',target)>0)

  tc:=tavucount(reversestring(target));
  //writeln('_',target,'_',tc,tc mod 2<>hakutc mod 2,hakutc );
  //if pos('*',target)>1 then target[pos('*',target)]:=target[pos('*',target)-1];
  if tc mod 2<>hakutc mod 2 then exit;
  target:=sanat[san].akon+target;
  if d then writeln('<li>X:',red(todo),length(todo),blue(target),length(target));
  if hakunen.eietu<>sanat[san].takavok then // vaikka haku ja sana eri astevaihtelua, niin testatussa muodossa ehk�
     for i:=0 to length(target) do if pos(target[i],'aou')>0 then begin writeln('avmix');exit;end;
  if not sanat[san].takavok then target:=etu(target);
  //aresu.add(target);
  if onjolist<>nil then onjolist.add(pointer(san));
  if d then
  writeln('<li>hit:=',copy(target,1,length(target)-length(hakunen.loppu)-1),'<b>',copy(target,length(target)-length(hakunen.loppu),15) ,'</b>//san:',sanat[san].san, '/todo:',todo,'/',san,'//',hakunen.akon,reversestring(hakunen.loppu),' ',hakunen.koko,'</li>');//,'</ul>');
  //if pos(sanat[san].akon,todo)=1 then
  //if sanat[san].akon=hakunen.akon then
  //if hakukonst+reversestring(haku)=target then
  if target=(hakunen.koko) then
  begin
    if d then  writeln('<li>exact:',todo,'/',sanat[san].san,san,'</li>');
    thishit:=thit.Create;
    with thishit.sana do
    begin
      sananum:=san;
      alku:=sanat[san].san;
      akon:=sanat[san].akon;
      v:=ahit.v;
      h:=ahit.h;
      sis:=ahit.sis;
      luokka:=ahit.luokka;
      sloppu:=lmmids[luokka,0];
      takvok:=sanat[san].takavok;
      writeln('xxx:',alku,'.',akon,'.',v,h,'.',sis,'.',luokka);
      //xxx:kki.p..iu.37 !kki
    end;
    nhitlist.add(thishit);
  end
  else   aresu.add(target);

  //writeln(' +',target);
end;

function yksav(todo,done:str16;av:word;vahvako:boolean):boolean;
 //var newtodo,newdone:str16;
var san:word;
 begin
  {$H-}
  //writeln('<li>?av:',red(todo),blue(done),cut_sis,xkon, '/');
  myav:=ifs(vahvako,avs[av].v,avs[av].h);
  ahit.h:=avs[av].h;
  ahit.v:=avs[av].v;
  cut_av:=cut_sis;
  //if xkon then myav:=done[1];
  //writeln('<li>av???',myav,':',red(todo),blue(done),xkon,cut_sis, '/');
  if xkon then
  begin  //fuckin mess!
   todo_av:=copy(todo,2,length(todo)-1);did_av:=todo[1];if cut_av>0 then cut_av:=cut_av-1;
   //writeln('<li>new:',red(todo_av),blue(did_av), '/');
    if did_av<>todo_av[1] then exit;
  end else//huom ei toimi generoinnissa kun ei viel�, eik� tarkista kunnolla
 if not sopii(todo,myav,todo_av,did_av,cut_av) then exit;
 if d then writeln('<li>AV<b>[',myAV,'</b> ',avs[av].v,avs[av].h,']',red('+'+todo_av),blue(done+'|'+did_av),'/cut:',cut_av,'[',myav,']/',avs[av].v,'/',avs[av].h,'<ul><li>');
  // write('<li>AV: :',avs[av].v,avs[av].h,' ',done,blue(newdone) ,'',red(newtodo),cut);//,': ',siss[sis].ekaav,'..', siss[sis].vikaav,'/cut:',cut,xkon);
  //if d then for san:=avs[av].ekasana to min(avs[av].ekasana+150, avs[av].vikasana)   do writeln('?',sanat[SaN].SAN,sanat[SaN].akon);
  for san:=avs[av].ekasana to avs[av].vikasana   do
 //for san:=avs[av].ekasana to min(avs[av].ekasana+3,avs[av].vikasana)   do
 YKSSANA(todo_av,did_av,san);
 if d then writeln('++++</ul>');
end;


procedure ykssisus(todo,done:str16;sis:word;vahvako:boolean);
var //newtodo,newdone,
  mysis:str16;
  av:word;
 begin
   try
   mysis:=siss[sis].sis;
   ahit.sis:=mysis;
   cut_sis:=cut_lka;
   if d then writeln('<li>??sis:','[',mysis,']',cut_sis,xkon,lopvok,red(todo));

    //if d then    writeln('?','[',mysis,']');
    if (lukn=19) and (cut_sis>0) then begin  //suo -> soita  -a=soit ??->s
      //writeln('<li>oioi:',todo,'/',mysis);
      if mysis[1]<>todo[1] then exit;
      todo_sis:=copy(todo,2,1);did_sis:=mysis[1];
      cut_sis:=0;
      //done:=pala[1];todo:=
      //break;
     end else
      if not sopii(todo,mysis,todo_sis,did_sis,cut_sis) then exit;
      if d then writeln('<li>SIS:','[',mysis,']',red(todo_sis) ,' -> ',blue(did_sis+'.'+did_lka+did_sija),' /','/cut:',cut_sis,'/X:',xkon,lopvok);
//????      if lopvok<>'' then if newdone<>'' then //if pos(mysis,vokaalit)=1 then
      //begin if d then writeln('<li>CHECKVOK:',lopvok,'=',newdone,lopvok=newdone[length(newdone)],cut);if lopvok<>newdone[length(newdone)] then exit;end;
     // begin if d then writeln('<li>CHECKVOK:',lopvok,'=',newdone,lopvok=newdone[length(newdone)],cut);if lopvok<>newdone[length(newdone)] then exit;end;
      //if pos('*',  [sis].sis
      //if d then writeln('<li>+++:',newtodo,'!');
      if d then write('<li>S:',lukn,done,blue(did_sis) ,'',red(todo_sis));//,': ',siss[sis].ekaav,'..', siss[sis].vikaav,'/cut:',cut,xkon);
      //if d then if xkon then writeln('XKON:', cut,'/','/',todo_lu[1],'!');//begin writeln('<li>latefail::',siss[sisus].sis[1],'!=',a_lu[1]);continue; end;
      if d then for av:=siss[sis].ekaav to siss[sis].vikaav  do write('///a:',avs[av].v,avs[av].h,'/',ifs(vahvako,avs[av].v,avs[av].h));
      if d then   writeln('<ul>');
      for av:=siss[sis].ekaav to siss[sis].vikaav  do
      begin   // if avs[av].v=avs[av].h then if prlim>2 then if lk<>38 then continue;
         yksav(todo_sis,did_sis,av, vahvako);
      end; // writeln('</pre></ul>');
      if d then   writeln('</ul>');
      except writeln('failsisus');end;
    end;

procedure yksluokka(todo,sijalop:string;lk:word;sika:tsija);
  var sis,av,sanx:integer;
    //done_lu,todo_lu,done_sis,todo_sis,done_av,todo_av,done_san,todo_san,ressan,mysijalop:string;
    //newtodo,newdone:str16;
    //cutsi,cutav,cutw:word;
    vahvako:boolean;
  begin
  //writeln('(',(sijalop),'|',todo,'+',lk,')');
   try
     ahit.luokka:=lk;
       lukn:=lk+1;//lopvok:='';
       try
       if not  muotosopii(todo,lmmids[lk,sika.num]) then
       begin
         if d then writeln('<li>--',lk+1,'/todo:',todo,'/mid:',lmmids[lk,sika.num],'/j��:',todo_lka,'\sopi:',did_lka,cut_lka);
         exit;
       end;
       except writeln('fail lkafix');raise;end;
       if luoks[lk].vahva then begin if sika.vv then vahvako:=true else vahvako:=false;end
       else begin if sika.hv then vahvako:=true else vahvako:=false;end;
       if d then writeln('<li>luk:',lk+1,todo,'>','#',sika.num,'<b>[',lmmids[lk,sika.num],']</b>:',blue(did_lka+'|'),red(todo_lka),'<b>:','_(',sijalop,')</b>_',todo,luoks[lk].vahva,vahvako,lmmids[lk,sika.num],'!!',cut_lka);//,'<ul>');
       //if sijalop<>'' then if sijalop[length(sijalop)]='*' then if newtodo<>'' then
       if sijalop<>'' then if sijalop[length(sijalop)]='*' then if todo_lka<>'' then
       begin
         if d then writeln(red(lopvok+'!='+did_lka),'/',sijalop);
         if pos(did_lka[1],vokaalit)>0 then if lopvok[1]<>did_lka[1] then exit;
         sijalop[length(sijalop)]:=lopvok[1];//newtodo[1];// else writeln('tyhj��:',sijalop,'/',todo_lu,sika.num,'+');
         lopvok:='';
       end;
       //if xkon then writeln('ddddd:', done_lu[1],'/',todo_lu[1],cut);//begin writeln('<li>latefail::',siss[sisus].sis[1],'!=',a_lu[1]);continue; end;
    //                   if d then writeln('/cut:',cut,'/:',luoks[lk].ekasis,'...',luoks[lk].vikasis,' ',luoks[lk].kot,'</b>:');//,'<ul>');
      //                 if d then for sis:=luoks[lk].ekasis to luoks[lk].vikasis  do write('/',siss[sis].sis,'/ ');
        //
       if d then    write('<ul>');
       //if newdone<>'' then
       //if d then
      if d then  writeln('<li> ',lk+1,' ',sijalop,'<b>',blue(did_lka+'|'),'</b>',red(todo_lka),luoks[lk].vahva,vahvako,cut_lka);
       for sis:=luoks[lk].ekasis to luoks[lk].vikasis  do
       YKSsisus(TODO_lka,sijalop,sis,VAHVAKO);
       if d then  writeln('</ul>');
   except writeln('faillka');end;
  end;

var sikanum,ha,hit:integer;takako:boolean;sika:tsija;  //lk, si globaaleiksi - voi sotkea jotain
begin
  //writeln(hakunen.koko+'=');
   d:=true;
   d:=false;
   nhitlist.clear;
   sikalauma:=tstringlist.create;
     //haku:=reversestring(hakusana);
     sikalauma.clear;
     //hakukonst:='';
     //while pos(haku[length(haku)],konsonantit)>0 do begin hakukonst:=haku[length(haku)]+hakukonst;delete(haku,length(haku),1); end;
     haesijat(hakunen.loppu,sikalauma);  //sijamuodot joiden p��te m�ts�� hakusanaan
     //for siat:=0 to sikalauma.count-1 do      writeln('|',sikalauma[siat]);
     if d then writeln('<h4>hae:',hakunen.koko,sikalauma.count,hakunen.loppu,'</h4>');
     hakutc:=tavucount(hakunen.koko);

     if d then writeln('<hr><ul>');
     for si:=0 to sikalauma.count-1 do
     begin   //SIJAMUOTO
       sikanum:=ptrint(sikalauma.objects[si]);

       //if sikanum<29 then continue;
       lopvok:='';
       //if sikanum<>5 then continue;
       if sikanum=5 then lopvok:=hakunen.loppu[2];  //!! OUUUUUUUUUUTTCCHHH
       //if length(sikalauma[siat])<1 then continue;  /// temppu :-(
       sika:=sijat[sikanum];
       //l_sija:=sikalauma[siat];
       if d then writeln('<h3>haku:',reversestring(hakunen.loppu),sikanum,' ',sikalauma[si],'///',sijat[sikanum].ending,sijat[sikanum].num,sikanum,']</h3>');
        //try
        luoks[0].ekasis:=0;
        did_sija:=sijat[sikanum].ending;
        //write('?',sika.ending,sika.num);
        //if d then
        //writeln('<li><b>',haku,'+</b>',sika.num,sijat[sikanum].ending,'<ul>');
        if d then for lk:=0 to 47 do writeln(lk+1,lmmids[lk,sikanum],'/');
        for lk:=0 to 48 do //clka do
        begin
         try
           if d then writeln('<li>LK_:',lk+1,'#',sikanum,' ###',red(sikalauma[si]),'/',(sijat[sikanum].ending),lk,'#',sijat[sikanum].num);
            yksluokka(sikalauma[si],reversestring(sijat[sikanum].ending),lk,sijat[sikanum]);
            except writeln('<li>FAILRUN');end;
         end;
        if d then writeln('</ul>');
     end;
     //writeln('<li>HAKU:',hakunen.koko+'/',hakunen.akon+reversestring(hakunen.loppu));//,': ',resu.commatext);
     if d then writeln('</ul>');
   //end;
end;


{taivutus edellytt�� ett� on kaivettu sanan perusmuoto, taivutusluokka ja astevaihtelu. Sen voi tehd� k�sin, tai etsi-funktiolla
(jolle tarvitaan parametri jo kertoo ett� halutaan tarkka haku, ei riimihakua. Tai ottamalla inputiksi perusmuoto, genetiivi ja partitiivi)
tehd��n alkuun taivutus tunnetusta muodosta.
}

procedure tnominit.generate(runko,sis,astva:str16;luokka:integer;aresu:tstringlist;hakutakvok:boolean);
var lukn,sijax,prlim,x:integer;
si,sikanum,ha:integer;sika:tsija;
 d,vahvaluokka,vahvasija:boolean;         sofar:string;
  {$H-}
  //((lk,sis,av,san,sija:integer;
   mymid,mysis,myav,mysana,mysija,lopvok,myend:str16;
   sikalauma, riimit,xxresu:tstringlist;
   function red(st:string):string;
   begin result:='<b style="color:red">'+st+'</b>';
   end;
   function blue(st:string):string;
   begin result:='<b style="color:blue">'+st+'</b>';
   end;

begin
   d:=true;
   d:=false;
    writeln('</ul>');
    writeln('<li>G:',luokka);
    //for si:=0 to scount-1 do writeln('/',lmmids[luokka,si]);
    vahvaluokka:=luokka+1<32;
    for si:=0 to scount do
    begin
      mymid:=lmmids[luokka,si];
      if pos('?',mymid)>0 then continue;
      myend:=nendings[si];
      sofar:=runko;
      sika:=sijat[si];
      if vahvaluokka then vahvasija:=si in nvahvanvahvat
      else vahvasija:=not (si in nheikonheikot);
      if astva='' then myav:='' else
      if vahvasija then  myav:=astva[1] else
      if length(astva)>1 then myav:=astva[2] else myav:='';
      sofar:=sofar+myav+sis;
      //if lka+1=19 then begin if (mymid[length(mymid)]='-') then end else
      while (mymid<>'') and (mymid[length(mymid)]='-') do
        // begin end else
        begin delete(mymid,length(mymid),1);if luokka+1=19 then delete(sofar,length(sofar)-1,1) else delete(sofar,length(sofar),1);end;
      if pos('!',mymid)=1 then continue;
      if pos('_',mymid)=1 then mymid:=sofar[length(sofar)];
      sofar:=sofar+reversestring(mymid);
      if pos('*',myend)=1 then if pos(sofar[length(sofar)],vokaalit)>0 then myend[1]:=sofar[length(sofar)] else myend[1]:=sofar[length(sofar)-1];//writeln('<li>tupla:',runko+'_'+myend);end;

      sofar:=sofar+myend;
      if not hakutakvok then sofar:=etu(sofar);
      writeln('<li>gene:',luokka+1,'#',si,':',sofar,'/',lmmids[luokka,si],'[',myav,'|',astva,vahvasija,vahvaluokka,']</li>');
      aresu.add(sofar);
       //if not hakutakvok then sofar:=etu(sofar);

     end;
     writeln('</ul>');
   //end;
end;

{s�vyyn
rynkkyyn
kykyyn
h�per��n
keittim��n}

{procedure tnominit.luemuodot(muotofile:string);
var ms,mline:tstringlist;i,j,k:word;
begin
 ms:=tstringlist.create;
 mline:=tstringlist.create;
 try
  ms.loadfromfile(muotofile);
  taivluokkia:=ms.count;
  for i:=0 to ms.count-1 do
  begin
   mline.commatext:=ms[i];
   try
   mline.delete(0);
   for j:=0 to mline.count-1 do
    lmmids[i][j]:=mline[j];
     //for k:=1 to min(8,length(mline[j])) do
     //lmmids[i][j][k]:=mline[j][k];
   except writeln('<li>faillka:',j,mline.commatext);end;
  end;
   finally ms.free;mline.free;end;
 end;
 }

end.

