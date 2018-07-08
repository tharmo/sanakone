BEGIN{FS=","}

#{if (substr($4,1,length($4)-1)==substr($9,1,length($4)-5)) print $4,$9}
{print $1, substr($4,1,length($4)-1), "  -  " ,substr($9,1,length($9)-3)}
