function Struct=pMakStruct(StructFldNms,varargin);

StructVrb=varargin';
nS=size(StructVrb,1);
if size(StructFldNms,1)~=nS;
	fprintf(1,'Error: pMakStruct: Field Names cell array does not agree with number of input variables. Terminating\n');
	Struct=NaN;
	return;
end;

for iS=1:nS;
	tStr=sprintf('Struct.%s=StructVrb{%g};',StructFldNms{iS},iS);
	eval(tStr);
end;

return;