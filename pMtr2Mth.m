function DrcMth=pMtr2Mth(DrcMtr);
%function DrcMth=pMtr2Mth(DrcMtr);
%
%Shell Global Solutions Statistics & Chemometrics
%Philip Jonathan
%October 2007
%
%Overview
% Convert directions from mathematical convention to meteorological
%   Meteorological convention typically used for wind fields
%   Mathematical convention for calculations (vector averaging, plotting, etc)
% Intput is vector of directions meteorological in [0,360) or (-180,180]
% Output is vector of directions in mathematical convention [0,360)
% Mathematical:
%   Refers to the direction to which the wind blows (ie direction vector of wind)
%   Anticlockwise is positive from x-axis == East == 0 degrees (standard mathematical)
%   North is 90, West is 180, South is 270
% Meteorological:
%   Refers to the direction from which the wind comes
%   North is 0 degrees, NorthWest is -45 (or -45+360=315), West is -90 (or 270), SouthWest is -135 (or 225)
%   NorthEast is +45, East is +90, SouthEast is +135, South is +180
% Check behaviour using
%   a=(-180:30:360)';
%   [a pMth2Mtr(a) pMth2Mtr(a,'NP') pMtr2Mth(pMth2Mtr(a)) pMtr2Mth(pMth2Mtr(a,'NP'))]
%
%Input arguments
%  DrcMtr            nD   x 1    real DiReCtions MeTeoRological
%
%Output arguments
%  DrcMth            nD   x 1    real DiReCtions MaTHematical
%
%Calls
%  Generic MATLAB functionality 
%
%Called by
%  Used as general conversion utility
%
%History
%v0.1: September 2007 By Philip Jonathan
%v0.2: September 2007 By Philip Jonathan
%26.09.07 Commented fully 

%Check inputs make sense
if nargin==1;
    if isnumeric(DrcMtr)==1;
    else;
        error('pMtr2Mth: DrcMtr is not numeric');
    end;
else;
    error('pMtr2Mth: Invalid number of input arguments');    
end;

%If there are negative angles in DrcMtr, these correspond to angle-360
%Add 360 to negative angles only, ensures that DrcMtr is in [0,360)
DrcMtr(DrcMtr<0)=DrcMtr(DrcMtr<0)+360;

%Convert from meteorological to mathematical convention
DrcMth=270-DrcMtr;

%If there are negative angles in DrcMth, add 360 to these only
%Ensures that DrcMth is in [0,360)
DrcMth(DrcMth<0)=DrcMth(DrcMth<0)+360;

%Normal completion
return;
