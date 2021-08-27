tTckY=get(gca,'ytick');tTckY=tTckY([1 end]);
tTckX=get(gca,'xtick');tTckX=tTckX(1);
tLblY=get(gca,'yticklabel');tLblY=tLblY([1 end]);
tFntSiz=get(gca,'fontsize');
tFntNam=get(gca,'fontname');
set(gca,'yticklabel',[]);
text(tTckX(1),tTckY(1),tLblY{1},'fontsize',tFntSiz,'fontname',tFntNam,'horizontalalignment','center');
text(tTckX(1),tTckY(2),tLblY{2},'fontsize',tFntSiz,'fontname',tFntNam,'horizontalalignment','center');
