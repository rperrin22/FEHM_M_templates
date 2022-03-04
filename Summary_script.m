%% Description
% 
% Summary of the steps I took to run the FEHM simulation
%
% Step 1 - Generate surfaces
%
% Step 2 - Generate a mesh, or if it has already been generated, load the
% mesh.  It would make the most sense to bring this thing into some kind of
% structure, perhaps make this a class.
%
% Step 3 - Build simulation directory using script from Dustin
%
% Step 4 - Build rock properties and boundary condition files
%
% Step 5 -  Run assignment scripts (topbc, heatin, rockprop)
%
% Step 6 - Run FEHM
%
% Step 7 - Build .ipi file and run heatin
% 
% Step 8 - Build subdirectory for coupled run
%
% Step 9 - Perform the coupled run
%
%% load toolboxes
addpath '/home/rperrin/Code_library/Matlab/FEHM';

%% Step 1 - Generate surfaces
model_top = -2000;
model_bottom = -6000;

% create surface mesh vectors
xvec = 1000:50:8000;
yvec = 1000:50:5000;
[XX,YY] = meshgrid(xvec,yvec);

xlength = max(xvec) - min(xvec);
ylength = max(yvec) - min(yvec);
zlength = model_top - model_bottom;

nx = 11;
ny = round(ylength/(xlength/nx));
nz = round(zlength/(xlength/nx));

% make surfaces
Zsf = ones(size(XX)) .* model_top;
Zcrust_top = (ones(size(XX)).*-4000) + (385*sin(XX*0.0008));
Zcrust_bottom = Zcrust_top - 500;
Zmodel_base = ones(size(XX)).*model_bottom;

% export surfaces for LaGriT
dlmwrite('seafloor.xyz',[XX(:) YY(:) Zsf(:)],'delimiter',' '); %#ok<DLMWT> 
dlmwrite('crust_top.xyz',[XX(:) YY(:) Zcrust_top(:)],'delimiter',' '); %#ok<DLMWT> 
dlmwrite('crust_bottom.xyz',[XX(:) YY(:) Zcrust_bottom(:)],'delimiter',' '); %#ok<DLMWT> 
dlmwrite('model_base.xyz',[XX(:) YY(:) Zmodel_base(:)],'delimiter',' '); %#ok<DLMWT> 

%% Step 2 - Generate the mesh from the surfaces
% set prefix
run_prefix = 'tester';
coupled_run_prefix = sprintf('%s_c',run_prefix);

% initialize the mesh object
C = genMesh(run_prefix,nx,ny,nz);
C = C.get_xy_limits;
C = C.set_z_limits(model_bottom, model_top);

% generate LaGriT scripts
C.create_triangulate_script;
C.create_meshing_script;

% run LaGriT scripts
C.run_triangulate;
C.run_meshing;

%% Step 3 - Build simulation directory
% build directory
mkfehmdir(run_prefix,run_prefix);

% move into that directory
cd(run_prefix);

%% Step 4a - Initialize rock properties class
zones = [1,2,3];
R = genProps(run_prefix,zones);

%% Step 4b - Build .hfi file
crust_age = 15; % [Ma]
R = R.createHFI(crust_age);

%% Step 4c - Build .rpi file
% parameters for porosity calculations
% function in the form:
%     FUN=@(depth)A.*exp(B.*depth)+C+D.*depth;
por_A = [0 0 0.7136];
por_B = [1 1 -.3714];
por_C = [0.05 0.1 0];
por_D = [0 0 0];

% parameters for conductivity calc
% function in the form:
%     FUN=@(depth,porosity)A+B.*depth+(KW.^porosity).*(KR.^(1-porosity));
k_A = [0 0 0];
k_B = [0 0 0];
k_KW = [0.62 0.62 0.62];
k_KR = [1.6 1.6 1.6];

% parameters for permeability calc
% functions in the form:
%     VOID=@(porosity)porosity./(1-porosity);%void ratio
%     POWERLAW=@(porosity)C.*1e-18.*(VOID(porosity).^D);
%     EXPONENTIAL=@(porosity)E.*exp(F.*VOID(porosity));
%     MORINSILVA83=@(porosity)G.*0.0001.*10.^(H.*VOID(porosity)+I);
%     FUN=@(depth,porosity)A+B.*depth+POWERLAW(porosity)+EXPONENTIAL(porosity)+MORINSILVA83(porosity);
perm_A = [1e-19 1e-16 1e-19];
perm_B = [0 0 0];
perm_C = [0 0 0];
perm_D = [1 1 1];
perm_E = [0 0 0];
perm_F = [1 1 1];
perm_G = [0 0 0];
perm_H = [1 1 1];
perm_I = [1 1 1];

% parameters for compressibility calc
% functions in the form:
%     LINEARPOROSITY=@(depth)RHOW.*GRAV.*depth.*(C-1-D.*depth.^2./2)+RHOG.*GRAV.*depth.*(depth-C+D.*depth.^2./2);
%     EXPONENTIALPOROSITY=@(depth)GRAV.*depth.*(RHOG-RHOW)+GRAV.*E.*(RHOW-RHOG).*(1-exp(-F.*depth))./F;
%     OVERBURDEN=@(depth)max(LINEARPOROSITY(depth),25);
%     FUN=@(depth,porosity)A+B.*depth+0.435.*G.*(1-porosity)./OVERBURDEN(depth);
comp_A = [1e-9 1e-19 1e-9];
comp_B = [0 0 0];
comp_C = [0 0 0];
comp_D = [0 0 0];
comp_E = [0 0 0];
comp_F = [0 0 0];
comp_G = [0 0 0];
comp_GRAV = [9.81 9.81 9.81];  % gravity yo!
comp_RHOW = [1000 1000 1000];  % water density
comp_RHOG = [2700 2700 2700];  % grain density
comp_SPECHEAT = [800 800 800]; % spec heat of water

% put parameters in structure
R = R.paramPor(por_A,por_B,por_C,por_D);
R = R.paramCond(k_A,k_B,k_KW,k_KR);
R = R.paramComp(comp_A,comp_B,comp_C,comp_D,comp_E,comp_F,comp_G,comp_GRAV,comp_RHOW,comp_RHOG,comp_SPECHEAT);
R = R.paramPerm(perm_A,perm_B,perm_C,perm_D,perm_E,perm_F,perm_G,perm_H,perm_I);

% write the .rpi file
R.createRPI();

%% Step 4c - run assignment scripts
topbc();
heatin();
rockprop();

%% Step 5 - Build the input (.dat) file for the FEHM conductive run
sim_length_years = 5000000;
sim_length = sim_length_years*365; % [days]
writeDatFile_cond(run_prefix,sim_length);

%% Step 6 - Run FEHM for the conductive simulation
system('cp /home/rperrin/Code_library/FEHM/FEHM_lin.exe FEHM_lin.exe');
system(sprintf('cp %s.files fehmn.files',run_prefix));
system(sprintf('cp %s_material.zone %s.zone',run_prefix,run_prefix));
system('./FEHM_lin.exe')

%% Step 7 - build .ipi file and run ipres()

% build .ipi file
ipi_filename = sprintf('%s.ipi',run_prefix);
fid = fopen(ipi_filename,'w+');

strings={...
    [''],...
    ['lagrit'],...
    ['100'],...
    ['-2000, 20.6, 2.0']};

disp(['Writing output to: ',ipi_filename])

fprintf(fid,'%s\n',strings{1:end-1});
fprintf(fid,'%s',strings{end});

fclose(fid);

% run ipres
ipres()

%% Build subdirectory for coupled run
mkfehmdir(coupled_run_prefix,coupled_run_prefix);
cd(coupled_run_prefix);
system(sprintf('cp %s_material.zone %s.zone',coupled_run_prefix));

% make a .files file
steam_table = '/home/rperrin/Geofluids/water_properties/h2o_table_NIST23_091519.txt';
genCoupFiles(coupled_run_prefix,steam_table);

% make a new .dat file for the coupled run
sim_length_years_coupled = 5000;
sim_length_coupled = sim_length_years_coupled*365; % [days]
writeDatFile_coup(coupled_run_prefix,sim_length_coupled);

%% Perform the coupled run
system('cp /home/rperrin/Code_library/FEHM/xfehm_v3.4.0 xfehm_v3.4.0');
system(sprintf('cp %s_material.zone %s.zone',coupled_run_prefix,coupled_run_prefix));
system(sprintf('./xfehm_v3.4.0 %s.files',coupled_run_prefix))
