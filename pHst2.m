function [no,xo] = pHst(varargin)

% Modified from MATLAB hist by PhJ 20150610
% Arg1=Data (mandatory)
% Arg2=Number of bins (optional)
% Arg3=Colour (optional)
% Arg4=Line thickness (optional)

%HIST  Histogram.
%   N = HIST(Y) bins the elements of Y into 10 equally spaced containers
%   and returns the number of elements in each container.  If Y is a
%   matrix, HIST works down the columns.
%
%   N = HIST(Y,M), where M is a scalar, uses M bins.
%
%   N = HIST(Y,X), where X is a vector, returns the distribution of Y
%   among bins with centers specified by X. The first bin includes
%   data between -inf and the first center and the last bin
%   includes data between the last bin and inf. Note: Use HISTC if
%   it is more natural to specify bin edges instead. 
%
%   [N,X] = HIST(...) also returns the position of the bin centers in X.
%
%   HIST(...) without output arguments produces a histogram bar plot of
%   the results. The bar edges on the first and last bins may extend to
%   cover the min and max of the data unless a matrix of data is supplied.
%
%   HIST(AX,...) plots into AX instead of GCA.
%
%   Class support for inputs Y, X: 
%      float: double, single
%
%   See also HISTC, MODE.

%   Copyright 1984-2010 The MathWorks, Inc. 
%   $Revision: 5.20.4.19 $  $Date: 2010/08/23 23:07:38 $

% Parse possible Axes input
error(nargchk(1,inf,nargin,'struct'));
[cax,args,nargs] = axescheck(varargin{:});
hold on;

if nargs == 1
  y = args{1};
  x = 10;
  lliw='k';
  trwch=1;
end

if nargs == 2
  y = args{1};
  x = args{2};
  lliw='k';
  trwch=1;
end

if nargs == 3
  y = args{1};
  x = args{2};
  lliw=args{3};
  trwch=1;
end

if nargs == 4
  y = args{1};
  x = args{2};
  lliw=args{3};
  trwch=args{4};
end

if isvector(y), y = y(:); end
if ~ishistnumeric(x) || ~ishistnumeric(y)
    error(message('MATLAB:hist:InvalidInput'))
end

% Cache the vector used to specify how bins are created
N = x;
    
if isempty(y),
    if length(x) == 1,
       x = 1:double(x);
    end
    nn = zeros(size(x)); % No elements to count
    %  Set miny, maxy for call to bar below.
    miny = [];
    maxy = [];
    edges = [-Inf Inf];
else
    %  Ignore NaN when computing miny and maxy.
    ind = ~isnan(y);
    miny = min(y(ind));
    maxy = max(y(ind));
    %  miny, maxy are empty only if all entries in y are NaNs.  In this case,
    %  max and min would return NaN, thus we set miny and maxy accordingly.
    if (isempty(miny))
      miny = NaN;
      maxy = NaN;
    end
    
    if length(x) == 1
    	  if miny == maxy,
    		  miny = miny - floor(x/2) - 0.5; 
    		  maxy = maxy + ceil(x/2) - 0.5;
     	  end
        binwidth = (maxy - miny) ./ x;
        xx = miny + binwidth*(0:x);
        xx(length(xx)) = maxy;
        x = xx(1:length(xx)-1) + binwidth/2;
    else
        xx = x(:)';
        binwidth = [diff(xx) 0];
        xx = [xx(1)-binwidth(1)/2 xx+binwidth/2];
        xx(1) = min(xx(1),miny);
        xx(end) = max(xx(end),maxy);
    end
    % Shift bins so the interval is ( ] instead of [ ).
    xx = full(real(xx)); y = full(real(y)); % For compatibility
    bins = xx + eps(xx);
    edges = [-Inf bins];
    nn = histc(y,edges,1);
    edges(2:end) = xx;    % remove shift
    
    % Combine first bin with 2nd bin and last bin with next to last bin
    nn(2,:) = nn(2,:)+nn(1,:);
    nn(end-1,:) = nn(end-1,:)+nn(end,:);
    nn = nn(2:end-1,:);
    edges(2) = [];
    edges(end) = Inf;
end

if nargout > 0
    if isvector(y) && ~isempty(y) % Return row vectors if possible.
        no = nn';
        xo = x;
    else
        no = nn;
        xo = x';
    end
else
  if ~isempty(cax)
     histPatch = bar(cax,x,nn,[miny maxy],'hist');
     if strcmpi(get(ancestor(cax,'figure'),'Visible'),'off')
         return;
     end     
  else
     histPatch =  bar(x,nn,[miny maxy],'hist');
     set(histPatch,'edgecolor',lliw,'facecolor','none','linewidth',trwch);
  end
  
end

function a = ishistnumeric(b)
% for backward compatibility, logical is allowed in hist.m
a = isnumeric(b) || islogical(b);



