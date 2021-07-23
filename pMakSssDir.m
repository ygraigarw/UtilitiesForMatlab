function sessionDir = pMakSssDir(dirNm)
% makes / checks session directory and makes the \results subdirectory
if ~nargin
	dirNm = tempdir;
end

% make directory and subdirectory (in one go) for results
success	= mkdir(fullfile(dirNm, 'results'));

sessionDir = dirNm;

if ~success
	error('.')
end



	