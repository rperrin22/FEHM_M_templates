function plotjdf_3d(mat_in)

load(mat_in)

Qcut_up=40;
Qcut_dn=5;

%Determine kaq / baq allowed ranges
baq_0=[100;200;300;600];
baq_up_0=[perm100(find(aq100_O <= Qcut_up,1,'last'));...
    perm200(find(aq200_O <= Qcut_up,1,'last'));...
    perm300(find(aq300_O <= Qcut_up,1,'last'));...
    perm600(find(aq600_O <= Qcut_up,1,'last'))];
baq_dn_0=[perm100(find(aq100_O >= Qcut_dn,1,'first'));...
    perm200(find(aq200_O >= Qcut_dn,1,'first'));...
    perm300(find(aq300_O >= Qcut_dn,1,'first'));...
    perm600(find(aq600_O >= Qcut_dn,1,'first'))];

%Interpolate for 400m and 500m aquifers
baq=(100:100:600)';
baq_up=interp1(baq_0,baq_up_0,baq,'spline');
baq_dn=interp1(baq_0,baq_dn_0,baq,'spline');

%Determine kaq / koc allowed ranges
koc=(-13:.5:-11)';
koc_up=[perm_oc13(find(oc13_O <= Qcut_up,1,'last'));...
    perm_oc12_5(find(oc12_5_O <= Qcut_up,1,'last'));...
    perm300(find(aq300_O <= Qcut_up,1,'last'));...
    perm_oc11_5(find(oc11_5_O <= Qcut_up,1,'last'));...
    perm_oc11(find(oc11_O <= Qcut_up,1,'last'))];
koc_dn=[perm_oc13(find(oc13_O >= Qcut_dn,1,'first'));...
    perm_oc12_5(find(oc12_5_O >= Qcut_dn,1,'first'));...
    perm300(find(aq300_O >= Qcut_dn,1,'first'));...
    perm_oc11_5(find(oc11_5_O >= Qcut_dn,1,'first'));...
    perm_oc11(find(oc11_O >= Qcut_dn,1,'first'))];

kaq=(min([baq_dn;koc_dn]) : .1 : max([baq_up;koc_up]))';

%Make 3d grid
[Kaq,Koc,Baq]=meshgrid(kaq,koc,baq);
Z=zeros(size(Kaq));

sy=-12;
sz=300;

for i=1:length(baq)
    Z(Koc==sy & Baq==baq(i) & Kaq<=baq_up(i) & Kaq>=baq_dn(i))=1;
end

for i=1:length(koc)
    Z(Baq==sz & Koc==koc(i) & Kaq<=koc_up(i) & Kaq>=koc_dn(i))=1;
end

slice(Kaq,Koc,Baq,Z,max(kaq),sy,sz)
end
