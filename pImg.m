function pImg(X,ShwNaN);
%function pImg(X,ShwNaN);
%
%Shell Projects & Technology, Statistics & Chemometrics
%Philip Jonathan
%February 2013
%
%Overview
%  Plots images using imagesc in greyscale (1=black, 0=white)
%  Optionally shows missing values in red

clf;

if nargin==1;
  ShwNaN=0;
end;

if ShwNaN==1; %Show NaN in red, and the remaining data scaled from 0 (min) to 1 (max)
  X=1-(X-nanmin(X(:)))/(nanmax(X(:))-nanmin(X(:)));
  t=X; t(isnan(X)==1)=1; t3(:,:,1)=t;
  t=X; t(isnan(X)==1)=0; t3(:,:,2)=t;
  t=X; t(isnan(X)==1)=0; t3(:,:,3)=t;
  imagesc(t3); axis('xy');
else;
  imagesc(X); axis('xy');
  a=colormap('gray');a=a(end:-1:1,:);colormap(a);
  colorbar;
end;
pDfl;

return;