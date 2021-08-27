function pAxsLmtDrc(Dlt);

if nargin==0;
    Dlt=0.1;
end;

set(gca,'XLim',[0 360],'XTick',[0:90:360]);

pAxsLmt(Dlt);

return;