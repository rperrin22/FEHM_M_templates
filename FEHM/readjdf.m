function readjdf(mat_out)

%Updated 6.29.15

if nargin<1
    error('Must enter a .mat filename to save to.')
end

%Specify directories by aquifer
dir_aq100={'p15sip','p14sip','p13sip',...
    'p12sip','p11_9','p11_8','p11_7','p11_6','p11p5sip',...
    'p11sip','p10sip'}';
dir_aq200={'p15sip','p14sip','p13sip',...
    'p12_5','p12_4','p12_3','p12_2','p12_1','p12sip',...
    'p11p5sip','p11sip','p10sip'}';
dir_aq300={'p15sip','p14sip','p13sip','p12_9','p12_8','p12_7','p12_6','p12_5',...
    'p12_4','p12_3','p12_2','p12_1','p12_r2','p11p5','p11'}';
dir_aq600={'p15sip','p14sip','p13sip','p12_9','p12_8','p12_7','p12_6','p12_5',...
    'p12_4','p12_3','p12_2','p12_1','p12_r2','p11p5','p11'}';

%Specify directories for outcrop tests
dir_oc13={'p13','p12_5','p12','p11_5','p11'}';
dir_oc12_5={'p13','p12_7','p12_6','p12_5','p12','p11_5','p11'}';
dir_oc11_5={'p13','p12_5','p12_4','p12_3','p12_2','p12_1','p12','p11_5','p11'}';
dir_oc11={'p13','p12_5','p12_4','p12_3','p12_2','p12_1','p12','p11_5','p11'}';

dir_rc13={'rc13/p13','rc12_5/p13','p13sip','rc11_5/p13','rc11/p13'}';
dir_dc13={'dc13/p13','dc12_5/p13','p13sip','dc11_5/p13','dc11/p13'}';
dir_rc12_5={'rc13/p12p5','rc12_5/p12p5','p12_5','rc11_5/p12p5','rc11/p12p5'}';
dir_dc12_5={'dc13/p12p5','dc12_5/p12p5','p12_5','dc11_5/p12p5','dc11/p12p5'}';
dir_rc12={'rc13/p12','rc12_5/p12','p12_r2','rc11_5/p12','rc11/p12'}';
dir_dc12={'dc13/p12','dc12_5/p12','p12_r2','dc11_5/p12','dc11/p12'}';
dir_rc11_5={'rc13/p11_5','rc12_5/p11_5','p11p5','rc11_5/p11_5','rc11/p11_5'}';
dir_dc11_5={'dc13/p11_5','dc12_5/p11_5','p11p5','dc11_5/p11_5','dc11/p11_5'}';
dir_rc11={'rc13/p11','rc12_5/p11','p11','rc11_5/p11','rc11/p11'}';
dir_dc11={'dc13/p11','dc12_5/p11','p11','dc11_5/p11','dc11/p11'}';

%Specify directories for sink tests
dir_sink12={'p12_r2','sink1/p12','sink10/p12','sink20/p12','sink30/p12',...
    'sink40/p12','sink50/p12','sink60/p12','sink70/p12','sink80/p12',...
    'sink90/p12','sink100/p12'}';
dir_sink11_5={'p11p5','sink1/p11p5','sink10/p11p5','sink20/p11p5','sink30/p11p5',...
    'sink40/p11p5','sink50/p11p5','sink60/p11p5','sink70/p11p5','sink80/p11p5',...
    'sink90/p11p5','sink100/p11p5','sink110/p11p5_r1','sink120/p11p5_r1',...
    'sink130/p11p5_r1','sink140/p11p5','sink150/p11p5','sink160/p11p5'}';
dir_sink11={'p11','sink1/p11','sink10/p11','sink20/p11','sink30/p11',...
    'sink40/p11','sink50/p11','sink60/p11','sink70/p11','sink80/p11',...
    'sink90/p11','sink100/p11','sink110/p11_r1','sink120/p11_r1',...
    'sink130/p11_r1','sink140/p11_r1','sink150/p11_r1','sink160/p11'}';

%Specify directories for anisotropy tests
dir_anibulk2={'T2x14','T2x13','T2x12_5','T2x12'};
dir_anibulk5={'T5x14','T5x13','T5x12_5','T5x12'};
dir_anibulk10={'p12x13','T10x12_5','p11x12_r1'};
dir_anibulk100={'p12x14','p11x13_r1','T100x12_5'};

dir_aniplane2={'T2x14','T2x13','T2x12'};
dir_aniplane5={'T5x14','T5x13','T5x12'};
dir_aniplane10={'p12x13','p11x12_r1'};
dir_aniplane100={'p12x14','p11x13'};

root_in={'aq100','aq200','aq300','aq600',...
    'oc13','oc12_5','oc11_5','oc11',...
    'sink12','sink11_5','sink11',...
    'rc13','dc13','rc12_5','dc12_5',...
    'rc12','dc12','rc11_5','dc11_5','rc11','dc11'...
    'anibulk2','anibulk5','anibulk10','anibulk100',...
    'aniplane2','aniplane5','aniplane10','aniplane100'}';
path_in={'4km_500k_100aq',...   %100
    '4km_500k_200aq',...        %200
    '4km_500k_300aq',...        %300
    '4km_500k_600aq',...        %600
    '4km_500k_300aq/oc13',...   %oc13
    '4km_500k_300aq/oc12_5',... %oc12_5
    '4km_500k_300aq/oc11_5',... %oc11_5
    '4km_500k_300aq/oc11',...   %oc11
    '4km_500k_300aq',...        %sink12
    '4km_500k_300aq',...        %sink11_5
    '4km_500k_300aq',...        %sink11
    '4km_500k_300aq',...        %rc13
    '4km_500k_300aq',...        %dc13
    '4km_500k_300aq',...        %rc12_5
    '4km_500k_300aq',...        %dc12_5
    '4km_500k_300aq',...        %rc12
    '4km_500k_300aq',...        %dc12
    '4km_500k_300aq',...        %rc11_5
    '4km_500k_300aq',...        %dc11_5
    '4km_500k_300aq',...        %rc11
    '4km_500k_300aq',...        %dc11
    '4km_500k_300aq/anibulk',...%anibulk2
    '4km_500k_300aq/anibulk',...%anibulk5
    '4km_500k_300aq/anibulk',...%anibulk10
    '4km_500k_300aq/anibulk',...%anibulk100
    '4km_500k_300aq/aniplane',...%aniplane2
    '4km_500k_300aq/aniplane',...%aniplane5
    '4km_500k_300aq/aniplane',...%aniplane10
    '4km_500k_300aq/aniplane'}';%aniplane100

%Calculate number of models
forlength=zeros(length(root_in),1);
for i=1:length(root_in)
    eval(['forlength(i)=length(dir_',root_in{i},');']);
end
nmodel=sum(forlength);
n=1;

%Read conductive
disp('Reading conductive run...')
Qcond=Qout_to('noconduit/4km_500k_300aq/p15',0,'p15.00001_sca_node.avs');

%Read coupled
disp('Reading coupled runs...')
for i=1:length(root_in)
    eval([root_in{i},'_Qs=zeros(size(dir_',root_in{i},'));']);
    eval([root_in{i},'_Fs=',root_in{i},'_Qs;']);
    eval([root_in{i},'_O=',root_in{i},'_Qs;']);
    eval([root_in{i},'_vy=',root_in{i},'_Qs;']);
    eval([root_in{i},'_vy1=',root_in{i},'_Qs;']);
    eval([root_in{i},'_vy3=',root_in{i},'_Qs;']);
    eval([root_in{i},'_qdiff5=',root_in{i},'_Qs;']);
    
    eval([root_in{i},'_qNode=cell(size(dir_',root_in{i},'));']);
    eval([root_in{i},'_qd=cell(size(dir_',root_in{i},'));']);
    eval([root_in{i},'_qdf=cell(size(dir_',root_in{i},'));']);
    eval([root_in{i},'_qf=cell(size(dir_',root_in{i},'));']);
    eval([root_in{i},'_vmagbb=cell(size(dir_',root_in{i},'));']);
    eval([root_in{i},'_qdMean=',root_in{i},'_Qs;']);
    eval([root_in{i},'_qdfMean=',root_in{i},'_Qs;']);
    eval([root_in{i},'_qfMean=',root_in{i},'_Qs;']);
    
    for j=1:forlength(i)
        fprintf('\n%s%u%s%u%s\n\n','Reading model (',n,'/',nmodel,')');
        n=n+1;
        
        eval(['Q=Qout_to([''noconduit/'',''',path_in{i},'/'',','dir_',root_in{i},'{j}],1);']);
        
        qdiff=Q.qsed-Qcond.qsed;
        eval([root_in{i},'_qNode{j}=Q.qNode;']);
        eval([root_in{i},'_qdiff5(j)=sum(Q.Ased(qdiff<-5))./sum(Q.Ased);']);
        
        eval([root_in{i},'_qd{j}=qdiff;']);
        eval([root_in{i},'_qdMean(j)=mean(qdiff);']);
        
        eval([root_in{i},'_qdf{j}=qdiff./Qcond.qsed;']);
        eval([root_in{i},'_qdfMean(j)=mean(qdiff./Qcond.qsed);']);
        
        eval([root_in{i},'_qf{j} = Q.qsed ./ Qcond.qsed;']);
        eval([root_in{i},'_qfMean(j) = sum(Q.qsed) ./ sum(Qcond.qsed);']);
        
        vy=sort(Q.vycen);
        eval([root_in{i},'_vy(j)=mean(Q.vycen);']);
        eval([root_in{i},'_vy1(j)=vy(ceil(length(vy).*.25));']);
        eval([root_in{i},'_vy3(j)=vy(ceil(length(vy).*.75));']);
        
        eval([root_in{i},'_vmagbb{j} = Q.vmagbb;']);
        
        eval([root_in{i},'_Qs(j)=Q.out2-Q.in2;']);
        eval([root_in{i},'_Fs(j)=(Q.out2-Q.in2)./(Q.out1+Q.out2);']);
        eval([root_in{i},'_O(j)=Q.out2;']);
    end
    
end

%Specify perm vectors for plotting
perm100=[-15:-13, -12:.1:-11.5, -11:-10]';
perm200=[-15:-13, -12.5:.1:-12, -11.5,-11:-10]';
perm300=[-15:-14, -13:.1:-12, -11.5:.5:-11]';
perm600=[-15:-14, -13:.1:-12, -11.5:.5:-11]';
perm_oc13=[-13:.5:-11]';
perm_oc12_5=sort([-13:.5:-11, -12.7:.1:-12.6])';
perm_oc11_5=sort([-13:.5:-11, -12.4:.1:-12.1])';
perm_oc11=sort([-13:.5:-11, -12.4:.1:-12.1])';
s_sink100=[0,1,10:10:90,100]';
s_sink160=[0,1,10:10:160]';
perm_rc=(-13:.5:-11)';
perm_dc=(-13:.5:-11)';
perm_ani=[-14,-13,-12.5,-12]';

clearvars dir_aq100 dir_aq200 dir_aq300 dir_aq600 ...
    dir_aq100_oc dir_aq200_oc dir_aq300_oc dir_aq600_oc ...
    dir_oc13 dir_oc12_5 dir_oc11_5 dir_oc11 ...
    dir_sink12 dir_sink11_5 dir_sink11 ...
    dir_rc13 dir_dc13 dir_rc12_5 dir_dc12_5 ...
    dir_rc12 dir_dc12 dir_rc11_5 dir_dc11_5 dir_rc11 dir_dc11 ...
    dir_anibulk2 dir_anibulk5 dir_anibulk10 dir_anibulk100 ...
    dir_aniplane2 dir_aniplane5 dir_aniplane10 dir_aniplane100 ...
    qdiff ...
    Q i j n

save(mat_out)

end