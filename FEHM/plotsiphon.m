function plotsiphon(mat_in,txt_out_flag)

if nargin<2,txt_out_flag=0;end
if txt_out_flag
    hot_out=[mat_in(1:end-4),'_hot.txt'];
    cond_out=[mat_in(1:end-4),'_cond.txt'];
end

load(mat_in)
load('outcropareas.mat')

%Data Prep
%---------
x_cond=[perm11;perm11p5;perm12;perm12p5;perm13];
y_cond=[repmat(-11,length(perm11),1);repmat(-11.5,length(perm11p5),1);...
    repmat(-12,length(perm12),1);repmat(-12.5,length(perm12p5),1);repmat(-13,length(perm13),1)];
x_hot=[perm10p5;perm11;perm11p5;perm_aq12b12;perm12p5;perm13;perm13p5;perm14;perm14p5;perm15;...
    perm11p25;perm11p75;perm12p25;perm12p75];
y_hot=[repmat(-10.5,length(perm10p5),1);repmat(-11,length(perm11),1);repmat(-11.5,length(perm11p5),1);...
    repmat(-12,length(perm_aq12b12),1);repmat(-12.5,length(perm12p5),1);repmat(-13,length(perm13),1);...
    repmat(-13.5,length(perm13p5),1);repmat(-14,length(perm14),1);repmat(-14.5,length(perm14p5),1);...
    repmat(-15,length(perm15),1);...
    repmat(-11.25,length(perm11p25),1);repmat(-11.75,length(perm11p75),1);...
    repmat(-12.25,length(perm12p25),1);repmat(-12.75,length(perm12p75),1)];

xi=-15:.01:-11;
yi=-15:.01:-10.5;
yi_cond=xi;
[Xi,Yi]=meshgrid(xi,yi);
[Xi_cond,Yi_cond]=meshgrid(xi,yi_cond);

%F
zF_cond=[cond_aq12r11_F;cond_aq12r11p5_F;cond_aq12r12_F;cond_aq12r12p5_F;cond_aq12r13_F];
zQ_cond=[cond_aq12r11_Qs;cond_aq12r11p5_Qs;cond_aq12r12_Qs;cond_aq12r12p5_Qs;cond_aq12r13_Qs];
zF_hot=[hot_aq12r10p5_F;hot_aq12r11_F;hot_aq12r11p5_F;hot_aq12r12_F;hot_aq12r12p5_F;hot_aq12r13_F;...
    hot_aq12r13p5_F;hot_aq12r14_F;hot_aq12r14p5_F;hot_aq12r15_F;...
    hot_aq12r11p25_F;hot_aq12r11p75_F;hot_aq12r12p25_F;hot_aq12r12p75_F];
zQ_hot=[hot_aq12r10p5_Qs;hot_aq12r11_Qs;hot_aq12r11p5_Qs;hot_aq12r12_Qs;hot_aq12r12p5_Qs;hot_aq12r13_Qs;...
    hot_aq12r13p5_Qs;hot_aq12r14_Qs;hot_aq12r14p5_Qs;hot_aq12r15_Qs;...
    hot_aq12r11p25_Qs;hot_aq12r11p75_Qs;hot_aq12r12p25_Qs;hot_aq12r12p75_Qs];

zFi_cond_interp=TriScatteredInterp(x_cond,y_cond,zF_cond,'linear');
zQi_cond_interp=TriScatteredInterp(x_cond,y_cond,zQ_cond,'linear');
zFi_hot_interp=TriScatteredInterp(x_hot,y_hot,zF_hot,'linear');
zQi_hot_interp=TriScatteredInterp(x_hot,y_hot,zQ_hot,'linear');

zFi_cond=zFi_cond_interp(Xi_cond,Yi_cond);
zQi_cond=zQi_cond_interp(Xi_cond,Yi_cond);
zFi_hot=zFi_hot_interp(Xi,Yi);
zQi_hot=zQi_hot_interp(Xi,Yi);

%Plotting
%--------

figure(1)
subplot(211)
contour(xi,yi,round(zFi_hot.*100)./100,0:.05:.3);
axis equal;
hold on
plot([-15,-11],[-15,-11],'--k')
scatter(x_hot(:),y_hot(:),'filled')
hold off
title('Siphon startup F')
subplot(212)
imagesc(xi,yi,flipud(zQi_hot))
colormap(copper(16))
axis equal;
colorbar;
xlim([-15,-11])

figure(2)
subplot(211)
contour(xi,yi_cond,round(zFi_cond.*100)./100,0:.05:.3);
axis equal;
hold on
plot([-15,-11],[-15,-11],'--k')
scatter(x_cond(:),y_cond(:),'filled')
hold off
title('Cond startup F')
xlim([-15,-11])
subplot(212)
imagesc(xi,yi,flipud(zQi_cond))
colormap(copper(16))
axis equal;
colorbar;
xlim([-15,-11])

figure(3)
Tr=Ab.*10.^-12;
subplot(311)
semilogx((10.^perm_aq12b12.*Ab)./Tr,hot_aq12r12_Qs,'-ok',...
    (10.^perm_aq12m12.*Am)./Tr,hot_med_Qs,'-^k',...
    (10.^perm_aq12s12.*As)./Tr,hot_small_Qs,'-sk');
xlim([1e-4,1])
ylim([0,65])
title('Models with recharging OC at -12, aq -12')
xlabel('T_D / T_R')
ylabel('Q_S (kg/s)')
legend('Large discharge OC','Med discharge OC','Small discharge OC')
subplot(312)
semilogx((10.^perm_aq12b12.*Ab)./Tr,hot_aq12r12_F,'-ok',...
    (10.^perm_aq12m12.*Am)./Tr,hot_med_F,'-^k',...
    (10.^perm_aq12s12.*As)./Tr,hot_small_F,'-sk');
xlim([1e-4,1])
ylim([0,.8])
legend('Large discharge OC','Med discharge OC','Small discharge OC')
xlabel('T_D / T_R')
ylabel('F_s')
subplot(313)
plot(perm_aq12b12,hot_aq12r12_Qs,'-ok',...
    perm_aq12m12,hot_med_Qs,'-^k',...
    perm_aq12s12,hot_small_Qs,'-sk');
ylim([0,65])

figure(4)
logTr=log10(Ab.*10.^-12);
subplot(211)
plot(log10(10.^perm_aq12b12.*Ab)./logTr,hot_aq12r12_Qs,'-ok',...
    log10(10.^perm_aq12m12.*Am)./logTr,hot_med_Qs,'-^k',...
    log10(10.^perm_aq12s12.*As)./logTr,hot_small_Qs,'-sk');
xlim([1,1.8])
ylim([0,65])
xlabel('log(T_{D}) / log(T_{R})')
ylabel('Q_S (kg/s)')
legend('Large discharge OC','Med discharge OC','Small discharge OC')
subplot(212)
plot(log10(10.^perm_aq12b12.*Ab)./logTr,hot_aq12r12_F,'-ok',...
    log10(10.^perm_aq12m12.*Am)./logTr,hot_med_F,'-^k',...
    log10(10.^perm_aq12s12.*As)./logTr,hot_small_F,'-sk');
xlim([1,1.8])
ylim([0,.8])
legend('Large discharge OC','Med discharge OC','Small discharge OC')
xlabel('log(T_{D}) / log(T_{R})')
ylabel('F_s')

minsiphonperm=[-12.7;-12.5;-12.4;-12.1;-12];
kd=10.^[(-12.5:.5:-11)';-13];
kr=10.^[(-12.5:.5:-11)';-12];
Ad=repmat(As,5,1);
Ar=repmat(Ab,5,1);
ratiolog=log10(kd.*Ad)./log10(kr.*Ar);
figure(5)
errorbar(ratiolog,minsiphonperm,[.1,.1,.1,.1,.1],'ok')
xlim([1.3,1.7])
ylim([-12.9,-11.7])
xlabel('log(T_{D}) / log(T_{R})')
ylabel('Minimum k for siphon')
title('Adjusting OC k on JdF geometry (1 big, 1 small)')

figure(6)
subplot(211)
semilogx((10.^perm12.*Ab)./Tr,hot_aq13r12_Qs,'-sk',...
    (10.^perm_aq12b12.*Ab)./Tr,hot_aq12r12_Qs,'-ok',...
    (10.^[perm12;-11.5].*Ab)./Tr,hot_aq11r12_Qs,'-^k',...
    (10.^[-15,-11].*Ab)./Tr,[5,5],'-r',...
    (10.^[-15,-11].*Ab)./Tr,[20,20],'-r');    
ylim([0,105])
title('Models with recharging OC at -12')
xlabel('T_D / T_R')
ylabel('Q_S')
subplot(212)
semilogx((10.^perm12.*Ab)./Tr,hot_aq13r12_F,'-sk',...
    (10.^perm_aq12b12.*Ab)./Tr,hot_aq12r12_F,'-ok',...
    (10.^[perm12;-11.5].*Ab)./Tr,hot_aq11r12_F,'-^k');
ylim([0,1.05])
legend('aq -13','aq -12','aq-11')
xlabel('T_D / T_R')
ylabel('F_S')
legend('aq -13','aq -12','aq-11')

if txt_out_flag
    fid=fopen(hot_out,'w');
    fprintf(fid,'%10s\t%10s\t%10s\t%10s\n','k_discharge','k_recharge','Fs','Qs');
    fprintf(fid,'%10.3f\t%10.3f\t%10.3f\t%10.3f\n',[x_hot,y_hot,zF_hot,zQ_hot]');
    fclose(fid);
    
    fid=fopen(cond_out,'w');
    fprintf(fid,'%10s\t%10s\t%10s\t%10s\n','k_discharge','k_recharge','Fs','Qs');
    fprintf(fid,'%10.3f\t%10.3f\t%10.3f\t%10.3f\n',[x_cond,y_cond,zF_cond,zQ_cond]');
    fclose(fid);
end



end
