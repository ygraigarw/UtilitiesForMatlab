function y=pNicClrBW(iC);

% Colours 1-3 are (mainly) green, red and blue
% In BW, colours 1-3 also decrease in grey scale intensity (so nice for B&W plots)

NicClrBW=[0.1 0.6 0.1;...
          1.0 0.6 0.0;...
          0.8 0.8 1.0;];
     
nClr=size(NicClrBW,1);

if nargin>0;
    y=NicClrBW(iC,:);
else;
    clf;hold on;
    for iC=1:nClr;
        plot((iC-1:iC),(iC-1:iC),'color',NicClrBW(iC,:),'linewidth',4);
    end;
    iC=iC+1;
    plot((iC-1:iC),(iC-1:iC),'color',[0 0 0],'linewidth',4); %add black for comparison
end;
pGI('Test',2)
