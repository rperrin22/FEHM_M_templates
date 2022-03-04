function plotsedsiphon(mat_in)

load(mat_in)
load('outcropareas.mat')

%Data Prep
%---------
x=[perm10p5;perm11;perm11p5;perm_aq12b12;perm12p5;perm13;perm13p5;perm14;perm14p5;perm15;...
    perm11p25;perm11p75;perm12p25;perm12p75];
y=[repmat(-10.5,length(perm10p5),1);repmat(-11,length(perm11),1);repmat(-11.5,length(perm11p5),1);...
    repmat(-12,length(perm_aq12b12),1);repmat(-12.5,length(perm12p5),1);repmat(-13,length(perm13),1);...
    repmat(-13.5,length(perm13p5),1);repmat(-14,length(perm14),1);repmat(-14.5,length(perm14p5),1);...
    repmat(-15,length(perm15),1);...
    repmat(-11.25,length(perm11p25),1);repmat(-11.75,length(perm11p75),1);...
    repmat(-12.25,length(perm12p25),1);repmat(-12.75,length(perm12p75),1)];

xi=-15:.01:-11;
yi=-15:.01:-10.5;
[Xi,Yi]=meshgrid(xi,yi);

z_Qd=[hot_aq12r10p5_Qd;hot_aq12r11_Qd;hot_aq12r11p5_Qd;hot_aq12r12_Qd;hot_aq12r12p5_Qd;hot_aq12r13_Qd;...
    hot_aq12r13p5_Qd;hot_aq12r14_Qd;hot_aq12r14p5_Qd;hot_aq12r15_Qd;...
    hot_aq12r11p25_Qd;hot_aq12r11p75_Qd;hot_aq12r12p25_Qd;hot_aq12r12p75_Qd];
zi_Qd_interp=TriScatteredInterp(x,y,z_Qd,'linear');
zi_Qd=zi_Qd_interp(Xi,Yi);

z_Qr=[hot_aq12r10p5_Qr;hot_aq12r11_Qr;hot_aq12r11p5_Qr;hot_aq12r12_Qr;hot_aq12r12p5_Qr;hot_aq12r13_Qr;...
    hot_aq12r13p5_Qr;hot_aq12r14_Qr;hot_aq12r14p5_Qr;hot_aq12r15_Qr;...
    hot_aq12r11p25_Qr;hot_aq12r11p75_Qr;hot_aq12r12p25_Qr;hot_aq12r12p75_Qr];
zi_Qr_interp=TriScatteredInterp(x,y,z_Qr,'linear');
zi_Qr=zi_Qr_interp(Xi,Yi);

z_sedvel_v=[hot_aq12r10p5_sedvel_v;hot_aq12r11_sedvel_v;hot_aq12r11p5_sedvel_v;hot_aq12r12_sedvel_v;hot_aq12r12p5_sedvel_v;hot_aq12r13_sedvel_v;...
    hot_aq12r13p5_sedvel_v;hot_aq12r14_sedvel_v;hot_aq12r14p5_sedvel_v;hot_aq12r15_sedvel_v;...
    hot_aq12r11p25_sedvel_v;hot_aq12r11p75_sedvel_v;hot_aq12r12p25_sedvel_v;hot_aq12r12p75_sedvel_v];
zi_sedvel_v_interp=TriScatteredInterp(x,y,z_sedvel_v,'linear');
zi_sedvel_v=zi_sedvel_v_interp(Xi,Yi);

z_sedvel_Q=[hot_aq12r10p5_sedvel_Q;hot_aq12r11_sedvel_Q;hot_aq12r11p5_sedvel_Q;hot_aq12r12_sedvel_Q;hot_aq12r12p5_sedvel_Q;hot_aq12r13_sedvel_Q;...
    hot_aq12r13p5_sedvel_Q;hot_aq12r14_sedvel_Q;hot_aq12r14p5_sedvel_Q;hot_aq12r15_sedvel_Q;...
    hot_aq12r11p25_sedvel_Q;hot_aq12r11p75_sedvel_Q;hot_aq12r12p25_sedvel_Q;hot_aq12r12p75_sedvel_Q];
zi_sedvel_Q_interp=TriScatteredInterp(x,y,z_sedvel_Q,'linear');
zi_sedvel_Q=zi_sedvel_Q_interp(Xi,Yi);

zi_Qsed=zi_Qr-zi_Qd;

%Plotting
%--------
figure(1)
imagesc(xi,yi,flipud(zi_Qsed))
colormap(copper(16))
axis equal;
colorbar;
xlim([-15,-11])
title('Total flow through sediment (kg/s)')

figure(2)
subplot(211)
imagesc(xi,yi,flipud(zi_sedvel_v.*3.1556926e10))
colormap(copper(16))
axis equal;
colorbar;
xlim([-15,-11])
title('Median flow through sediment (velocities) [mm/yr]')
subplot(212)
imagesc(xi,yi,flipud(zi_sedvel_Q.*3.1556926e10))
colormap(copper(16))
axis equal;
colorbar;
xlim([-15,-11])
title('Median flow through sediment (sink flow/node area) [mm/yr]')

figure(3)
subplot(211)
Tr=Ab.*10.^-12;
semilogx((10.^perm_aq12b12.*Ab)./Tr,hot_aq12r12_Qr-hot_aq12r12_Qd,'-ok',...
    (10.^perm_aq12m12.*Am)./Tr,hot_med_Qr-hot_med_Qd,'-^k',...
    (10.^perm_aq12s12.*As)./Tr,hot_small_Qr-hot_small_Qd,'-sk');
xlabel('T_D / T_R')
ylabel('Q_sed (kg/s)')
xlim([1e-4,1])
legend('Large discharge OC','Med discharge OC','Small discharge OC')

subplot(212)
semilogx((10.^perm12.*Ab)./Tr,hot_aq13r12_Qr-hot_aq13r12_Qd,'-vk',...
    (10.^perm_aq12b12.*Ab)./Tr,hot_aq12r12_Qr-hot_aq12r12_Qd,'-ok',...
    (10.^[perm12;-11.5].*Ab)./Tr,hot_aq11r12_Qr-hot_aq11r12_Qd,'-^k');
xlabel('T_D / T_R')
ylabel('Q_sed (kg/s)')
xlim([1e-4,1])
legend('aq -13','aq -12','aq-11')

end
