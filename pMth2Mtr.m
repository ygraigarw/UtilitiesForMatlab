function DrcMtr=pMth2Mtr(DrcMth,OtpFrm);
%function DrcMtr=pMth2Mtr(DrcMth,OtpFrm);
%
%Shell Global Solutions Statistics & Chemometrics
%Philip Jonathan
%October 2007
%
%Overview
% Convert directions from meteorological convention to mathematical
%   Meteorological convention typically used for wind fields
%   Mathematical convention for calculations (vector averaging, plotting, etc)
% Input is vector of directions in mathematical convention [0,360) (although (-180,180] also handled)
% Output is vector of directions meteorological in [0,360) or (-180,180] specified by OtpFrm='P' or 'NP'
% Meteorological:
%   Refers to the direction from which the wind comes
%   North is 0 degrees, NorthWest is -45 (or -45+360=315), West is -90 (or 270), SouthWest is -135 (or 225)
%   NorthEast is +45, East is +90, SouthEast is +135, South is +180
% Mathematical:
%   Refers to the direction to which the wind blows (ie direction vector of wind)
%   Anticlockwise is positive from x-axis == East == 0 degrees (standard mathematical)
%   North is 90, West is 180, South is 270
% Check behaviour using
%   a=(-180:30:360)';
%   [a pMth2Mtr(a) pMth2Mtr(a,'NP') pMtr2Mth(pMth2Mtr(a)) pMtr2Mth(pMth2Mtr(a,'NP'))]
%
%Input arguments
%  DrcMth            nD   x 1    real DiReCtions MaTHematical
%  OtpFrm            2    x 1    char OuTPut FoRMat 'P'=[0,360), 'NP'=(-180,180]
%                                     This argument is optional. If unspecified, 'P' assumed
%
%Output arguments
%  DrcMtr            nD   x 1    real DiReCtions MeTeoRological
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
%26.09.07 Commented fully and added optional parameter OtpFrm to specify output 'P'=[0,360), 'NP'=(-180,180] 

%Check inputs make sense
if nargin==1;
    if isnumeric(DrcMth)==1;
        OtpFrm='P';
    else;
        error('pMth2Mtr: DrcMth is not numeric');
    end;
elseif nargin==2;
    if isnumeric(DrcMth)==1;
    else;
        error('pMth2Mtr: DrcMth is not numeric');
    end;
    if strcmp(OtpFrm,'P')==1 | strcmp(OtpFrm,'NP')==1;
    else;
        error('pMth2Mtr: Invalid value %s for OtpFrm. Should be ''P'' or ''NP''',OtpFrm);
    end;
else;
    error('pMth2Mtr: Invalid number of input arguments');    
end;

%If there are negative angles in DrcMth, we assume that these correspond to angle-360
%Add 360 to negative angles only, ensures that DrcMth is in [0,360)
DrcMth(DrcMth<0)=DrcMth(DrcMth<0)+360;

%Convert from mathematical to meteorological convention
DrcMtr=270-DrcMth;

%If there are negative angles in DrcMtr, add 360 to these only
%Ensures that DrcMtr is in [0,360)
DrcMtr(DrcMtr<0)=DrcMtr(DrcMtr<0)+360;

%If the output is requested as (-180,180], need to subtract 360 from all DrcMtr>180
if strcmp(OtpFrm,'NP')==1;
    DrcMtr(DrcMtr>180)=DrcMtr(DrcMtr>180)-360;
end;

%Normal completion
return;