function Ssn=E_clcSsn(Dts)

%calculate season from matlab date vector;

Ssn=datevec(Dts);
tSsn=Ssn; tSsn(:,2)=1;tSsn(:,3)=1;tSsn(:,4:6)=1; tSsn=datenum(tSsn);
Lp=unique(Ssn(Ssn(:,2)==2 & Ssn(:,3)==29,1));  %leap years
I=false(length(Ssn),1);
for i=1:length(Lp)
    I(Ssn(:,1)==Lp(i))=true;
    
end
Dys=ones(length(I),1)*365; Dys(I)=366;
Ssn=mod((datenum(Ssn)-tSsn)./Dys,1)*360;
