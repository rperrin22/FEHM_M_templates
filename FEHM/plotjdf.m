function plotjdf(mat_in)

load(mat_in)

%Generate heatflow tails
tailPerc = 2.5;
hfType = 'qdf';
dataNames = {'aq100'; 'aq200'; 'aq300'; 'aq600'; ...
    'oc13'; 'oc12_5'; 'oc11_5'; 'oc11'; ...
    'sink12'; 'sink11_5'; 'sink11'; ...
    'rc12_5'; 'rc12'; 'rc11_5'; 'rc11'; ...
    'dc12_5'; 'dc12'; 'dc11_5'; 'dc11'; ...
    'anibulk2'; 'anibulk5'; 'anibulk10'; 'anibulk100'; ...
    'aniplane2'; 'aniplane5'; 'aniplane10'; 'aniplane100'};

for i = 1:length(dataNames)
    eval(['dataLen = length(', dataNames{i}, '_', hfType, ');']);
    eval([dataNames{i}, '_hLow = zeros(dataLen, 1);']);
    eval([dataNames{i}, '_hHigh = zeros(dataLen, 1);']);
    for j = 1:dataLen
        eval(['[', dataNames{i}, '_hLow(j),', dataNames{i}, '_hHigh(j)]', ...
            '= perctails(', dataNames{i}, '_', hfType, '{j}, tailPerc, 1);']);
    end
end

figure(1)
subplot(311)
h=plot(perm100(4:end),aq100_Qs(4:end),'-vk',...
    perm200(5:end),aq200_Qs(5:end),'-^k',...
    perm300(7:end),aq300_Qs(7:end),'-ok',...
    perm600(3:end),aq600_Qs(3:end),'-sk',...
    [-16,-9],[5,5],'-r',[-16,-9],[20,20],'-r');
    %[-16,-9],[60 60],'-b');
    %[-11,-11,-12,-12],anibulk_Qs,'ok',...
    %-11,aniplane_Qs(1),'or');
ylabel('Q_S (kg/s)')
xlabel('log(k_{A}) (m^2)')
legend('100m','200m','300m','600m','Location','NorthWest')
ylim([0,155]);
xlim([-13.05,-9.95]);
set(h(1:4),'MarkerFaceColor','k');

subplot(312)
hold on;
errorbar(perm100(5:end)-.03,aq100_qdfMean(5:end),aq100_hLow(5:end),aq100_hHigh(5:end),'vk');
errorbar(perm200(6:end)-.01,aq200_qdfMean(6:end),aq200_hLow(6:end),aq200_hHigh(6:end),'^k');
errorbar(perm300(8:end)+.01,aq300_qdfMean(8:end),aq300_hLow(8:end),aq300_hHigh(8:end),'ok');
errorbar(perm600(4:end)+.03,aq600_qdfMean(4:end),aq600_hLow(4:end),aq600_hHigh(4:end),'sk');
plot([-16,-9],[-0.05,-0.05],'-b',...
    [-16,-9],[0.05,0.05],'-b');
hold off;
ylabel('F_H (-)')%Fraction of area with >10mW heat-flow suppression
xlabel('log(k_{A}) (m^2)')
ylim([-.35,.2]);
xlim([-13.05,-9.95]);
%set(h(1:4),'MarkerFaceColor','k');

subplot(313)
h=plot(perm100(5:end),aq100_Fs(5:end),'-vk',...
    perm200(6:end),aq200_Fs(6:end),'-^k',...
    perm300(8:end),aq300_Fs(8:end),'-ok',...
    perm600(4:end),aq600_Fs(4:end),'-sk');
ylabel('F_S (-)')
xlabel('log(k_{A}) (m^2)')
ylim([0,1.05])
xlim([-13.05,-9.95]);
set(h(1:4),'MarkerFaceColor','k');


figure(2)
subplot(121)
h=plot(s_sink100(1:end-5),sink12_Qs(1:end-5),'-ok',...
    s_sink100(1:end-6),s_sink100(1:end-6)+sink12_Qs(1:end-6),'-ok',...
    s_sink160(1:end-2),sink11_5_Qs(1:end-2),'-sk',...
    s_sink160(1:end-3),s_sink160(1:end-3)+sink11_5_Qs(1:end-3),'-sk',...
    s_sink160,sink11_Qs,'-^k',s_sink160,s_sink160+sink11_Qs,'-^k');
set(h([1,3,5]),'MarkerFaceColor','k');
axis equal;
ylabel('Siphon flow (kg/s)')
xlabel('Crustal outflow (kg/s)')
xlim([0,160]);
ylim([0,210]);
legend(h([1,3,5]),'log(k_{A}): -12','-11.5','-11','Location','NorthWest')

subplot(122)
hold on;
errorbar(s_sink100(2:end-6)-3,sink12_qdfMean(2:end-6),sink12_hLow(2:end-6),sink12_hHigh(2:end-6),'ok');
errorbar(s_sink160(2:end-3),sink11_5_qdfMean(2:end-3),sink11_5_hLow(2:end-3),sink11_5_hHigh(2:end-3),'sk');
errorbar(s_sink160(2:end)+3,sink11_qdfMean(2:end),sink11_hLow(2:end),sink11_hHigh(2:end),'^k');
plot([-10,170],[-0.05,-0.05],'-b',...
    [-16,-9],[0.05,0.05],'-b');
hold off;
ylabel('F_H (-)')
xlabel('Crustal outflow (kg/s)')
%ylim([0,.105]);
xlim([-6,166]);


figure(3)
subplot(321)
plot(perm_rc,rc12_5_Qs,'-vk',...
    perm_rc,rc12_Qs,'-ok',...
    perm_rc,rc11_5_Qs,'-sk',...
    perm_rc,rc11_Qs,'-^k',...
    [-16,-9],[5,5],'-r',[-16,-9],[20,20],'-r');
    %[-16,-9],[60 60],'-b')
title('Grizzly Bare permeability')
ylabel('Q_S (kg/s)')
xlabel('log(k_G) (m^2)')
legend('log(k_{A}): -12.5','-12','-11.5','-11','Location','NorthWest')
ylim([0,270]);
xlim([-13.1,-10.9]);

subplot(323)
hold on;
errorbar(perm_rc(2:end)-.075,rc12_5_qdfMean(2:end),rc12_5_hLow(2:end),rc12_5_hHigh(2:end),'vk');
errorbar(perm_rc-.025,rc12_qdfMean,rc12_hLow,rc12_hHigh,'ok');
errorbar(perm_rc+.025,rc11_5_qdfMean,rc11_5_hLow,rc11_5_hHigh,'sk');
errorbar(perm_rc+.075,rc11_qdfMean,rc11_hLow,rc11_hHigh,'^k');
plot([-16,-9],[-0.05,-0.05],'-b',...
    [-16,-9],[0.05,0.05],'-b');
hold off;
ylabel('F_H (-)')
xlabel('log(k_G) (m^2)')
ylim([-.5,.1]);
xlim([-13.1,-10.9]);

subplot(325)
plot(perm_rc(2:end),rc12_5_Fs(2:end),'-vk',...
    perm_rc,rc12_Fs,'-ok',...
    perm_rc,rc11_5_Fs,'-sk',...
    perm_rc,rc11_Fs,'-^k')
ylabel('F_S (-)')
xlabel('log(k_G) (m^2)')
ylim([0,1.05])
xlim([-13.1,-10.9]);

subplot(322)
plot(perm_dc(1:end-1),dc12_5_Qs(1:end-1),'-vk',...
    perm_dc,dc12_Qs,'-ok',...
    perm_dc,dc11_5_Qs,'-sk',...
    perm_dc,dc11_Qs,'-^k',...
    [-16,-9],[5,5],'-r',[-16,-9],[20,20],'-r');
title('Baby Bare permeability')
ylabel('Q_S (kg/s)')
xlabel('log(k_B) (m^2)')
legend('log(k_{A}): -12.5','-12','-11.5','-11','Location','NorthWest')
ylim([0,270]);
xlim([-13.1,-10.9]);

subplot(324)
hold on;
errorbar(perm_dc(1:end-2)-.075,dc12_5_qdfMean(1:end-2),dc12_5_hLow(1:end-2),dc12_5_hHigh(1:end-2),'vk');
errorbar(perm_dc-.025,dc12_qdfMean,dc12_hLow,dc12_hHigh,'ok');
errorbar(perm_dc+.025,dc11_5_qdfMean,dc11_5_hLow,dc11_5_hHigh,'sk');
errorbar(perm_dc+.075,dc11_qdfMean,dc11_hLow,dc11_hHigh,'^k');
plot([-16,-9],[-0.05,-0.05],'-b',...
    [-16,-9],[0.05,0.05],'-b');
hold off;
ylabel('F_H (-)')
xlabel('log(k_B) (m^2)')
ylim([-.5,.1]);
xlim([-13.1,-10.9]);

subplot(326)
plot(perm_dc(1:3),dc12_5_Fs(1:3),'-vk',...
    perm_dc,dc12_Fs,'-ok',...
    perm_dc,dc11_5_Fs,'-sk',...
    perm_dc,dc11_Fs,'-^k',...
    [-16,-9],[5,5],'-r',[-16,-9],[20,20],'-r')
ylabel('F_S (-)')
xlabel('log(k_B) (m^2)')
ylim([0,1.05])
xlim([-13.1,-10.9]);


figure(4)
subplot(311)
plot(perm300(7:end-2),aq300_Qs(7:end-2),'-ok',...
    perm_ani, anibulk2_Qs, '-vk', ...
    perm_ani(2:end), anibulk5_Qs(2:end), '-xk', ...
    perm_ani(2:end), anibulk10_Qs, '-sk', ...
    perm_ani(1:3), anibulk100_Qs, '-^k', ...
    [-16,-9],[5,5],'-r',[-16,-9],[20,20],'-r');
xlim([-13.05,-11.95])
ylim([0,100]);
ylabel('Q_S (kg/s)')
legend('1x','2x','5x','10x','100x','Location','NorthWest')

subplot(312)
hold on;
errorbar(perm300(8:end)-.04,aq300_qdfMean(8:end),aq300_hLow(8:end),aq300_hHigh(8:end),'ok');
errorbar(perm_ani(3)-.02,anibulk2_qdfMean(3),anibulk2_hLow(3),anibulk2_hHigh(3),'vk');
errorbar(perm_ani,anibulk5_qdfMean,anibulk5_hLow,anibulk5_hHigh,'xk');
errorbar(perm_ani(2:end)+.02,anibulk10_qdfMean,anibulk10_hLow,anibulk10_hHigh,'sk');
errorbar(perm_ani(1:3)+.04,anibulk100_qdfMean,anibulk100_hLow,anibulk100_hHigh,'^k');
plot([-16,-9],[-0.05,-0.05],'-b',...
    [-16,-9],[0.05,0.05],'-b');
hold off;
xlim([-13.05,-11.95])

subplot(313)
plot(perm300(7:end-2),aq300_Fs(7:end-2),'-ok',...
    perm_ani, anibulk2_Fs, '-vk', ...
    perm_ani(2:end), anibulk5_Fs(2:end), '-xk', ...
    perm_ani(2:end), anibulk10_Fs, '-sk', ...
    perm_ani(1:3), anibulk100_Fs, '-^k');
xlim([-13.05,-11.95])
ylim([0,1])

% aniperm={'p11p12';'p11p13';'p12p13';'p12p14'};
% disp('Tensor anisotropy (AQ only):')
% fprintf(['%3s %7s %7s %7s %7s\n',...
%     repmat('%3s %7.2f %7.2f %7.2f %7.2f\n',1,3),'\n'],...
%     '',aniperm{:},'Q_D',anibulk_Qs,'F_S',anibulk_Fs,'F_H',anibulk_qdfMean);
% disp('Tensor anisotropy (AQ and OC):')
% fprintf(['%3s %7s %7s %7s %7s\n',...
%     repmat('%3s %7.2f %7.2f %7.2f %7.2f\n',1,3),'\n'],...
%     '',aniperm{:},'Q_D',anibulkoc_Qs,'F_S',anibulkoc_Fs,'F_H',anibulkoc_qdfMean);
% disp('Fault-induced anisotropy:')
% fprintf(['%3s %7s %7s %7s %7s\n',...
%     repmat('%3s %7.2f %7.2f %7.2f %7.2f\n',1,3),'\n'],...
%     '',aniperm{:},'Q_D',aniplane_Qs,'F_S',aniplane_Fs,'F_H',aniplane_qdfMean);

% figure(2)
% subplot(311)
% plot(perm_oc13,oc13_O,'-xk',...
%     perm_oc12_5,oc12_5_O,'-vk',...
%     perm300(end-8:end),aq300_O(end-8:end),'-ok',...
%     perm_oc11_5(end-7:end),oc11_5_O(end-7:end),'-sk',...
%     perm_oc11(end-4:end),oc11_O(end-4:end),'-^k',...
%     [-16,-9],[5,5],'-r',[-16,-9],[20,20],'-r');
% ylabel('Q_S (kg/s)')
% xlabel('log(k_{A}) (m^2)')
% legend('OC 10^{-13}','OC 10^{-12.5}','OC 10^{-12}','OC 10^{-11.5}','OC 10^{-11}','Location','NorthWest')
% ylim([0,420]);
% xlim([-13.05,-10.95]);
% 
% subplot(312)
% hold on;
% errorbar(perm_oc13(2:end)-.015,oc13_qdfMean(2:end),oc13_hLow(2:end),oc13_hHigh(2:end),'xk');
% errorbar(perm_oc12_5(2:end)-.03,oc12_5_qdfMean(2:end),oc12_5_hLow(2:end),oc12_5_hHigh(2:end),'vk');
% errorbar(perm300(end-7:end),aq300_qdfMean(end-7:end),aq300_hLow(end-7:end),aq300_hHigh(end-7:end),'ok');
% errorbar(perm_oc11_5(end-6:end)+.015,oc11_5_qdfMean(end-6:end),oc11_5_hLow(end-6:end),oc11_5_hHigh(end-6:end),'sk');
% errorbar(perm_oc11(end-3:end)+.03,oc11_qdfMean(end-3:end),oc11_hLow(end-3:end),oc11_hHigh(end-3:end),'^k');
% plot([-16,-9],[-0.05,-0.05],'-b');
% hold off;
% ylabel('F_H (-)')
% xlabel('log(k_{A}) (m^2)')
% ylim([-.7,.1]);
% xlim([-13.05,-10.95]);
% % 
% subplot(313)
% plot(perm_oc13,oc13_Fs,'-xk',...
%     perm_oc12_5,oc12_5_Fs,'-vk',...
%     perm300,aq300_Fs,'-ok',...
%     perm_oc11_5,oc11_5_Fs,'-sk',...
%     perm_oc11,oc11_Fs,'-^k')
% ylabel('F_S (-)')
% xlabel('log(k_{A}) (m^2)')
% ylim([0,1])
% xlim([-13.05,-10.95]);

end
