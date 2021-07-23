function pPlotCorr(Xo,Nms,SprOrPrs,ClrOrBw,NmsOrNmb,Co);
%function pPlotCorr(Xo,Nms,SprOrPrs,BwOrClr,NmsOrNmb,Co);
%
%PJ 28.09.99
%
%HISTORY
%28.09.99 : modified from pspearplt.m to handle Spearman and Pearson correlations
%22.03.04 : Modified to put text not numbers, toggle BW/Colour, Names/Numbers
%
%- Plots the correlation map in matrix Xo
%- Optionally (if arguments 2 and 3 are both specified)
%  = identifies all correlations above a given threshold (Co) and prints them to file 'corr.txt'
%
%Inputs
% Xo       : a x a square array with rank correlation map (generates by pspear.m, say)
% Names    : a x b character array of Nms for all 'a' variables
% SprOrPrs : =1 (Spearman) =0 (Pearson)
% ClrOrBw  : =1 (Colour)   =0 (B&W)
% NmsOrNmb : =1 (Names)    =0 (Numbers)
% Co       : scalar cutoff below which correlations are not considered interesting for printing
%
%Outputs
% Only text and graphics to screen
%
%Uses
% Generic MATLAB functionality only

if SprOrPrs==0 | SprOrPrs==1;
else;
   fprintf(1,'Incorrect specification of SprOrPrs. Terminating\n');
   return;
end;

p=size(Xo,1);

if ClrOrBw==0; %B&W
    colormap(gray);
    c=colormap;
    c=c(2:2:64,:);
    [t1,t2]=sort(-c(:,1));
    d=[c; c(t2,:)];
    colormap(d);
else;%Colour: set up colormap, make intermediate colors all white
    colormap(jet);
    c=colormap;
    %c(26:39,:)=1;
    %c(30:35,:)=1;
    colormap(c);
end;

%add extra row to correlation matrix
%making sure that it has max=1 and min=-1 values
%(see help for pcolor to understand why)
x=[Xo zeros(p,1)];
x=[x;zeros(1,p+1)];
x(p+1,p)=1;
x(p+1,p+1)=-1;

%put missing values as zeros (ie to appear as white)
x(x==-99)=0;

if ClrOrBw==0; %One sided plot option, mandatory for B&W
    for i=1:p+1;
        for j=1:p+1;
            if i>j;
                if x(i,j)<0;x(i,j)=0;end;
            elseif i<j;
                if x(i,j)>0;x(i,j)=0;end;
            end;
        end;
    end;
end;

pcolor(x);
colorbar;
pDflBig;

if NmsOrNmb==1; %Plot variable Nms not numbers
    set(gca,'XTick',[1:p],'XTickLabel',[]);
    for j=1:p;
        h=text(j+0.5,1-0.1,deblank(Nms(j,1:min(10,size(Nms,2)))));set(h,'Rotation',90,'HorizontalAlignment','right','VerticalAlignment','middle','FontSize',8);
    end;
    set(gca,'YTick',[1:p],'YTickLabel',[]);
    for j=1:p;
        h=text(1-0.1,j+0.5,deblank(Nms(j,1:min(30,size(Nms,2)))));set(h,'Rotation',0,'HorizontalAlignment','right','VerticalAlignment','middle','FontSize',8);
    end;
end;

if p<=30; %Print values of Corr in grid if p<=20;
	for i=1:p;
		for j=1:p;
			text(i+0.5,j+0.5,sprintf('%5.2f',Xo(i,j)),'HorizontalAlignment','center','VerticalAlignment','middle','FontSize',8);
		end;
	end;
end;

pDflBig;
set(gca,'FontSize',14,'FontName','Garamond'); grid on; box on;
if SprOrPrs==1; 
   title 'Spearman rank correlation matrix';
else;
   title 'Pearson correlation matrix';
end;

%print out a colour hard copy
%while 1;
while 0;
   hc=input('Do you want a hard copy? Y/N [Y]\n','s');
   if isempty(hc) | hc=='Y' | hc=='y';
%      print -dpsc corr.ps;
     print -djpeg corr.jpg;
%      print -dbmp corr.bmp;
      break;
   end;
   if hc=='N' | hc=='n';
      break;
   end;
end;

%look for all correlations with absolute value > Co
if isempty(Co)==0;
   fid=fopen('corr.txt','w');
   for j=1:p;
      fprintf(fid,'%s :\n',Nms(j,:));
      tmp=abs(Xo(:,j))>=Co&Xo(:,j)~=-99;
      if sum(tmp==1)>0;
         for k=1:p;
            if tmp(k)==1&k~=j;
               fprintf(fid,'  %6.4f with %s\n',x(j,k),Nms(k,:));
            end;
         end;
      end;
   end;
   fclose(fid);
end;