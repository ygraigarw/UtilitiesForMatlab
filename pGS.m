function Out=pGS(i,j);
% 12 combinations of colours and styles which work well in "colour" and "greyscale" images
% Use solid black as a 13th option when necessary

Clr=NaN;
Stl=NaN;

if max(abs(rem(i,1)))>1e-10;
    fprintf(1,'Error: pGS: not integer\n');
    return;
end;

if min(i)<1;
    fprintf(1,'Error: pGS: min(i)<1\n');
    return;
end;

if min(i)<1;
    fprintf(1,'Error: pGS: max(i)>12\n');
    return;
end;

if nargin==1;
    j=1;
end;

if j==1;
    %% Colour
    iC=rem(i,3);if iC==0; iC=3; end;
    t1=[1 0 0]; %red
    t2=[0.2 0.9 0.9]; %just off cyan
    t3=[0.7 1 0.2]; %lime (ish)
    BW=[t1;t2;t3];
    Clr=BW(iC,:);
    Out=Clr;
end;

if j==2;
    %% Style
    iS1=floor((i-1)/3)+1;
    iS=rem(iS1,4);if iS==0; iS=4; end;
    LinSty=cell(4,1);
    LinSty{1}='-'; %solid
    LinSty{2}='--';%dashed
    LinSty{3}=':';%dotted
    LinSty{4}='-.';%dash-dot
    Stl=LinSty{iS};
    Out=Stl;
end;

return;