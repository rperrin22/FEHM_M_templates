function plotVertProf(prefix,xloc,yloc,HF)
%UNTITLED10 Summary of this function goes here
%   Detailed explanation goes here

plot_1D_loc = [yloc xloc];

fehmn_filename = sprintf('%s.fehm',prefix);
fidin = fopen(fehmn_filename,'r');

% read in the 'coor' string
temp = fgetl(fidin); %#ok<NASGU>

% get the number of nodes - this will be the second line of the file
num_nodes = str2num(fgetl(fidin)); %#ok<ST2NM>

% initialize coordinate matrix (rows = num_nodes, cols = 8)
M = zeros(num_nodes,9);

for count = 1:num_nodes
    M(count,1:4) = str2num(fgetl(fidin)); %#ok<ST2NM>
end

fclose(fidin);

% convert to table
MT = array2table(M,'VariableNames',...
    {'node','x','y','z','perm','cond','den','heat_cap','por'});

rock_prop_filename = sprintf('%s.rock',prefix);
perm_filename = sprintf('%s.perm',prefix);
cond_filename = sprintf('%s.cond',prefix);

fidin = fopen(rock_prop_filename,'r');
temp = fgetl(fidin); %#ok<NASGU>
while ~feof(fidin)
    temp = str2num(fgetl(fidin)); %#ok<ST2NM>
    if ~isempty(temp)
        MT.den(temp(1):temp(2)) = temp(4);
        MT.heat_cap(temp(1):temp(2)) = temp(5);
        MT.por(temp(1):temp(2)) = temp(6);
    end
end
fclose(fidin);

fidin = fopen(cond_filename,'r');
temp = fgetl(fidin); %#ok<NASGU>
while ~feof(fidin)
    temp = str2num(fgetl(fidin)); %#ok<ST2NM>
    if ~isempty(temp)
        MT.cond(temp(1):temp(2)) = temp(4);
    end
end
fclose(fidin);

fidin = fopen(perm_filename,'r');
temp = fgetl(fidin);
while ~feof(fidin)
    temp = str2num(fgetl(fidin)); %#ok<ST2NM>
    if ~isempty(temp)
        MT.perm(temp(1):temp(2)) = temp(4);
    end
end
fclose(fidin);

Fperm = scatteredInterpolant(MT.x,MT.y,MT.z,MT.perm,'linear');
Fcond = scatteredInterpolant(MT.x,MT.y,MT.z,MT.cond,'linear');
Fpor = scatteredInterpolant(MT.x,MT.y,MT.z,MT.por,'linear');
Fheat_cap = scatteredInterpolant(MT.x,MT.y,MT.z,MT.heat_cap,'linear');
Fden = scatteredInterpolant(MT.x,MT.y,MT.z,MT.den,'linear');

zvec = linspace(min(MT.z),max(MT.z),1000);
xvec = ones(size(zvec))*plot_1D_loc(2);
yvec = ones(size(zvec))*plot_1D_loc(1);

permvec = Fperm(xvec,yvec,zvec);
condvec = Fcond(xvec,yvec,zvec);
porvec = Fpor(xvec,yvec,zvec);
heatcapvec = Fheat_cap(xvec,yvec,zvec);
denvec = Fden(xvec,yvec,zvec);

figure;
ax(1) = subplot(151);
semilogx(permvec,zvec,'linewidth',2);
grid on
ylabel('Elevation (m)')
xlabel('Permeability (m^2)');

ax(3) = subplot(153);
plot(condvec,zvec,'linewidth',2);
grid on
ylabel('Elevation (m)')
xlabel('Thermal Conductivity (W/m-K)');

ax(2) = subplot(152);
plot(porvec,zvec,'linewidth',2);
grid on
ylabel('Elevation (m)')
xlabel('Porosity');

ax(4) = subplot(154);
plot(heatcapvec,zvec,'linewidth',2);
grid on
ylabel('Elevation (m)')
xlabel('Heat Capacity (J/kg-K)');

ax(5) = subplot(155);
plot(denvec,zvec,'linewidth',2);
grid on
ylabel('Elevation (m)')
xlabel('Density (kg/m^3)');

linkaxes(ax,'y')

%%
t_fourier_vec = zeros(size(zvec));
t_fourier_vec(1) = 2;
temp_condvec = fliplr(condvec);

for count = 2:length(zvec)
    meancond = harmmean(temp_condvec(count-1:count));
    t_fourier_vec(count) = t_fourier_vec(count-1) + ((HF/meancond)*(zvec(count) - zvec(count-1)));
end

t_fourier_vec = fliplr(t_fourier_vec);

%%

avs_log = import_avs_log(sprintf('%s.avs_log',prefix),[5 inf]);

figure;
ax(1) = subplot(131);
plot(condvec,zvec,'linewidth',2);
grid on
ylabel('Elevation (m)')
xlabel('Thermal Conductivity (W/m-k)');

ax(2) = subplot(132);
plot(t_fourier_vec,zvec,'k:','linewidth',2);
hold on
grid on
ylabel('Elevation (m)')
xlabel('Temperature (C)')

ax(3) = subplot(133);
grid on
xlabel('Pressure (MPa)')
ylabel('Elevation (m)')
hold on

for count = 1:height(avs_log)

    MO = readtable(sprintf('%s_sca_node.csv',avs_log.FilePrefix(count)));

    % make an interpolator
    FMO = scatteredInterpolant(MO.XCoordinate_m_,MO.YCoordinate_m_,MO.ZCoordinate_m_,MO.Temperature_degC_,'linear');
    FPRES = scatteredInterpolant(MO.XCoordinate_m_,MO.YCoordinate_m_,MO.ZCoordinate_m_,MO.LiquidPressure_MPa_,'linear');

    subplot(132)
    tempvec = FMO(xvec,yvec,zvec);
    plot(tempvec,zvec,'linewidth',2);

    subplot(133)
    presvec = FPRES(xvec,yvec,zvec);
    plot(presvec,zvec,'linewidth',2);

end

linkaxes(ax,'y')

%% plot points on phase diagram
figure; 
scatter(MO.LiquidPressure_MPa_,MO.Temperature_degC_,25,'ks','filled'); 
grid on; 
xlabel('Pressure (MPa)'); 
ylabel('Temperature (C)')
hold on
% plot approximate phase line
plot([0.00060795 0.101 22.064],[0.01 100 373.99],'r','linewidth',2)

end