function pTimSrs(X0,names,indx,ind,prow,pcol,abscX,ttl)
%function pTimSrs(X0,names,indx,ind,prow,pcol,abscX)
%
% PJ 05.09.97
%
% Produces time-series plots
%
% ARGUMENTS
% X0 	n*p matrix of observations
% names p*? array of character variables describing variables names
% indx 	column number of variable to put on x-axis (usually time)
%       =0 means "don't print label on x-axis, but you must then
%	   specify abscX"
% ind 	columns to be plotted (individually) on y axis
% OPTIONALLY
% prow 	number of vertical plots per page of output
% pcol 	number of horizontal plots per page of output
% abscX alternative vector for X-axis
% If these are not specified prow=5, pcol=4 assumed
 
if nargin<4;
  fprintf(1,'Insufficient arguments. Terminating\n');
else;
  if nargin==4;
    fprintf(1,'Assuming 5x4 landscape\n');
    orient landscape;
    prow=5;
    pcol=4;
  else;
    if prow>pcol;
      fprintf(1,'Assuming tall\n');
      orient tall;
    else;
      fprintf(1,'Assuming landscape\n');
      orient landscape;
    end;
  end;
end;

ppic=prow*pcol;

% Operations

  k=0;

  for j=1:size(ind,1);
 
    k=k+1;
    fprintf(1,'%d ',k);

    p=rem(k,ppic);
    if p==0;
      p=ppic;
    end;

    if indx==0 & nargin>=7;
      a=[abscX X0(:,ind(j))];
    else;
      if indx>0;
        a=X0(:,[indx ind(j)]);
      else;
        fprintf(1,'ERROR : You have indx=0 and have not specified abscX!\n');
        return;
      end;
    end;

    subplot(prow,pcol,p);
    
    %orient landscape;
    %orient tall;
    orient portrait;
    t1=a==-99;t2=sum(t1')';t3=t2==0;b=a(t3,:);
    c=pSwpMV(a);
    %pPlt(c(:,1),c(:,2),'k.-');
    %   plot(b(:,1),b(:,2),'r*');
    pPlt(a(:,1),a(:,2),'k.-',0);
    %hist(b(:,2),10);
	%    pPlt(a(:,1),a(:,2),'k',0);
    %   pplt_contig(a(:,1),a(:,2),1,'k.',0);
    % hist(b(:,2),100)
    pDflSml;
	axis('tight')
    
    h=title([ names(ind(j),:) ]);set(h,'FontSize',8);
    tmp=rem(size(ind,1),pcol); if tmp==0;tmp=pcol;end;
    if indx>0 & (((prow*pcol-p) < pcol) | (size(ind,1)-j<tmp));
      xlabel([ names(indx,:) ]);
    end;
    %ylabel([ int2str(ind(j)) ' : #MV= ' int2str(sum(t2==1))]);
    ylabel([ int2str(ind(j)) ' : #Counts= ' int2str(sum(isnan(b(:,2))==0))]);

    if ( p==ppic | j==size(ind,1));
      fprintf(1,'printing ');
      %eval(['print -dpsc out' int2str(j)]); 
      pDatStm(ttl);
      if nargin==8;
          pGI(sprintf('%s%g',ttl,j));
      else;
          pGI(sprintf('out%g',j));
      end;          
      %eval(['print -djpeg out' int2str(j)]); 
      %eval(['print -djpeg ' ttl]); 
      %eval(['print -dps out' int2str(j)]); 
      %print -dpsc -append out.ps ;
      %print -dbmp out.bmp ;
      %pause;
	  clf;
    end;

  end;
