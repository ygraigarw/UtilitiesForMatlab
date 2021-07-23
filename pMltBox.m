function pMltBox(D);
%
% function pMltBox(D);
% You need to specify a structure D with fields nBox, Lct, Wdt, Clr, Thr, X (and optionally Lbl)
% See example (under nargin==0)

if nargin==0;
    clf;
    D.nBox=4; %number of box plots
    D.Lct=[1 2 3 4]'; %x-locations of box plots
    D.Wdt=ones(4,1)*0.4; %x-half-widths of box plots
    D.Clr={'r';'m';'g';'c';}; %colours of box plots
    D.Thc=ones(4,1)*2; %thickness of lines for box plots
    D.X{1}=randn(100,1); %data set 1
    D.X{2}=randn(10,1)*1.2+2; %data set 2
    D.X{3}=randn(30,1)+0.8-1; %data set 3
    D.X{4}=randn(80,1)*0.1; %data set 4
    D.Lbl={'A';'B';'C';'D'}; %optional data labels for x-axis
end;

for iB=1:D.nBox;
    pBoxWhs(D.Lct(iB),D.Wdt(iB),D.X{iB},D.Clr{iB},D.Thc(iB));
    if isfield(D,'Lbl')==1;
        set(gca,'xtick',D.Lct);
        set(gca,'xticklabel',D.Lbl);
    end;
end;

grid on;
box on;

