function [SumMgn,SumDrc]=pPlrAdd(Mgn,Drc,Wgh);
%function [SumMgn,SumDrc]=pPlrAdd(Mgn,Drc,Wgh);
%
%Shell Global Solutions Statistics & Chemometrics
%Philip Jonathan
%November 2007
%
%Overview
%
% Adds vectors specified in polar co-ordinates, returning sum in polar coordinates
% Input is MaGNitudes and DiReCtions in degrees using standard mathematical convention (NOT METEOROLOGICAL!)
% Output is SumMaGNitude and SumDiReCtion
%
% Input can be vectors (for spatial or temporal averaging) or matrices (for spatio-temporal averaging). Sum is over all elements
%
% Can specify a WeiGHting vector (such that sum(sum(Wgh))=1
%
% Use pMth2Mtr and pMtr2Mth for data in meteorological convention
%
%Input
% Mgn          n x m                  real MaGNitudes of n vector quantities
% Drc          n x m                  real DiReCtions of n vector quantities (in degrees mathematical)
% Wgh          n x m                  real WeiGHting matrix (s.t. sum(sum(Wgh))=1)
%
%Output data structures
% SumMgn       1 x 1                  real SUM MaGNitude
% SumDrc       1 x 1                  real SUM DiReCtion (in degrees mathematical)
%
%Calls
% Generic MATLAB functionality
%
%Called by
% ****
%
%History
%v0.1: November 2007 by Philip Jonathan
%12.11.07

%Ensure Wgh exists
if nargin==2; %Wgh not specified as input argument, must create
    [n,m]=size(Mgn);
    Wgh=ones(n,m); %All points weighted equally
end;

%Calculate X and Y components of vectors
X=Mgn.*cosd(Drc);%cosd takes argument in degrees
Y=Mgn.*sind(Drc);%sind takes argument in degrees

%Calculate (weighted) sum of vectors
SumX=sum(sum(Wgh.*X));
SumY=sum(sum(Wgh.*Y));

%Calculate magnitude of sum
SumMgn=sqrt(SumX.^2+SumY.^2);

%Calculate sine and cosine of sum
SumCsn=SumX/SumMgn; %cosine of spatio-temporally averaged
SumSin=SumY/SumMgn; %sine of spatio-temporally averaged

%Calculate direction in degrees corresponding to sine and cosine found
if SumSin>0 & SumCsn>0; %first quadrant (mathematical);
    SumDrc=asind(abs(SumSin)); %asind gives output in degrees
elseif SumSin>0 & SumCsn<0; %second quadrant (mathematical);
    SumDrc=180-asind(abs(SumSin));
elseif SumSin<0 & SumCsn<0; %third quadrant (mathematical);
    SumDrc=180+asind(abs(SumSin));
else SumSin<0 & SumCsn>0; %fourth quadrant (mathematical);
    SumDrc=360-asind(abs(SumSin));
end;

%Normal completion
return;