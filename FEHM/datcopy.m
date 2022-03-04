function datcopy (root, datfile_out, sourcedir)

%Copy an FEHM dat file, replacing all root name instances with ROOT.
%
%SYNTAX
%   datcopy() 
%
%EXAMPLE
%   datcopy()
%
%   See also MKFEHMDIR, MKDOTFILES, FIN2INI, IAP2INI.
%
%   Written by Dustin Winslow, UCSC Hydrogeology
%   Revision: 1.0 , 2013/09/16

if nargin<3,sourcedir='.';end

%INPUT
%--------------------
disp('Locating FEHM input (.dat) file...')
datfile=getfile([sourcedir,'/*.dat']);

disp(['Reading file: ',datfile])
fid=fopen(datfile);
datlines=textscan(fid,'%s','Delimiter','\n');
fclose(fid);
datlines=datlines{:};

%REPLACE FILENAMES
%--------------------
fileind=find(strcmp('file',datlines))+1;
swaproot=@(str_in)[root,str_in(strfind(str_in,'.'):end)];

datlines(fileind)=cellfun(swaproot,datlines(fileind),'UniformOutput',0);

%OUTPUT
%-------------------
disp(['Writing file: ',datfile_out])
fid=fopen(datfile_out,'w');
fprintf(fid,'%s\n',datlines{:});
fclose(fid);

end