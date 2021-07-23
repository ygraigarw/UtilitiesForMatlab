function [ErrFlg,UnqStr,nUnqStr,IdUnqStr,RfrNew]=pUnqStr(Str,Rfr);
%function [ErrFlg,UnqStr,nUnqStr,IdUnqStr,RfrNew]=pUnqStr(Str,Rfr);
%
%Shell Global Solutions Statistics & Risk
%Philip Jonathan
%November 2003
%
%Overview
%  With one input argument Str:
%  - Extracts unique occurrences in the character array Str into UnqStr
%  - Sorts unique occurrences in dictionary order
%  - Reports the number of unique occurrences nUnqStr and identifies
%  - Identifies each element of Str with a number corresponding to the row of UnqStr
%  With two input arguments Str Rfr:
%  - As above, except that UnqStr is sorted by order of Rfr
%  - Any elements of UnqStr not in Rfr are appended to Rfr in dictionary order in RfrNew and output
%
%Input arguments
%  Inp1              1    x 8    char Description
%  Inp2              1    x 1    inte Description
%  ...
%  (e.g. ErrFlg      1    x 1    inte ERRor FLaG (0=normal completion,>0 otherwise)
%
%Output arguments
%  Inp1              1    x 8    char Description
%  Inp2              1    x 1    inte Description
%  ...
%
%Calls
%  FncNam1
%  FncNam2
%  ...
%  Generic MATLAB functionality 
%
%Called by
%  *****
%
%History
%v0.1: Month Year By Owner
%DD.MM.YY (Section) Description of change
%(e.g. 01.04.03 (5.1) Error flag added)
%
%Process steps
%1.  Description
%1.1 Description
%... 
%2. 
%... 
%(e.g.
%O.  Initialisation
%0.1 Initialise output arguments to NaN
%0.2 Initialise ErrFlg to 1
%1.  Basic checks of input data
%2.  Numerical work
%...
%x.  Completion

%0.  Initialise output arguments to NaN, ErrFlg to 1;
%Otp1=NaN;Otp2=NaN;... %Output arguments to NaN
%ErrFlg=1; %Abnormal completion if function does not run to end; set to zero at the end

%O.  Initialisation
%0.1 Initialise output arguments to NaN
UnqStr=NaN;nUnqStr=NaN;IdUnqStr=NaN;
%0.2 Initialise ErrFlg to 1
ErrFlg=1; %Abnormal completion if function does not run to end; set to zero at the end
%0.3 Initialise Rfr to [] if only one input argument
if nargin==1; 
    Rfr=[]; 
end;
[nRfr,pRfr]=size(Rfr);

nStr=size(Str,1);

%1.  Find unique occurrences
UnqStr=[Str(1,:)];
for iS=2:nStr;
    tMtc=0;
    for iN=1:size(UnqStr,1);
        if strcmp(Str(iS,:),UnqStr(iN,:))==1;
            tMtc=tMtc+1;
        end;
    end;
    if tMtc==0;
        UnqStr=[UnqStr;Str(iS,:)];
    end;
end;

%2.  Sort unique occurrences and count number
%2.1 In dictionary order
UnqStr=sortrows(UnqStr); %dictionary sort
nUnqStr=size(UnqStr,1); %number present
%2.2 By Rfr order, if Rfr is non-empty
t1UnqStr=[]; %Unique occurrences in Rfr, sorted by Rfr
t2UnqStr=[]; %Unique occurrences not in Rfr, sorted by dictionary
if isempty(Rfr)==0; %sort by Rfr if given
    for iR=1:nRfr;
        for iU=1:nUnqStr;
            if strcmp(UnqStr(iU,1:pRfr),Rfr(iR,:))==1;
                t1UnqStr=strvcat(t1UnqStr,UnqStr(iU,:));
                break;
            end;
        end;
    end;
    for iU=1:nUnqStr;
        for iR=1:nRfr;
            if strcmp(UnqStr(iU,1:pRfr),Rfr(iR,:))==1;
                tMtc=1;
                break;
            end;
        end;
        if tMtc==0;
            t2UnqStr=strvcat(t2UnqStr,UnqStr(iU,:));
        end;
    end;
    UnqStr=strvcat(t1UnqStr,t2UnqStr);
    if isempty(t2UnqStr)==0;
        RfrNew=strvcat(Rfr,t2UnqStr(:,1:pRfr));
    else;
        RfrNew=Rfr;
    end;
    nRfrNew=size(RfrNew,1);
end;

%3. Identify occurrences in Str by row of UnqStr
IdUnqStr=zeros(nStr,1);
if isempty(Rfr)==0; %if Rfr non-empty
    for iR=1:nRfrNew;
        for iS=1:nStr;
            if strcmp(Str(iS,1:pRfr),RfrNew(iR,:))==1;
                IdUnqStr(iS)=iR;
            else;
            end;
        end;
    end;    
else;
    for iU=1:nUnqStr; %if Rfr empty
        for iS=1:nStr;
            if strcmp(Str(iS,:),UnqStr(iU,:))==1;
                IdUnqStr(iS)=iU;
            else;
            end;
        end;
    end;
end;

%Normal completion
ErrFlg=0;