function readjdf2d(mat_out)

if nargin<1
    error('Must enter a .mat filename to save to.')
end

%Specify directories
dir_aq300_2d={'p12_5','p12','p11_5','p11','p10','p9'}';
dir_aq600_2d={'p12_5','p12','p11_5','p11','p10','p9'}';

root_in={'aq300_2d','aq600_2d'}';
path_in={'aq300','aq600'}';

%Calculate number of models
forlength=zeros(length(root_in),1);
for i=1:length(root_in)
    eval(['forlength(i)=length(dir_',root_in{i},');']);
end
nmodel=sum(forlength);
n=1;

%Read conductive
disp('Reading conductive run...')
Qcond=Qout_to('2d/aq300/b11s14a11_coldstart',0,'b11s14a11_coldstart.00001_sca_node.avs');

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
    eval([root_in{i},'_qdiff10=',root_in{i},'_Qs;']);
    eval([root_in{i},'_qdiff20=',root_in{i},'_Qs;']);
    eval([root_in{i},'_I=',root_in{i},'_Qs;']);
    eval([root_in{i},'_qdf=cell(size(dir_',root_in{i},'));']);
    eval([root_in{i},'_qdfMean=',root_in{i},'_Qs;']);
    eval([root_in{i},'_qNode=cell(size(dir_',root_in{i},'));']);
    eval([root_in{i},'_vmagbb=cell(size(dir_',root_in{i},'));']);

    for j=1:forlength(i)
        fprintf('\n%s%u%s%u%s\n\n','Reading model (',n,'/',nmodel,')');
        n=n+1;
        
        eval(['Q=Qout_to([''2d/'',''',path_in{i},'/'',','dir_',root_in{i},'{j}],1);']);
        
        qdiff=Q.qsed-Qcond.qsed;
        eval([root_in{i},'_qNode{j}=Q.qNode;']);
        eval([root_in{i},'_qdiff5(j)=sum(Q.Ased(qdiff<-5))./sum(Q.Ased);']);
        eval([root_in{i},'_qdiff10(j)=sum(Q.Ased(qdiff<-10))./sum(Q.Ased);']);
        eval([root_in{i},'_qdiff20(j)=sum(Q.Ased(qdiff<-20))./sum(Q.Ased);']);
        
        eval([root_in{i},'_qdf{j}=qdiff./Qcond.qsed;']);
        eval([root_in{i},'_qdfMean(j)=mean(qdiff./Qcond.qsed);']);
        
        vy=sort(Q.vycen);
        eval([root_in{i},'_vy(j)=mean(Q.vycen);']);
        eval([root_in{i},'_vy1(j)=vy(ceil(length(vy).*.25));']);
        eval([root_in{i},'_vy3(j)=vy(ceil(length(vy).*.75));']);
        
        eval([root_in{i},'_vmagbb{j} = Q.vmagbb;']);
        
        eval([root_in{i},'_Qs(j)=Q.out2-Q.in2;']);
        eval([root_in{i},'_Fs(j)=(Q.out2-Q.in2)./(Q.out1+Q.out2);']);
        eval([root_in{i},'_O(j)=Q.out2;']);
        eval([root_in{i},'_I(j)=Q.in2;']);
    end
    
end

%Specify perm vectors for plotting
perm300_2d=[-12.5:.5:-11,-10,-9]';
perm600_2d=[-12.5:.5:-11,-10,-9]';

clearvars dir_aq300 dir_aq600 ...
    Q i j n

save(mat_out)

end