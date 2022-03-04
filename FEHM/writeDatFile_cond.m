function writeDatFile_cond(prefix,sim_length)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
fid = fopen(sprintf('%s.dat',prefix),'w+');

strings={...
['# ',prefix, '.dat'],...
['# ----------------------------SOLUTION TYPE---------------------------'],...
['sol'],...
['-1  -1'],...
['# -----------------------CONTOUR OUTPUT REQUESTS----------------------'],...
['cont'],...
['surf   100000  365e7'],...
['xyz'],...
['temperature'],...
['material'],...
['flux'],...
['pressure'],...
['liquid'],...
['saturation'],...
['permeability'],...
['velocity'],...
['source'],...
['endavs'],...
['end'],...
['# ----------------------INITIAL VARIABLE GRADIENTS--------------------'],...
['init'],...
  [' 20.5   0.0  2.  0.  0.  2.  0., 0.'],...
['# -----------------------------PERMEABILITY---------------------------'],...
['zone'],...
['file'],...
[sprintf('%s_material.zone',prefix)],...
['perm'],...
['file'],...
[sprintf('%s.perm',prefix)],...
['# -----------------------------ROCK CONDUCTIVITY----------------------'],...
['cond'],...
['file'],...
[sprintf('%s.cond',prefix)],...
['ppor'],...
['file'],...
[sprintf('%s.ppor',prefix)],...
['# ----------------------PRODUCTION------------------------------------'],...
['zone'],...
['file'],...
[sprintf('%s_outside.zone',prefix)],...
['hflx'],...
['-00001 0 0 2.0 1.e6'],...
['0'],...
['hflx'],...
['file'],...
[sprintf('%s.hflx',prefix)],...
['flow'],...
['file'],...
[sprintf('%s.flow',prefix)],...
['# ----------------------MAT PROPERTIES--------------------------------'],...
['rock'],...
['file'],...
[sprintf('%s.rock',prefix)],...
['# -----------------------TIME STEPPING PARAMETERS---------------------'],...
['time'],...
 [sprintf('1.e-4 %.4e 10000  10  0   1   0',sim_length)],...
[''],...
['# --------------------SIM CONTROL PARAMETERS--------------------------'],...
['ctrl'],...
['-50  1.00e-04  25  100 gmre'],...
['1  0  0  2'],...
[''],...
['1  3  1.0'],...
['7  1.3  1.0e-06  3650000.0'],...
['0  1'],...
['stop']};

%Write output 
disp(['Writing output to: ',prefix,'.dat'])

fprintf(fid,'%s\n',strings{1:end-1});
fprintf(fid,'%s',strings{end});
fclose(fid);


end