      BEGIN { FS="[<|>]"}
      /\<tn\>/ { ssta=match($0,"<s>")+3;ssto=match($0,"<\/s>");tsta=match($0,"<tn>")+4;tsto=match($0,"</tn>");
         asta=match($0,"<av>")+4;asto=match($0,"</av>");
         av=substr($0,asta,asto-asta)
          if (asta=="") {asta="-"}
          st=substr($0,ssta,ssto-ssta)
         tn=sprintf("%03d", substr($0,tsta,tsto-tsta));
          if (st=="") {st="XXX"}
         print tn   "_" av  "_" st
       } 

