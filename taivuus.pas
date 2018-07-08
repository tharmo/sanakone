unit taivuus;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils,math;

implementation
uses taivup,taivubits;
function IFss(cond:boolean;st1,st2:ansistring):ansistring;
begin
 if cond then result:=st1 else result:=st2;
end;


end.

