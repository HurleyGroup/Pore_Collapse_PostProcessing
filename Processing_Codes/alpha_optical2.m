clc,clear all; close all;
tic;

time=1:40;

res=0.025;

for i=0:40
Frame=i;
node_coordinates=importdata('/data1/sghosh29/Pore_collapse/Validation_July2024/Al/Al6/Processing_codes/Data_output_L/nodeCoordinates_Job1_Frame'+string(Frame)+'.txt');

NX(1:length(node_coordinates),i+1)=node_coordinates(:,1);
NY(1:length(node_coordinates),i+1)=node_coordinates(:,2);
NZ(1:length(node_coordinates),i+1)=node_coordinates(:,3);

end

NX(~any(NX,2),:)=[];
NY(~any(NY,2),:)=[];
NZ(~any(NZ,2),:)=[];

x_lower=min(NX,[],"all");
y_lower=min(NY,[],"all");
z_lower=min(NZ,[],"all");

x_upper=max(NX,[],"all");
y_upper=max(NY,[],"all");
z_upper=max(NZ,[],"all");


tstep=length(time);

load('/data1/sghosh29/Pore_collapse/Analysis_Al_6/Saved_data/Triangle_coordinates.mat');
% TXS=TXS+x_lower;
% TYS=TYS+y_lower;
% TZS=TZS+z_lower;

nDT=size(TXS,1);

connectivity=importdata('/data1/sghosh29/Pore_collapse/Validation_July2024/Al/Al6/Processing_codes/Data_output_L/connectivity_Job1.txt');
connectivity(~any(connectivity,2),:)=[];

nx=ceil((x_upper-x_lower)/res);
ny=ceil((y_upper-y_lower)/res);
nz=ceil((z_upper-z_lower)/res);

I=zeros(nx,ny,nz);

% scatter3(NX(:,40),NY(:,40),NZ(:,40),'.','MarkerEdgeAlpha',0.1)
% tno=40;
% tx=TXS(:,:,tno);
% ty=TYS(:,:,tno);
% tz=TZS(:,:,tno);
% hold on
% 
% for k=1:length(tx)
% 
% P1=[tx(k,1);ty(k,1);tz(k,1)];
% P2=[tx(k,2);ty(k,2);tz(k,2)];
% P3=[tx(k,3);ty(k,3);tz(k,3)];
% P4=[tx(k,4);ty(k,4);tz(k,4)];
% 
% T=[1 2 3 4];
% 
% X=[P1 P2 P3 P4]';
% 
% tetramesh(T,X)
% 
% % scatter3(tx(k,1),ty(k,1),tz(k,1),'r.');
% % hold on
% % scatter3(tx(k,2),ty(k,2),tz(k,2),'r.');
% % scatter3(tx(k,3),ty(k,3),tz(k,3),'r.');
% % scatter3(tx(k,4),ty(k,4),tz(k,4),'r.');
% end

%% 

for Frame=[0:39]%[2,6,8,10,12]%[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18]%[1,3,4,5,7]for Frame=[0]
%Frame
elementdensity= importdata('/data1/sghosh29/Pore_collapse/Validation_July2024/Al/Al6/Processing_codes/Data_output_L/elemdensity_Job1_Frame'+string(Frame)+'.txt');
 node_coordinates=importdata('/data1/sghosh29/Pore_collapse/Validation_July2024/Al/Al6/Processing_codes/Data_output_L/nodeCoordinates_Job1_Frame'+string(Frame)+'.txt');

% 
%  node_coordinates(~any(node_coordinates,2),:)=[];
% elementdensity(~any(elementdensity,2),:)=[];

% NX=node_coordinates(:,1);
% NY=node_coordinates(:,2);
% NZ=node_coordinates(:,3);
% % 
% NX(~any(NX,2),:)=[];
% NY(~any(NY,2),:)=[];
% NZ(~any(NZ,2),:)=[];
% 
% x_lower=min(NX);
% x_upper=max(NX);
% 
% y_lower=min(NY);
% y_upper=max(NY);
% 
% z_lower=min(NZ);
% z_upper=max(NZ);

 % scatter3(NX,NY,NZ,'.')



% 
% % Example list of points
 points = node_coordinates;
% 
 inside_box = all(points >= [x_lower, y_lower, z_lower],2) & all(points <= [x_upper, y_upper, z_upper],2);
% 
 nodes_inside = find(inside_box);
% 
matching_indices_1 = find(ismember(connectivity(:,2),nodes_inside));
matching_indices_2 = find(ismember(connectivity(:,3),nodes_inside));
matching_indices_3 = find(ismember(connectivity(:,4),nodes_inside));
matching_indices_4 = find(ismember(connectivity(:,5),nodes_inside));

% 
union_AB = union(matching_indices_1, matching_indices_2);
union_CD = union(matching_indices_3, matching_indices_4);
elements_inside = union(union_AB, union_CD);
% 
% 
for j=1:size(elements_inside,1)
% j
    i=elements_inside(j);


    el_den=elementdensity(i)*(1e+13);
    nodes=connectivity(i,2:5);
    coord_1=node_coordinates(nodes(1),:);
    coord_2=node_coordinates(nodes(2),:);
    coord_3=node_coordinates(nodes(3),:);
    coord_4=node_coordinates(nodes(4),:);
    tetrahedronVertices = [coord_1; coord_2; coord_3; coord_4];
    x_min = (floor(min([coord_1(1), coord_2(1), coord_3(1), coord_4(1)]) / res) * res);
    x_max = (ceil(max([coord_1(1), coord_2(1), coord_3(1), coord_4(1)]) / res) * res);
    y_min = (floor(min([coord_1(2), coord_2(2), coord_3(2), coord_4(2)]) / res) * res);
    y_max = (ceil(max([coord_1(2), coord_2(2), coord_3(2), coord_4(2)]) / res) * res);
    z_min = (floor(min([coord_1(3), coord_2(3), coord_3(3), coord_4(3)]) / res) * res);
    z_max = (ceil(max([coord_1(3), coord_2(3), coord_3(3), coord_4(3)]) / res) * res);

    if x_min<=x_lower || x_max >=x_upper ||y_min<=y_lower || y_max >=y_upper ||z_min<=z_lower || z_max >=z_upper
        continue;  % Skip this iteration and proceed to the next iteration
    end


    [xx, yy, zz] = meshgrid(1:round((x_max-x_min)/res)+1,1:round((y_max-y_min)/res)+1 , 1:round((z_max-z_min)/res)+1); % round because sometime it is like 24.999999

    test_points = [
        x_min + (xx(:)-1) * res,
        y_min + (yy(:)-1) * res,
        z_min + (zz(:)-1) * res
    ];

    test_points = reshape(test_points', [], 3);


    inside_tetrahedron = funPtInTriCheckNd(tetrahedronVertices,test_points);


    local_cube = zeros(size(inside_tetrahedron));
    local_cube(inside_tetrahedron==1) = el_den;


    test_points(:, 1) = round((test_points(:, 1) - x_lower) / res);
    test_points(:, 2) = round((test_points(:, 2) - y_lower) / res);
    test_points(:, 3) = round((test_points(:, 3) - z_lower) / res);
    test_points = int32(test_points);
    test_points = test_points(inside_tetrahedron==1, :);

    I(sub2ind(size(I), test_points(:, 1), test_points(:, 2), test_points(:, 3))) = el_den;

end 
% 
Frame
% 
% hold on
I_out=uint16(I);

for tri=1:nDT

    % [Frame tri]

    tx=TXS(tri,:,Frame+1);  %%remove -ox,-oy-oz
    ty=TYS(tri,:,Frame+1);
    tz=TZS(tri,:,Frame+1);

    % LOL=[tx' ty' tz'];
    % 
    % for ab=1:4
    % 
    %   scatter3(LOL(ab,1),LOL(ab,2),LOL(ab,3),'r*')
    %  hold on
    % end


    iminx=floor(min(tx,[],"all")/res);
    imaxx=ceil(max(tx,[],"all")/res);

    iminy=floor(min(ty,[],"all")/res);
    imaxy=ceil(max(ty,[],"all")/res);
    iminz=floor(min(tz,[],"all")/res);
    imaxz=ceil(max(tz,[],"all")/res);





if imaxx<size(I_out,1)&& imaxy<size(I_out,2)&&imaxz<size(I_out,3) &&iminx>0&& iminy>0&&iminz>0 %keep in frame


    % I_chunk=I_out(iminx:imaxx,iminy:imaxy,iminz:imaxz);
      I_chunk=I(iminx:imaxx,iminy:imaxy,iminz:imaxz);
    % I_chunk=permute(I_chunk,[3 2 1]);

% 
% imwrite(I_chunk(:,:,1),[segmentstackfull,'/',num2str(Frame),'/',nameprefseg,num2str(Frame),'_',num2str(tri),'.tif']);
% for ii=2:size(I_chunk,3)
%     imwrite(I_chunk(:,:,ii),[segmentstackfull,'/',num2str(Frame),'/',nameprefseg,num2str(Frame),'_',num2str(tri),'.tif'],'WriteMode','append')
% end
end

black=0;
white=0;

for i=1:size(I_chunk,1)
    for j=1:size(I_chunk,2)
        for k=1:size(I_chunk,3)
                 px=(i+iminx)*res;py=(j+iminy)*res;pz=(k+iminz)*res;

                 inside_tetrahedron = funPtInTriCheckNd([tx;ty;tz]',[px py pz]);


                    if inside_tetrahedron==1
                          if I_chunk(i,j,k)==0
                                black=black+1;
                         else
                              white=white+1;
                            end
                    end

        end
    end
end

alpha(tri,Frame+1)=(black+white)/white;

end
end

% 
save('/data1/sghosh29/Pore_collapse/Analysis_Al_6/Saved_data/alpha_lowRes.mat',"alpha")
elapsedtime=toc;
