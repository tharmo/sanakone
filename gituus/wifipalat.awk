      BEGIN { FS="[><]"; g0=0;gogo=0;suomi=0;intext=0  
      otsi="===Yl�k�sit,===Vastak,===Synonyy,===Alak�s,==Osak�s,===Vierus,==Liitty,==Etymo"
      split(otsi,ots,",")
       }
      /<title/ { if (go)
                { if (suomi==1) print juttu>"keep.txt"; else print "EI:" juttu>"eisuomi.txt" }
                 suomi=0
                 if (match($3,/[^��a-z\-]/)==0)
                  { go=1;intext=0 }  #ei muuta kuin pieni� kirjaimia .. tavuviiva?
                   else { go=0;gogo=0;sana=$3 
                   }
                 # print $3 go "************************************************************"
                 #print "%" sana "%" match($3,/[^a-z]/)
                 juttu="";
                }
      /^\*/ { print >"vex.txt" ;next}      
      /<comment/ { next }    
       /Luokka\:/    { if (index($0,"Suomen")<1) { print sana,"///" $0>"pois.txt";go=0} }    
       /==Suomi/ { suomi=1;print  }
      { if (go) juttu=juttu "\n" $0}          
