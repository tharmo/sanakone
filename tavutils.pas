unit tavutils;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;
function getaste(a:ansichar):taste;

implementation
 function getaste(a:ansichar):taste;
var i,hit:byte;
begin
  hit:=16;
  //result:='';
  for i:=1 to 15 do if aste[i].a=a then hit:=i;
  if hit=16 then result:=aste[0] else result:=aste[hit];
end;


end.

