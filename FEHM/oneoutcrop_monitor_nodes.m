function node_out=oneoutcrop_monitor_nodes(fehm_in,center_coor,node_dist,z_range)
%Locates nodes in 8 directions in a series of squares surrounding a single
%FEHM outcrop model. Returned order is ascending node numbers, by shell.

if nargin<4
    z_range=[3399;3426];
end

if nargin<3
    node_dist=1e3.*(5:5:20);
else
    node_dist=node_dist(:)';
end

if nargin<2
    center_coor=[40e3;40e3];
end

if nargin<1
    disp('Locating FEHM (.fehm) file...')
    fehm_in=getfile('*.fehm*');
end

fprintf('%s\n\n',['Reading file: ',fehm_in])
[node,coor]=getnode(fehm_in);

%Limit to horizontal slice
node=node(coor(:,3)>=min(z_range) & coor(:,3)<=max(z_range));
coor=round(coor(node,:));

%Build squares
node_out=zeros(8.*length(node_dist),1);
for i=1:length(node_dist)
    square_x=[-1;-1;-1;0;0;1;1;1].*node_dist(i);
    square_y=[-1;0;1;-1;1;-1;0;1].*node_dist(i);
    
    square_coor=[center_coor(1)+square_x,center_coor(2)+square_y];
    
    [~,node_ind,~]=intersect(coor(:,1:2),square_coor,'rows','stable');
    
    fprintf('%s %u %s %g\n','Nodes in shell ',i,' : Distance ',node_dist(i))
    fprintf([repmat('%g ',1,7),'%g\n\n'],node(node_ind))
    node_out(8*i-7:8*i)=node(node_ind);
end

end