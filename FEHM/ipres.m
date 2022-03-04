function ipres(ipi_in)

%Calculates and writes initial hydrostatic pressure (.iap and .icp file)
%using parameters from .ipi file.
%SYNTAX
%   ipres() reads a local '.ipi' file FILENAME.ipi and uses parameters
%   within to calculate the initial ambient hydrostat for nodes in a local
%   '.fehm' file using temperatures from a local '.fin' file. The initial
%   cold hydrostat is also calculated, assuming 2degC everywhere. Ambient
%   hydrostat is written to FILENAME.iap, cold hydrostat is written to
%   FILENAME.icp.
%
%   ipres(ipi_in) instead reads 'ipi_in' as the input '.ipi' file. Output
%   will use the same root as 'ipi_in', with the '.iap' and '.icp'
%   extensions.
%
%FORMAT
%   Initial pressure input files (.ipi):
%
%   BLANK_LINE
%   lagrit
%   DELTA_Z
%   REFERENCE_DEPTH, REFERENCE_PRESSURE, REFERENCE_TEMPERATURE
%   BLANK_LINE
%
%   Where lagrit is a literal string, and the first and fifth lines are
%   blank. DELTA_Z is the interval used in calculating hydrostatic
%   pressures, and the REFERENCE values serve as an anchor point, and all
%   calculated values are relative to this reference.
%
%EXAMPLE
%   ipres()
%
%   heatin('NewRun.ipi')
%
%   See also ROCKPROP, HEATIN, HEATOUT.
%
%   Written by Dustin Winslow, UCSC Hydrogeology
%   Revision: 1.0 , 2013/07/21

%INPUT
%--------------------------

disp('Locating FEHM (.fehm) file...')
fehmfile=getfile('*.fehm*');

disp('Locating outsize zone (_outside.zone) file...')
outsidefile=getfile('*outside.zone');

disp('Locating FEHM output (.fin) file...')
finfile=getfile('*.fin');

disp('Locating water properties (.wpi) file...')
wpifile=getfile('*.wpi');

if nargin<1
    fprintf('%s\n\n','Locating ipres input (.ipi) file...')
    root=getfile('*.ipi');
else
    root=ipi_in;
end
root=root(1:end-4);

%Read .wpi
disp(['Reading file: ',wpifile])
fid=fopen(wpifile);
lookup=textscan(fid,'%f%f%f%*f%*f%*f%*f%*f%*f%*f%*f');
fclose(fid);

lookup_P=lookup{1};
lookup_T=lookup{2};
lookup_rho=lookup{3};
clearvars lookup

%Read .fehm(n)
disp(['Reading file: ',fehmfile])
[node,coor]=getnode(fehmfile);
coor=round(1e3.*coor)./1e3;%round to nearest mm for interpolation

%Read _outside.zone
disp(['Reading file: ',outsidefile])
node_sflr=getzone('top',outsidefile);
coor_sflr=coor(node_sflr,:);

%Read .fin
disp(['Reading file: ',finfile])
fid=fopen(finfile);
T_in=cell2mat(textscan(fid,'%f','Headerlines',5));
fclose(fid);

%Read .ipi
disp(['Reading file: ',root,'.ipi'])
fid=fopen([root,'.ipi']);
ipi=cell2mat(textscan(fid,'%f','Delimiter',',','Headerlines',2));
fclose(fid);

%INTERPOLATION
%-------------------------
plane=0;
if length(unique(coor(:,1)))==1, plane=1;end
if length(unique(coor(:,2)))==1, plane=2;end

if plane%   WORKING IN 2D
    %Create false 3D by replicating grid into 3 parallel slices
    disp('Grid is 2D, replicating grid for false 3D...')
    coor_sflr_3d=repmat(coor_sflr,3,1);
    coor_sflr_3d(:,plane)=coor_sflr_3d(:,plane)+[10+zeros(length(node_sflr),1);zeros(length(node_sflr),1);-10+zeros(length(node_sflr),1)];
    coor_3d=repmat(coor,3,1);
    coor_3d(:,plane)=coor_3d(:,plane)+[10+zeros(length(node),1);zeros(length(node),1);-10+zeros(length(node),1)];
    T_3d=repmat(T_in,3,1);
else%       WORKING IN 3D
    coor_sflr_3d=coor_sflr;
    coor_3d=coor;
    T_3d=T_in;
end

disp('Generating interpolants...')
%Make a seafloor interpolant for depth
sflr_interp = TriScatteredInterp(coor_sflr_3d(:,1),coor_sflr_3d(:,2),coor_sflr_3d(:,3));

%Make temperature interpolant
T_interp = TriScatteredInterp(coor_3d(:,1),coor_3d(:,2),coor_3d(:,3),T_3d); %#ok<*DTRIINT>

%Make density interpolant from lookup table
rho_interp=TriScatteredInterp(lookup_P,lookup_T,lookup_rho); 

%INITIALIZE .IPI DATA
%--------------------------
%Set initial z,T,P point at top of grid
z_spc=ipi(1);
z0=max(coor(:,3));
T0=ipi(4);
if z0==ipi(2)
    P0=ipi(3);
else
    %Extrapolate up or down a column at bottom-water depth
    z_spc_tmp=sign(z0-ipi(2)).*min(abs(z0-ipi(2))/10,z_spc);
    delz=ipi(2):z_spc_tmp:z0; %#ok<BDSCI>
    delP=ipi(3);
    for i=2:length(delz)
        delP(i)=delP(i-1)-9.80665E-6*z_spc_tmp*rho_interp(delP(i-1),T0);
    end
    P0=delP(end);
    %Note this process operates with different sign conventions than that
    %done below, as the bootstrapping direction is uncertain here.
end


%DETERMINE PRESSURES
%---------------------------
disp('Determining pressures...')
disp('   ')
Pamb_node=zeros(size(node));
Pcold_node=zeros(size(node));
[~,loc_ind,~]=unique(round(coor(:,1:2)),'rows');%identify columns with unique (x,y)

for i=1:length(loc_ind)%loop over each column
    %Progress bar
    if mod(i,20)==0
    fprintf('\b\b\b\b%3.0f',100*(length(Pamb_node)-length(find(Pamb_node==0)))/length(Pamb_node))
    fprintf('%s','%')
    end
    
    %identify which nodes are in column
    col_ind=round(coor(:,1))==round(coor(loc_ind(i),1)) & round(coor(:,2))==round(coor(loc_ind(i),2));
    x=round(coor(find(col_ind,1),1));
    y=round(coor(find(col_ind,1),2));
    zmin=min(coor(col_ind,3));%bottom of column
    
    %build pressure column
    Pamb=P0;%initialize pressure
    Pcold=P0;
    
    z=(z0:-z_spc:zmin-z_spc)';%build depth column
    z(z<min(coor(:,3)))=[];%dont allow z to extend beyond interpolant domains
    
    Tamb=zeros(size(z));
    zb_ind=(z+z_spc/2)<=sflr_interp(x,y);%determine which depths in z are below the seafloor
    zbelow=z(zb_ind);
    
    Tamb(zb_ind)=T_interp(zeros(size(zbelow))+x,zeros(size(zbelow))+y,zbelow+z_spc/2);%build temperature column between nodes
    Tamb(z+z_spc/2>sflr_interp(x,y))=T0;%set temperatures above seafloor to bottom water
    Tcold=zeros(size(Tamb))+T0;
    
    %bootstrap down the column
    for j=2:length(z)
        Pamb(j)=Pamb(j-1)+9.80665E-6*z_spc*rho_interp(Pamb(j-1),Tamb(j));
        Pcold(j)=Pcold(j-1)+9.80665E-6*z_spc*rho_interp(Pcold(j-1),Tcold(j));
    end
    %if find(isnan(Pamb)), keyboard, end
    Pamb_node(col_ind)=interp1(z,Pamb,coor(col_ind,3),'linear','extrap');
    Pcold_node(col_ind)=interp1(z,Pcold,coor(col_ind,3),'linear','extrap');
    
end

if ~isempty(Pamb(isnan(Pamb))), warning ('iPres:P_ambOutofRange','P_amb (.iap) includes NaN values, lookup.in not cover full range of conditions.'),end
if ~isempty(Pcold(isnan(Pcold))), warning ('iPres:P_coldOutofRange','P_cold (.icp) includes NaN values, lookup.in not cover full range of conditions.'),end

%OUTPUT
%-----------------------------
fprintf('\n%s\n',['Writing output to file: ',root,'.iap'])

fid=fopen([root,'.iap'],'w');
fprintf(fid,'%17.7f%21.7f%21.7f%21.7f',ones(4,1));
fprintf(fid,'\n%17.7f%21.7f%21.7f%21.7f',ones(length(Pamb_node)-4,1));
fprintf(fid,'\n%17.7f%21.7f%21.7f%21.7f',Pamb_node);
fclose(fid);

disp(['Writing output to file: ',root,'.icp'])

fid=fopen([root,'.icp'],'w');
fprintf(fid,'%17.7f%21.7f%21.7f%21.7f',ones(4,1));
fprintf(fid,'\n%17.7f%21.7f%21.7f%21.7f',ones(length(Pcold_node)-4,1));
fprintf(fid,'\n%17.7f%21.7f%21.7f%21.7f',Pcold_node);
fclose(fid);

end