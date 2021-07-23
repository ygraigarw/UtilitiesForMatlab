function pPlt(x1,x2,string,verbose);
%function pPlt(x1,x2,string,verbose);
%
%PJ 20.12.96
%
%Plots one or two vectors, ignoring missing values.
%Missing values are coded -99 at present.
%Have to edit code if using different MV code.

hold on;

if nargin==4;
   %Work silently
   if(size(x1,2)>1);
      fprintf(1,'Assuming first argument is abscissa VECTOR\n');
   end;
   a=x1;
   for j=1:size(x2,2);
      b=x2(:,j);
      a2=a(a~=-99 & b~=-99);
      b2=b(a~=-99 & b~=-99);
      pDfl;
      plot(a2,b2,string);
   end;
end;


if(nargin==1);
  a=(1:size(x1,1))'; 
  string='r.';
  for j=1:size(x1,2);
    b=x1(:,j);
    if(sum(a==-99 | b==-99)>0);
      fprintf(1,'Dropping %d missing values of response %d\n',sum(a==-99 | b==-99),j);
    end;
    a2=a(a~=-99 & b~=-99);
    b2=b(a~=-99 & b~=-99);
    pDfl;
    plot(a2,b2,string);
  end;
else;      
  if(nargin==2);
    if isstr(x2)==1;
      a=(1:size(x1,1))';
      string=x2;
      for j=1:size(x1,2);
        b=x1(:,j);
        if(sum(a==-99 | b==-99)>0);
          fprintf(1,'Dropping %d missing values of response %d\n',sum(a==-99 | b==-99),j);
        end;
        a2=a(a~=-99 & b~=-99);
        b2=b(a~=-99 & b~=-99);
        pDfl;
        plot(a2,b2,string);
      end;
    else;
      if(size(x1,2)>1);
        fprintf(1,'Assuming first argument is abscissa VECTOR\n');
      end;
      a=x1;
      string='r.';
      for j=1:size(x2,2);
        b=x2(:,j);
        if(sum(a==-99 | b==-99)>0);
          fprintf(1,'Dropping %d missing values of response %d\n',sum(a==-99 | b==-99),j);
        end;
        a2=a(a~=-99 & b~=-99);
        b2=b(a~=-99 & b~=-99);
        pDfl;
        plot(a2,b2,string);
      end;
    end;
  else;
    if(nargin==3);
      if(size(x1,2)>1);
        fprintf(1,'Assuming first argument is abscissa VECTOR\n');
      end;
      a=x1;
      for j=1:size(x2,2);
        b=x2(:,j);
        if(sum(a==-99 | b==-99)>0);
          fprintf(1,'Dropping %d missing values of response %d\n',sum(a==-99 | b==-99),j);
        end;
        a2=a(a~=-99 & b~=-99);
        b2=b(a~=-99 & b~=-99);
        pDfl;
        h=plot(a2,b2,string);set(h,'MarkerSize',5,'LineWidth',2);
        %h=plot(a2,b2,string);set(h,'MarkerSize',10,'LineWidth',2);
      end;
    end;
  end;
end;

hold off;
