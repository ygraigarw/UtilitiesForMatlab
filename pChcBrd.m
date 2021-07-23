function pChcBrd(X,Y,Z,DmnZ,WdtX,WdtY)
%function pChcBrd(X,Y,Z,DmnZ,WdtX,WdtY)

%X    n x 1     x-locations of cell centres 
%Y    n x 1     y-locations of cell centres 
%Z    n x 1     z-value for each cell
%DmnZ 2 x 1     DoMaiN of Z values (optional)
%WdtX 1 x 1     WiDTh of each cell in x (optional)
%WdtY 1 x 1     WiDTh of each cell in y (optional)

if nargin==0;
	X=(1:10)';
	Y=X;
	Z=X;
elseif nargin<3 || nargin>6;
	fprintf(1,'pChcBrd: Terminating. Incorrect number of arguemnts\n');
	return;
end;

Dmn=[X Y];
[uXY,lol,uRows]=unique(Dmn,'rows');
X=uXY(:,1);
Y=uXY(:,2);
nZ=size(uXY,1);
uZ=ones(nZ,1)+NaN;
for iZ=1:nZ;
	uZ(iZ)=mean(Z(uRows==iZ));
end;
Z=uZ;

if nargin<=4;
	t=unique(diff(sort(X))); WdtX=min(t(t>0));
	t=unique(diff(sort(Y))); WdtY=min(t(t>0));
end

if nargin<6;
	DmnZ=[min(Z);max(Z)];
end;

ClrMap=colormap;
nClrMap=size(ClrMap,1);
cInd=ceil(nClrMap*(Z-DmnZ(1))/range(DmnZ)); cInd(cInd==0)=1;
cZ=ClrMap(cInd,:);

n=size(X,1);
%clf; 
hold on; pDfl;
for i=1:n;
	tBox(X(i),Y(i),WdtX,WdtY,cZ(i,:));
end;
pClrBar(DmnZ,10); 
%axis image; 
pAxsLmt;

return;

function tBox(x,y,wx,wy,cZ)
tx=[x-wx/2;x+wx/2;x+wx/2;x-wx/2];
ty=[y-wy/2;y-wy/2;y+wy/2;y+wy/2];
fill(tx,ty,cZ); %cInd is an index to the current colormap by definition
return;