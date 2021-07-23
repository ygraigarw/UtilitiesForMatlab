function c = pStr2Cell(s)

% string with terminators (LF= char(10)) to cell conversion

% (C) 2003 Protys, www.protys.com\toolbox
% $a:JdH

% $TBD: CR, FF

term	= [10];

ind	= findstr(term,s);
if ~any(ind)
  c	= {s};
  return
end

if (ind(end) + length(term) -1) < length(s)
  % always have a terminator at the end
  ind(end+1)	= length(s) + 1;
end

ind	= [0 ind];

c	= cell(length(ind)-1,1);

for ii = 1:length(ind)-1
  c{ii}  = s(ind(ii)+1 : ind(ii+1)-1);
end


