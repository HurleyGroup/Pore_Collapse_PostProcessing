clc,clear all

time=[1:20];


%Get node coordinate data

connectivity=importdata('/data1/sghosh29/Pore_collapse/Analysis_SLG_6/Data_output/connectivity_Job1.txt');
connectivity(:,1)=[];

for i=1:length(time)

%this is calculated at thhe element nodes

node_coordinates(:,:,i)=importdata(strcat('/data1/sghosh29/Pore_collapse/Analysis_SLG_6/Data_output/','nodeCoordinates_Job1_Frame',int2str(i-1),'.txt'));

nodepressure(:,:,i)=importdata(strcat('/data1/sghosh29/Pore_collapse/Analysis_SLG_6/Data_output/Node_pressures/','nodepressure_Frame',int2str(i-1),'.txt'));

end


% 
count=1;

for t=1:length(time)%0:20:80

filename=strcat('DC_all_grains/Frame_',int2str(t-1),'.txt');
data(count,:,:)=load(filename);
count=count+1;
end


x0=data(1,:,1)';
y0=data(1,:,2)';
z0=data(1,:,3)';

DT=delaunayTriangulation(x0,y0,z0);
T=DT.ConnectivityList;
% 
C=rand(size(DT,1),3);

for i=1:size(DT,1)

    PointIndexes=DT.ConnectivityList(i,:);

T=[DT.Points(PointIndexes,1) DT.Points(PointIndexes,2) DT.Points(PointIndexes,3)];

XS0(i,:,1)=T(:,1)';
YS0(i,:,1)=T(:,2)';
ZS0(i,:,1)=T(:,3)';

% patch(YS0(i,:),ZS0(i,:),C(i,:));
% hold on

end
% 
% %triangle Ys and Zs for later tsteps
TYS=zeros(size(DT,1),3,length(time));
TZS=zeros(size(DT,1),3,length(time));

for k=1:length(time)

x=data(k,:,1)';
y=data(k,:,2)';
z=data(k,:,3)';

for i=1:size(DT,1)
for j=1:4

TXS(i,j,k)=x(DT(i,j));
TYS(i,j,k)=y(DT(i,j));
TZS(i,j,k)=z(DT(i,j));

end
end
end
% TXS(:,:,1)=XS0;
% TYS(:,:,1)=YS0;
% TZS(:,:,1)=ZS0;

% save('Saved_data/Triangle_coordinates.mat',"TXS",'TYS','TZS')
% tetramesh(DT,'all')
% 
% [F,P]=freeBoundary(DT);
% 
% trisurf(F,P(:,1),P(:,2),P(:,3))
%% 


for i=1:size(DT,1)

V(i)=abs((1/6)*det([XS0(i,:)' YS0(i,:)' ZS0(i,:)' ones(4,1)]));


end

plot(V)

P=prctile(V,95);

conn=DT.ConnectivityList;

for i=1:size(DT,1)

if V(i)>P
  conn(i,:)=zeros(1,4);
else
    conn(i,:)=conn(i,:);
end
end

conn(~any(conn,2),:)=[];


tetramesh(conn,DT.Points)
xlim([1 1.1])

