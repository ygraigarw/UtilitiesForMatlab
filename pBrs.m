function Pnt=pBrush(X,ObNms,VrNms,Obs,Vrs,Dsc,Pnt0);
%function Pnt=pBrush(X,ObNms,VrNms,Obs,Vrs,Dsc,Pnt0)
%
% PJ: 30.08.01
% 
%-Produces scatter matrix plots
%-Can mark (sets of) points in one of up to 5 colours

%for testing only
% X=randn(100,10);
% ObNms=[];
% VrNms=[];
% [n,p]=size(X);
% for i=1:n;
%    ObNms=strvcat(ObNms,sprintf('Obs%d',i));
% end;
% for j=1:p;
%    VrNms=strvcat(VrNms,sprintf('Var%d',j));
% end;
% Vrs=[1 3 5 7 9]';
% Dsc='test';
% Pnt0=[];

clf;

if isempty(X);
    fprintf(1,'Error: No data! Terminating\n');
    return;
else;
    [n,p]=size(X);
end;

if isempty(ObNms);
    ObNms=[];
    for i=1:n;
        ObNms=strvcat(ObNms,sprintf('o%d',i));
    end;
end;

if isempty(VrNms);
    VrNms=[];
    for i=1:p;
        VrNms=strvcat(VrNms,sprintf('v%d',i));
    end;
end;
    
if isempty(Vrs);
    Vrs=(1:p)';
end;

if isempty(Dsc);
    Dsc='BrushPlot';
end;

if isempty(Obs)==0;
    X=X(Obs==1,:);
    n=size(X,1);
    ObNms=ObNms(Obs==1,:);
end;

nSc=size(Vrs,1);%size of scatter matrix

MnMx=[nanmin(SwapMV(X))' nanmax(SwapMV(X))']; %axis XLim and YLim for plots, ignoring missing values

Bns=ones(nSc,20); %assumes histograms will have 20 bins, with constant centres for each variable

LliwB=['r';'m';'g';'c';'b']; %Colours for histograms
LliwP=['r.';'m.';'g.';'c.';'b.']; %Colours for plots (note dots)

Stp=0; %you currently want to pick points, so Stop=0
Start=1; %Start=1 initiates the scatter matrix below

while Stp==0; %keep ginputting until Stp=1 is set
    
    if Start==1;
        Btt=0; %Initiates scatter matrix plot below
        Start=0;
   else;
        [x,y,Btt]=ginput(1);%[x y Btt z]
        z=gca;
    end;
    
    % Use keyboard and left (right) mouse buttons to specify options
    % KEYBOARD
    % q=Quit
    % s=Save and Quit
    % c=Clear screen and start over
    % l=Lliw (colour) - loop through these
    % h=Help
    % MOUSE BUTTONS
    % l=Pick corners of rectangle within which to mark
    % r=Pick nearest point to mark (Not currently implemented)
    switch Btt; %
    case 113; %q Quit
        Stp=1;
        clf;
        break;
    case 115; %s End
        orient landscape;
        eval(['print -djpeg ' Dsc '.jpg']); 
        %eval(['print -dpsc ' Dsc '.ps']);
        clf;
        Stp=1;
        break;
    case {99,0}; %c Clear, 0 at startup - start again
        clf;
        if isempty(Pnt0);
            Pnt=zeros(n,5);
        else;
            Pnt=Pnt0;
        end;
        LL=1; %First colour (Lliw) 
        NewCrn=1; %Look for first corner for marking
        h=ones(nSc*nSc,1).*-99;
        for k1=1:nSc;
            for k2=1:nSc;
                subplot(nSc,nSc,nSc*(k1-1)+k2);
                if k1==k2;
                    t=X(:,Vrs(k1))~=-99; tx=X(t==1,Vrs(k1));
                    [junk,Bns(k1,:)]=hist(tx,20);
                    bar(Bns(k1,:),junk,0.7,'k');
                    set(gca,'XLim',[MnMx(Vrs(k1),1:2)]);
                    pdefs;
                else;
                    t=X(:,Vrs(k2))~=-99 & X(:,Vrs(k1))~=-99; tx=X(t==1,Vrs(k2)); ty=X(t==1,Vrs(k1));
                    plot(tx,ty,'k.');
                    set(gca,'XLim',[MnMx(Vrs(k2),1:2)]);
                    set(gca,'YLim',[MnMx(Vrs(k1),1:2)]);
                    pdefs;
                end;
                if k2==1; ylabel(VrNms(Vrs(k1),:)); end;
                if k1==nSc; xlabel(VrNms(Vrs(k2),:)); end;
            end;
        end;
    case 108; %l Lliw - next colour
        LL=LL+1; 
        if LL>5; 
            fprintf(1,'No more colours remaining sorry!\n');
            fprintf(1,'Looping through colours again!\n');
            LL=1;
        end;
        fprintf(1,'Current colour is %s\n',LliwB(LL,:));            
    case 1; %a corners
        if NewCrn==1;
            xb=x;yb=y;
            zb=z; %remember the subplot
            NewCrn=0;
        else;
            if z~=zb;
                fprintf(1,'Different subplot. Use same one!');
            else;
                xt=x;yt=y;zt=z;
                NewCrn=1;
                IdnGCA=nSc^2+1-find(get(gcf,'children')==zt);
                vx=rem(IdnGCA,nSc);if vx==0; vx=nSc; end; %identify variables
                vy=floor((IdnGCA-1)/nSc)+1;
                %fprintf(1,'x-axis is %d : Variable %s. y-axis is %d : Variable %s.\n',vx,VrNms(vx,:),vy,VrNms(vy,:));
                clear t; t(1)=xb;t(2)=xt;xb=min(t);xt=max(t); %make sure that xb<=xt
                clear t; t(1)=yb;t(2)=yt;yb=min(t);yt=max(t); %make sure that yb<=yt
                tPnt=X(:,Vrs(vx))>=xb & X(:,Vrs(vx))<xt & X(:,Vrs(vy))>=yb & X(:,Vrs(vy))<yt & X(:,Vrs(vx))~=-99 & X(:,Vrs(vy))~=-99;
                fprintf(1,'New cases are:\n');
                tmp=find(tPnt==1);
                if size(tmp,1)>0;
                    for i=1:sum(tPnt==1);
                        fprintf(1,'%s\n',ObNms(tmp(i),:));
                    end;
                    Pnt(tPnt,LL)==1;
                    for k1=1:nSc;
                        for k2=1:nSc;
                            subplot(nSc,nSc,nSc*(k1-1)+k2);
                            if k1==k2;
                                hold on; [a,b]=hist(X(tPnt,Vrs(k1)),Bns(k1,:));
                                bar(b,a,0.9,LliwB(LL,:));
                                set(gca,'XLim',[MnMx(Vrs(k1),1:2)]);
                                pdefs;
                            else;
                                hold on; plot(X(tPnt,Vrs(k2)),X(tPnt,Vrs(k1)),LliwP(LL,:));
                                set(gca,'XLim',[MnMx(Vrs(k2),1:2)]);
                                set(gca,'YLim',[MnMx(Vrs(k1),1:2)]);
                                pdefs;
                            end;
                        end;
                    end;
                else;
                    fprintf(1,'No points picked. Try again!\n');
                end;
            end;
        end;
    case 3; %b nearest point
    otherwise;
        fprintf(1,'Not understood! Redo');
    end;
end;

