function Y_new=ppick(Y,varid);
%function Y_new=ppick(Y,varid);
%
%PJ : 22.10.97
%
%This code allows interactive elimination of points from a time-series
%plot with 1:size(Y,1) as x-variable and Y(:,varid) as y-variable.
%
%The output matrix Y_new is the same as the input, apart from the selected
%points which are given a value of -99
%
%A log file pick_log.m is also created, which can be run afterwards in
%MATLAB to reproduce Y_new from Y.
%
%INPUT
%Y	: nxp matrix
%varid 	: column number of matrix to examine
%
%OUTPUT
%Y_new 	: updated matrix with -99 for dropped values
%
%EXAMPLE
%	X00=ppick(X00,21);
% allows interactive elimination of strange values of variable 21 
% of matrix X00

%!if (-e pick_log.m) mv pick_log.m pick_log.m_old

happy='N';
while happy=='N';
   
  xo=(1:size(Y,1))';
  yo=Y(:,varid);
  Y_new=Y;
  
  clf;
  pplt(xo,yo,'ro');
  title(['Variable ' num2str(varid)]);
  
  xd=[];
  yd=[];
  a=[];
  b=[];
  
  %This is the outer loop, which you use to specify a new rectangle of points
  but=0;
  while 1==1;
  
    fprintf(1,'Options : Input first point with LH button\n');
    fprintf(1,'        : End selection of points with RH button\n');
    but=0;
    [a,b,but]=ginput(1);
    if but==3;
      if size(xd,1)>0;
        break;
      else;
        fprintf(1,'Error : no points selected! Terminating\n');
        return;
      end;
    end;
  
    while 1==1;
      while 1==1;
        but=0;
        [a2,b2,but]=ginput(1);
        if but==1;
          break;
        end;
        if but==3 & size(a,1)==2;
          break;
        else;
          fprintf(1,'You need to enter a second corner now\n');
        end;
      end;
      if but==3;
        break;
      end;
      if size(a,1)==1; 
        a=[a;a2]; b=[b;b2];
      else;
        if size(a,1)==2;
          a=[a(2);a2];b=[b(2);b2];
        else;
          fprintf(1,'Error : how did you get here? Terminating\n');
          return;
        end;
      end;

      fprintf(1,'Corners of rectangle are :\n');
      fprintf(1,'(%d,%d)\n',[sort(a) sort(b)]');

      t1=xo>=min(a)&xo<=max(a)&yo>=min(b)&yo<=max(b);
      if sum(t1)>0;
        fprintf(1,'You have highlighted %d points:\n',sum(t1));
        fprintf(1,'(%d,%d)\n',[xo(t1==1) yo(t1==1)]');
        pplt(xo,yo,'ro');
        title(['Variable ' num2str(varid)]);
        if size(xd,1)>0;
          pplt(xd,yd,'bo');
        end;
        pplt(xo(t1==1),yo(t1==1),'go');
        drawnow;  
      else
        fprintf(1,'No points in rectangle!\n');
      end;
    end;
  
    if sum(t1)>0;
      xd=[xd;xo(t1==1)];
      yd=[yd;yo(t1==1)];
      pplt(xd,yd,'bo');
    end;
    drawnow;
    
  end;
     
  clf;
  tmp=yo;
  tmp(xd)=-99;
  pplt(xo,tmp,'ro');
  title(['Variable ' num2str(varid)]);
  fprintf(1,'You are going to drop %d points:\n',size(xd,1));
  fprintf(1,'(%d,%d) ',[xd yd]');
  fprintf(1,'\n');
     
  happy=fprintf('Happy? (Y=RH button /N=LH button)\n');
  [junk1,junk2,but]=ginput(1);
  if but==3;
     happy='Y';
  end;
  if but==1;
     happy='N';
  end;
     
end;
  
fprintf(1,'Eliminating highlighted observations\n');
Y_new(xd,varid)=-99;

fid=fopen('pick_log.m','a');
id_drop=sort(xd);
fprintf(fid,'X([');
fprintf(fid,'%d ',id_drop);
fprintf(fid,'],%d)=-99;',varid);
fprintf(fid,'\n');
fclose(fid);
