function [q,topnode]=heatout(plotflag,sourcedir,lastflag,avsfile_in)

%Calculate conductive heat output at each node, using Fourier's Law and a
%number of FEHM files assumed to be in the current working directory.
%SYNTAX
%   q = heatout() returns heat output [mW/m2] at all nodes, assuming heat
%   conduction between each node on the top surface and the next node
%   directly below each. The calculation uses the harmonic mean between
%   conductivity values at each node as an effective conductivity.
%
%   q = heatout(plotflag) also creates a heat map of 'q' when plotflag is
%   non-zero.
%
%   [q,topnode]=heatout(...) also outputs the top node numbers.
%
%EXAMPLE
%   q = heatout(1);
%
%   See also GETNODEBELOW, NODE2COOR, GETZONE, GETPT, GETPROP.
%
%   Written by Dustin Winslow, UCSC Hydrogeology
%   Revision: 1.0 , 2013/07/18

if nargin<1,plotflag=0;end
if nargin<2,sourcedir='./';end
if ~strcmp(sourcedir(end),'/'),sourcedir=[sourcedir,'/'];end
if nargin<3,lastflag=0;end
if nargin<4
    fprintf('%s\n','Locating FEHM output (.avs) file...')
    scafile=getfile([sourcedir,'*sca_node.avs'],0,0,lastflag);
else
    scafile=[sourcedir,avsfile_in];
end

%INPUT
%----------------------

disp('Locating outsize zone (_outside.zone) file...')
outsidefile=getfile([sourcedir,'*_outside.zone']);

disp('Locating FEHM (.fehm) file...')
fehmfile=getfile([sourcedir,'*.fehm*']);

disp('Locating conductivity (.cond) file...')
condfile=getfile([sourcedir,'*.cond']);

%Generate top node list
disp(['Reading file: ',outsidefile])
topnode=getzone('top',outsidefile);

%Read sca_node
disp(['Reading file: ',scafile])
[sca,scaheader]=getavs(scafile);
T=sca(:,strncmp(scaheader,'Temperature',11));

%Read .cond
disp(['Reading file: ',condfile])
cond=getprop(condfile);

disp('Finding nodes below top surface...')
nextnode=getnodebelow(topnode,fehmfile);

%Read .fehm(n)
disp(['Reading file: ',fehmfile])
coor=node2coor([topnode;nextnode],fehmfile);
coor=round(1e3.*coor)./1e3;%round to nearest mm for interpolation
topcoor=coor(1:length(topnode),:);
nextcoor=coor(length(topnode)+1:end,:);
clearvars coor

%CALCULATION
%-------------------------
fprintf('%s\n','Calculating heatflow (mW/m2):')

q=-2.*cond(topnode,3).*cond(nextnode,3)./(cond(topnode,3)+cond(nextnode,3)).*(T(topnode)-T(nextnode))./(topcoor(:,3)-nextcoor(:,3));
q=q.*1000;%mW conversion

if plotflag
    heatmap(topcoor,q);
    title('Heat output mW/m^2')
    axis equal;
    if length(plotflag)==2
        caxis(plotflag);
    end
end

end