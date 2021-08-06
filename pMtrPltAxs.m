function Ax=pMtrPltAxs(nRow,nClm,RowLbl,ClmLbl,S);

if nargin==0;
    nRow=6;
    nClm=3;
end;

if nargin<=2;
    for iR=1:nRow; RowLbl{iR}=sprintf('Row%g\n',iR); end;
    for iC=1:nClm; ClmLbl{iC}=sprintf('Col%g\n',iC); end;
end;

if nargin<=4;
    S.Gap.Y=0.06; % Fraction gap between two subplots in y direction
    S.Gap.T=0.00; % Fraction gap above top row (for the title)
    S.Gap.B=0.10; % Fraction gap below the bottom row
    
    S.Gap.X=0.05; % Fraction gap between two subplots in x direction
    S.Gap.L=0.10; % Fraction gap on left hand size (for ylabel)
    S.Gap.R=0.01; % Fraction gap on right hand size
    
    S.Ext.X=0.5; % Fraction of the x-extent of full screen to use
    S.Ext.Y=1; % Fraction of the y-extent of full screen to use
    
    S.Font.A=20;
    S.Font.L=30;
end;

% Create a full screen figure
h1=figure('units','normalized','outerposition',[0 0 1 1]);
posfig = get(h1,'Position');

% Create and plot into axes
Ax = gobjects(nRow,nClm);

% Set appropriate spacings around subplots
gy=S.Gap.Y;
gt=S.Gap.T;
gb=S.Gap.B;
gx=S.Gap.X;
gl=S.Gap.L;
gr=S.Gap.R;

% Width and height for individual subplots
w=(S.Ext.X-gl-gr-(nClm-1)*gx)/nClm;
h=(S.Ext.Y-gb-gt-(nRow-1)*gy)/nRow;

for i=1:nRow;
    k=nRow+1-i; %so that plot looks more natural (row 1 on top)
    for j=1:nClm;
        
        % Position each subplot
        axPos=[posfig(1) + (gl+(w+gx)*(j-1))*posfig(3) ...
            posfig(2) + (gb+(h+gy)*(i-1))*posfig(4) ...
            posfig(3)*w ...
            posfig(4)*h];
        
        Ax(k,j) = axes('Position',axPos);
        set(gca,'box','on','xgrid','on','ygrid','on','fontsize',S.Font.A,'fontname','garamond');
        
        % ylabels on left hand side
        if j==1;
            ylabel(RowLbl{k},'fontsize',S.Font.L,'interpreter','latex');
        end;
        
        % titles on top
        if i==1;
            xlabel(ClmLbl{j},'fontsize',S.Font.L,'interpreter','latex');
        end;
        
    end;
end;

if nargin==0;
    pGI('Test-pMtrPltAxs',2);
end;

return;