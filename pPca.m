function [t_oid,z]=ppca(xo,oid,vid,maxpc,idrop,penawd,icol,col);
%function [t_oid,z]=ppca(xo,oid,vid,maxpc,idrop,penawd,icol,col);
%
%Last up-date : PJ 27.09.96
%
%This is Phil's standard software for PCA
%You need to specify :
%1. the matrix, x
%2. the observation labels, oid
%3. the variable labels, vid
%4. the maximum # PCs to plot, maxpc
%5. the maximum number of missing values for a variable, idrop
%6. a title string, penawd
%7. a label to control interpretation of colour vector
%   icol=0 assumes col takes values 0 (mv) and 1 to 5
%   otherwise the vector col will be partitioned into 5 groups
%   according to the values in col
%8. an optional 'response' vector for colouring the plots, col
%9. optionally, clustering purity can be calculated. Need to edit
%   code
%
%Missing values (=-99) are eliminated
%  - by variable : a variable with more than idrop missing values
%    is dropped
%  - by observation : all remaining observations with missing 
%    values
%You can iterate to select the best compromise between omitting 
%observations and variables.
%
%Variables with variances less than 1e-10 are also dropped

orient portrait ;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%eliminate pca.ps hard-copy, if required
 
%unix('if ( -e ppca.ps ) mv ppca.ps ppca_old.ps');
%unix('if ( -e ppcac.ps ) mv ppcac.ps ppcac_old.ps');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%setting up colour scheme for display of y
%
if isempty(col)==1;
  col=oid;
  icol=0;
end;

%icol=0 means that the values of col are 0 == missing
%and 1,2,3,4,5 for the different groupings
%icol=1 means that you will sort the col values and colour them using
%5 colours

nc=5;

if icol==1;

  t1=(col==-99);

  n1=sum(t1);
  n2=sum(~t1);
  n3=floor(n2/nc);
  n4=rem(n2,nc);

  t2=zeros(1,n1);
  for i=1:nc;
    t2 = [t2 i*(ones(1,n3))];
  end;
  t2=[t2 nc*(ones(1,n4))];
  t2=t2';

  [t3,t4]=sort(col);

  col(t4)=t2;
  y=col;

  clear t1 t2 t3 t4 n1 n2 n3 n4;

end;

lliw=['b-';'c-';'g-';'m-';'r-'];
%lliw=['b-';'g-';'r-'];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Loop finding best compromise to omit missing values
%
happy='N';
while (happy=='N');

  %omit variables with too many missing values
  s1=xo==-99;
  s2=sum(s1);
  s3=s2<=idrop;
  x1=xo(:,s3);
  t1vid=vid(s3);
  fprintf( 1,'Eliminating %d variables with more than %d mv\n',sum(s2>idrop),idrop );
  if size(t1vid,1)<=60;
    fprintf( 1,'Keeping' );
    disp(t1vid');
  end;

  clear s1 s2 s3;

  %omit observations with missing values
  t1=x1==-99;
  t2=sum(t1');
  t3=t2==0;
  x1=x1(t3,:);
  fprintf( 1,'Eliminating %d observations with mv :\n',sum(t2~=0) );
  %disp((oid(~t3))')
  t_oid=oid(t3);
  t_col=col(t3);

  clear t1 t2 t3;

  % omit variables with small variances
  s2=sum(std(x1)<1e-10);
  s3=std(x1)>=1e-10;
  x=x1(:,s3);
  t_vid=t1vid(s3);
  fprintf( 1,'Eliminating %d variables with small variances\n',s2);
  if size(t1vid,1)<=30;
    fprintf( 1,'Keeping' );
    disp(t_vid');
  end;

  clear s2 s3;
  
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

end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%If matrix x is large enough, continue
%

clf;

if (size(x,1)>=5) & (size(x,2)>=3 );
  
  fprintf(1,'PCA using %d obs and %d vars\n',size(x,1),size(x,2));

  %create a label for the observations
  lo=[];
  for k=1:size(t_oid,1);
    t1=sprintf('%5d',t_oid(k));
    lo=[lo ; t1];
  end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf( 1,'Plotting data\n' );

  clf;
  hold on;
  for k1=1:size(t_oid,1);
    for k2=1:5;
      if t_col(k1)==k2;
        plot(t_vid,x(k1,:),lliw(k2));
      end;
    end;
  end;
  set(gca,'FontSize',8);
  if size(t_vid)<=30;
    set(gca,'xlabel',text(0,0,'Variable number','FontSize',8),'XTick',t_vid);
  else
    xlabel(['Variable number']);
  end;
  
  ylabel(['Data']);
  title([penawd ' : ' 'Data']);
  hold off; 

  t_pr=input('Hard-copy? Y/N [N]: ','s');
  if isempty(t_pr);
    t_pr='N';
  end
  if t_pr=='Y' | t_pr=='y';
    print ppcac -dpsc -append
  end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  clf;
  hold on;
  fprintf( 1,'Plotting average vector\n' );
  av=mean(x);
  [sum(t_col==1),sum(t_col==2),sum(t_col==3),sum(t_col==4),sum(t_col==5)];
  if icol==0;
    for k=1:5;
      if sum(t_col==k)>1; 
        plot(t_vid,mean(x(t_col==k,:)),lliw(k)); 
      end;
      if sum(t_col==k)==1; 
        plot(t_vid,x(t_col==k,:),lliw(k)); 
      end;
    end;
  else;
    plot(t_vid,av,'r-');
  end;
  set(gca,'FontSize',8);
  if size(t_vid)<=30
    set(gca,'xlabel',text(0,0,'Variable number','FontSize',8),'XTick',t_vid);
  else
    xlabel(['Variable number']);
  end
  ylabel(['Average value']);
  title([penawd ' : ' 'Average']);

  t_pr=input('Hard-copy? Y/N [N]: ','s');
  if isempty(t_pr);
    t_pr='N';
  end
  if t_pr=='Y' | t_pr=='y';
    print ppcac -dpsc -append
  end;
  hold off;
  clf;

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  clf;
  hold on;
  fprintf( 1,'Plotting standard deviation vector\n' );
  sd=std(x);
  fprintf(1,'Total variance is %d\n',sum(std(x).^2));
  if icol==0;
    ivar=zeros(1,5);
    for k=1:5;
      if sum(t_col==k)>3; 
        plot(t_vid,std(x(t_col==k,:)),lliw(k)); 
        ivar(k)=sum(std(x(t_col==k,:)).^2);
        fprintf(1,'Total variance for colour %d is %d\n',k,sum(std(x(t_col==k,:)).^2));
      end;
    end;
  else;
    plot(t_vid,sd,'r-');
  end;
  set(gca,'FontSize',8);
  if size(t_vid)<=30
    set(gca,'xlabel',text(0,0,'Variable number','FontSize',8),'XTick',t_vid);
  else
    xlabel(['Variable number']);
  end
  if icol==0;
    ylabel(['Standard deviation. Individual colour variances are : ' sprintf(' %i',ivar) ]);
  else;
    ylabel(['Standard deviation']);
  end;
    
  title([penawd ' : ' 'Standard deviation. Average sd = ' num2str(mean(sd)) ' . Total variance = ' num2str(sum(sd.^2)) ]);

  t_pr=input('Hard-copy? Y/N [N]: ','s');
  if isempty(t_pr);
    t_pr='N';
  end
  if t_pr=='Y' | t_pr=='y';
    print ppcac -dpsc -append
  end;
  hold off;
  clf;

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf( 1,'Centering and scaling the data\n' );
  x=x-ones(size(x,1),1)*av;
%  x=x ./ (ones(size(x,1),1)*sd);
  fprintf( 1,'***** No scaling being performed *****\n' );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fprintf( 1,'\nCalculating clustering purity\n' );
% nn_purity(x,t_col,4);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf( 1,'Performing SD\n' );
  
  if size(x,1)>=size(x,2);
    v=cov(x);
    % note that eig does not sort the eigenvalues!!!
    [e,lam]=eig(v);
    t1=diag(lam);
    [t2,id]=sort(-t1);
    t3=-t2>1e-10;
    id=id(t3');
    e=e(:,id');
    lam=t1(id');
    fprintf( 1,'Keeping %d PCs with var>1e-10\n',sum(t3~=0) );
  else
    [e,lam,junk]=svd(x'./sqrt(size(x,1)-1),0);
    lam=diag(lam.^2);
    t3=lam>1e-10;
    id=(1:sum(t3))';
    lam=lam(t3);
    e=e(:,t3);
    fprintf( 1,'Keeping %d PCs with var>1e-10\n',sum(t3~=0) );
  end;

  sl=sum(lam);
  fprintf(1,'Total retained variance is %d\n',sl);
  lam=(100.0/sl)*lam;

  clam=zeros(size(lam,1),1);
  for k=1:size(lam,1);
    clam(k)=sum(lam(1:k));
  end;

  z=x*e;
  k=(1:size(lam,1))';
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf( 1,'Plotting eigenvalue decay\n' )
  plot(k,lam,'ko',k,lam,'k-',k,clam,'k^',k,clam,'k--');
  set(gca,'FontSize',8);
  xlabel(['Eigenvalue number']);
  ylabel(['% Eigenvalue']);
  title([penawd ' : ' 'Eigenvalue decay & Cumulant. Total var = ' num2str(sl) ]);

  t_pr=input('Hard-copy? Y/N [N]: ','s');
  if isempty(t_pr);
    t_pr='N';
  end
  if t_pr=='Y' | t_pr=='y';
    %print ppca -dps -append
	print -djpeg LinPltEgnDcy.jpg
  end;

  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  fprintf( 1,'Plotting eigenvectors 1 2 and 3 \n' )
  plot(t_vid,e(:,1),'r-',t_vid,e(:,2),'g--',t_vid,e(:,3),'b:');
  hold on;
  plot(t_vid,e(:,1),'ro',t_vid,e(:,2),'go',t_vid,e(:,3),'bo');
  set(gca,'FontSize',8);
  text(t_vid(1),e(1,1),'1');text(t_vid(1),e(1,2),'2');text(t_vid(1),e(1,3),'3');
  grid on;
  hold off;
  if size(t_vid)<=30
    set(gca,'xlabel',text(0,0,'Variable number','FontSize',8),'XTick',t_vid);
  else
    xlabel(['Variable number']);
  end
  ylabel(['Eigenvector']);
  title([penawd ' : ' 'Eigenvectors']);

  t_pr=input('Hard-copy? Y/N [N]: ','s');
  if isempty(t_pr);
    t_pr='N';
  end
  if t_pr=='Y' | t_pr=='y';
    %print ppca -dps -append
    print -djpeg LinPltEgnVct.jpg
  end;

  
  %create a label for the eigenvectors
  le=[];
  for k=1:size(e,1);
  % the following line ensures that the character conversion occupies 4 columns
    t1=sprintf('%5i',t_vid(k));
    le=[le ; t1];
  end
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
  for i=1:min(size(lam),maxpc)-1;
    for j=i+1:min(size(lam),maxpc);

      ab=int2str(i);
      or=int2str(j);
      vab=['PC ' ab ' : ' int2str(floor(lam(i))) '%'];
      vor=['PC ' or ' : ' int2str(floor(lam(j))) '%'];
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      fprintf( 1,'Plotting eigenvector contributions to PCs %i and %i\n',i,j );
      if size(t_vid) <= 30;
        plot(e(:,i),e(:,j),'g.');
%       compass(e(:,i),e(:,j),'g');
      else;
        plot(e(:,i),e(:,j),'k.');
      end;
      set(gca,'FontSize',8);
	  if size(t_vid) <=200;
		  ldg=text(e(:,i),e(:,j),le,'FontSize',8);
	  end;
      xlabel(vab);
      ylabel(vor);
      title([penawd ' : ' 'Variable contributions to PC' ab ' and PC' or]);

      t_pr=input('Hard-copy? Y/N [N]: ','s');
  if isempty(t_pr);
    t_pr='N';
  end
      if t_pr=='Y' | t_pr=='y';
        %print ppca -dps -append
		print('-djpeg',sprintf('%s%d_%d','SctLdn',i,j));
	  end;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      fprintf( 1,'Plotting PC scores PC %i vs PC %i\n',i,j );
      if size(t_vid) <= 30;
        hold on;
      else;
        hold off;
      end;
      plot(z(:,i),z(:,j),'r+');
      set(gca,'FontSize',8);
      xlabel(vab);
      ylabel(vor);
      title([penawd ' : ' 'PC scores plot for PC' ab 'vs PC' or]);
      hold off;

      t_pr=input('Hard-copy? Y/N [N]: ','s');
  if isempty(t_pr);
    t_pr='N';
  end
      if t_pr=='Y' | t_pr=='y';
        %print ppca -dps -append
		print('-djpeg',sprintf('%s%d_%d','SctScrNoLbl',i,j));
      end;

      clf;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
      fprintf(1,'Plotting PC scores PC %i vs PC %i with labels\n',i,j );
      plot(z(:,i),z(:,j),'w.');
      set(gca,'FontSize',8);
      hold on;
  
      if sum(t_col==1)>0;
        z1=z((t_col==1)',[i j]); 
        lo1=lo((t_col==1)',:);
        pcs1=text(z1(:,1),z1(:,2),lo1,'FontSize',8,'Color',[0 0 1]);
      end;
  
      if sum(t_col==2)>0;
        z2=z((t_col==2)',[i j]); 
        lo2=lo((t_col==2)',:);
        pcs2=text(z2(:,1),z2(:,2),lo2,'FontSize',8,'Color',[0 1 1]);
      end;
  
      if sum(t_col==3)>0;
        z3=z((t_col==3)',[i j]); 
        lo3=lo((t_col==3)',:);
        pcs3=text(z3(:,1),z3(:,2),lo3,'FontSize',8,'Color',[0 1 0]);
      end;
  
      if sum(t_col==4)>0;
        z4=z((t_col==4)',[i j]); 
        lo4=lo((t_col==4)',:);
        pcs4=text(z4(:,1),z4(:,2),lo4,'FontSize',8,'Color',[1 0 1]);
      end;
  
      if sum(t_col==5)>0;
        z5=z((t_col==5)',[i j]); 
        lo5=lo((t_col==5)',:);
        pcs5=text(z5(:,1),z5(:,2),lo5,'FontSize',8,'Color',[1 0 0]);
      end;
  
      xlabel(vab);
      ylabel(vor);
      title([penawd ' : ' 'PC scores plot for PC' ab 'vs PC' or]);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     fprintf( 1,'\nCalculating clustering purity\n' );
%     nn_purity(z(:,[i j]),t_col,4);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

      t_pr=input('Hard-copy? Y/N [N]: ','s');
      if isempty(t_pr);
        t_pr='N';
      end
      if t_pr=='Y' | t_pr=='y';
        %print ppcac -dpsc -append
		print('-djpeg',sprintf('%s%d_%d','SctScrLbl',i,j));
      end;
      clf;

    end;
  end;
else;

  fprintf(1,'Insufficient obs (%d) and vars (%d) for PCA. Holding\n',size(x,1),size(x,2));
  pause;

end;
