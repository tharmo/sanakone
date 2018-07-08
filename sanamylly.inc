{W2C:
  repopulate the clusters word by word, each word being placed to the cluster who's words correlate with the correlates of the word.
  iterate this a few times (no of iterations given in the  parameter
  }
procedure tmylly.w2c(n_iters:word);//(ncors,ntargs:pscarcemat);
var i,j,k,w,wcol,cw,WW,clu,cluw,MAXC,rlength,iter:word;newclus:tmat;
  maxcs:longword;
  recw,recc:r_scarcefield;
  f:file;
  csum,CMEMS:array[1..1000] of longword;
  bestforw:array[1..1000] of longint;
  //HISTO:ARRAY[0..128] OF WORD;

  procedure sortrow(row:word);
  var i,j,k,x,iter,w,ccount:word;reci,recj:r_scarcefield;
     smalmat,smalmat2:array[1..64] of array[1..64] of longword;
     //xlinep:p_longrow;
     resp:pointer;
     xline:array[1..1000] of longword;
     wline:array[1..1000] of word;
     csize:longword;
     wcor,ccor:word;

     maxw,maxval,maxw2,maxval2:longword;
  begin
    fillchar(smalmat,sizeof(smalmat),0);
    //fillchar(smalmat2,sizeof(smalmat),0);
    fillchar(xline,sizeof(xline),0);
    ccount:=newclus.cols;csize:=0;
     for i:=1 to 12 do //newclus.cols do  //should we exclude first memeber?
     begin if newclus.wc(row,i).w=0 then
       begin ccount:=i-1;break; end;
       csize:=csize+newclus.wc(row,i).s;  //counting the number of non-empties in the row
     end;
     ccount:=min(ccount,64);
    //if debug then
    //write('\*:',ccount,' ',row,' :',cluscount);
    //if debug then readln;
    maxval:=0;maxval2:=0;maxw:=0;maxw2:=0;
    for i:=1 to ccount do
    begin
       reci:=newclus.wc(row,i);
       wline[i]:=reci.w;
       xline[i]:=0;

       // if debug then write(^j,^j,'\X:',i,'>',reci.w,' :');
       //if reci.w=0 then break;
       //if i=1 then reci.s:=reci.s div 3;
       //if  matfrom.sums^[reci.w]=0 then begin write(''); continue;end;
       //xline[i]:=0;
       for j:=1 to ccount do //min(12,ccount) do  //just look at the 12 main cluster "loadings"
       if i<>j then
       begin
           recj:=newclus.wc(row,j);
           ccor:=recj.s;
           try
           // if row=2 then if debug then write(^j,' B',j);
           wcor:=wsmat.valueof(recj.w,reci.w);
           if wcor>0 then
           smalmat[i,j]:=(min(ccor,wcor));// div ((csize)+1);
           //smalmat[i,j]:=((ccor*wcor)) div ((wsmat.sums^[w]*csize)+10);
           xline[i]:=xline[i]+(smalmat[i,j]);// div 100);
           //smalmat[i,j]:=min(recj.s,reci.s)*wsmat.valueof(reci.w,recj.w);//(wsmat.sums^[recj.w]+wsmat.sums^[reci.w]+1);
           //smalmat[i,j]:=min(recj.s,reci.s)*wsmat.valueof(reci.w,recj.w);//(wsmat.sums^[recj.w]+wsmat.sums^[reci.w]+1);
           //smalmat[i,j]:=recj.s*reci.s*wsmat.valueof(reci.w,recj.w) div 1000;//(wsmat.sums^[recj.w]+wsmat.sums^[reci.w]+1);
           //smalmat[i,j]:=recj.s*reci.s*wsmat.valueof(recj.w,reci.w) div 1000;//(wsmat.sums^[recj.w]+wsmat.sums^[reci.w]+1);
           //smalmat[i,j]:=recj.s*reci.s*wsmat.valueof(recj.w,reci.w) div 1000;//(wsmat.sums^[recj.w]+wsmat.sums^[reci.w]+1);
//           if i=1 then smalmat[i,j]:=smalmat[i,j] div 3;
           //xline[i]:=xline[i]+reci.s*wsmat.valueof(recj.w,reci.w) div (wsmat.sums^[recj.w]+wsmat.sums^[reci.w]+1);
           except writeln('faillinexline');end;
       end;
       //write(xline[i],' ');
       //if i>1 then
       //if xline[i]>maxval then begin maxval:=xline[i];maxw:=i;end else
       //if xline[i]>maxval2 then begin maxval2:=xline[i];maxw2:=i;end;
    end;
    //write(^j,sanat[wline[maxw]],maxval,sanat[wline[maxw2]],maxval2,':::');
    maxval:=0;maxval2:=0;maxw:=0;maxw2:=0;
    for i:=1 to ccount do
    begin
       if xline[i]>maxval then begin maxval:=xline[i];maxw:=i;end else
       if xline[i]>maxval2 then begin maxval2:=xline[i];maxw2:=i;end;
    end;
    //xline[maxw]:=xline[maxw2];//[2]; //decrease the weight of the first one  as it is an artifact (at first round only?)
    if maxval2>0 then for i:=1 to ccount do  //normalize
         xline[i]:=(100*xline[i]) div maxval;

    if debug then write('E');
    for i:=1 to ccount do newclus.setval(row,i,0,0);  //all info for the cluster is in xline, so we can empty the cluster line to make room for new
    for j:=1 to ccount do //crude sorting
    begin
      //reci:=wsmat.wc(row,j);
      for k:=1 to ccount do
      begin
        recj:=newclus.wc(row,k);
        if xline[j]>recj.s then
        begin
          NEWCLUS.INSERTAT(ROW,K,wline[j],XLINE[J]);
          //move(newclus.mat^[row*newclus.cols+(k-1)],newclus.mat^[row*newclus.cols+(k)],4*(CCOUNT-K-1));
          //NEWCLUS.SETVAL(ROW,K,wline[j],XLINE[J]);
          break
        end;
      end;

    end;
    //for i:=1 to ccount do write(sanat[newclus.wc(row,i).w],newclus.wc(row,i).s, '_');
    //writeln;
  end;
/////////////////// W2C ///////////////////
var wcor,ccor,nz:word;p:^word;maxc2,maxcs2:longword;
begin
 writeln('W2C',cluscount);
 //mat.list;

 n_iters:=4;
 for iter:=1 to n_iters do
 begin
    writeln('ITER******************',iter,'/',n_iters);
    fillchar(csum,sizeof(csum),0);
    writeln('clusters******************',csmat.cols,'/',csmat.rows);
    for clu:=1 to cluscount do
    begin  //sums of entries in old cluster
      csum[clu]:=0;
      for w:=1 to csmat.cols do if csmat.wc(clu,1).w=0 then break else csum[clu]:=csum[clu]+csmat.wc(clu,1).s;
    end;
    //for clu:=1 to cluscount do write(' ',csum[clu],sanat[csmat.wc(clu,1).w]);
    //begin
    rlength:=64;
    newclus:=tmat.create(csmat.rows,csmat.cols);
    for w:=1 to wsmat.rows do  //for all words,
    begin
      //writeln('<li>',sana(wsmat.wc(w,1).w));
      recw:=Wsmat.wc(w,1);
      fillchar(bestforw,sizeof(bestforw),0);
      for clu:=1 to cluscount do // find the old cluster the word fits best in
         //if csmat.wc(clu,wcol).w=0 then break else
      begin
        try
         if csum[clu]=0 then continue;
         for wcol:=1 to 12 do //add up correlations of the word with the first 8 (?) cluster members
         begin
          //recc:=Wsmat.wc(W,wCol);
          recc:=csmat.wc(clu,wCol);
          if recc.w=0 then break;
          wcor:=wsmat.valueof(w,recc.w);  //how much the current word correlates with word wcol in cluuster
          //if wcor=0 then bestforw[clu]:=bestforw[clu]-(recc.s) div 50 else

          if recc.w<>recw.w then  //do we count in the old members
           bestforw[clu]:=bestforw[clu]+(1000*recc.s*wcor) div csum[clu] else
           bestforw[clu]:=bestforw[clu]+(1000*recc.s*wcor) div (csum[clu]*2); //old memrship in clus can be played down
          //bestforw[clu]:=bestforw[clu]+(recc.s*csmat.valueof(clu,recw.w)) div csum[clu]
          //else    bestforw[clu]:=bestforw[clu]+(recw.s*csmat.valueof(clu,recw.w)) div (4*csum[clu]); //old memrship in clus played down
          end;
          //if bestforw[clu]>0 then writeln('|',bestforw[clu]);
        except writeln(w,'**************',clu);end;// bestforw[clu]:=bestforw[clu]
      end;
      maxc:=0;maxcs:=0;
      maxc2:=0;maxcs2:=0;
      for wcol:=1 to cluscount do
      if bestforw[wcol]>maxcs2 then
      begin
        if bestforw[wcol]>maxcs then
         begin
            maxc:=wcol;
            maxcs:=bestforw[wcol];
         end else
         //if iter<n_iters then
         begin
           maxc2:=wcol;
           maxcs2:=bestforw[wcol];
        end;
      end;
      if maxcs>0 then
       begin
            newclus.addtorowsorted(maxc,w,maxcs);
          if iter mod 2=1 then  if 4*maxcs2>3*maxcs then  newclus.addtorowsorted(maxc2,w,maxcs2);

         //writeln('<li>',sana(w),':',sana(csmat.wc(maxc,1).w),'(',maxc,')',maxcs,' ',sana(csmat.wc(maxc2,1).w),'(',maxc2,')',maxcs2)
         ;//else writeln('<li><strike>',sana(w),':',sana(csmat.wc(maxc,1).w),'(',maxc,')',maxcs,' ',sana(csmat.wc(maxc2,1).w),'(',maxc2,')',maxcs2,'</strike>');
       end;
    END; //of one word
    //writeln(^j,^j,'GOTWORDS***********************************',iter,' clust:',cluscount);
    //newclus.list;
    debug:=false;
    //readln;
    //if iter=2 then debug:=true;
    for i:=100 to 0 do //cluscount do
     begin //write(^j,'/&&&&:',i);
      sortrow(i);
    end;
    //writeln('lisstedWORDS***********************************',iter);
    //newclus.list;
    csmat.free;
    csmat:=newclus;
     writeln('clusters******************',csmat.cols,'/',csmat.rows);
    for clu:=1 to cluscount do
    begin
     csum[clu]:=0;
     cMEMS[clu]:=0;
    end;
    //csmat.list;
  end;
  //writeln(^j^j, 'SAVECLUST******************/',cluscount,' /nonzerop:',nz);
end;

function tmylly.linexline(r:word;matfrom,matto:tmat;var wcc:word):boolean;
var i,j,k,x,iter:word;reci,recj:r_scarcefield;
   smalmat,smalmat2:array[1..32] of array[1..32] of longword;
   resp:pointer;
   keeplimit:longword;
   xline:array[1..1000] of longword;
   wcount,hitcount:word;

procedure debu;
var i,j:word;
begin
    for i:=1999 to wcount do
    begin //debug
      write(^j,sana(matfrom.wc(r,i).w),';',xline[i]);
      for j:=1 to wcount do if smalmat[i,j]>0 then
       write(sana(matfrom.wc(r,j).w),smalmat[i,j],'\ ');
    end;
    writeln;//(^j,'--------------------------',wcount);
  for i:=1 to wcount do if xline[i]>0 then write(sana(matfrom.wc(r,i).w),xline[i],'\ ');
end;

begin
fillchar(smalmat,sizeof(smalmat),0);
fillchar(smalmat2,sizeof(smalmat),0);
wcount:=32;
i:=0;
result:=true;
write(^j,'!',cluscount,':',sana(r));
while i<wcount do  //find the original word-correlations (in wsmat) row-word X each of its correlates.. gotta check this carefully, probably problems with 0/1
 begin
   i:=i+1;
   reci:=matfrom.wc(r,i);  //
   if reci.w=0 then begin wcount:=i-1;break;end;
   if i=1 then reci.s:=reci.s div 3;
   if  matfrom.sum(reci.w)=0 then begin write('z'); continue;end;
   for j:=1 to wcount do //cors with the first ignored? shouldn't just be played down?
   if i<>j then
   begin
       recj:=matfrom.wc(r,j);
       try
       if  matfrom.sum(recj.w)=0 then begin write('');smalmat[i,j]:=0;continue;end;// else write(' ',recj.s);
       smalmat[i,j]:=(1000*matfrom.valueof(recj.w,reci.w) div (matfrom.sum(recj.w)+matfrom.sum(reci.w)+1000));
       //smalmat[i,j]:=smalmat[i,j]+matfrom.valueof(reci.w,recj.w);// div 10;// div (matfrom.sums^[recj.w]+matfrom.sums^[reci.w]+1);
       //smalmat[i,j]:=reci.s*matfrom.valueof(recj.w,reci.w);// div 10;// div (matfrom.sums^[recj.w]+matfrom.sums^[reci.w]+1);
       except writeln('faillinexline');end;
   end;
 end;
//write(^j^j,sana(r),'::  ',wcount);
for i:=1 to wcount do for j:=0 to wcount do if  j=0 then xline[i]:=0 else if i<>j then xline[i]:=xline[i]+smalmat[i,j];
//debu;
for iter:=1 to 1 do  //multiply matrix by itself, magnify those that correlate with other ones in the cluter..
begin
   for i:=1 to wcount do
     for j:=1 to wcount do if smalmat[i,j]>0 then
     begin
      //smalmat2[i,j]:=smalmat2[i,j]+1;//round(sqrt(smalmat[i,k]*smalmat[j,k]));//(xline[i]*xline[j]+1);
        smalmat2[i,j]:=0;
        if smalmat[i,j]>0 then  //why? tested above. still seems to do good, but why?
        for k:=1 to wcount do
        begin
          smalmat2[i,j]:=smalmat2[i,j]+round(sqrt(smalmat[i,k]*smalmat[j,k]));//(xline[i]*xline[j]+1);
        end;// else write('?');
     end;
     for i:=1 to wcount do  for j:=1 to wcount do  smalmat[i,j]:=smalmat2[i,j];
end;


  for i:=1 to wcount do for j:=0 to wcount do if j=0 then xline[i]:=0 else if i<>j then xline[i]:=xline[i]+smalmat[i,j];
  hitcount:=0;
  for i:=1 to wcount do if xline[i]>0 then hitcount:=hitcount+1;
  if hitcount<2 then begin result:=false;exit;end;
  //xline[1]:=xline[1] div 4;
  //debu;
  //writeln;
   //xlinep:=@xline;
   //resp:=pointer(csmat.mat);
   //resp:=pointer(resp+(cluscount*cols*4));
   //csmat.sortedrow(xlinep,cluscount,resp,16,16);

   for i:=1 to wcount do //write(' -',sanat[csmat.wc(cluscount,i).w],csmat.wc(cluscount,i).s);
   begin   //inefficient sort .. it's ok do it ineff.
      for k:=1 to wcount do
      if xline[i]>matto.wc(cluscount,k).s then
      begin
       matto.insertat(cluscount,k,matfrom.wc(r,i).w,xline[i]);
       //matto.addtorow(cluscount,matfrom.wc(r,i).w,xline[i]);
       //  writeln('/didset:',matto.wc(cluscount,k).w,sana(matto.wc(cluscount,k).w),';',csmat.mat^[cols*cluscount+k-1].s,'       :::clusteers:',cluscount);
         //move(matto.mat^[cluscount*matto.cols+k],matto.mat^[cluscount*matto.cols+k+1],4*(w2cc-k));//*cols); //WHY "*cols"
         //matto.setval(cluscount,k,matfrom.wc(r,i).w,xline[i]);
         //if isinclus^[matfrom.wc(r,i).w]<1 then
         begin
         //wccount:=wccount+1;
         //for x:=1 to 16 do begin rec:=csmat.wc(cluscount,x); write(x,sanat[rec.w],rec.s,'|');end;
         //writeln('  ///:',k,':',sana(matfrom.wc(r,i).w,xline[i]););
         //writeln('didset:',cluscount,':',k,sanat[wsmat.wc(r,i).w],'=',xline[i]);
         //isinclus^[matfrom.wc(r,i).w]:=cluscount;
         wcc:=wcc+1;
         end;
         break;
      end;
   end;
   keeplimit:=matto.wc(cluscount,1).s div 2;
   for i:=1 to wcount do //write(' -',sanat[csmat.wc(cluscount,i).w],csmat.wc(cluscount,i).s);
   begin   //inefficient sort .. it's ok do it ineff.
      for k:=1 to wcount do
      if matto.wc(cluscount,k).s <keeplimit then begin for j:=k to wcount do matto.setval(cluscount,j,0,0);break;end;
      begin
                isinclus^[matto.wc(cluscount,k).w]:=cluscount;

      end;

   end;
   for i:=1 to wcount do if matto.wc(cluscount,i).w=0 then break else write(' +',sana(matto.wc(cluscount,i).w),matto.wc(cluscount,i).s);
 end;


procedure tmylly.cluster(clusN:word);
var i,j,w,c,k,w_c,iters,hits:word;
   var f:file;

  rec:r_scarcefield;p:pointer;st:string;
  //clusterpot:array of longword;
  wccount,clusmax:word;//had:booleafn;
  maxs,maxw:longword;
  //onerow:p_longrow;
  //var xline:array[0..128] of longword;
  // xlinep:p_longrow;
  //wsums:array[1..1009] of longword;

begin
    //onerow:=wsmat.longrow;
    csmat:=tmat.create(2*clusn,wsmat.cols);
    cluscount:=0;
    wccount:=0;
    writeln(^j,rows,'createdmat************************************************************-->',clusn);

    iters:=1;
    while iters< clusn do
    begin
     //write('~',iters);
     //fillchar(onerow^,rows*4,0);
     //fillchar(xlinep^,cols*4,0);
      wsmat.clearsums;
      //fillchar(wsmat.sums^,wsmat.rows*4,0);
      for w:=1 to wsmat.rows do
      if isinclus^[w]=0 then
      begin
         for c:=1 to 6 do
         begin
             rec:=wsmat.wc(w,c);
             //wsmat.setsum(w,0);
             if rec.s=0 then continue;
             if isinclus^[rec.w]=0 then
              wsmat.incsum(w,rec.s);
             //write(sana(w+1),rec.w,'[',wsmat.sums^[w],'_ ',sana(rec.w),'] ');
         end;
      end;
      maxs:=0;maxw:=0;//had:=true;


      for w:=0 to wsmat.rows-1 do  //find the biggest one
      if isinclus^[w]=0 then
      if Wsmat.sum(w)>maxs then
      begin //if w<>5702 then
          //writeln('MAX:',sanat[w],sanat[w],'/sum:',wsmat.sums^[w],' /omax:',maxs,' ', WSMAT.sums^[w]>maxs);
            maxs:=Wsmat.sum(w);
            maxw:=w;
      end;
        if maxw=0 then begin write('!!zero after ',iters,' iterations');break;end;
        //for j:=1 to 5 do   write('________',sanat[wsmat.wc(maxw,j).w]);
      //    for i:=1 to 16 do write(sanat[wsmat.wc(maxw,i).w]);

      //  writeln('iter ',iters);
      cluscount:=cluscount+1;
      wccount:=wccount+1;
      hits:=0;
      //writeln(^j,cluscount,' (',wccount,')', sanat[maxw],'/', wsmat.sum(maxw),'[',isinclus^[maxw],']',maxw,':::');
      if linexline(maxw,wsmat,csmat,wccount) then iters:=iters+1;
      isinclus^[maxw]:=cluscount;
      for w_c:=19 to 16 do //cols do
      begin
      //if 15*xline[w_c]<xline[1] then
      //if xline[w_c]=0 then
        if isinclus^[csmat.wc(cluscount,w_c).w]<>cluscount  then write('[',isinclus^[csmat.wc(cluscount,w_c).w],']');
        write(sanat[csmat.wc(cluscount,w_c).w],csmat.wc(cluscount,w_c).s,' ');
      end;
     end;
    wccount:=0;
    for i:=0 to wsmat.rows-1 do if isinclus^[i]>0 then wccount:=wccount+1;
    writeln(^j,'Words in clusters;',wccount,'  /clusters:',cluscount);
    //csmat.list;
    writeln(^j,'Words in clusters;',wccount,'  /clusters:',cluscount);
        //mylly.saveafile('clusters.smat',mylly.csmat.mat,mylly.csmat.rows*mylly.csmat.cols*4);
        //writeln('save:',fname,siz);


end;


procedure tmylly.wxw;//(ncors,ntargs:pscarcemat);
  // sparce  matrix 'multiplication'
var itarg,j,jtarg,m,commij,k:WORD;
   //sims:array[1..6461] of word;

  simsx:^ar_longrow;
  maxes:array[1..6461] of longword;
  maxw2,maxs2,
  smallest,sum,maksi:longword;
  fixi:double;ch:char;
  isiz:word;
  oli:word;
  recMID,RECJ:r_scarcefield; // cosizes,cowhats:array[1..64] of longword; //should be local vars
 //onerow:^ar_fullrow;
 //incluster:p_matcol;//array of word;
 newmat:p_scarcemat;
 resp:pointer;
 test1,test2:byte;
 wsums:array[0..1000] of longword;
begin
  try
  //getmem(sims,sizeof(sims^));
  rows:=wsmat.rows;
  cols:=wsmat.cols;
  getmem(simsx,4*(rows+1));
// write(^j,itarg,':',jtarg,' > ',wsmat.wc(itarg,jtarg).w);
maksi:=0;//for itarg:=1 to wrds do maksi:=max(maksi,cors^[itarg,1]);
//fillchar(sims,sizeof(sims),0);
//setlength(inclust,rows+1);
//sims:=getmem(4*(rows+1));
//fillchar(sims^,4*(rows+1),0);
try
//newmat:=tmat.create(rows,cols);
//newmat.mymy:=self;
writeln('wwwwwwwwwwwxxxxxxxxwwwwwwww',rows,'*',cols);
getmem(newmat,4*(rows+1)*(cols+1));
for itarg:=1 to rows do
begin
 if itarg mod 1000=1 then
    write(itarg,'^ ');
 fillchar(simsx^,4*(rows+1),0);
 //fillchar(wsmat.sums^,4*(rows+1),0);
 //write('got here',rows);
 //write(^j^j,sanat[itarg],'???');
  //if inclust^[itarg]<>0 then continue;
  maxes[itarg]:=0;maxs2:=0;maxw2:=0;
  for k:=1 to rows do simsx^[k]:=0;
  for m:=1 to cols do           //a: c,d,e
  begin
       RECMID:=WSMAT.WC(itarg,M);            //recmid=c^
       commij:=RECMID.W;//mAT^[itarg,m];
       //if inclust[maybeij]<>0 then continue;
       if commij=0 then continue;
       if commij>rows then writeln('failed at ', itarg);
       isiz:=RECmid.S;//cors^[itarg,m];
       if isiz=0 then continue else
       for j:=1 to coLS do          //   c: a,b,e
       //if mat^[itarg,
       begin
        try
           try
           recj:=wsmat.wc(commij,j);
           except writeln('faiu '); end;
           jtarg:=recj.w;          //  jtarg=a from c:a,b,e
           if jtarg=0 then continue;
           //if inclust[jtarg]<>0 then continue;
           begin                                      //>
            //simsx^[jtarg]:=simsx^[jtarg]+min(isiz,recj.s);// div 4;// sums[k]**2;       //if itarg=7 then if jtarg=9 then //SIMS^[JTARG]>300 then
            simsx^[jtarg]:=simsx^[jtarg]+round(sqrt(isiz*recj.s)) div 10;// sums[k]**2;       //if itarg=7 then if jtarg=9 then //SIMS^[JTARG]>300 then
           end;
           except writeln(commij,'zzzzzzzzzzzz:',jtarg,'!');raise; end;
           //if itarg>rows-4 then write(sana(jtarg),'_', simsx^[jtarg]);
      end;
    end;
   for j:=1 to rows do
    if simsx^[j]>newmat^[itarg*cols+cols-1].s then
    begin
     for k:=1 to cols   do
      if simsx^[j]>newmat^[(itarg-1)*cols+k-1].s then   //.wc(itarg,k).s then
      begin
         move(newmat^[(itarg-1)*cols+k-1],newmat^[(itarg-1)*cols+k],4*(cols-k));
         //newmat.setval(itarg,k,j,simsx^[j]);
         //if k<8 then write(sanat[j],simsx^[j],' ');
         newmat^[(itarg-1)*cols+k-1].w:=j;
         newmat^[(itarg-1)*cols+k-1].s:=simsx^[j];
         break;
      end;
   end;
   {if itarg>6454 then
   begin
        write(^j,itarg,':');
        for j:=0 to 15 do  write('  :',j,sana(newmat^[(itarg-1)*cols+j].w),newmat^[(itarg-1)*cols+j ].s,'');
        writeln;
   end;}
 end; //of one word
  except  writeln('failed multiply');end;
  finally
    //writeln('freesims'); freemem(simsx,4*(rows+1));write('freedsims');
  end;
  //mat.free;
   wsmat.swapmat(newmat);
   writeln('!!!!!!!!!wwwwwwwwwwwxxxxxxxxwwwwwwww',wsmat.rows,'!');
end;



procedure tmylly.readwords;
var f:textfile;i:integer;s:string;
begin try
  setlength( sanat,n_w+1);
  assign(f,'sanat.iso');
  reset(f);
  i:=1;
  while not eof(f) do
  begin
    readln(f,sanat[i]);
    //write(' .',i,sanat[i]);
    i:=i+1;

  end;
  //for i:=0 to n_w do write(i,sanat[i]);
  write('Xread ',i,'words');
  //for i:=0 to rows-1 do write(sana(i),i,' ');

except   writeln('noreadgo____________');end;
end;
procedure tmylly.saveafile(fname:string;cnt:pointer;siz:longword);
var f:file;
begin
writeln('save:',fname,siz);
assign(f,fname);
Rewrite (F,siz);
try
Blockwrite (F,cnt^,1);
except writeln('could not write file',fname);end;
close (f);
end;

function tmylly.readafile(fname:string;cnt:pointer;siz:longword):longword;

var f:file;j:word;
begin
  assign(f,fname);
  if siz=0 then
  begin
    reset(f,1);
    siz:=filesize(f);   //rows*cols*4;
    close(f);
  end;
//writeln(^j,'tryread:',fname,siz);
writeln('myllyread:',fname,siz);
Reset (F,siz);
result:=siz;
//writeln('OKreset:',fname,siz,':',sanat[word(cnt^)],word(cnt^),'!');
try

Blockread (F,cnt^,1);
writeln('OKread:');
except writeln('FAILREAD',fname);end;
  //writeln('OK:',fname,siz);
close (f);
writeln('OKread:',fname,siz);

end;
function tmylly.sana(wrd:word):string;
begin
   result:=sanat[wrd];
end;



function tmylly.full2scarce:a_scarcemat;
var i,j:word;
  //ONErow:array of longword;
  ip:qword;  full:p_fullmat;
begin
writeln('read fullmatrix');

 full:=wsmat.readfullmatrix;

 writeln('fullmatrix read');
 //for j:=0 to 10 do writeln(full^[j],' ');
 wsmat.fromfull(full);
 writeln('madescarcematrix');
 //wsmat.list;
 exit;
end;
    //writeln(itarg,':::',sanat[itarg],targs^[itarg,1]);
                                   {   a b c d e
                                     a 3   3 3 3
                                     b     3 3
                                     c 3 3     3
                                     d 3 3
                                     e 3   3

                                     a*b= c d
                                     a*c= e
                                     a*e=c

                                     b*a= c d
                                     b*e= c

                                     c*a=  e
                                     c*d= a b
                                     c*e= a

                                     d*c= a b
                                     d*e= a
                                     e*c=  a
                                   ************************************
          1itarg,3jta                a: c,d,e
                                     b: c,d
           2mid                      c: a,b,e
                                     d: a,b
                                     e: a,c

                                     a
                                       a/c: ab, ae
                                       a/d: ab
                                       a/e: c
                                      ab+c+d, ac+e ae+c
                                      b
                                        b/c= a e
                                        b/d= a
                                      ba+c+d   be+c
                                      c
                                        c/a: d e
                                        c/b: d
                                        c/e: a
                                      ca+e cd+a+b ce+a

                                     }
