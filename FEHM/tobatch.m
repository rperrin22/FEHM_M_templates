function tobatch(mat_out,prefix)

if nargin<2, prefix='';end
if nargin<1, mat_out='tobatch.mat';end

folderlist=dir;
folderlist={folderlist(3:end).name}';
folderlist(strcmp('mesh',folderlist))=[];

for i=1:length(folderlist)
    varname=[prefix,folderlist{i}];
    eval(['global ',varname])
    eval([varname,'=getto(folderlist{i});']);
end

clearvars folderlist varname i prefix
save(mat_out);

end