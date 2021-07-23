function pBoxWhs(Lct,Wdt,X, Clr, Thc);

if nargin==0;
    clf;
    Lct=1; %location on x axis
    Wdt=0.4; %half width on x axis
    Clr='r'; %color
    Thc=2; %line thickness
    X=randn(100,1); 
end;

%% Key summary statistics
Q=quantile(X,[0.025 .25 .5 .75 .975]); %quantiles to use
Avr=mean(X); %average

hold on;
plot((Lct-Wdt)*ones(2,1),Q([2 4]),'color',Clr,'linewidth',Thc);
plot((Lct+Wdt)*ones(2,1),Q([2 4]),'color',Clr,'linewidth',Thc);
plot([Lct-Wdt,Lct+Wdt],Q(2)*ones(2,1),'color',Clr,'linewidth',Thc);
plot([Lct-Wdt,Lct+Wdt],Q(3)*ones(2,1),'color',Clr,'linewidth',Thc);
plot([Lct-Wdt,Lct+Wdt],Q(4)*ones(2,1),'color',Clr,'linewidth',Thc);
plot([Lct-Wdt,Lct+Wdt],Avr*ones(2,1),'color',Clr,'linewidth',Thc,'linestyle','--');
plot(Lct*ones(2,1),Q([4 5]),'color',Clr,'linewidth',Thc);
plot(Lct*ones(2,1),Q([1 2]),'color',Clr,'linewidth',Thc);
plot([Lct-Wdt/2,Lct+Wdt/2],Q(1)*ones(2,1),'color',Clr,'linewidth',Thc);
plot([Lct-Wdt/2,Lct+Wdt/2],Q(5)*ones(2,1),'color',Clr,'linewidth',Thc);

return;
