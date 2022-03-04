function Q=Qout_to(sourcedir,lastflag,avsfile_in)

if nargin<1,sourcedir='./';end
if ~strcmp(sourcedir(end),'/'),sourcedir=[sourcedir,'/'];end
if nargin<2,lastflag=0;end

if nargin<3
    fprintf('%s\n','Locating FEHM output (.avs) file...')
    avsfile=getfile([sourcedir,'*sca_node.avs'],0,0,lastflag);
else
    avsfile=[sourcedir,avsfile_in];
end

heatInTot = 2084.1717.*1e9;%mW
vecfile=[avsfile(1:end-12),'vec_node.avs'];

%Locate files
%------------
fprintf('%s\n','Locating OUTSIDE ZONE (_outside.zone) file...')
outsidefile=getfile([sourcedir,'*outside.zone']);

fprintf('%s\n','Locating ZONE (*.zone) file...')
zonefile=getfile([sourcedir,'*.zone'],1);

fprintf('%s\n','Locating FEHM (.fehm) file...')
fehmfile=getfile([sourcedir,'*.fehm*']);

fprintf('%s\n','Locating AREA (.area) file...')
areafile=getfile([sourcedir,'*.area']);

disp('Locating conductivity (.cond) file...')
condfile=getfile([sourcedir,'*.cond']);

%Gather node numbers
%-------------------
disp('Reading node numbers and zones...')
node_top=getzone('top',outsidefile);
area_top=getzone('top',areafile);
node_oc1=getzone(2,zonefile);
node_oc2=getzone(3,zonefile);
node_aq=getzone(4,zonefile);

node_sbi_up=getnode(fehmfile,[30e3,50e3,50e3,80e3,3500,3550]);
node_center=getnode(fehmfile,[-1e3,81e3,60e3,70e3,-25,4025]);
node_hflx_int=getnode(fehmfile,[-1e3,81e3,-1e3,131e3,3975,4025]);
node_exclude=[getnode(fehmfile,[35.75e3,44.25e3,35.75e3,44.25e3,3975,4025]);...
    getnode(fehmfile,[37.75e3,42.25e3,87.75e3,92.25e3,3975,4025])];

%Parse node numbers
%------------------
node_aqcenter=intersect(node_aq,node_center);

[node_hflx_int_top,~,ind_top_int]=intersect(node_hflx_int,node_top);
area_top_int=area_top(ind_top_int,3);

[node_hflx_up,ind_excludeOC]=setdiff(node_hflx_int_top,node_exclude);
area_hflx_up=area_top_int(ind_excludeOC);

node_dn=getnodebelow([node_sbi_up;node_hflx_up],fehmfile);
node_sbi_dn=node_dn(1:length(node_sbi_up));
node_hflx_dn=node_dn(length(node_sbi_up)+1:end);

topnode_oc1=intersect(node_oc1,node_top);
topnode_oc2=intersect(node_oc2,node_top);

%Read avs
%--------
[avs,avsheader]=getavs(avsfile);
vec=getavs(vecfile);

Scol=find(cellfun(@(in)~isempty(strfind(in,'Source')),avsheader),1,'first');
Tcol=find(cellfun(@(in)~isempty(strfind(in,'Temperature')),avsheader),1,'first');

cond=getprop(condfile);

%Calculate heatflow fraction
coor=node2coor([node_hflx_up;node_hflx_dn],fehmfile);
coor=round(1e3.*coor)./1e3;%round to nearest mm for interpolation
coor_hflx_up=coor(1:length(node_hflx_up),:);
coor_hflx_dn=coor(length(node_hflx_up)+1:end,:);
clearvars coor

fprintf('%s\n','Calculating heatflow (mW/m2):')
qsed=-2.*cond(node_hflx_up,3).*cond(node_hflx_dn,3)./(cond(node_hflx_up,3)+cond(node_hflx_dn,3))...
    .*(avs(node_hflx_up,Tcol)-avs(node_hflx_dn,Tcol))./(coor_hflx_up(:,3)-coor_hflx_dn(:,3));

%Save to structure
%-----------------
Q.Tsbi_all=avs(node_sbi_up,Tcol)+.5.*(avs(node_sbi_up,Tcol)-avs(node_sbi_dn,Tcol));
Q.Tsbi=mean(Q.Tsbi_all);

Q.qsed=qsed.*1000;%mW conversion
Q.Ased=area_hflx_up;%note: only the subset used in qsed in Ased
Q.qNode=node_hflx_up;

Q.heatInTot = heatInTot;

Q.vycen=vec(node_aqcenter,2);

if max(vec(topnode_oc2, 3)) <= 0,
    Q.vmagbb = vec(topnode_oc2, 2);
else
    Q.vmagbb = vec(topnode_oc2, 3);
end

Q.S_tot=avs(:,Scol);
Q.out_tot=sumpos(Q.S_tot);
Q.in_tot=sumpos(-Q.S_tot);

Q.S1=avs(topnode_oc1,Scol);
Q.out1=sumpos(Q.S1);
Q.in1=sumpos(-Q.S1);

Q.S2=avs(topnode_oc2,Scol);
Q.out2=sumpos(Q.S2);
Q.in2=sumpos(-Q.S2);

end