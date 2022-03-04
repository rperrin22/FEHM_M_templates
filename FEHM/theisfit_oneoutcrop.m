function Q_out = theisfit_oneoutcrop(sourcedir,xy_center,aq_thick,window)
%Fit a theis curve to the pressure output from single outcrop models.

if nargin<4, window=[.5,1];end
if nargin<3, aq_thick=300;end
if nargin<2, xy_center=[40e3,40e3];end
if nargin<1, sourcedir='.';end
if ~strcmp(sourcedir(end),'/'),sourcedir=[sourcedir,'/'];end

disp('Locating permeability (.perm) file...')
permfile=getfile([sourcedir,'*.perm']);

disp('Locating compressibility (.ppor) file...')
pporfile=getfile([sourcedir,'*.ppor']);

disp('Locating rock properties (.rock) file...')
rockfile=getfile([sourcedir,'*.rock']);

disp('Locating water properties (.wpi) file...')
wpifile=getfile([sourcedir,'*.wpi']);

fprintf('%s\n\n','Locating history (.hist) file...')
histfile=getfile([sourcedir,'*.hist']);

perm=getprop(permfile);
aq_comp=getprop(pporfile);
rock=getprop(rockfile);
[den_interp,visc_interp]=getwpi(wpifile);
his=gethist(histfile,1);

perm=median(mean(perm(his.node,:),2));
aq_comp=median(aq_comp(his.node));
porosity=median(rock(his.node,3));

r_vec=sqrt( ( his.coor(:,1)-xy_center(1) ).^2 + ...
    ( his.coor(:,2)-xy_center(2) ).^2 );

subsample_ind=floor(length(his.time).*window(1)) : floor(length(his.time).*window(2));

t_vec=his.time(subsample_ind);
P=his.total_pressure(subsample_ind,:);
T=his.temperature(subsample_ind,:);

[r,t]=meshgrid(r_vec,t_vec);

density_w=den_interp(P,T);
visc=visc_interp(P,T);

density_w=median(density_w(:));
visc=median(visc(:));

clearvars rock his den_interp visc_interp

P=P.*1e6;%convert to Pa from MPa
t=t.*24.*3600;%convert to seconds

disp('Fitting for Q...')
Q_out=fminsearch(@(Q) sum(var(...
    theis(Q,t,r,perm,aq_thick,aq_comp,visc,density_w,porosity ) - P...
    )),1);

ploty=theis(Q_out,t,r,perm,aq_thick,aq_comp,visc,density_w,porosity)-P;
plot(t./3.15569e7,ploty-meshgrid(mean(ploty),t_vec))
xlabel('Time (years)')
ylabel('Fit residuals (Pa)')

end