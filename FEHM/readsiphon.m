function readsiphon(mat_out)

if nargin<1
    error('Must enter a .mat filename to save to.')
end

%Specify cond startup directories
dir_cond_aq11r12=flipud({'b12b12';'b12b12p5';'b12b13';'b12b13p5';'b12b14';'b12b14p5';'b12b15'});
dir_cond_aq13r12=dir_cond_aq11r12;

dir_cond_aq12r11=flipud({'b11b11';'b11b11p5';'b11b12';'b11b12p5';'b11b13';'b11b13p5_r1';'b11b14_r1';'b11b14p5_r1';'b11b15_r1'});
dir_cond_aq12r11p5=flipud({'b11p5b11p5_r1';'b11p5b12_r1';'b11p5b12p5_r1';'b11p5b13_r1';'b11p5b13p5_r1';'b11p5b14_r1';'b11p5b14p5_r1';'b11p5b15_r1'});
dir_cond_aq12r12=flipud({'b12b12';'b12b12p5';'b12b13';'b12b13p5';'b12b14';'b12b14p5_r1';'b12b15_r1'});
dir_cond_aq12r12p5=flipud({'b12p5b12p5_r1';'b12p5b13_r1';'b12p5b13p5_r1';'b12p5b14_r1';'b12p5b14p5_r1';'b12p5b15_r1'});
dir_cond_aq12r13=flipud({'b13b13';'b13b13p5';'b13b14';'b13b14p5';'b13b15'});

dir_cond_small=flipud({'b12s11_r1';'b12s11p5_r1';'b12s12';'b12s12p5';'b12s13';'b12s13p5';'b12s14';'b12s14p5';'b12s15'});

%Specify hot startup directories
dir_hot_aq11r12=flipud({'b12b11p5';'b12b12';'b12b12p5';'b12b13';'b12b13p5';'b12b14';'b12b14p5';'b12b15'});
dir_hot_aq13r12=flipud({'b12b12';'b12b12p5';'b12b13';'b12b13p5';'b12b14';'b12b14p5';'b12b15'});

dir_hot_aq12r10p5=flipud({'b10p5b12p5';'b10p5b13';'b10p5b13p5';'b10p5b14';'b10p5b14p5';'b10p5b15'});
dir_hot_aq12r11=flipud({'b11b11';'b11b11p5';'b11b12';'b11b12p5';'b11b13';'b11b13p5';'b11b14';'b11b14p5';'b11b15'});
dir_hot_aq12r11p5=flipud({'b11p5b11p5';'b11p5b12';'b11p5b12p5';'b11p5b13';'b11p5b13p5';'b11p5b14';'b11p5b14p5';'b11p5b15'});
dir_hot_aq12r12=flipud({'b12b12';'b12b12p5';'b12b13';'b12b13p25';'b12b13p5';'b12b13p75';'b12b14';'b12b14p5';'b12b15'});
dir_hot_aq12r12p5=flipud({'b12p5b12p5';'b12p5b13';'b12p5b13p5';'b12p5b14';'b12p5b14p5';'b12p5b15'});
dir_hot_aq12r13=flipud({'b13b13';'b13b13p5';'b13b14';'b13b14p5';'b13b15'});
dir_hot_aq12r13p5=flipud({'b13p5b13p5';'b13p5b14';'b13p5b14p5';'b13p5b15'});
dir_hot_aq12r14=flipud({'b14b14';'b14b14p5';'b14b15'});
dir_hot_aq12r14p5=flipud({'b14p5b14p5';'b14p5b15'});
dir_hot_aq12r15=flipud({'b15b15'});

dir_hot_aq12r11p25=flipud({'b11p25b12p75';'b11p25b13p25';'b11p25b13p75'});
dir_hot_aq12r11p75=flipud({'b11p75b12p75';'b11p75b13p25';'b11p75b13p75'});
dir_hot_aq12r12p25=flipud({'b12p25b12p75';'b12p25b13p25';'b12p25b13p75'});
dir_hot_aq12r12p75=flipud({'b12p75b13p25';'b12p75b13p75';'b12p75b14p25'});

dir_hot_med=flipud({'b12m11';'b12m11p5';'b12m12';'b12m12p25';...
    'b12m12p3';'b12m12p4';'b12m12p5';'b12m12p6';'b12m12p7';'b12m12p8';'b12m12p9';'b12m13';...
    'b12m13p1';'b12m13p2';'b12m13p3';'b12m13p4';'b12m13p5';'b12m14';'b12m14p5';'b12m15'});
dir_hot_small=flipud({'b12s11';'b12s11p1';'b12s11p2';'b12s11p3';'b12s11p4';'b12s11p5';...
    'b12s11p6';'b12s11p7';'b12s11p8';'b12s11p9';'b12s12';...
    'b12s12p5';'b12s13';'b12s13p5';'b12s14';'b12s14p5';'b12s15'});

root_cond={'aq11r12','aq13r12','aq12r11','aq12r11','aq12r11p5','aq12r12','aq12r12p5','aq12r13','small'}';
path_cond={'siphon_cond_start/siphon_big_big_a11/',...
    'siphon_cond_start/siphon_big_big_a13/',...
    'siphon_cond_start/siphon_big_big_a12/',...
    'siphon_cond_start/siphon_big_big_a12/',...
    'siphon_cond_start/siphon_big_big_a12/',...
    'siphon_cond_start/siphon_big_big_a12/',...
    'siphon_cond_start/siphon_big_big_a12/',...
    'siphon_cond_start/siphon_big_big_a12/',...
    'siphon_cond_start/siphon_big_small_a12/'}';

root_hot={'aq11r12','aq13r12','aq12r10p5','aq12r11','aq12r11p5','aq12r12','aq12r12p5','aq12r13',...
    'aq12r13p5','aq12r14','aq12r14p5','aq12r15','aq12r11p25','aq12r11p75','aq12r12p25','aq12r12p75',...
    'small','med'}';
path_hot={'siphon_hot_start/siphon_big_big_a11/',...
    'siphon_hot_start/siphon_big_big_a13/',...
    'siphon_hot_start/siphon_big_big_a12/',...
    'siphon_hot_start/siphon_big_big_a12/',...
    'siphon_hot_start/siphon_big_big_a12/',...
    'siphon_hot_start/siphon_big_big_a12/',...
    'siphon_hot_start/siphon_big_big_a12/',...
    'siphon_hot_start/siphon_big_big_a12/',...
    'siphon_hot_start/siphon_big_big_a12/',...
    'siphon_hot_start/siphon_big_big_a12/',...
    'siphon_hot_start/siphon_big_big_a12/',...
    'siphon_hot_start/siphon_big_big_a12/',...
    'siphon_hot_start/siphon_big_big_a12/',...
    'siphon_hot_start/siphon_big_big_a12/',...
    'siphon_hot_start/siphon_big_big_a12/',...
    'siphon_hot_start/siphon_big_big_a12/',...
    'siphon_hot_start/siphon_big_small_a12/',...
    'siphon_hot_start/siphon_big_med_a12/'}';

%Calculate number of models in each set
forlength_cond=zeros(length(root_cond),1);
forlength_hot=zeros(length(root_hot),1);
for i=1:length(root_cond)
    eval(['forlength_cond(i)=length(dir_cond_',root_cond{i},');']);
end
for i=1:length(root_hot)
    eval(['forlength_hot(i)=length(dir_hot_',root_hot{i},');']);
end
nmodel=sum(forlength_cond)+sum(forlength_hot);
n=1;

%Read cond startup directories
for i=1:length(root_cond)
    eval(['cond_',root_cond{i},'_Qs=zeros(size(dir_cond_',root_cond{i},'));']);
    eval(['cond_',root_cond{i},'_F=cond_',root_cond{i},'_Qs;']);
    eval(['cond_',root_cond{i},'_R=cond_',root_cond{i},'_Qs;']);
    eval(['cond_',root_cond{i},'_sedvel_v=cond_',root_cond{i},'_Qs;']);
    eval(['cond_',root_cond{i},'_sedvel_Q=cond_',root_cond{i},'_Qs;']);
    
    for j=1:forlength_cond(i)
        fprintf('\n%s%u%s%u%s\n\n','Reading model (',n,'/',nmodel,')');
        n=n+1;
        
        eval(['Q=Qout_to([''',path_cond{i},''',','dir_cond_',root_cond{i},'{j}],1);']);
        
        Qs=Q.out2-Q.in2;
        
        F=Qs./(Q.out1+Q.out2);%Fraction of total fluid discharging from basement, transmitted by the siphon
        R=Qs./(Q.out1+Q.in2);%Ratio of siphon flow to local flow
                
        eval(['cond_',root_cond{i},'_Qs(j)=Qs;']);
        eval(['cond_',root_cond{i},'_F(j)=F;']);
        eval(['cond_',root_cond{i},'_R(j)=R;']);
        eval(['cond_',root_cond{i},'_sedvel_v(j)=Q.sedvel_v;']);
        eval(['cond_',root_cond{i},'_sedvel_Q(j)=Q.sedvel_Q;']);
    end
end

%Read hot startup directories
for i=1:length(root_hot)
    eval(['hot_',root_hot{i},'_Qs=zeros(size(dir_hot_',root_hot{i},'));']);
    eval(['hot_',root_hot{i},'_F=hot_',root_hot{i},'_Qs;']);
    eval(['hot_',root_hot{i},'_R=hot_',root_hot{i},'_Qs;']);
    eval(['hot_',root_hot{i},'_sedvel_v=hot_',root_hot{i},'_Qs;']);
    eval(['hot_',root_hot{i},'_sedvel_Q=hot_',root_hot{i},'_Qs;']);
    
    for j=1:forlength_hot(i)
        fprintf('\n%s%u%s%u%s\n\n','Reading model (',n,'/',nmodel,')');
        n=n+1;
        
        eval(['Q=Qout_to([''',path_hot{i},''',','dir_hot_',root_hot{i},'{j}],1);']);
        
        Qs=Q.out2-Q.in2;
                
        F=Qs./(Q.out1+Q.out2);%Fraction of total fluid discharging from basement, transmitted by the siphon
        R=Qs./(Q.out1+Q.in2);%Ratio of siphon flow to local flow
                
        eval(['hot_',root_hot{i},'_Qs(j)=Qs;']);
        eval(['hot_',root_hot{i},'_F(j)=F;']);
        eval(['hot_',root_hot{i},'_R(j)=R;']);
        eval(['hot_',root_hot{i},'_sedvel_v(j)=Q.sedvel_v;']);
        eval(['hot_',root_hot{i},'_sedvel_Q(j)=Q.sedvel_Q;']);
    end
end

%Specify perm vectors for plotting
perm10p5=(-15:.5:-12.5)';
perm11=(-15:.5:-11)';
perm11p5=(-15:.5:-11.5)';
perm12=(-15:.5:-12)';
perm12p5=(-15:.5:-12.5)';
perm13=(-15:.5:-13)';
perm13p5=(-15:.5:-13.5)';
perm14=(-15:.5:-14)';
perm14p5=(-15:.5:-14.5)';
perm15=(-15:.5:-15)';

perm11p25=(-13.75:.5:-12.75)';
perm11p75=(-13.75:.5:-12.75)';
perm12p25=(-13.75:.5:-12.75)';
perm12p75=(-14.25:.5:-13.25)';

perm_aq12b12=[-15:.5:-14,-13.75:.25:-13.25,-13:.5:-12]';
perm_aq12m12=[-15:.5:-13.5,-13.4:.1:-12.3,-12.25,-12:.5:-11]';
perm_aq12s12=[-15:.5:-12.5,-12:.1:-11]';

clearvars dir_cond_aq11r12 dir_cond_aq13r12 dir_cond_aq12r11 dir_cond_aq12r11p5 ...
    dir_cond_aq12r12 dir_cond_aq12r12p5 dir_cond_aq12r13 dir_cond_small ...
    dir_hot_aq11r12 dir_hot_aq13r12 ...
    dir_hot_aq12r10p5 dir_hot_aq12r11 dir_hot_aq12r11p5 ...
    dir_hot_aq12r12 dir_hot_aq12r12p5 dir_hot_aq12r13 ...
    dir_hot_aq12r13p5 dir_hot_aq12r14 dir_hot_aq12r14p5 dir_hot_aq12r15 ...
    dir_hot_aq12r11p25 dir_hot_aq12r11p75 dir_hot_aq12r12p25 dir_hot_aq12r12p75 ...
    dir_hot_small dir_hot_med ...
    Qs F R root_cond root_hot path_cond path_hot ...
    forlength_cond forlength_hot n nmodel Q i j

save(mat_out)

end