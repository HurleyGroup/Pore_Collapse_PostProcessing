tic
clc,clear all,close all

%%NOOOOOOO out of plane slice calculations

%%%triangle data
rng("default")

time=1:40;



%offsets due to coordinate system mishap in outputting the data
%Assembly CS is correct

for i=0:40
Frame=i;
node_coordinates=importdata('/data1/sghosh29/Pore_collapse/Validation_July2024/Al/Al6/Processing_codes/Data_output_L/nodeCoordinates_Job1_Frame'+string(Frame)+'.txt');

NX(1:length(node_coordinates),i+1)=node_coordinates(:,1);
NY(1:length(node_coordinates),i+1)=node_coordinates(:,2);
NZ(1:length(node_coordinates),i+1)=node_coordinates(:,3);
end

x_lower=min(NX,[],"all");
x_upper=max(NX,[],"all");

y_lower=min(NY,[],"all");
y_upper=max(NY,[],"all");

z_lower=min(NZ,[],"all");
z_upper=max(NZ,[],"all");

ox=0.127688;
oy=0.130384;
oz=0.192222;



res=0.0025;

count=1;

for tstep=1:length(time)%0:20:80

filename=strcat('/data1/sghosh29/Pore_collapse/Analysis_Al_6/DC_all_grains/Frame_',int2str(tstep-1),'.txt');
data(count,:,:)=load(filename);
count=count+1;
end

x0=data(1,:,1)';
y0=data(1,:,2)';
z0=data(1,:,3)';

DT=delaunayTriangulation(x0,y0,z0);
T=DT.ConnectivityList;

C=rand(size(DT,1),3);

for i=1:size(DT,1)

    PointIndexes=DT.ConnectivityList(i,:);

T=[DT.Points(PointIndexes,1) DT.Points(PointIndexes,2) DT.Points(PointIndexes,3)];

XS0(i,:)=x0(PointIndexes)-ox; %%added this line
YS0(i,:,1)=T(:,1)'-oy;
ZS0(i,:,1)=T(:,2)'-oz;

% patch(YS0(i,:),ZS0(i,:),C(i,:),'FaceAlpha',0.5);
% hold on

end

% %triangle Ys and Zs for later tsteps

TXS=zeros(size(DT,1),4,tstep);
TYS=zeros(size(DT,1),4,tstep);
TZS=zeros(size(DT,1),4,tstep);
% 
for k=1:length(time)

x=data(k,:,1)';
y=data(k,:,2)';
z=data(k,:,3)';

for i=1:size(DT,1)
for j=1:4

TXS(i,j,k)=x(DT(i,j))-x_lower; %%added this line
TYS(i,j,k)=y(DT(i,j))-y_lower;
TZS(i,j,k)=z(DT(i,j))-z_lower;

end
end
end


% TXS(:,:,1)=XS0-ox;
% TYS(:,:,1)=YS0-oy;
% TZS(:,:,1)=ZS0-oz;
% 
% tetramesh(DT)

save('/data1/sghosh29/Pore_collapse/Analysis_Al_6/Saved_data/Triangle_coordinates.mat','TXS','TYS','TZS');
