function B=pBss(X, Xl, Xr, ndX, SplDgr, IsPrd);

% CONSTRUCT A B-SPLINE BASIS OF SplDgrREE 'SplDgr', USING TRUNCATED POWER
% FUNCTIONS (TPFs). (SEE "SPLINES, KNOTS & PENALTIES", Eilers and MarX
% 2004, pages 3&4)

% X        n x 1 data
% Xl       1 x 1 left limit of X data
% Xr       1 x 1 right limit of X
% ndX      1 x 1 number of segments wanted
% SplDgr   1 x 1 degree of spline
% PnlOrd   1 x 1 difference penalty order
% IsPrd    1 x 1 optional periodic b-spline

%% Optional test mode
if nargin==0; %test mode
	X=(0.01:0.01:1)'*10;
	Xl=0;
	Xr=1*10;
	ndX=10;
	SplDgr=3;
	IsPrd=0;
end;

%% Standardise for stability
X0=X;
X=(X-Xl)/(Xr-Xl);
Xl=0;
Xr=1;

%% Estimate truncated power functions
dX = (Xr - Xl) / ndX ;
knots = (Xl - SplDgr * dX : dX : Xr + SplDgr * dX)';
P=NaN(length(X),length(knots));
for i=1:length(X)
	for j=1:length(knots)
		P(i,j)=tpower(X(i),knots(j),SplDgr); %grid of values of the truncated power function for all possible (X,knots)
	end
end

%% Convert truncated power functions into b-spline basis set
n = length(knots);
D = diff(eye(n),SplDgr + 1) ./ (gamma(SplDgr + 1) * dX ^ SplDgr);
B = (-1) ^ (SplDgr + 1) * P * D';
m = length(B(1,:));

%% Make periodic b-spline if required
if IsPrd==1; %periodic version
	B(:,1:SplDgr) = B(:,1:SplDgr)+B(:,m-(SplDgr-1):m);
	B=B(:,1:m-SplDgr);
end;

%% Plot if test
clf;
if nargin==0; %test mode
	subplot(1,2,1); plot(X0,B); title 'b-spline basis functions';
    subplot(1,2,2); hold on; plot(X0,B*ones(size(B,2),1),'b'); title 'typical functions';
    tCff=zeros(size(B,2),1);tCff(6)=1;
	subplot(1,2,2); hold on; plot(X0,B*tCff,'c');
	subplot(1,2,2); hold on; plot(X0,B*(1:size(B,2))'/size(B,2),'g');
	fprintf(1,'pBBase: B is %g x %g\n',size(B));
end;

%% Normal completion
return;

%% *************************************************************
function P = tpower(X, T, SplDgr);

% TRUNCATED POWER FUNCTION - USING TO CONSTRUCT B-SPLINE BASIS MATRIX
%See "Splines, Knots & Penalties" (Eilers & Marx 2004), and "The Craft of Smoothing"
%presentation - slide 23-24

P=((X - T) .^ SplDgr .* (X > T))';

%Normal completion
return;
%% *************************************************************