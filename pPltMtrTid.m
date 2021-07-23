function pPltMtrTid(nRow,nClm,ax);

for i=1:nRow*nClm;

   Row=floor((i-1)/nClm)+1;
   Clm=i-(Row-1)*nClm;
   
   %% Manange ticks
   if Row==nRow;
   else;
      set(ax(i),'xticklabel',[]);
   end;
   if Clm==1;
   else;
      set(ax(i),'yticklabel',[]);
   end;
   
end;

return;