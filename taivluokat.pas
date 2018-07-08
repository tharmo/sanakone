unit taivluokat;

{$mode objfpc}{$H+}

interface
uses
  Classes, SysUtils;
type tnomsijat=(Nom,Gen,Par,Ine,Ela,Ill,Ade,Abl,All,Ess,Tra,Abe,Ins,Kom);
// const aste: array[1..2] of ansistring =(('abc';'asd'));
const snomsijat: array[1..14,1..3] of ansichar=('Nom','Gen','Par','Ine','Ela','Ill','Ade','Abl','All','Ess','Tra','Abe','Ins','Kom');
type ttailuokka= class(tobject)

end;
type tnomluokka=class(ttailuokka)
end;

type tN1=class(tnomluokka)
end;
implementation
{gawk:
BEGIN { FS=",";q="\x27"}
 /:/{ next}
//{ muodot="const N" $1 ":array[1.." NF-2 "] of ansistring =(";
for (i=2;i<NF-1;i++) muodot=muodot q $i q ",";print muodot  q $(NF-1) q");"}
}

const N01 :array[1..13] of ansistring =('','a','n','*n','lle','tta','t','ja','jen','ihin','ille','in','itta');
const N02 :array[1..13] of ansistring =('','a','n','*n','lle','tta','t','ita','iden','ihin','ille','in','itta');
const N03 :array[1..13] of ansistring =('','ta','n','*n','lle','tta','t','ita','iden','ihin','ille','in','itta');
const N04 :array[1..13] of ansistring =('','a','n','*n','lle','tta','t','ja','jen','ihin','ille','in','itta');
const N05 :array[1..13] of ansistring =('','ia','in','iin','ille','itta','it','eja','ien','eihin','eille','ein','eitta');
const N06 :array[1..13] of ansistring =('','ia','in','iin','ille','itta','it','eita','ien','eihin','eille','ein','eitta');
const N07 :array[1..13] of ansistring =('','ea','en','een','elle','etta','et','a','en','in','lle','n','tta');
const N08 :array[1..13] of ansistring =('','a','n','en','lle','tta','t','ja','in','ihin','ille','in','itta');
const N09 :array[1..13] of ansistring =('','a','n','an','lle','tta','t','oja','ain','oihin','oille','oin','oitta');
const N10 :array[1..13] of ansistring =('','a','n','an','lle','tta','t','ia','ien','iin','ille','in','itta');
const N11 :array[1..13] of ansistring =('','a','n','an','lle','tta','t','ia','ien','iin','ille','in','itta');
const N12 :array[1..13] of ansistring =('','a','n','an','lle','tta','t','oita','ain','oihin','oille','oin','oitta');
const N13 :array[1..13] of ansistring =('','a','n','an','lle','tta','t','oita','in','oihin','oille','oin','oitta');
const N14 :array[1..13] of ansistring =('','a','n','an','lle','tta','t','oja','in','oihin','oille','oin','oitta');
const N15 :array[1..13] of ansistring =('','a','n','an','lle','tta','t','ita','iden','ihin','ille','in','itta');
const N17 :array[1..13] of ansistring =('','ta','n','seen','lle','tta','t','ita','iden','ihin','ille','in','itta');
const N18 :array[1..13] of ansistring =('','ta','n','h*n','lle','tta','t','ita','iden','ihin','ille','in','itta');
const N19 :array[1..13] of ansistring =('','ta','n','h*n','lle','tta','t','ita','iden','ihin','ille','in','itta');

const N1919 :array[1..13] of ansistring =('*','*ta','*n','*hon','*lle','*tta','*t','ita','iden','ihin','ille','in','itta');
const N20 :array[1..13] of ansistring =('','ta','n','h*n','lle','tta','t','ita','iden','ihin','ille','in','itta');
const N21 :array[1..13] of ansistring =('','ta','n','h*n','lle','tta','t','ita','iden','ihin','ille','in','itta');
const N22 :array[1..13] of ansistring =('','''ta','''n','''hen','''lle','''tta','''t','''ita','''iden','''ihin','''ille','''in','''itta');
const N23 :array[1..13] of ansistring =('','ta','en','een','elle','etta','et','a','en','in','lle','n','tta');
const N24 :array[1..13] of ansistring =('','ta','en','een','elle','etta','et','a','en','*n','lle','in','tta');
const N25 :array[1..13] of ansistring =('','ea','en','een','elle','etta','et','a','en','in','lle','n','tta');
const N26 :array[1..13] of ansistring =('','ta','en','een','elle','etta','et','a','en','in','lle','n','tta');
const N27 :array[1..13] of ansistring =('','tta','den','teen','delle','detta','det','a','en','in','lle','n','tta');
const N28 :array[1..13] of ansistring =('i','ta','en','een','elle','etta','et','a','en','in','lle','n','tta');
const N30 :array[1..13] of ansistring =('i','a','en','een','elle','etta','et','ia','en','iin','ille','in','itta');
const N32 :array[1..13] of ansistring =('','ta','en','een','elle','etta','et','ia','ien','iin','ille','in','itta');
const N33 :array[1..13] of ansistring =('','ta','men','meen','melle','metta','met','mia','mien','miin','mille','min','mitta');
const N34 :array[1..13] of ansistring =('','ta','man','maan','malle','matta','mat','mia','ten','miin','mille','min','mitta');
const N36 :array[1..13] of ansistring =('n','mpaa','mman','mpaan','mmalle','mmatta','mmat','mpia','mpien','mpiin','mmille','mmin','mmitta');
const N38 :array[1..13] of ansistring =('nen','sta','sen','seen','selle','setta','set','sia','sien','siin','sille','sin','sitta');
const N39 :array[1..13] of ansistring =('s','sta','ksen','kseen','kselle','ksetta','kset','ksia','ksien','ksiin','ksille','ksin','ksitta');
const N40 :array[1..13] of ansistring =('','tta','den','teen','delle','detta','det','ksia','ksien','ksiin','ksille','ksin','ksitta');
const N41 :array[1..13] of ansistring =('','ta','*n','*seen','*lle','*tta','*t','ita','iden','ihin','ille','in','itta');
const N43 :array[1..13] of ansistring =('','ta','en','een','elle','etta','et','ita','iden','ihin','ille','in','itta');
const N44 :array[1..13] of ansistring =('t','tta','an','aseen','alle','atta','at','ita','iden','ihin','ille','in','itta');
const N47 :array[1..13] of ansistring =('ut','utta','een','eeseen','eelle','eetta','eet','eita','eiden','eihin','eille','ein','eitta');
const N48 :array[1..13] of ansistring =('','tta','en','eseen','elle','etta','et','ita','iden','ihin','ille','in','itta');
const N49 :array[1..13] of ansistring =('','ta','en','een','elle','etta','et','ia','ien','iin','ille','in','itta');

end.


{
2260 GJ =sade  neliökilsalla
84000 GJ hiroshmimma

2260 KJ litra  vettä
sentin sade neliömetrillä 100 litraa vettä /m2
-> 1ML neliökilsa


40 km2, 1cm vettä = 1 hiro

tänään uudellamalla (1000 km/2) neljä senttiä = 100 hiroa
}


