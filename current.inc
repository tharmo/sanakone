procedure tmat.mergerow(resmat:p_fullmat;wmat:tmat;old1,old2,row,rcount:word);  //full cluster cors from clus*words
var j,c1,c2,xval:word;reci,recj,rew1,rew2:r_scarcefield;asum,avali:longword;

begin
 sums^[row]:=0;
 asum:=0;
 //write(^j^j,mymy.sanat[wc(old1,1).w],old1,'/',mymy.sanat[wc(old2,1).w],old2,':: ',row,'::;;;;! ',mymy.mergecount);
for c1:=1 to rcount do //if row<>j then if sums^[j]>0 then        //for each pair of cluster
 // for j:=1 to rcount do if row<>j then if sums^[j]>0 then        //for each pair of cluster
 if c1<>old1 then if c1<>old2 then
 begin
   //if word((csums+c1*2)^)=0 then continue;
   //RESMAT^[row*1000+c1-1]:=(100*resmat^[old1*1000+c1-1]*resmat^[old2*1000+c1-1]) div (1+word((csums+c1*2)^));
   //avali:=2*min(resmat^[old1*1000+c1-1],resmat^[old2*1000+c1-1]);
   //write(resmat^[old1*1000+c1-1],';',resmat^[old2*1000+c1-1],' ');
   //write(resmat^[old1*1000+c1-1],'/',resmat^[old2*1000+c1-1],'/',' ');

   avali:=round(sqrt(1+resmat^[old1*1000+c1-1]*resmat^[old2*1000+c1-1]));//(1+10*(csums[c1]*csums[c2]));
   //avali:=(resmat^[old1*1000+c1-1]+resmat^[old2*1000+c1-1]) div 2;//(1+10*(csums[c1]*csums[c2]));
   //write('==',avali,' ');
   RESMAT^[row*1000+c1-1]:=RESMAT^[row*1000+c1-1]+avali;// div (1+word((csums+c1*2)^));
   RESMAT^[c1*1000+row-1]:=RESMAT^[c1*1000+row-1]+avali;// div (1+word((csums+c1*2)^));
   //RESMAT^[c1*1000+rows-1]:=RESMAT^[c1*1000+rows-1]+round(100*log2(1+resmat^[old1*1000+c1-1]*resmat^[old2*1000+c1-1] div (1+word((csums+c1*2)^))));
   //RESMAT^[row*1000+c1-1]:=min(resmat^[old1*1000+c1-1],resmat^[old2*1000+c1-1]);// div 2;
   //RESMAT^[old1*1000+row-1]:=resmat^[row*1000+c1-1];
    //if (old1>cluscount) then if avali>20 then write(mymy.sanat[wc(c1,1).w],RESMAT^[row*1000+c1-1],' ');

   asum:=asum+resmat^[row*1000+c1-1];
  end;
  //if asum>10 then
  //write('[[',asum,'/',word((csums+old1*4)^),'/',word((csums+old2*4)^),']]');
  sums^[row]:=asum;
end;

procedure tmat.clusterrow(resmat:p_fullmat;wmat:tmat;row,rcount:word);  //full cluster cors from clus*words
var j,w1,w2,xval:word;reci,recj,rew1,rew2:r_scarcefield;sum:longword;

begin
  write('m');
  sum:=0;
  for j:=1 to rcount do if row<>j then if sums^[j]>0 then        //for each pair of cluster
  begin
    //recj:=wmat.wc(i,j);
    //ival:=recj.s;
    //wmat.wc(i,j)
    //if ival=0 then break;//
    //ival:=1;
    for w1:=1 to rcount do  if wmat.sums^[w1]>0 then
    begin
      rew1:=wc(row,w1);
      if row>mymy.cluscount then     write('&');
      if rew1.w=0 then break;           //scan each pair of words in the clusters
      for w2:=1 to rcount do  if wmat.sums^[w2]>0 then
      begin
        rew2:=wc(j,w2);
        if rew2.w=0 then break;  //if the correlates of members of clusters correlate
        xval:=wmat.valueof(rew1.w,rew2.w);
        //xval:=xval+wmat.valueof(rew2.w,rew1.w);
        //if xval>0 then     write(^j,xval,':::',mymy.sanat[rew1.w],mymy.sanat[rew2.w]);
        try
        //xval:=round(10000000*xval / (1+sums^[row]*sums^[j]*wmat.sums^[w1]*wmat.sums^[w2]));
        xval:=round(10000*xval / (10+sums^[row]*sums^[j]));  //10+ plays down small rows/cols
        sum:=sum+xval;
        resmat^[row*1000+j-1]:=resmat^[row*1000+j-1]+xval;
        resmat^[j*1000+row-1]:=resmat^[j*1000+row-1]+xval;
        //sum:=sum+resmat^[j*1000+row-1];
        //if row>mymy.cluscount then if xval>=0 then
        //if xval>=0 then
        //writeln(xval,'  i:',sums^[row],' j:',sums^[j],' w:',wmat.sums^[rew1.w],' ww:',wmat.sums^[rew2.w],     '=',resmat^[row*1000+j-1]);
        except writeln('fail:',sums^[row],'*',sums^[j],'*',wmat.sums^[w1],'*',wmat.sums^[w2]);end;
        //if debug then if xval>0 then
        //write('|',mymy.sanat[wc(j,1).w],resmat^[row*1000+j-1]);
        //result^[i*1000+j-1]:=result^[i*1000+j-1]+round(100000*ival*1*wmat.valueof(rew1.w,rew2.w)div (sums^[i]*sums^[j])); //div sums something
        //result^[j*1000+i-1]:=result^[j*1000+i-1]+round(10000*ival*1*wmat.valueof(rec2.w,rec1.w) div (sums^[i]*sums^[j])); //div sums something
      end;

    end;

    //if wc(i,1).w=4875 then if result^[i*1000+j-1]>0 then begin write(mymy.sanat[wc(i,1).w],result^[i*1000+j-1],'_'); end;
    //write(' %', resmat^[row*1000+j-1]);

  end;

end;

function tmat.scarce2full(wmat:tmat;cc:word):p_fullmat;  //full cluster cors from clus*words
var maxc1,maxc2,i,j,w1,w2,iter:word;reci,recj,rew1,rew2:r_scarcefield;
  ival,jval,maxs,xval:longword;merged:array[1..1000] of word;debug:boolean;
begin
cc:=500; //got to get this from somewhere
writeln('doful',cols,'*',rows,'**',cc);
  getmem(result,1000*1000*2);
  fillchar(result^,1000*1000*2,0);
  //cc:=300;//mymy.cluscount;
  mymy.cluscount:=cc;
  maxs:=0;
  //////////////  Normalize word/word cors////////////
  for w1:=1 to wmat.rows do
  begin
    wmat.sums^[w1]:=0;
    for w2:=1 to wmat.cols do if wmat.wc(w1,w2).w=0 then break else
     begin
     wmat.sums^[w1]:=wmat.sums^[w1]+wmat.wc(w1,w2).s; //write(wmat.wc(w1,w2).s,'/');
     end;
     if maxs<wmat.sums^[w1] then maxs:=wmat.sums^[w1];
  end;

  for w1:=1 to wmat.rows do wmat.sums^[w1]:=(1000*wmat.sums^[w1]) div maxs;
  maxs:=0;
  //////////////  Normalize clust/clust cors////////////
  for i:=1 to cc do
  begin
    sums^[i]:=0;
    for w1:=1 to cols do
    begin
      rew1:=wc(i,w1);  //from
      if rew1.w=0 then break else
      sums^[i]:=sums^[i]+rew1.s;
      if maxs<sums^[i] then maxs:=sums^[i];
    end;
  end;
  for i:=1 to rows do
  begin sums^[i]:=(1000*sums^[i]) div maxs;
    //writeln(mymy.sanat[wc(i,1).w],sums^[i]);

  end;
  //////////////  calculate clust/clust cors ////////////
  for i:=1 to cc do if sums^[i]>0 then
  begin
    clusterrow(result,wmat,i,cc);
  end;
  writeln('got rows',cols,'*',rows,'**',cc);
  for i:=1 to cc do
  begin
    result^[1000*i+i-1]:=0;
    for j:=1 to cc do if i<>j then
        result^[i*1000+i-1]:=result^[i*1000+i-1]+result^[1000*i+j-1];
    for j:=1 to cc do if i<>j then
        result^[i*1000+j-1]:=1000*(result^[i*1000+j-1]) div (1+result^[1000*i+i-1]);
  end;
  for i:=1 to cc do
  begin
    result^[1000*i+i-1]:=0;
    for j:=1 to cc do if i<>j then
        result^[i*1000+i-1]:=result^[i*1000+i-1]+result^[1000*i+j-1];

  end;
  for i:=1999 to cc do
  begin
   write(^j^j,mymy.sanat[wc(i,1).w],result^[1000*i+i-1],' ');
   for j:=1 to cc do
   if result^[i*1000+j-1]>50 then
    write(mymy.sanat[wc(j,1).w],result^[i*1000+j-1],'\/');
  //if xval>0 then
  end;

end;

procedure tmylly.dolayout;
var mhist:p_mergehistory;//merges:tmat;
Var F : File Of byte;i,ac,bc:word;
  isin:array[1..1000] of word;
  function getcluswords(m,cc:word):string;
  var j:word;
  begin
    result:='['+inttostr(m)+'/'+inttostr(mhist^[m-500,1])+']';
    if m=0 then exit;
    if m<=500 then
    begin
      for j:=1 to 5 do result:=result+'_'
       +sanat[csmat.wc(m,j).w];
        exit;
    end;
    if CC>100 then begin result:=result+('LOOP');EXIT;END;
    if m=mhist^[m,1] then begin result:=result+'SELFREF';EXIT;END;
    if m>500 then
     begin
       result:=result+'('+inttostr(m)+'>'+inttostr(mhist^[m-500,1])+')'+getcluswords(mhist^[m-500,1],cc+1);
       //for i:=1 to
      //cc:=cc+1; if cc>20 then break;
     end  ;
     //RESULT:=M
  end;
var j:word;
begin
//3308032
writeln(^j^j^j'cols:',wsmat.cols);
//6461*128*4
csmat:=tmat.create(800,64);
//merges:=tmat.create(800,128);
//writeln('************************',sizeof(csmat.mat^));
readafile('clusters.smat',csmat.mat,csmat.rows*csmat.cols*4);
//csmat.list;
//readafile('merges.smat',merges.mat,csmat.rows*csmat.cols*4);
getmem(mhist,5000);
readafile('merges.steps',mhist,4184);//2336);
writeln('____________');
mergecount:=500;//555;
cluscount:=mergecount;// div 2;//25;
//hiero;
fillchar(isin,sizeof(isin),0);
for i:=1 to mergecount do
begin
 if (isin[mhist^[i,1]]>0) or (isin[mhist^[i,2]]>0) then
 writeln(i,'   ',mhist^[i,1],'+',mhist^[i,2],'/');
 isin[mhist^[i,1]]:=i;
 isin[mhist^[i,2]]:=i;
end;
{
for i:=1 to mergecount do
 begin
   //ac:=getclus(MHIST^[I,1],1);
   //Bc:=getclusfirst(MHIST^[i,2],1);
   //writeln(i,'   ',mhist^[i,1],'+',mhist^[i,2],'/',cluscount);
   writeln(^j,i,'    ',getcluswords(mhist^[i,1],0),^j,getcluswords(mhist^[i,2],0));
 end;
 }
layout(mhist,mergecount);
 // layout(
 //readafile('merges.
 //smat',merges,
end;

type tnode=class(tobject)
 var parent:tnode;
 var c1,c2:tnode;
end;

type tnodes=class(tobject)
 head,tail:string;
end;
procedure tmylly.layout(mhist:p_mergehistory;mcount:word); //merges:tmat;
//var     mhist:p_mergehistory;//array[1..1000] of array[1..2] of word;
 var tf:text;counter:word;
   function wordlist(clus:word):string;
   var i:word;
   begin
     result:='';
     for i:=1 to csmat.cols do if csmat.wc(clus,i).w=0 then break else
       result:=result+'<span> '+sanat[csmat.wc(clus,i).w]+'</span> ';
   end;
   function wordhtmi(clus:word):string;
   var i:word;
   begin
     result:='';
     for i:=1 to csmat.cols do if csmat.wc(clus,i).w=0 then break else
       result:=result+' '+sanat[csmat.wc(clus,i).w];
   end;
function cluslist(clus:word):string;
   var i:word;
   begin
     result:='';
     //for i:=1 to 4 do if merges.wc(clus,i).w=0 then break else
     //  result:=result+'<b>'+sanat[merges.wc(clus,i).w]+'</b> ';
   end;

   procedure buildmergetree(current:word;ind:string);
   var m,cur:integer;cc:array[1..2] of word;cla:string;
   begin
     //writeln('*',current,'=[',mhist[current,1],';',mhist[current,1],'] ');
     cc[1]:=min(mhist^[current,1],mhist^[current,2]);
     cc[2]:=max(mhist^[current,1],mhist^[current,2]);
     counter:=counter+1;
     for m:=1 to 2 do
     begin
        cur:=mhist^[current,m];//cc[m];
        if cur=current then exit;  //just to make sure...
        if cur>0 then
        if cur<=cluscount then
        begin
          writeln('===',cur,'^',cluscount);
          writeln(ind,'<p class="',m,'">',m,wordlist(cur),'</p>');
          writeln(tf,ind,'p: ',wordhtmi(cur));

        end
        else
        begin
          writeln(tf,ind,'node id="n',counter,'"');
          writeln(ind,'<div id="m',current,'" idfref=',cur,'>',m,'<p class="clus">',cluslist(cur-cluscount),'</p>');
          writeln('next from',cur,' -cluscount',cluscount,'=',cur-cluscount);
          buildmergetree(cur-cluscount,ind+'  ');
          writeln(ind,'</div>');
        end;
     end;
   end;
var i:word;

begin
      assignfile(tf,'hiero.htmi');
     rewrite(tf);
     writeln(^j,'go',mergecount,'/',cluscount);
     writeln(tf,'hiero class="hiero:hiero.xsi"');
 mergecount:=500;
 cluscount:=mergecount;
 for i:=mergecount downto 500 do writeln(i,'=',mhist^[i,1],',',mhist^[i,2]); //exit;
for i:=mergecount downto 1 do
 if (mhist^[i,1]=0) or (mhist^[i,2]=0) or (mhist^[i,1]=mhist^[i,2])
  then continue else //begin writeln(i,'=',mhist^[i,1],',',mhist^[i,2]);continue; end else
 begin

  buildmergetree(i,'  ');break;

 end;
 close(tf);
 writeln('hiero.htmi closed');
end;


function tmat.getrow(no:word):p_scarcefield;
begin
result:=p_scarcefield(mat)+no*cols-1;
end;

procedure tmylly.hiero;
vAR //SUPERC: ARRAY[1..2000] of longword;
  joins:array[1..2000] of word;
  csums:array[1..2000] of longword;
  cor12,maxs:longword;
  rec,rec2:r_scarcefield;
  merges:tmat;
   mhist:p_mergehistory;//array[1..10000] of array[1..2] of word;
  cluscors:p_fullmat;

  procedure xmerge(c1,c2:word);
    var w1,w2,k:word;crec:r_scarcefield; row1,row2:p_scarcefield;
    begin  //consider 16 from each, select 16
       mergecount:=mergecount+1;
       csmat.mergerow(cluscors,wsmat,c1,c2,cluscount+mergecount,cluscount+mergecount);  //full cluster cors from clus*words
   end;

 function compare2(clu1,clu2:word):longword;
 var w1,w2:word;r1,r2:r_scarcefield;row1,row2:p_scarcefield;
 begin
    result:=0;
    if clu1<=cluscount then row1:=csmat.getrow(clu1) else
     row1:=merges.getrow(clu1-cluscount);
    if clu2<=cluscount then row2:=csmat.getrow(clu2) else
     row2:=merges.getrow(clu2-cluscount);
   for w1:=1 to 8 do
   begin
      r1:=(row1+w1-1)^;//csmat.wc(clu1,w1);
      if r1.w=0 then break;
      for w2:=1 to 8 do //csmat.cols do
      begin
        r2:=(row2+w2-1)^;//csmat.wc(clu2,w2);
        if r2.w=0 then break;
        result:=result+wsmat.topvalueof(r1.w,r2.w,8);
        result:=result+wsmat.topvalueof(r2.w,r1.w,8);
      end;
   end;
 end;
 function powercomp(clu1,clu2:word):longword;
 var c1,c2,w1,w2,ww:word;r1,r2,r3:r_scarcefield;row1,row2:p_scarcefield;rvar,rcor1,rcor2:longword;
 begin
 result:=0;
 for  c1:=1 to cluscount+mergecount do
 begin
   //if cluscors^[1000*clu1+c1-1]>0 then
   //for  cee:=1 to cluscount do
   if cluscors^[1000*clu2+c1-1]>0 then
   begin
     //writeln('had:',c1);
     result:=result+cluscors^[1000*clu1+c1-1]*cluscors^[1000*clu2+c1-1];
   end;
  end;
  if result=0 then writeln('unconnected:',clu1,'/',clu2);
end;

 procedure pickone(var maxc1,maxc2:word;maxs:longword;force:boolean);
    var c1,c2:word;
    begin
          maxs:=0;maxc1:=0;maxc2:=0;
      c1:=0;
      while c1<=cluscount+mergecount do
      begin
        c1:=c1+1;
        //write('m',joins[c1],'/',csums[c1]);
        if joins[c1]=0 then if csums[c1]>0 then
        //for c1:=1 to cluscount+mergecount do if joins[c1]=0 then if csums[c1]>0 then
        begin
           //write(^j,c1,sanat[csmat.wc(c1,1).w],iters);

          for c2:=c1 to cluscount+mergecount do if c1<>c2 then if joins[c2]=0 then //if csums[c2]>0 then
          begin
              if force then cor12:=powercomp(c1,c2) else
              begin
              cor12:=cluscors^[1000*c1+c2-1]; //cor12:=compare(c1,c2);
              //if c1>cluscount then if c2>cluscount then begin if cor12>0 then write(' ',cor12) else write(',');end;//cor12:=cor12 div 2;
              end;
              if c1>cluscount then cor12:=cor12 div 2;
              if c2>cluscount then cor12:=cor12 div 2;
              if cor12>maxs then
              begin
                  //if cor12>300000 then  begin    writeln(^j,'*********',iters,sanat[wsmat.wc(c1,1).w], sanat[wsmat.wc(c1,2).w],  '+',sanat[wsmat.wc(c2,1).w], sanat[wsmat.wc(c2,2).w],'========',cor12,'///// '); readln;end;
                  maxs:=cor12; maxc2:=max(c1,c2);maxc1:=min(c1,c2);
              end;
          end;
        end;
      end;
      //if maxc1>cluscount then if maxc2>cluscount then  write('JOJO',cor12,maxs);
      //writeln(^j,'!',maxs);
    end;

  var m1x,m2x:word; w,c1,c2,wc1,wc2,i,j,iters,maxc1,maxc2:word;

  begin
   writeln('HIEROx ',cluscount);
  getmem(mhist,1000);

  fillchar(joins,sizeof(joins),0);
  //fillchar(superc,sizeof(superc),0);
  merges:=tmat.create(csmat.rows,csmat.cols);
  write('dofull',cluscount);
  cluscors:=csmat.scarce2full(wsmat,cluscount);
   write('didfull',cluscount);

  for iters:=1 to cluscount do
  begin

    fillchar(csums,sizeof(csums),0);
    //writeln(^j,'iter:',iters,'/',cluscount,'/',mergecount);
    try
    for c1:=1 to cluscount+mergecount do
    begin
        csums[i]:=0;
        if joins[c1]>0 then continue else
        for c2:=1 to cluscount+mergecount do if joins[c2]=0 then if c1<>c2 then
        begin
          //if c1<=cluscount then rec:=csmat.wc(c1,wc1) else rec:=merges.wc(c1-cluscount,wc1);
          //if rec.w=0 then break;
          csums[c1]:=csums[c1]+cluscors^[1000*c1+c2-1]; //cluscors^[c1,c2];// //rec.s;
          //write(cluscors^[1000*c1+c2-1],' ');
        end;

        //writeln('====',csums[c1],^j);
        //if c1=233 then  write('[[',csums[c1],']]');
    end;
    except writeln('failsums');end;
    //for i:=1 to cluscount do begin csums[i]:=0;for j:=0 to cluscount do csums[i]:=csums[i]+cluscors^[cluscount*i+j-1];end;
    //writeln(^j,'gotsums:',iters);


    pickone(maxc1,maxc2,maxs,false);
    //writeln('!',mergecount,'=',sanat[csmat.wc(maxc1,1).w],maxc1,'!',sanat[csmat.wc(maxc2,1).w],maxc2);//,'!',csum[cluscount*1000+mergecount-1]);
    if maxc1=0 then
    begin
      //writeln('force the remaining');
      pickone(maxc1,maxc2,maxs,true);
        if maxc1=0 then
        begin
          writeln(' 1_with0',maxc2);
          break;
        end ;//else writeln('got one more');
        if maxc2=0 then
        begin
          write(' 2_with0:',maxc1,' @',iters);
          break;
        end;// else writeln('got one more');
        writeln('f:',iters,'  :',  maxc1,'/',maxc2,'  ',csums[maxc1],'/',csums[maxc2]);
    end;
    xmerge(maxc1,maxc2);
    //write(iters,'/',mergecount,' ');
    mhist^[iters,1]:=min(maxc1,maxc2);
    mhist^[iters,2]:=max(maxc1,maxc2);
    joins[maxc1]:=iters;
    joins[maxc2]:=iters;
    //writeln(iters,'=[',maxc1,'&',joins[maxc1],'/',maxc2,'&',joins[maxc2],']',mergecount);
    //write('.');
    //writeLN;


  {  FOR J:=1 TO 4 DO  WRITE(SANAT[csmat.wc(maxc1,j).w],'_');
    writeLN;
    for j:=1 to 4 do write(SANAT[csmat.wc(maxc2,j).w], '-');
    writeLN;
    }
  end;
  //   if mergecount>431 then
   i:=0;
   while i< cluscount do  //unjoined merges
   begin
     i:=i+1;
      if (joins[i+cluscount]=0) then //or (joins[i+mergecount]=0) then
      begin
          mergecount:=mergecount+1;
          writeln(i,'   ',mergecount,'#',cluscount,'   =',cluscount+mergecount,'+',i+cluscount);
          mhist^[mergecount,1]:=i+cluscount;
          mhist^[mergecount,2]:=cluscount+mergecount-1;//i+cluscount;
          joins[i+cluscount]:=mergecount;
          joins[i+mergecount-1]:=mergecount;
      end;
   end;

    maxs:=0;maxc1:=0;maxc2:=0;
    if 1=1 then begin
     for i:=1 to cluscount do if (joins[i]=0) then writeln(' NO:',i, sanat[csmat.wc(1,i).w]);
     for i:=1 to mergecount do if (joins[i+cluscount]=0) then // or (mhist[i,1]=mhist[i,2]) then
     begin
       writeln(^j,'"""""""""""',i+cluscount,':',mhist^[i,1],':',joins[mhist^[i,1]],'/',mhist^[i,2],':',joins[mhist^[i,2]],':');
       for j:=0 to 32 do if merges.wc(i,j).w=0 then continue else write(' ',sanat[merges.wc(i,j).w],merges.wc(i,j).s);
     end;

    writeln(^j,'clusters (',cluscount,'): ');
       {for i:=1 to cluscount do if joins[i]=0 then
       begin writeln(^j,i,'/', csums[i],':');
         for j:=1 to csmat.cols do if csmat.wc(i,j).w=0 then continue else //if joins[csmat.wc(i,j).w]=0 then continue else
         write('!*',sanat[csmat.wc(i,j).w],csmat.wc(i,j).s,' ');
       end;}
       writeln(^j,'merges (',mergecount,'): ');
     end;

  saveafile('clusters.smat',csmat.mat,csmat.rows*csmat.cols*4);
  writeln('MERGEGOUNT:',mergecount,'/clusts:',cluscount,'/r:',csmat.rows,'/c:',csmat.cols,'/csmat.file',csmat.rows*csmat.cols*4,'/sizof:',sizeof(csmat.mat^));
  saveafile('merges.smat',merges.mat,csmat.rows*csmat.cols*4);
  saveafile('merges.steps',mhist,mergecount*8);
 //layout(merges,mhist,mergecount);
end;