      @include "V.gen"  
      #@include "A.gen"  
      #@include "N.gen"  
      #@include "Pron.gen"  
      #@include "Num.gen"  
      // { 
      
       if ($1=="V") { print; V($1)}
       #if ($2=="A")  A($1)
       #if ($1=="N" && substr($2,1,3)+0<50)  N($3)
       #if ($2=="Pron")  Pron($1)
       #if ($2=="Num")  Num($1)
      }
