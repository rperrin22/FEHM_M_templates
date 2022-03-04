function plotjdf2d(in_2d,in_3d)

load('outcropareas.mat')
load(in_2d)
load(in_3d)

%Generate heatflow tails
tailPerc = 2.5;
hfType = 'qdf';
dataNames = {'aq300_2d'; 'aq600_2d'; 'aq300'; 'aq600'};

for i = 1:length(dataNames)
    eval(['dataLen = length(', dataNames{i}, '_', hfType, ');']);
    eval([dataNames{i}, '_hLow = zeros(dataLen, 1);']);
    eval([dataNames{i}, '_hHigh = zeros(dataLen, 1);']);
    for j = 1:dataLen
        eval(['[', dataNames{i}, '_hLow(j),', dataNames{i}, '_hHigh(j)]', ...
            '= perctails(', dataNames{i}, '_', hfType, '{j}, tailPerc, 1);']);
    end
end

%Seconds per day
spd=3600*24;
spy = spd * 365;

% figure(1)
% subplot(211)
% h=plot(perm300_2d(3:end),aq300_2d_Qs(3:end)./As2.*spy,'-ok',...
%     perm600_2d(2:end),aq600_2d_Qs(2:end)./As2.*spy,'-sk',...
%     perm300(8:end),aq300_Qs(8:end)./As.*spy,'-ok',...
%     perm600(4:end),aq600_Qs(4:end)./As.*spy,'-sk');
% xlim([-13.1,-8.9]);
% %ylim([0.1,150]);
% xlabel('log(k) in aquifer (m^2)');
% ylabel('Mean specific discharge (m/d)');
% legend('b=300m','b=600m','Location','NorthWest')
% set(h(3:4),'MarkerFaceColor','k');
% 
% subplot(212)
% hold on;
% errorbar(perm300_2d(3:end)-.045,aq300_2d_qdfMean(3:end),aq300_2d_hLow(3:end),aq300_2d_hHigh(3:end),'ok');
% errorbar(perm600_2d(2:end)-.015,aq600_2d_qdfMean(2:end),aq600_2d_hLow(2:end),aq600_2d_hHigh(2:end),'sk');
% h1=errorbar(perm300(8:end)+.015,aq300_qdfMean(8:end),aq300_hLow(8:end),aq300_hHigh(8:end),'ok');
% h2=errorbar(perm600(4:end)+.045,aq600_qdfMean(4:end),aq600_hLow(4:end),aq600_hHigh(4:end),'sk');
% set(h1(1),'MarkerFaceColor','k');
% set(h2(1),'MarkerFaceColor','k');
% plot([-16,-9],[-0.05,-0.05],'-b',...
%     [-16,-9],[0.05,0.05],'-b');
% hold off;
% xlim([-13.1,-8.9]);
% ylim([-1,.2]);
% xlabel('log(k) in aquifer (m^2)');
% ylabel('F_H (-)');
% set(h(3:4),'MarkerFaceColor','k');

figure(1)
subplot(211)

q300_2d = zeros(length(aq300_2d_vmagbb), 1);
for i = 1:length(q300_2d)
    q300_2d(i) = mean(aq300_2d_vmagbb{i});
end

q600_2d = zeros(length(aq600_2d_vmagbb), 1);
for i = 1:length(q600_2d)
    q600_2d(i) = mean(aq600_2d_vmagbb{i});
end

q300 = zeros(length(aq300_vmagbb), 1);
for i = 1:length(q300)
    q300(i) = mean(aq300_vmagbb{i});
end

q600 = zeros(length(aq600_vmagbb), 1);
for i = 1:length(q600)
    q600(i) = mean(aq600_vmagbb{i});
end

h=semilogy(perm300_2d(3:end),q300_2d(3:end).*spy,'-ok',...
    perm600_2d(3:end),q600_2d(3:end).*spy,'-sk',...
    perm300(8:end),q300(8:end).*spy,'-ok',...
    perm600(4:end),q600(4:end).*spy,'-sk');

xlim([-13.1,-8.9]);
ylim([0.1,100]);
xlabel('log(k) in aquifer (m^2)');
ylabel('Mean specific discharge (m/y)');
legend('b=300m','b=600m','Location','NorthWest')
set(h(3:4),'MarkerFaceColor','k');

subplot(212)
hold on;
errorbar(perm300_2d(3:end)-.045,aq300_2d_qdfMean(3:end),aq300_2d_hLow(3:end),aq300_2d_hHigh(3:end),'ok');
errorbar(perm600_2d(2:end)-.015,aq600_2d_qdfMean(2:end),aq600_2d_hLow(2:end),aq600_2d_hHigh(2:end),'sk');
h1=errorbar(perm300(8:end)+.015,aq300_qdfMean(8:end),aq300_hLow(8:end),aq300_hHigh(8:end),'ok');
h2=errorbar(perm600(4:end)+.045,aq600_qdfMean(4:end),aq600_hLow(4:end),aq600_hHigh(4:end),'sk');
set(h1(1),'MarkerFaceColor','k');
set(h2(1),'MarkerFaceColor','k');
plot([-16,-9],[-0.05,-0.05],'-b',...
    [-16,-9],[0.05,0.05],'-b');
hold off;
xlim([-13.1,-8.9]);
ylim([-1,.2]);
xlabel('log(k) in aquifer (m^2)');
ylabel('F_H (-)');
set(h(3:4),'MarkerFaceColor','k');

end