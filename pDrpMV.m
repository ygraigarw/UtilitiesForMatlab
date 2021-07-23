function [t_x,t_oid,t_vid]=pdrop_mv(xo,oid,vid,idrop,go);
%function [t_x,t_oid,t_vid]=pdrop_mv(xo,oid,vid,idrop,go);
%
%PJ 12.06.97
%
%M-function to drop missing values of observations and variables 
%in a sensible way.
%
%Will iterate until you are happy.

happy='N';
while (happy=='N');

  %omit variables with too many missing values
  s1=sum(xo==-99);
  x1=xo(:,s1<=idrop);
  t1vid=vid(s1<=idrop);

  fprintf( 1,'Eliminating %d variables with more than %d mv\n',sum(s1>idrop),idrop );
  if(sum(s1>idrop)<=30);
    fprintf(1,' %d',vid(s1>idrop));
    fprintf(1,'\n');
  end;

  clear s1;

  %omit observations with missing values
  t1=sum(x1'==-99);
  x1=x1(t1==0,:);
  t_oid=oid(t1==0);

  fprintf( 1,'Eliminating %d observations with mv :\n',sum(t1>0) );
  if(sum(t1>0)<=30);
    fprintf(1,' %d',oid(t1>0));
    fprintf(1,'\n');
  end;

  clear t1;

  % omit variables with small variances
  s1=std(x1);
  t_x=x1(:,s1>=1e-10);
  t_vid=t1vid(s1>=1e-10);

  fprintf( 1,'Eliminating %d variables with small variances\n',sum(s1<1e-10));
  if(sum(s1<1e-10)<=30);
    fprintf(1,' %d',t1vid(s1<1e-10));
    fprintf(1,'\n');
  end;

  clear s1;
  
  if nargin==4;
      go=0;
  end;
  if go==0;
      happy=input('Are you happy? Y/N [Y]: ','s');
      if isempty(happy);
          happy='Y';
      end
      if happy=='N' | happy=='n';
          idrop = input('Enter new value of idrop: ');
          if happy=='n';
              happy='N';
          end;
      else
          happy='Y';
      end;
  else;
      happy='Y';
  end;

end;
