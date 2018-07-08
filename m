grep -a $1 verbsall.lst |head
read -n1 -r -p "verbsall alku..." key
grep -a $1 verbsall.lst 
read -n1 -r -p "verbsall loppu..." key
grep -a $1 vsort.csv |head
read -n1 -r -p "sor alku..." key
grep -a $1 vsort.csv 
