

{constructor tscamat.create;
begin
end;}



{
  //note-fullmat is implemented as a 1D array to keep it in one memory block
  // result:=tscamat.create;
  //setlength(result,n_w*n_c);
  setlength(sums,n_w*4);
  getmem(fullmat,2*n_w*n_w);
  //fillchar(fullmat^[0],2*n_w*n_w,#0);

  //setlength(fullmat,n_w*n_w);
  readfullmatrix;
  //setlength(result,n_w);
  setlength(onerow,n_w);
  //write(n_w,',','sums[i]. ');
  for i:=0 to n_w-1 do
  begin
     //sums[i]:=0;
    try;
     for j:=0 to n_w-1 do  if i<>j then
       sums[i]:=sums[i]+fullmat^[n_w*i+j];
     except  write('NOSUM:',i,':',j,'/sums!!!  ');end;
     end;
   for i:=0 to n_w-1 do
   begin
     try
       ip:=qword(@result[1]);
      //fillchar(onerow,sizeof(onerow),0);
      //for j:=0 to n_w-1 do onerow[j]:=0;
      prevp:=@RESULT[I];
     if sums[i]>0 then
     for j:=0 to n_w-1 do
     if sums[j]>0 then
     begin
       //r:=mat^[i];
       //write('#');//,sanat[j+1]);
       //for j:=1 to 1000 do write(r[j],'/',mat^[i,j],' ');
       onerow[j]:=round((1000000000*fullmat^[n_w*i+j])/((sums[j]*sums[i]+100000000))); //ADDED CONST TO DENOMINATOR TO PUNISH RARE WORDS
     end else onerow[j]:=0;
     except  write(i,'nogo','xxxx',j,'/');end;
     try
     //scarcesort(onerow,@(result[i*4*n_c]),n_w,n_c);
     except write('FAILSORT');end;
     try
     //for j:=0 to 12 do
     if word(result[i*4*n_c].s)>500 then
     begin write(^j,'***',sanat[i+1],result[max(1,i*4*n_c)].w,'!!!');write(i,sanat[i+1],': ',sanat[1+result[max(1,i*4*n_c)].w]);
     //word(result[i*4*n_c].w));
     end;
     except write('FAILWRITE',sanat[i+1],result[max(1,i*4*n_c)].w,'!!!');end;
     //WRITELN;
  end;
  saveafile('wxw.sca',@wsmat,sizeof(wsmat));
  freemem(fullmat,2*n_w*n_w);
  write('didit');
  }

