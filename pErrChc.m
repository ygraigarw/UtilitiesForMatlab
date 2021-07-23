%M-file issues error and calling terminates function if ErrFlg~=0
if ErrFlg~=0;
    fprintf(1,'Error found. Terminating\n');
    return;
end;
