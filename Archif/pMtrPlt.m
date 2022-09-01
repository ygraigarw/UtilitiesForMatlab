function pMtrPlt(X,Lbl);

[S,AX,BigAx,H,HAx]=plotmatrix(X);
for iS=1:size(S,1);
    for jS=1:size(S,2);
        S(iS,jS).Color = 'k';
        S(iS,jS).Marker = '.';
        if jS==1;
            AX(iS,jS).YLabel.String=Lbl(iS);
        end;
        if iS==size(S,1);
            AX(iS,jS).XLabel.String=Lbl(jS);
        end;
        AX(iS,jS).FontSize=25;
        S(iS,jS).MarkerSize=20;
        S(iS,jS).LineWidth=20;
    end;
    H(iS).EdgeColor = 'w';
    H(iS).FaceColor = 'k';
end;

return;