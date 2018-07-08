

procedure tmylly.dolayout;
var mhist:p_mergehistory;//merges:tmat;
Var F : File Of byte;i,ac,bc:word;
  isin:array[0..2000] of word;
  function getcluswords(m,cc:word):string;
  var j:word;
  begin
    result:='['+inttostr(m)+'/'+inttostr(mhist^[m-cluscount,1])+']';
    if m=0 then exit;
    if m<=cluscount then
    begin
      for j:=1 to 5 do result:=result+'-'
       +sanat[csmat.wc(m,j).w];
        exit;
    end;
    if CC>100 then begin result:=result+('LOOP');EXIT;END;
    if m=mhist^[m,1] then begin result:=result+'SELFREF';EXIT;END;
    if m>cluscount then
     begin
       result:=result+'('+inttostr(m)+'>'+inttostr(mhist^[m-cluscount,1])+')'+getcluswords(mhist^[m-cluscount,1],cc+1);
       //for i:=1 to
      //cc:=cc+1; if cc>20 then break;
     end  ;
     //RESULT:=M
  end;
var j:word;
begin
//3308032
//6461*128*4
//csmat:=tmat.create(1000,64);
//merges:=tmat.create(800,128);
//writeln('************************',sizeof(csmat.mat^));
//readafile('clusters.smat',csmat.mat,csmat.rows*csmat.cols*4);
//csmat.readfile('clusters2.smat',0);
//csmat.list;
//readafile('merges.smat',merges.mat,csmat.rows*csmat.cols*4);
writeln(^j^j^j'DOLAYOUT w:',wsmat.cols,'*',wsmat.rows,' /clust:',cluscount);
getmem(mhist,10000);
mergecount:=readafile('merges.steps',mhist,0);//2336);
mergecount:=mergecount div 6;
writeln('____________MERGES:',mergecount);
//mergecount:=200;//555;
cluscount:=mergecount;// div 2;//25;
//hiero;
fillchar(isin,sizeof(isin),NOWORD);
for i:=1999 to mergecount-1 do
begin
 //if (isin[mhist^[i,1]]>0) or (isin[mhist^[i,2]]>0) then
 writeln(i,'   ',sana(csmat.wc(mhist^[i,1],1).w),'+',sana(csmat.wc(mhist^[i,2],1).w),'/',mhist^[i,1],'-',mhist^[i,2]);
 isin[mhist^[i,1]]:=i;
 isin[mhist^[i,2]]:=i;
end;
writeln('listed');
for i:=1999 to mergecount do
 begin
   //ac:=getclus(MHIST^[I,1],1);
   //Bc:=getclusfirst(MHIST^[i,2],1);
   //writeln(i,'   ',mhist^[i,1],'+',mhist^[i,2],'/',cluscount);
   writeln(^j,i,'    ',getcluswords(mhist^[i,1],0),^j,getcluswords(mhist^[i,2],0));
 end;

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
     //result:=result+' '+sanat[csmat.wc(clus,i).w];
   end;
   function wordhtmi(clus:word):string;
   var i:word;
   begin
     result:='';//+inttostr(clus);
     for i:=1 to csmat.cols do if csmat.wc(clus,i).w=0 then break else
       //result:=result+'<span> '+sanat[csmat.wc(clus,i).w]+'</span> ';
       result:=result+' '+sana(csmat.wc(clus,i).w);
   end;

   procedure buildmergetree(current:word;ind:string);
   var i,m,cur:integer;cc:array[1..2] of word;cla:string;
   begin
     write(^j,ind,current+cluscount,': ',wordlist(current+cluscount),' [',mhist^[current,1],':',mhist^[current,2],']');
     cc[1]:=min(mhist^[current,1],mhist^[current,2]);
     cc[2]:=max(mhist^[current,1],mhist^[current,2]);
     counter:=counter+1;
     for m:=1 to 2 do
     begin
        cur:=mhist^[current,m];//cc[m];
        //if cur=current then exit;  //just to make sure...
        if cur>0 then
        if cur<=cluscount then
        begin
          write(^j,ind,' P',cur,' ',wordlist(cur));
          //writeln(ind,'<p class="',m,'">',m,wordlist(cur),'</p>');
          writeln(tf,ind,'p: ');//,wordhtmi(cur));
          for i:=1 to csmat.cols do if csmat.wc(cur,i).w=0 then break else
            writeln(tf,ind+'   span: '+sanat[csmat.wc(cur,i).w]);
        end
        else
        begin
         write(^j,ind,' D',cur,' ',wordlist(cur));
          writeln(tf,ind,'node id="n',counter,'"  cur="',cur,'": ',wordhtmi(cur));
          //writeln(ind,'<div id="m',current,'" idfref=',cur,'>',m,'<p class="clus">',cluslist(cur-cluscount),'</p>');
          //writeln('next from',cur,' -cluscount',cluscount,'=',cur-cluscount);
          buildmergetree(cur-cluscount,ind+'    ');
          //writeln(ind,'</div>');
        end;
     end;
   end;
var i:word;

begin
      assignfile(tf,'hiero.htmi');
     rewrite(tf);
     writeln(^j,'<h1>golayout</h1>',mergecount,'/',cluscount);
     writeln(tf,'hiero class="hiero:hiero.xsi"');
 //mergecount:=500;
 //cluscount:=mergecount;
 //for i:=mergecount downto 500 do writeln(i,'=',mhist^[i,1],',',mhist^[i,2]); //exit;
 cluscount:=cluscount-1;
for i:=mergecount downto 1 do
 if (mhist^[i,1]=0) or (mhist^[i,2]=0) or (mhist^[i,1]=mhist^[i,2])
  then continue else //begin writeln(i,'=',mhist^[i,1],',',mhist^[i,2]);continue; end else
 begin
  counter:=0;
  buildmergetree(i,'  ');break;

 end;
 close(tf);
 writeln('hiero.htmi closed');
end;
procedure tmylly.clustcors(var cc:tcluscors);
var i,j:word;
begin
cc:=csmat.scarce2full(wsmat,cluscount);
//csmat.list;
writeln('????????????????');
//cc.list(csmat);

end;

procedure tmylly.hiero(cluscors:tcluscors);
vAR
  joins:array[0..2000] of word;
  //!csums:array[1..2000] of longword;
  cor12:longword;
  rec,rec2:r_scarcefield;
  merges:tmat;
   mhist:p_mergehistory;
  //p_fullmat;
  iters:word;
  procedure xmerge(old1,old2:word);
    var cc1,cc2,k:word;crec:r_scarcefield; row1,row2:p_scarcefield;
      row:word;asum,avali:longword;
    begin  //consider 16 from each, select 16
       mergecount:=mergecount+1;
       row:=cluscount+mergecount;  //???zero-base. 256 at first round
       //old1:=old1-1;
       //old2:=old1-1;
       //if iters<4 then writeln(^j,^j,'mergeto:',row);//readln;
       //csmat.mergerow(cluscors,wsmat,c1,c2,cluscount+mergecount,cluscount+mergecount);  //full cluster cors from clus*words
       csmat.setsum(row,0);
       asum:=0;
       //write(^j,sana(csmat.wc(old1,1).w),sana(csmat.wc(old2,1).w),':');
       //write('==',sana(old1),sana(old2),':');

       for cc1:=1 to row do //row-1 do //if row<>j then if sums^[j]>0 then        //for each pair of cluster
       //if cc1<>old1 then if cc1<>old2 then
       begin
         //avali:=cluscors.get(old1,cc1)+cluscors.get(old2,cc1) div 3;
         avali:=min(cluscors.get(old1,cc1),cluscors.get(old2,cc1));
          cluscors.setval(row,cc1,avali);
          cluscors.setval(cc1,row,avali);
          asum:=asum+avali;
          //!!avali:=round(cluscors^[(old1-1)*cluscount+cc1]+cluscors^[(old2-1)*cluscount+cc1] div 2);//(1+10*(csums[c1]*csums[c2]));
          //!cluscors^[row*cluscount+cc1]:=cluscors^[(row)*cluscount+cc1]+avali;// div (1+word((csums+c1*2)^));
          //!cluscors^[cc1*cluscount+row]:=cluscors^[cc1*cluscount+row]+avali;// div (1+word((csums+c1*2)^));
          //!asum:=asum+cluscors^[row*cluscount+cc1];
         //avali:=round(sqrt(1+resmat^[old1*cluscount+c1-1]*resmat^[old2*cluscount+c1-1]));//(1+10*(csums[c1]*csums[c2]));
         //avali:=round(sqrt(1+cluscors^[(old1-1)*cluscount+cc1]*cluscors^[(old2-1)*cluscount+cc1]));//(1+10*(csums[c1]*csums[c2]));
          //avali:=round(cluscors^[(old1-1)*cluscount+cc1]+cluscors^[(old2-1)*cluscount+cc1]);//(1+10*(csums[c1]*csums[c2]));
          //if avali>2000 then write(sana(csmat.wc(cc1+1,1).w),cluscors^[(old1-1)*cluscount+cc1],'/',cluscors^[(old2-1)*cluscount+cc1],',');
          //RESMAT^[row*cluscount+c1-1]:=RESMAT^[row*cluscount+c1-1]+avali;// div (1+word((csums+c1*2)^));
          //RESMAT^[c1*cluscount+row-1]:=RESMAT^[c1*cluscount+row-1]+avali;// div (1+word((csums+c1*2)^));
          //if iters=1 then write(avali,'_',asum,' ');
         //if avali>50000 then   writeln('big:',avali,'/from:',old1,':',cluscors^[(old1-1)*cluscount+cc1],'/',old2,':',cluscors^[(old2-1)*cluscount+cc1]);
       end;
      //if iters<4  then writeln(^j,old1,'!',old2,' ');
       csmat.setsum(row,asum);
       //if asum>0 then write('\\',row,'=' ,asum,'.');
       //if row>500 then     write(^j,'XMERGE ZERO', row,'=',csmat.getsum(row+1),'&&&&',mergecount);
       //csmat.sortedrow(xlinep,cluscount,resp,16,16);
               { asum:=0;
         for c1:=0 to rcount-1 do //if row<>j then if sums^[j]>0 then        //for each pair of cluster
         // for j:=1 to rcount do if row<>j then if sums^[j]>0 then        //for each pair of cluster
         if c1<>old1 then if c1<>old2 then
         begin
           avali:=round(sqrt(1+resmat^[old1*cluscount+c1-1]*resmat^[old2*cluscount+c1-1]));//(1+10*(csums[c1]*csums[c2]));
           RESMAT^[row*cluscount+c1-1]:=RESMAT^[row*cluscount+c1-1]+avali;// div (1+word((csums+c1*2)^));
           RESMAT^[c1*cluscount+row-1]:=RESMAT^[c1*cluscount+row-1]+avali;// div (1+word((csums+c1*2)^));
           asum:=asum+resmat^[row*cluscount+c1-1];
          end;
          sums^[row]:=asum;
        }
   end;

{ function compare2(clu1,clu2:word):longword;
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
 end;}
 function powercomp(clu1,clu2:word):longword;  //to get similarities for the last few unclustered clusters
 var c1,c2,w1,w2,ww:word;r1,r2,r3:r_scarcefield;row1,row2:p_scarcefield;rvar,rcor1,rcor2:longword;
 begin
 result:=0;
 for  c1:=1 to cluscount+mergecount do
 begin
   //if cluscors^[cluscount*clu1+c1-1]>0 then
   //for  cee:=1 to cluscount do
    //if cluscors^[cluscount*(clu2-1)+c1-1]>0 then
    if cluscors.get(clu2,c1)>0 then
   begin
     //writeln('had:',c1);
   result:=result+cluscors.get(clu1,c1)*cluscors.get(clu2,c1);
    //result:=result+cluscors^[cluscount*(clu1-1)+c1-1]*cluscors^[cluscount*(clu2-1)+c1-1];
   end;
  end;
  write('X');
  //if result=0 then writeln(' unconnected:',clu1,'/',clu2);
end;
function info(it:word):string;
var c1,c2,i:word;

begin
c1:=mhist^[it,1];
c2:=mhist^[it,2];
result:='!!!';
result:=result+csmat.listc(mhist^[iters,1]);
result:=result+'    +     ';
try
result:=result+csmat.listc(mhist^[iters,2])+'///';
except writeln('failinfo:',it,'/',c1,'/',c2,'@',iters);end;
//write(result,'*');
end;

 function pickone(var maxc1,maxc2:word;force:boolean):longword;
    var c1,c2,i,thirdparty:word;
    begin
      result:=0;maxc1:=0;maxc2:=0;
      c1:=0;
      while c1<=cluscount+mergecount do
      begin
        c1:=c1+1;
        //write('X',sana(csmat.wc(c1,1).w));
        //if csmat.sum(c1)<2 then continue;
        if joins[c1]=0 then if csmat.sum(c1)>0 then
        //for c1:=1 to cluscount+mergecount do if joins[c1]=0 then if csums[c1]>0 then
        begin
          //write(' \',csmat.sum(c1));
           //write(^j,c1,sanat[csmat.wc(c1,1).w],iters);
          for c2:=c1 to cluscount+mergecount do if c1<>c2 then if joins[c2]=0 then //if csums[c2]>0 then
          begin
              if force then cor12:=powercomp(c1,c2)
             else
              begin
              cor12:=4*cluscors.get(c1,c2); //0-based  cor12:=compare(c1,c2);

                  if (c1>cluscount) and (c2>cluscount) then cor12:=cor12 div 2
                  //else if (c2>cluscount)  then cor12:=cor12 div 2;
              //if  (c2<=cluscount) then cor12:=round(cor12*1.0);
              //begin if cor12>0 then write(' ',cor12) else write(',');end;//cor12:=cor12 div 2;
              end;
              //if (c1>cluscount) or  (c2>cluscount) then cor12:=cor12 div 2;
              //if (c1<cluscount) and  (c2<cluscount) then cor12:=cor12 * 2;
              //if cor12>30000 then
              //writeln(^j,'*********',iters,csmat.listc(c1), '  /  ',csmat.listc(c2),'========',cor12,'///// ');
              if cor12>result then
              begin
                  //
                  result:=cor12; maxc2:=c2;maxc1:=c1;//maxc2:=max(c1,c2);maxc1:=min(c1,c2);
                  if result>0 then write('!');
              end;
          end;
        end;
      end;
      if result=0 then
      begin
        //for i:=0 to cluscount+mergecount do  if joins[i]>0 then
        //begin write(cluscors^[1000*(maxc1-1)+i]);end;
        writeln('ZERO MAX',cluscount+mergecount,'/',mergecount,' PRESS ENTER');//readln;
      end else
    if (maxc1>cluscount) or (maxc2>cluscount)  then  write(cor12,'..') else write(cor12,',,');

      //writeln(^j,'#',result);
    end;
  //  HIERO =================================================================================//
  var m1x,m2x:word; w,c1,c2,wc1,wc2,i,j,maxc1,maxc2:word;     maxs,turha:longword;
  begin
  writeln(csmat.rows,' HIEROx ',cluscount,'->',mergecount);
  getmem(mhist,20000);

  fillchar(joins,sizeof(joins),0);
  //fillchar(superc,sizeof(superc),0);
  merges:=tmat.create(csmat.rows,csmat.cols);
  //cluscount:=200;
  writeln(csmat.rows,'dofull',cluscount);
  //cluscors:=csmat.scarce2full(wsmat,cluscount);
  //cluscors.list(csmat);
  //exit;
  //for i:=1 to csmat.rows do for j:=1 to cluscount do
  //writeln(san a(csmat.wc(i,1).w),' ',sana(csmat.wc(i,2).w),' ',csmat.sum(i));
  writeln('gotcors');
  for iters:=1 to cluscount do
  begin
    //fillchar(csmat.sums^,csmat.rows*4,0);
    csmat.rows:=cluscount+mergecount;
    csmat.clearsums;
    write('"',iters);
    //fillchar(csmat.sums^,sizeof(csums),0);
    //if iters<3 then writeln(^j,'iter:',iters,'/',cluscount,'/',mergecount,'/rows:',csmat.rows);
    //for i:=1 to cluscount do writeln(sana(csmat.wc(i,1).w),csmat.sum(i));
    try
    //if iters <3 then writeln(^j,'>>>>>>>',cluscount+mergecount,'==',csmat.getsum(iters));
    for c1:=1 to cluscount+mergecount do //if joins[c1]>0 then
    begin
        //csmat.setsum(i,0);
        //if joins[c1]=0 then //continue else
        for c2:=1 to cluscount+mergecount+1 do if joins[c2]=0 then if c1<>c2 then
        begin
          //if c1<=cluscount then rec:=csmat.wc(c1,wc1) else rec:=merges.wc(c1-cluscount,wc1);
          //if rec.w=0 then break;
          //write(cluscors.get(c1,c2),' ');
         csmat.incsum(c1,cluscors.get(c1,c2)); //cluscors^[c1,c2];// //rec.s;
          //write(csmat.getsum(c1), ' ');
        end;
        //writeln;
        //if iters <3 then write('--',c1,'==',csmat.getsum(c1));
        //if c1=233 then  write('[[',csums[c1],']]');
    end;
    //for i:=1 to cluscount do writeln(sana(csmat.wc(i,1).w),csmat.sum(i));
    //if iters mod 50 =2 then
    //writeln('======',iters,'==',csmat.sum(iters));
    //for i:=0 to cluscount do begin write(^j,^j,i,':');for j:=0 to cluscount-1 do  write(cluscors^[cluscount*i+j],' ');end;
    except writeln('failsums');end;
    //for i:=1 to cluscount do begin csums[i]:=0;for j:=0 to cluscount do csums[i]:=csums[i]+cluscors^[cluscount*i+j-1];end;
    //writeln(^j,'gotsums:',iters);


    maxs:=pickone(maxc1,maxc2,false);
    //write(^j,'!pick:',mergecount,'=',sana(csmat.wc(maxc1,1).w),maxc1,':');
    //write(maxc2,sana(csmat.wc(maxc2,1).w),maxc2,'=',maxs);//,'!',csum[cluscount*cluscount+mergecount-1]);

    if maxc1=0 then
    begin
      writeln('force::',iters);
      maxs:=pickone(maxc1,maxc2,true);
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
        //writeln('f:',iters,'  :',  maxc1,'/',maxc2,'  ',csmat.sum(maxc1),'/',csmat.sum(maxc2));
    end;
    //writeln(listc(maxc1),listc(maxc2));
    xmerge(maxc1,maxc2);
    //write(iters,'/',mergecount,' ');
    mhist^[iters,1]:=min(maxc1,maxc2);  //mhist is one-based, and so are its entries
    mhist^[iters,2]:=max(maxc1,maxc2);
    mhist^[iters,3]:=maxs;
    joins[maxc1]:=iters;
    joins[maxc2]:=iters;
    //writeln(iters,'[',maxc1,'&/',maxc2,']',info(iters),'  =   ',maxs);
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
          //writeln(i,'   ',mergecount,'#',cluscount,'   =',cluscount+mergecount,'+',i+cluscount);
          mhist^[mergecount,1]:=i+cluscount;
          mhist^[mergecount,2]:=cluscount+mergecount-1;//i+cluscount;
          mhist^[mergecount,3]:=0;//i+cluscount;
          joins[i+cluscount]:=mergecount;
          joins[i+mergecount-1]:=mergecount;
      end;
   end;

    maxs:=0;maxc1:=0;maxc2:=0;
    if 1=1 then begin
     for i:=1 to cluscount do if (joins[i]=0) then writeln(' NO:',i, sana(csmat.wc(1,i).w));
     for i:=1 to mergecount do if (joins[i+cluscount]=0) then // or (mhist[i,1]=mhist[i,2]) then
     begin
       try
       writeln(^j,'"""""""""""',i+cluscount,':',mhist^[i,1],':',joins[mhist^[i,1]],'/',mhist^[i,2],':',joins[mhist^[i,2]],':!!');
       for j:=0 to 32 do if merges.wc(i,j).w=0 then continue else write(' ',sana(merges.wc(i,j).w),merges.wc(i,j).s);
       except writeln('>>>>>>>>>>>>>failed report zero');readln;end
     end;

    writeln(^j,'clusters (',cluscount,'): ');
    //csmat.savenonzeroes('turha');readln;
       {for i:=1 to cluscount do if joins[i]=0 then
       begin writeln(^j,i,'/', csums[i],':');
         for j:=1 to csmat.cols do if csmat.wc(i,j).w=0 then continue else //if joins[csmat.wc(i,j).w]=0 then continue else
         write('!*',sanat[csmat.wc(i,j).w],csmat.wc(i,j).s,' ');
       end;}
     end;
  for i:=1 to mergecount do  //populate scarce clustermart ix with strongest words in merged clusters
  begin   //this needs honing
    csmat.mergewords(cluscount+i,mhist^[i,1],mhist^[i,2],cluscount);
  end;
  //for i:=1 to mergecount do
  //writeln(i,'   ',mhist^[i,1],'+',mhist^[i,2]);
  //saveafile('clusters.smat',csmat.mat,csmat.rows*csmat.cols*4);
  //csmat.savenonzeroes('clusters3.smat');
  writeln('MERGEGOUNT:',mergecount,'/clusts:',cluscount);//
  try
  writeln('try joins');
          for i:=19999 to mergecount do
        begin
         //if (isin[mhist^[i,1]]>0) or (isin[mhist^[i,2]]>0) then
          try
          if (mhist^[i,1]>cluscount) and (mhist^[i,2]>cluscount) then
           write('******************************');
         writeln(i,'::::',sana(csmat.wc(mhist^[i,1],1).w),'+',sana(csmat.wc(mhist^[i,2],1).w),'/',mhist^[i,1],'-',mhist^[i,2],'=',mhist^[i,3]);
          except writeln('failed list merges..PRESS enter');end;
        end;
  except writeln('failed joins');end;
  writeln('didjoins PRESS ENTER');//readln;
  merges.savefile('merges.smat',0);
  saveafile('merges.steps',mhist,mergecount*6);
  //saveafile('merges.smat',merges.mat,csmat.rows*csmat.cols*4);
  //saveafile('merges.steps',mhist,mergecount*8);
 //layout(merges,mhist,mergecount);
end;


