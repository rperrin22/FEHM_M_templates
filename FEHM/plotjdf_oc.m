function plotjdf_oc (mat_in)

load(mat_in)

errorbar(ock,k_Q_y40,k_Q_E40,'.');
ylim([-12.6,-10.9]);
ylabel('Estimated aquifer permeability log(m2)')
xlabel('Simulated OC permeability log(m2)')

hold on;
errorbar(ock,k_Q_y,k_Q_E,'.k');
plot(ock,upperk_q,'-r');
hold off;

end