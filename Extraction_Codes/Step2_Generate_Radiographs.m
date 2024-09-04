clc,clear all; close all;
tic;
format long
%Frame=20;
%res=0.025; %in microns, This is not actual resolution, I am choosing it for compuattaionaly efficency. 

   res=0.025;% actual resolution
    % res=0.025;% resolution
connectivity=importdata('/data1/sghosh29/Pore_collapse/Analysis_SLG_6/Data_output/connectivity_Job1.txt');
%nameprefseg = 'image_Al_singlelayer_294979_linear_new_7_Frame_check2_';

nameprefseg = 'SLG_6_';
segmentstackfull=['/data1/sghosh29/Pore_collapse/Analysis_SLG_6/HighRes_Microstructures/'];

Frame=0;


node_coordinates=importdata('/data1/sghosh29/Pore_collapse/Analysis_SLG_6/Data_output/nodeCoordinates_Job1_Frame'+string(Frame)+'.txt');



NX=node_coordinates(:,1);
NY=node_coordinates(:,2);
NZ=node_coordinates(:,3);


x_lower=min(NX);
x_upper=max(NX);

y_lower=min(NY);
y_upper=max(NY);

z_lower=min(NZ);
z_upper=max(NZ);






nx=ceil((x_upper-x_lower)/res);
ny=ceil((y_upper-y_lower)/res);
nz=ceil((z_upper-z_lower)/res);

I=zeros(nx,ny,nz);
count=1;

for Frame=[0:20]%[2,6,8,10,12]%[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18]%[1,3,4,5,7]for Frame=[0]
Frame
elementdensity= importdata('/data1/sghosh29/Pore_collapse/Analysis_SLG_6/Data_output/elemdensity_Job1_Frame'+string(Frame)+'.txt');

node_coordinates=importdata('/data1/sghosh29/Pore_collapse/Analysis_SLG_6/Data_output/nodeCoordinates_Job1_Frame'+string(Frame)+'.txt');
[nelements,mm]=size(elementdensity);



% NX=node_coordinates(:,1);
% NY=node_coordinates(:,2);
% NZ=node_coordinates(:,3);

nx=ceil((x_upper-x_lower)/res);
ny=ceil((y_upper-y_lower)/res);
nz=ceil((z_upper-z_lower)/res);

I=zeros(nx,ny,nz);





% Example list of points
points = node_coordinates;
%roi=[x_lower,x_upper,y_lower,y_upper,z_lower,z_upper];
%inside_box=findPointsinROI(points,roi);

% Check if points lie inside the box
%inside_box = all(points >= [x_lower, y_lower, z_lower], 2) & all(points <= [x_upper, y_upper, z_upper], 2);

inside_box = all(points >= [x_lower, y_lower, z_lower],2) & all(points <= [x_upper, y_upper, z_upper],2);

% Display the result
%disp(inside_box);

nodes_inside = find(inside_box);

matching_indices_1 = find(ismember(connectivity(:,2),nodes_inside));
matching_indices_2 = find(ismember(connectivity(:,3),nodes_inside));
matching_indices_3 = find(ismember(connectivity(:,4),nodes_inside));
matching_indices_4 = find(ismember(connectivity(:,5),nodes_inside));


union_AB = union(matching_indices_1, matching_indices_2);
union_CD = union(matching_indices_3, matching_indices_4);
elements_inside = union(union_AB, union_CD);


for j=1:size(elements_inside,1)
%for j=1:nelements 
    %j
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
    %local_cube = NaN(floor((x_max-x_min)/res)+1, floor((y_max-y_min)/res)+1, floor((z_max-z_min)/res)+1);
    %[xx, yy, zz] = meshgrid(1:floor((x_max-x_min)/res)+1,1:floor((y_max-y_min)/res)+1 , 1:floor((z_max-z_min)/res)+1);



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

    %inside_tetrahedron = isInsideTetrahedron_2(tetrahedronVertices, test_points);

    local_cube = zeros(size(inside_tetrahedron));
    local_cube(inside_tetrahedron==1) = el_den;


    test_points(:, 1) = round((test_points(:, 1) - x_lower) / res);
    test_points(:, 2) = round((test_points(:, 2) - y_lower) / res);
    test_points(:, 3) = round((test_points(:, 3) - z_lower) / res);
    test_points = int32(test_points);
    test_points = test_points(inside_tetrahedron==1, :);

    I(sub2ind(size(I), test_points(:, 1), test_points(:, 2), test_points(:, 3))) = el_den;


    %local_cube = zeros(size(inside_tetrahedron));
%local_cube(inside_tetrahedron) = value_data(inside_tetrahedron);

end 




I_out=uint16(I);




%I_out = uint16(Densit_dist.test);

imwrite(I_out(:,:,1),[segmentstackfull,'/',nameprefseg,num2str(Frame),'.tif']);
for ii=2:size(I_out,3)
    imwrite(I_out(:,:,ii),[segmentstackfull,'/',nameprefseg,num2str(Frame),'.tif'],'WriteMode','append')
end

%sum_rows = 65536*exp(-0.0000003*sum(I_out, 1));
%sum_rows = 65536*exp(-0.00000003*sum(I_out, 1));
sum_rows = 65536*exp(-0.0000001*sum(I_out, 1));
%sum_rows = 10200*exp(-0.0000001*sum(I_out, 1));
sum_rows=reshape(sum_rows,size(sum_rows,2),size(sum_rows,3));
sum_rows_out=uint16(sum_rows);




t = Tiff(['/data1/sghosh29/Pore_collapse/Analysis_SLG_6/HighRes_Microstructures/',num2str(Frame),'.tif'], 'w');




%t = Tiff([segmentstackfull,'/',nameprefseg,num2str(Frame),'.tif'], 'w');
tagstruct.ImageLength = size(sum_rows_out, 1);
tagstruct.ImageWidth = size(sum_rows_out, 2);
tagstruct.Photometric = Tiff.Photometric.MinIsBlack;
tagstruct.BitsPerSample = 16;
tagstruct.SamplesPerPixel = 1;
tagstruct.SampleFormat = Tiff.SampleFormat.UInt;
tagstruct.Compression = Tiff.Compression.None;
tagstruct.PlanarConfiguration = Tiff.PlanarConfiguration.Chunky;  % Set PlanarConfiguration
t.setTag(tagstruct);
t.write(sum_rows_out,sum_rows_out);
t.close();

%%%%%%

compaction=flip(mean(sum_rows,2));


x=linspace(0,size(compaction,1)*res,size(compaction,1));


CFV_data(:,1)=x;
CFV_data(:,count+1)=compaction;

count=count+1;

%%%

%imwrite(sum_rows,[segmentstackfull,'/Radiograph_',nameprefseg,num2str(Frame),'.tif'])
elapsedtime=toc;
end


% save('CF_Data_R.mat',"CFV_data")




