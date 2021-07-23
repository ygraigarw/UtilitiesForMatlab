function iFlg=pSwapStrings(StrOld,StrNew,FilOld,FilNew);
%function iFlg=pSwapStrings(StrOld,StrNew,FilOld,FilNew);
%
%Shell Global Solutions Statistical Consulting
%Philip Jonathan
%October 2006
%
%Overview
%Swaps all occurrences of string StrOld with string StrNew in MATLAB-readable file FilOld, creating file FilNew
%
%e.g. to replace each occurrence of a commas in file t.txt with the space character, use: 
%        SwapStrings(',',' ','t.txt','t_new.txt');
%     to remove all occurrences of commas in file t.txt, use: 
%        SwapStrings(',','','t.txt','t_new.txt');
%
%Input arguments
% StrOld   ? x 1 char  text STRing to be replaced (OLD)
% StrNew   ? x 1 char  Replacement text STRing (NEW)
% FilOld   ? x 1 char  ascii text FILe name for input (OLD)
% FilNew   ? x 1 char  ascii text FILe name for output (NEW)
%
%Output arguments
%iFlg          1 x 1    inte <0 => Abnormal completion; 0 = OK
%
%Calls
%  Generic MATLAB functionality 
%
%Called by
%  *****
%
%History
%v0.1: October 2006 by Philip Jonathan
%
%1.Searches for FilOld in the current directory
%  Terminates if not found
%2.Checks for location of end of file to locate last line of data
%  Reads and writes line at a time, replacing/removing as it goes

%Setup
iFlg=-1; %abnormal completion of routine
Drc=pwd; %current directory

%1.Searches for FilOld in the current directory
%  Terminates if not found
t1=dir(Drc);nFil=size(t1,1);
IsFil=ones(nFil,1).*0;
for i=1:nFil;
	if strfind(t1(i).name,FilOld)==1;
		IsFil(i)=1;
	end;
end;
if sum(IsFil)==0;
	fprintf(1,'Error from SwapStrings: No file %s found. Terminating.\n',FilOld);
	return;
elseif sum(IsFil)>1;
	fprintf(1,'Error from SwapStrings: Multipe files %s found. Terminating.\n',FilOld);
	return;
else;
	tFil=fullfile(Drc,t1(find(IsFil==1)).name);
	if isempty(StrOld)==0;
		if isempty(StrNew)==0;
			fprintf(1,'SwapStrings: Swapping occurrence(s) of ''%s'' with ''%s'' from ''%s''. Output to ''%s''\n',StrOld,StrNew,FilOld,FilNew);
		else;
			fprintf(1,'SwapStrings: Removing occurrence(s) of ''%s'' from ''%s''. Output to ''%s''\n',StrOld,FilOld,FilNew);
		end;
	else;
		fprintf(1,'SwapStrings: ERROR: StrOld cannot be empty. Terminating\n');
		return;
	end;
end;

%2.Checks for location of end of file to locate last line of data
%  Reads and writes line at a time, replacing/removing as it goes
nHit=0;
fi=fopen(tFil);
fo=fopen(fullfile(Drc,FilNew),'w');
for i=1:1e8; %will try to read up to 1e8 lines
	Li=fgetl(fi);
	if isnumeric(Li)==1;
		if Li==-1;
			n=i-1;
			fprintf(1,'SwapStrings: %d line(s) read\n',n);
			break;
		end;
	else;
		tHit=strfind(Li,StrOld);tHit=size(tHit,2);
		nHit=nHit+tHit;
		if tHit>0;
			Lo=strrep(Li,StrOld,StrNew);
			fprintf(fo,'%s\n',Lo);
		else;
			fprintf(fo,'%s\n',Li);
		end;
	end;
end;
fclose(fo);
fclose(fi);

if isempty(StrNew)==0;
	fprintf(1,'SwapStrings: %d occurrence(s) of ''%s'' found and replaced\n',nHit,StrOld);
else;
	fprintf(1,'SwapStrings: %d occurrence(s) of ''%s'' removed\n',nHit,StrOld);
end;

iFlg=0; %normal completion of routine
fprintf(1,'SwapStrings: Complete\n',nHit,StrOld);
return;