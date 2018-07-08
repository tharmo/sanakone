unit taivubits;

{ mode delphi}{$H+}

interface
uses
  Classes, SysUtils,strutils,math;
function testbits:boolean;
procedure listaatavut;
procedure luetavut;
var  mulls1,mulls2,hyps,alko,kons1,kons2,voks,xxtavus:tstringlist;masat:tstringarray;
  function hyphenfi(w:ansistring;tavus:tstringlist):ansistring;
  const yhtloput:array[0..11] of ansistring =('','a', 'n', '', 'a', 'ut', 'i', 'tu', 'en', 'isi', 'kaa', 'kaskunemme');
  //const yhtlopsall:array[1..75] of ansistring =('a','n','t','','mme','tte','vat','','a','aan','ut','imme','itte','ivat','in','it','i','tu','tiin','aksemme','aksenne','akseni','aksesi','aksensa','taman','essa','en','taessa','matta','malla','masta','maan','massa','man','matta','malla','mista','masta','man','maan','massa','ma','ut','ut','tu','vat','va','tava','','emaisillamme','emaisillanne','nemaisillani','nemaisillasi','isi','isimme','isitte','isivat','isin','isit','isi','taisiin','kaamme','kaa','koot','','koon','takoon','minen','mista','emme','ette','evat','en','et','ee');
  const yhtlopsall:array[1..75] of ansistring =('a','n','t','','mme','tte','vat','','a','aan','ut','imme','itte','ivat','in','it','i','tu','tiin','aksemme','aksenne','akseni','aksesi','aksensa','taman','essa','en','taessa','matta','malla','masta','maan','massa','man','matta','malla','mista','masta','man','maan','massa','ma','ut','ut','tu','vat','va','tava','maisillaan','maisillamme','maisillanne','maisillani','maisillasi','isi','isimme','isitte','isivat','isin','isit','isi','taisiin','kaamme','kaa','koot','','koon','takoon','minen','mista','emme','ette','evat','en','et','ee');
  const exples:array[1..29] of ansistring=('eitätä','eitätä','abstraktistua','aakkostaa','lypsää','soutaa','ajaa','kaataa','kaitsea','tuntea','lähteä','ahmia','aateloida','saada','juoda','käydä','ahmaista','aaltoilla','ahkeroida','ansaita','juosta','nähdä','aleta','aisata','erota','bingota','taitaa','kumajaa','hohkaa');
  var xxx:array[0..11] of ansistring =('','a', 'n', '', 'a', 'ut', 'i', 'tu', 'en', 'isi', 'kaa', 'emme');
  const konsonantit ='bcdfghjklmnpqrstvwxz'''; vokaalit='aeiouyäö';
    function taka(st:ansistring):ansistring;
    function etu(st:ansistring):ansistring;
    function isdifto(c1,c2:ansichar):boolean;


implementation

{ $mode objfpc}{ $H+}
{ $modeswitch advancedrecords}
//interface

uses taivup;
function taka(st:ansistring):ansistring;
var i:byte;
begin
 for i:=1 to length(st) do
  if st[i]='ä' then st[i]:='a' else
 if st[i]='ö' then st[i]:='o' else
 if st[i]='y' then st[i]:='u' // else st[i]:=st[i];
 ;//else if st[i]='l' then st[i]:='x';// else st[i]:=st[i];
 result:=st;
 //writeln('<li>taka:',st);
end;
function etu(st:ansistring):ansistring;
var i:byte;
begin
 for i:=1 to length(st) do
  if st[i]='a' then st[i]:='ä' else
 if st[i]='o' then st[i]:='ö' else
 if st[i]='u' then st[i]:='y';// else st[i]:=st[i];
 result:=st;
end;

//Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs;
type   rtavu = bitpacked record  //halutaan mahduttaa 20 bit (16 ois kiva muttei taida onnistua.. tai taitaa sittenkin). Alkuun ois 6 + 6 + 8
   //miksei mahdu:
    konas: 0..3; //15 mahd tavunalukonsonanttia (ekan tavun lisäkons ei mukana). CBQZXW pois jos tiukkaa (4bit)
    voks: 4..8;  //20 vokaalia tai diftongia .. jos etuvok muutettu takavok ., muuten ois 34  (5bit)
    konlos: 9..15; // 44 (<2^7) erilaista, osa     aika turhia .  64 (6bit)
    //jos cbfxzf pois niin  menee alle 64:ään
  end;
//type rtavu=record        a,k,l:byte;end;
type rsana=record
   alkukons: byte; //needs only 5 bits  (4 woith some squeezing)
   //alks: 0..5;  //20 mahd alkukons-yhdistelmää (ekan tavun lisäkonsonanteista)
   takavok:boolean;    //sisältääkö öäy
   sanalka:word;//3 bit riittäis
   tailka:byte;
   tavut:array[1..4] of rtavu;
   id:word; //0 .. noin 10K
   end;
  function encodetavu(n:word):ansistring;
  var akons,lcons,vok:ansistring;
  begin
   case n of 1:result:='t'; 2:result:='k'; 3:result:='l'; 4:result:='m'; 5:result:='n'; 6:result:='h'; 7:result:='p'; 8:result:='r'; 9:result:='s'; 10:result:='j'; 11:result:='v'; 12:result:='d'; 13:result:='g'; 14:result:='f'; else result:='';end;
  end;
  function decodetavu(t:word):ansistring;
  var akons,lcons,vok:ansistring;
  begin
   case t of 1:result:='t'; 2:result:='k'; 3:result:='l'; 4:result:='m'; 5:result:='n'; 6:result:='h'; 7:result:='p'; 8:result:='r'; 9:result:='s'; 10:result:='j'; 11:result:='v'; 12:result:='d'; 13:result:='g'; 14:result:='f'; else result:='';end;
  end;

 function isdifto(c1,c2:ansichar):boolean;
  begin
   result:=false;
   if c1=c2 then result:=true else                       //arv  i o i da
   case c1 of
    'a': if pos(c2,'iu')>0 then result:=true;
    'e','i': if pos(c2,'ieuy')>0 then result:=true;
    'o','u': if pos(c2,'iuo')>0 then result:=true;
    'y','ö': if pos(c2,'iyö')>0 then result:=true;
    'ä': if pos(c2,'iy')>0 then result:=true;
   end;
  end;

 function hyphenfi(w:ansistring;tavus:tstringlist):ansistring;
 //var tavus:tstringlist;
   var i,k,len,vpos:integer;hy,vocs,alkkon:ansistring;ch,chprev:ansichar;lasttag:ansistring;haddif:boolean;

 begin
   tavucount:=0; //global,  temp trickstery
   tavus.clear;
   len:=length(w);
  //writeln('<li>',w,': ');
  if len=0 then exit;
  result:='';//w[len];
  chprev:=' ';//w[len];   //o
  haddif:=false;
  alkkon:='';
  //write(^j,w,':');
  if (pos(w[1],konsonantit)>0) then
  for i:=2 to 3 do if (pos(w[i],konsonantit)>0) then alkkon:=alkkon+w[i-1] else break;
  //if alkkon<>'' then write('\',alkkon);
  if alkkon<>'' then w:=ansilowercase(copy(w,length(alkkon)+1,99));

  len:=length(w);
  //write('#',w, '/',alkkon,'@');
   //  a-iu,e-ieuy, i-ieuy,o-iou,u-iou

  for i:=len downto 1 do
  begin
     ch:=w[i]; //d  kons alkaa uuden tavun paitsi jos ed=kons
     //if i=1 then if alkkon<>'' then begin tavus.insert(0,alkkon);end;
     if (pos(chprev,vokaalit)>0) then  //jos ed on vokaali
     begin        //a ie  prev:e nyt:i  ie on dift
       //if (pos(ch,konsonantit)>0) then  begin haddif:=false;result:=result+'-'+ch+hy+'-'+result;addtolist(hyps,ch+hy,true);hy:='';ch:=' ';end
       if (pos(ch,konsonantit)>0)  then  begin haddif:=false;result:=result+'-'+ch+hy;tavus.insert(0,ch+hy);hy:='';ch:=' ';end
       //else if (haddif) then begin result:=hy+'+'+result;addtolist(hyps,hy,true);hy:=ch;end
       else  if haddif then begin haddif:=false;result:=result+'-'+hy;tavus.insert(0,hy);hy:=ch end
       else
       if (not isdifto(ch,chprev)) then //or  ((i>1) and (pos(w[i-1],vokaalit)>0)) then //kolm vok pätks aina kaksi vikaa?                     //  as-il a a is | os
       //else if (isdifto(ch,chprev)) then //or  ((i>1) and (pos(w[i-1],vokaalit)>0)) then //kolm vok pätks aina kaksi vikaa?                     //  as-il a a is | os
       begin
         //result:=hy+'+'+result;addtolist(hyps,hy,true);hy:=ch; //chprev:='y';//                     //  as-il a a is | os
         result:=result+'+'+hy+'+';tavus.insert(0,hy);hy:=ch; //chprev:='y';//                     //  as-il a a is | os
       end else  //diftongi, mutta tulossa vielä yksi vokaali
        if ((i>1) //and (pos(w[i-1],vokaalit)>0))
         and (isdifto(w[i-1],ch))) then begin
          result :=result+'+'+hy+'+';tavus.insert(0,hy);hy:=ch; //chprev:='y';//                     //  as-il a a is | os
        end else
        begin haddif:=true;hy:=ch+hy;
        end; //ignoroi kolmoiskons - mukana vain ei-yhd.sanojen perusmuodot,
    end else hy:=ch+hy;
     //if i=1 then begin result:=hy+'_'+result ;addtolist(hyps,hy,true);end else
     if i=1 then begin result:=result+'_'; if hy<>'' then tavus.insert(0,hy);end else
    chprev:=ch;
     //if i=1 then addtolist(hyps,copy(alkkon,length(alkkon)-1,length(alkkon))+hy,true);
     //if hy<>'' then
     //if pos(chprev,vokaalit)>990 then result:=chprev+'-'+result
     //else result:=chprev+result;
  end;

  //if alkkon<>'' then tavus[tavus.count-1]:=alkkon+tavus[tavus.count-1];  //ei näin kun sanoja rakennellaan - alkukonsontit talletaan sanan tietoihin, ei ekaan tavuun
  //if alkkon<>'' then tavus[0]:=alkkon+tavus[0];  //ei näin kun sanoja rakennellaan - alkukonsontit talletaan sanan tietoihin, ei ekaan tavuun
  if alkkon<>'' then tavus.insert(0,alkkon+'')
  else tavus.insert(0,'');//  tryin this .. maybe breaks something
  result:=alkkon+'_'+result;
  //writeln('**',hy,':::',alkkon);
  {ch:=w[1];
  if (pos(ch,konsonantit)>0) and (pos(chprev,konsonantit)>0) then
  begin
  for i:=2 to min(3,len) do if result[i]='-' then delete(result,i,1);
  end;  //result:=ch+''+result;
  //writeln('<hr/>');
  }
   result:=tavus.commatext;
  //tavus.free;
 end;

 function hyphenfiold(w:ansistring;tavus:tstringlist):ansistring;
 //var tavus:tstringlist;
 function lstindexof(lst:tstringlist;st:ansistring):integer;
  var i:integer;
  begin
  result:=-1;
   for i:=0 to lst.count-1 do begin try if lst[i]=st then begin result:=i;break;end;
   except writeln('<li>failindex:',i,'/',lst.count);end; end;
  end;

  function addtolist(lst:tstringlist;st:ansistring;pilko:boolean):ansistring;
  var ordo,oldo:integer;obi:qword;j:word;pala,xtr:ansistring;count,palano:word;
   begin
    if st='' then exit;
    result:='*'+st+'_';
    ordo:=lst.indexof(st);
    //if pilko then tavus.add(st);
    if pilko then tavus.insert(0,st);
    if pilko then tavucount:=tavucount+1;
    //if  pilko then begin write('');count:=count+1 ; tavus.add(st);
    // writeln(' <b>',st,'</b>');end else write(st,'/');
    ordo:=lstindexof(lst,st);
    if ordo<0 then begin
      lst.add(st);ordo:=lst.count-1;
     obi:=qword(tobject(0));
       //if not pilko then if st='äi' then writeln('<li>EKA',ordo,'=',st,'/',lst.count);//st=voks[ordo],voks[ordo],'/',integer(qword(lst.objects[ordo])),'</li>_ ');
    end
    else begin
      obi:=qword(lst.objects[ordo]);
    end;
    lst.objects[ordo]:=tobject(integer(obi)+1);
    //if not pilko then if st='äi' then writeln('<li>',st,lst=voks, ordo,'/',integer(qword(lst.objects[ordo])),'</li>_ ');
    pala:='';palano:=1;
    //if pilko then addtolist(kons1,ak,'',false);
    //if not pilko then
    //if lst=kons1 then write('  K1:',st) else if lst=voks then write('  V:',st) else if lst=kons2 then write('  K2:',st)
    //else write(' !!!',st,':: ');
    //while st<>'' do
    st:=st+' ';
    if 1=1 then if pilko then
    for j:=1 to length(st) do
     begin
        //if j=length(st) then xtr:=st[j] else xtr:='';
        //write(palano,pala,'(',st[j],')');
        if palano=1 then begin
           if (pos(st[j],konsonantit)>0) then pala:=pala+st[j]
           else  begin addtolist(kons1,pala,false);pala:=st[j];palano:=2;end;
         end else
        if palano=2 then begin if (pos(st[j],vokaalit)>0)  then pala:=pala+st[j] else begin addtolist(voks,taka(pala),false);pala:=st[j];palano:=3;end; end else
        if palano=3 then if (pos(st[j],konsonantit)>1) then begin pala:=pala+st[j];end else begin if pala='nsp' then writeln('<li>',w,'@ ');addtolist(kons2,taka(pala)+xtr,false);pala:='';palano:=4;end;
     end;
    //if pala='öö' then writeln('<h5>'+inttostr(j)+st,'</h5>');
   end;
  {for j:=0 to tavus.count-1 do
  begin if tlen>length(f[i]) then break;
    tlen:=tlen+length(tavus[j]);
    hyps:=hyps+'\'+tavus[j];
    //if tlen+length(tavus[i]>lengt(f[i])
   end;}
  procedure xbreak;begin end;
  var i,k,len,vpos:integer;hy,vocs,alkkon:ansistring;ch,chprev:ansichar;lasttag:ansistring;haddif:boolean;
  procedure addtavu(t:ansistring); begin
    tavus.add(t);
  end;
 begin
   tavucount:=0; //global,  temp trickstery
   tavus.clear;
  len:=length(w);
  //writeln('<li>',w,': ');
  if len=0 then exit;
  result:='';//w[len];
  hy:=result;
  //writeln(w);
  chprev:=' ';//w[len];   //o
  haddif:=false;
  alkkon:='';
  //write(^j,w,':');
  if (pos(w[1],konsonantit)>0) then
  for i:=2 to 3 do if (pos(w[i],konsonantit)>0) then alkkon:=alkkon+w[i-1] else break;
  //if alkkon<>'' then write('\',alkkon);
  if alkkon<>'' then w:=ansilowercase(copy(w,length(alkkon)+1,99));

  len:=length(w);
  //write('#',w, '/',alkkon,'@');
   //  a-iu,e-ieuy, i-ieuy,o-iou,u-iou

  for i:=len downto 1 do
  begin
     //writeln('<li>',w[i],'/',chprev,' ',tavus.commatext);
     ch:=w[i]; //d  kons alkaa uuden tavun paitsi jos ed=kons
     if i=1 then if alkkon<>'' then begin addtolist(alko,alkkon,false);end;
     if (pos(chprev,vokaalit)>0) then  //jos ed on vokaali
     begin        //a ie  prev:e nyt:i  ie on dift
       //if (pos(ch,konsonantit)>0) then  begin haddif:=false;result:=result+'-'+ch+hy+'-'+result;addtolist(hyps,ch+hy,true);hy:='';ch:=' ';end
       if (pos(ch,konsonantit)>0)  then  begin haddif:=false;result:=result+'-'+ch+hy;addtolist(hyps,ch+hy,true);hy:='';ch:=' ';end
       //else if (haddif) then begin result:=hy+'+'+result;addtolist(hyps,hy,true);hy:=ch;end
       else  if haddif then begin haddif:=false;result:=result+'-'+hy;addtolist(hyps,hy,true);hy:=ch end
       else
       if (not isdifto(ch,chprev)) then //or  ((i>1) and (pos(w[i-1],vokaalit)>0)) then //kolm vok pätks aina kaksi vikaa?                     //  as-il a a is | os
       //else if (isdifto(ch,chprev)) then //or  ((i>1) and (pos(w[i-1],vokaalit)>0)) then //kolm vok pätks aina kaksi vikaa?                     //  as-il a a is | os
       begin
         //result:=hy+'+'+result;addtolist(hyps,hy,true);hy:=ch; //chprev:='y';//                     //  as-il a a is | os
         result:=result+'+'+hy+'+';addtolist(hyps,hy,true);hy:=ch; //chprev:='y';//                     //  as-il a a is | os
       end else  //diftongi, mutta tulossa vielä yksi vokaali
        if ((i>1) //and (pos(w[i-1],vokaalit)>0))
         and (isdifto(w[i-1],ch))) then begin
          result :=result+'+'+hy+'+';addtolist(hyps,hy,true);hy:=ch; //chprev:='y';//                     //  as-il a a is | os
        end else
        begin haddif:=true;hy:=ch+hy;
        end; //ignoroi kolmoiskons - mukana vain ei-yhd.sanojen perusmuodot,
    end else hy:=ch+hy;
     //if i=1 then begin result:=hy+'_'+result ;addtolist(hyps,hy,true);end else
     if i=1 then begin result:=result+'_';addtolist(hyps,hy,true);end else
    chprev:=ch;
     //if i=1 then addtolist(hyps,copy(alkkon,length(alkkon)-1,length(alkkon))+hy,true);
     //if hy<>'' then
     //if pos(chprev,vokaalit)>990 then result:=chprev+'-'+result
     //else result:=chprev+result;
  end;
  //if alkkon<>'' then tavus[tavus.count-1]:=alkkon+tavus[tavus.count-1];  //ei näin kun sanoja rakennellaan - alkukonsontit talletaan sanan tietoihin, ei ekaan tavuun
  if alkkon<>'' then tavus[0]:=alkkon+tavus[0];  //ei näin kun sanoja rakennellaan - alkukonsontit talletaan sanan tietoihin, ei ekaan tavuun
  //if alkkon<>'' then tavus.add(alkkon);  //  tryin this .. maybe breaks something
  result:=alkkon+'_'+result;
  //writeln('**',hy,':::',alkkon);
  {ch:=w[1];
  if (pos(ch,konsonantit)>0) and (pos(chprev,konsonantit)>0) then
  begin
  for i:=2 to min(3,len) do if result[i]='-' then delete(result,i,1);
  end;  //result:=ch+''+result;
  //writeln('<hr/>');
  }
   result:=tavus.commatext;
  //tavus.free;
 end;
{for i:=len-1 downto 1 do
begin
 ch:=w[i]; //d  kons alkaa uuden tavun paitsi jos ed=kons
 if (pos(chprev,konsonantit)<1) then
 begin
 if (pos(ch,konsonantit)>0) then  begin result:='-'+ch+result;addtolist(hy);end
 else if haddif or (not isdifto(ch,chprev)) then begin result:=ch+'-'+result;haddif:=false;end else result:=ch+result; //ignoroi kolmoiskons - mukana vain ei-yhd.sanojen perusmuodot,
end else  result:=ch+result;
chprev:=ch;

 //if hy<>'' then
 //if pos(chprev,vokaalit)>990 then result:=chprev+'-'+result
 //else result:=chprev+result;
end;
ch:=w[1];
if (pos(ch,konsonantit)>0) and (pos(chprev,konsonantit)>0) then
begin
for i:=2 to min(3,len) do if result[i]='-' then delete(result,i,1);
end;  //result:=ch+''+result;
end;
}

type xx=record a,b:ansichar;end;
var x:array[1..2] of xx =((a:'a';b:'c'),(a:'a';b:'c'));

procedure luetavut;
var
  tfIn: TextFile;
  s,ss: string;i,j:word;
begin
  // Give some feedback
writeln('luetavut');
AssignFile(tfIn, 'sanatall.iso');
  i:=0;
  try
    reset(tfIn);
    while not eof(tfIn) do
    begin
      readln(tfIn, s);
      //writeln(pos(' V ',s),' ');
      if pos(' V ',s)<1 then continue;
      i:=i+1;
      //if i>500 then break;
      s:=ansilowercase(copy(s,1,pos(' ',s)-1));
      //writeln(s);
      //if i mod 5=1 then
      begin
       for j:=1 to length(s) do
       begin
         case s[j] of
          'c':s[j]:='k';
          'b':s[j]:='p';
          //'f':s[j]:='v';
          'q':s[j]:='k';
          'x':s[j]:='k';
          'w':s[j]:='v';
          'z':s[j]:='s';
          'ä':s[j]:='a';
          'â':s[j]:='a';
          'ö':s[j]:='o';
          'å':s[j]:='o';
          'y':s[j]:='u';
          'á':s[j]:='a';
          'é':s[j]:='e';
          'è':s[j]:='e';
          end;
       end;
       //writeln('<li>');
       hyphenfi(s,tavus);
       if i>300 then break;
      end;
    end;
    //type tavu:akons:packed bitarray{
    // Done so close the file
    CloseFile(tfIn);

  except
    on E: EInOutError do
     writeln('File handling error occurred. Details: ', E.Message);
  end;

end;
function Sortbypop(List: TStringList; Index1, Index2: Integer): integer;
var
  i1, i2: Integer;
begin writeln('?');
i1 :=integer(qword(list.objects[index1]));
i2 :=integer(qword(list.objects[index2]));
  Result := i2 - i1;
end;


procedure listaatavut;
var i,J,K,count:word;
begin
writeln('<hr/>TAVUJA:',count,'');
writeln('<hr/><h2>SANANALKUkonstit',alko.count,'</h2><ul>');
//write('<li>var xxx:array[1..',alko.count+1,'] of array[1..2] of ansichar =(');
for i:=0 to alko.count-1 do
         try write('<li>',alko[i][1],'''',',''',alko[i][2],''')');except write('* ');end;

 //var xxx:array[1..2] of array[1..2] of ansichar =(('a','c'),('a','c'));
 //writeln('<li>',i,'  ',alko[i],' : ', integer(qword(alko.objects[i])));
 kons1.CustomSort(@sortbypop);
 kons2.CustomSort(@sortbypop);
 voks.CustomSort(@sortbypop);

 writeln('<hr/><h2>Tavunlkukonstit:',kons1.count,'</h3><ul><li>case akons of ');
 for i:=0 to kons1.count-1 do
  writeln(i+1,':result:=''',kons1[i],'''; ');//, integer(qword(kons1.objects[i])));
  writeln('else result:='''';end;</ul><hr/>VOK' ,voks.count,'<ul>');
  writeln('<hr/><h2>vokaalit:',voks.count,'</h3><ul><li>case vok of ');
  for i:=0 to voks.count-1 do
   writeln(i+1,':result:=''',voks[i],'''; ');//, integer(qword(kons1.objects[i])));
   writeln('else result:=''''0'''';end;</ul><hr/>VOK' ,voks.count,'<ul>');
   writeln('<hr/><h2>Tavunlkukonstit:',kons1.count,'</h3><ul><li>case akons of ');
 for i:=0 to kons2.count-1 do
    writeln(i+1,':result:=''',kons2[i],'''; ');//, integer(qword(kons1.objects[i])));
    writeln('else result:=''''0'''';end;</ul><hr/>VOK' ,voks.count,'<ul>');
for i:=0 to voks.count-1 do
 writeln('<li>',i,'  ',voks[i],' : ', integer(qword(voks.objects[i])));
writeln('</ul><hr/>TAVUNLOPPUKONSTIT: ',kons2.count,'<ul>');
//shorts:=0;
write('kons2: array [1..',kons2.count+2,'] of array[1..2] of ansichar=(');
for i:=0 to kons2.count-1 do
//  write(
 //if length(kons2[i])<5 then begin try  shorts:=shorts+1;writeln('<li>',shorts,'  ',kons2[i],' : ', integer(qword(kons2.objects[i])));except write('<li>fail at ',i);end;end else
writeln('<li>(',kons2[i],' : ', integer(qword(kons2.objects[i])),')');
writeln('</ul><h2/>sorted: ',kons1.count,'</h2><ul>');
//for i:=0 to hyps.count-1 do
// writeln('<li>',i,'  ',hyps[i],' : ', integer(qword(hyps.objects[i])));
//kons1.sorted:=true;
//kons1.sort;
writeln('<li>K:',kons1.commatext,'<hr>');
//for i:=0 to kons1.count-1 do
// writeln('<li>',i,'  ',kons1[i],' : ', integer(qword(kons1.objects[i])));
//  Error: Incompatible type for arg no. 1: Got "<address of function(TStringList;LongInt;LongInt):Boolean;Register>",
//expected "<procedure variable type of function(TStringList;LongInt;LongInt):LongInt;Register>"
//FOR I:=0 TO konsl.count-1 do  if konsl]i].
end;



{ $modeswitch advancedrecords}
 {ype TSomeBitStructure = record
  private
  RawData:Word;
    function GetBits(const AIndex: Integer): Integer; inline;
    procedure SetBits(const AIndex: Integer; const AValue: Integer); inline;
  public
    // High byte of index offset, low byte of index is bit count
    property OneBit: Integer index $0001 read GetBits write SetBits;
    property TwoBits: Integer index $0102 read GetBits write SetBits;
    property FourBits: Integer index $0304 read GetBits write SetBits;
    property EightBits: Integer index $0708 read GetBits write SetBits;
  end;
 }
   function testbits:boolean;
   var bits:rtavu; val,i,j,k,ak,vok,lk:word;w:integer;

     mask,vals:array[0..2] of word;
     procedure getw;var j:word;
     begin
      write('<li>:');
             // for j:=0 to 2 do begin
             //write('',inttobin((val and mask[j]),16),'/<b>',(val and mask[j]), '/</b>' );end;end;
             write('',inttobin((val and mask[0]),16),'/<b>',(val and mask[0]), '/</b>' );
             write('',inttobin((val and mask[1]) shr 4,16),'/<b>',(val and mask[1]) shr 4, '/</b>' );
             write('',inttobin((val and mask[2]) shr 10,16),'/<b>',(val and mask[2]) shr 10, '/</b>' );
     //end;
     end;
     procedure setv(ak,vo,lk:word);var p:word;
     begin
        val:=0;
        val:=(ak and  Mask[0]) or ((vo shl 4) and mask[1]) or ((lk shl 10) and mask[2]);
        writeln('<li>',ak,'/', vo,'/',lk);
        getw;
        //shl Offset))) or (AValue shl Offset);
     end;
   begin
    w:=$24;
    //          1          10
    mask[0]:=%000000000001111;
    mask[1]:=%0000000111110000;
    mask[2]:=%1111110000000000;

        for i:=50 to 0 do
          for j:=0 to 3 do
           for k:=0 to 3 do
             setv(i,j,k);

    setv(0,32,0);
    setv(12,31,62);
    setv(12,22,63);
    setv(12,21,0);
    setv(12,20,48);
    setv(12,20,63);
    setv(16,32,64);
    setv(15,31,63);
    setv(0,0,0);
    exit;
    w:=3;
    write(intpower(2,w),16);
    //for w:=0 to 15  do begin writeln('<li>',w,'/',inttobin(round(intpower(2,w)),16),'</li>');end;
    for w:=12 to 23  do
     begin writeln('</ul><hr>',w,'/',inttobin(w,16),'<ul>');
       for j:=0 to 2 do begin  write('<li>',inttobin(w and mask[j],16),'/<b>',(w and mask[j]),'</b> ' );end;
    end;

    for i:=0 to 3 do
      for j:=0 to 3 do
       for k:=0 to 3 do
        begin
          w:=k+j*8+i*16 ;
          writeln('<li>',i,'+',j,'+',k,'=',(w and 64),',', (w shl 3),',', (w shr 6));
        end;
   end;
{$OPTIMIZATION ON}
{$OVERFLOWCHECKS OFF}
{unction TSomeBitStructure.GetBits(const AIndex: Integer): Integer;
var
  Offset: Integer;
  BitCount: Integer;
  Mask: Integer;
begin
  BitCount := AIndex and $FF;
  Offset := AIndex shr 8;
  Mask := ((1 shl BitCount) - 1);
  Result := (RawData shr Offset) and Mask;
end;

procedure TSomeBitStructure.SetBits(const AIndex: Integer; const AValue: Integer);
var
  Offset: Integer;
  BitCount: Integer;
  Mask: Integer;
begin
  BitCount := AIndex and $FF;
  Offset := AIndex shr 8;
  Mask := ((1 shl BitCount) - 1);
  Assert(aValue <= Mask);
  RawData := (RawData and (not (Mask shl Offset))) or (AValue shl Offset);
end;

}
end.

