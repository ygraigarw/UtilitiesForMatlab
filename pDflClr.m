set(0, 'DefaultFigureColormap', jet(128))
col = jet(128); col=col(end:-1:1,:);col=col(21:end-20,:); nc=size(col,1);
col=col(round(linspace(1,nc,5)),:);
set(gcf,'defaultAxesColorOrder',col)
