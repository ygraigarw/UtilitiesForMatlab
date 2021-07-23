function pClrBar(Dmn,Stp,Lbl);
%function pClrBar(Dmn,Stp,Lbl);
%
%Shell Projects & Technology, Statistics & Chemometrics
%Philip Jonathan
%June 2010
%
%Overview: Refined colorbar plotting
%Plots colorbar with specified colour range and number of ticks, or with specified tick locations and text labels
%
%Input
% Dmn  DoMaiN limits for colorbar
% Stp  number of STePs for ticks on colorbar (if scalar)
%      tick locations (if vector)
% Lbl  tick LaBeLs vector

if sum(isnan(Dmn)==0)==0;
  Dmn=[-0.05;0.05];
end;
if range(Dmn)==0;
  Dmn=[Dmn(1)-0.05;Dmn(2)+0.05;];
end;

if nargin==0;
else;
  
  caxis(Dmn);
  if nargin<3;
    if nargin==1;
      Stp=10;
    end;
    colorbar('YTick',Dmn(1):range(Dmn)/Stp:Dmn(2));
  elseif nargin==3;
    colorbar('YTick',Stp,'YTickLabel',Lbl);
  end;
end;

return;