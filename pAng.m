function A=pAng(C,S,IsRdn);
%Calculates the angle (math'l) corresponding to a given cos and sin
%If nargin==3, answer in degrees, otherwise radians

%% Find angle for each row of [C S] in radians
A=ones(size(C,1),1)+NaN;
A(C>=0 & S>=0)=asin(S(C>=0 & S>=0));
A(C<0 & S>=0)=pi-asin(S(C<0 & S>=0));
A(C<0 & S<0)=pi-asin(S(C<0 & S<0));
A(C>=0 & S<0)=2*pi+asin(S(C>=0 & S<0));

if nargin==2;
   IsRdn=1;
end;

%% Convert to degrees if necessary
if IsRdn==0;
  A=A*180/pi;
end;

return;