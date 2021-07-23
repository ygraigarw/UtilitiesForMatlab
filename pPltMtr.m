function ax=pPltMtr(nRow,nClm,Pst);
%function ax=pPltMtr(nRow,nClm,Pst);
%
%Create nRow x nClm subplots with minimum white space
%Use pAxsFcs to get a particular axes in focus (as "gca")
%Use pPltMtrTid to tidy up after plotting, before printing

%% Manage whitespace around outside
if nargin==2;
   xb=0.05;yb=0.05;
   xt=0.99;yt=0.99;
   lx=xt-xb;ly=yt-yb;
else;
   xb=Pst(1);yb=Pst(2);
   xt=Pst(3);yt=Pst(4);
   lx=Pst(5);ly=Pst(6);
end;

%% Locations of axes
DltX=lx/nClm;
DltY=ly/nRow;

ax=nan(nRow*nClm,1);
%% Create axes
for i=1:nRow*nClm;

   Row=floor((i-1)/nClm)+1;
   Clm=i-(Row-1)*nClm;
   
   ax(i)=axes('position',[xb+(Clm-1)*DltX yb+ly-Row*DltY DltX DltY],'box','on');
   
   %% Manange ticks
   if Row==nRow;
      if Clm<nClm;
         t=get(ax(i),'xtick');
         set(ax(i),'xtick',t(1:end-1));
      end;
   else;
      set(ax(i),'xticklabel',[]);
   end;
   if Clm==1;
      if Row>1;
         t=get(ax(i),'ytick');
         set(ax(i),'ytick',t(1:end-1));
      end;
   else;
      set(ax(i),'yticklabel',[]);
   end;
   
end;

return;