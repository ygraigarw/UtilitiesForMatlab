function Cll=pCsvStr2Cll(Str);

if strcmp(Str(end),',')==0;
	Str=sprintf(',%s,',Str);
else;
	Str=sprintf('%s,',Str);
end;

LctCmm=strfind(Str,',')';
nElm=size(LctCmm,1)-1;

Cll=cell(nElm,1);
for iE=1:nElm;
	Cll{iE}=Str(LctCmm(iE)+1:LctCmm(iE+1)-1);
end;

return;