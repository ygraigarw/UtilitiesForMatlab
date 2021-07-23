function [Y,QntYLo,QntYHi]=pSmt(X,Window,MeanOrMedi,Side);
% function Y=pSmt(X,Window,MeanOrMedi,Side);
%
% PJ 28.09.99
%
% Smoothes data using a Left,Centre,or Right-sided rectangular moving mean or median filter
% NaN for MV
%
% INPUTS
% X          : n x p  : data matrix
% Window     : scalar : half-window width
% MeanOrMedi : string : 'MEAN' or 'MEDI' (or numeric for quantile)
% Side       : string : 'L','C','R'
%
% OUTPUTS
% Y          : n x p  : smoothed data (with NaN for additional missing values)
%
% USES
% Generic MATLAB functionality only

[n,p]=size(X);

Y=ones(n,p) .* NaN;
QntYLo=ones(n,p) .* NaN;
QntYHi=ones(n,p) .* NaN;

if Window>0;
	
	%Perform centre smooth
	%Y(1:Window,:)=X(1:Window,:);
	%Y((n-Window+1):n,:)=X((n-Window+1):n,:);
	
	fprintf(1,'Smoothing data\n');
	for i=1+Window:n-Window;
		if rem(i,1000)==0;
			fprintf(1,'%d ',i);
			if rem(i,10000)==0;
				fprintf(1,'\n');
			end;
		end;
		for j=1:p
			t1=X((i-Window):(i+Window),j);
			t2=t1(isnan(t1)==0);
			if sum(isnan(t1)==0)>=3;
				if  strcmp(MeanOrMedi,'MEAN')==1;
					Y(i,j)=nanmean(t2);
				elseif strcmp(MeanOrMedi,'MEDI')==1;
					Y(i,j)=nanmedian(t2);
				else;
					t2=t2(isnan(t2)==0);
					Y(i,j)=quantile(t2,MeanOrMedi);
				end;
                t3=t2(isnan(t2)==0);
                QntYLo(i,j)=quantile(t3,0.025);
                QntYHi(i,j)=quantile(t3,0.975);
			end;
		end;
	end;
	fprintf(1,'\n');
	
	%Lag the data to left or right if necessary
	if strcmp(Side,'L')==1;
		Y=pLag(Y,-Window);
		QntYLo=pLag(QntYLo,-Window);
		QntYHi=pLag(QntYHi,-Window);
	elseif strcmp(Side,'R')==1;
		Y=pLag(Y,+Window);
		QntYLo=pLag(QntYLo,+Window);
		QntYHi=pLag(QntYHi,+Window);
	end;
	
else;
	
	Y=X;
	
end;