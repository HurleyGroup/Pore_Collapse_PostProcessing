tic
clc,clear all

count=1;

%%Get triangle data

time=[1:41];

% for tstep=1:length(time)%0:20:80
% 
% filename=strcat('../DC_all_grains/Frame_',int2str(time(tstep)),'.txt');
% data(count,:,:)=load(filename);
% count=count+1;
% end
% 
% 
% x0=data(1,:,1)';
% y0=data(1,:,2)';
% z0=data(1,:,3)';
% 
% DT=delaunayTriangulation(x0,y0,z0);
% T=DT.ConnectivityList;
% 
% C=rand(size(DT,1),3);
% 
% for i=1:size(DT,1)
% 
%     PointIndexes=DT.ConnectivityList(i,:);
% 
% T=[DT.Points(PointIndexes,1) DT.Points(PointIndexes,2) DT.Points(PointIndexes,3)];
% 
% XS0(i,:,1)=T(:,1)';
% YS0(i,:,1)=T(:,2)';
% ZS0(i,:,1)=T(:,3)';
% 
% % p=fill3(XS0(i,:,1),YS0(i,:,1),ZS0(i,:,1),C(i,:));
% % p(1).FaceAlpha=0.1;
% % hold on
% 
% end
% 
% 
% 
% %triangle Ys and Zs for later tsteps
% TYS=zeros(size(DT,1),4,tstep-1);
% TZS=zeros(size(DT,1),4,tstep-1);
% 
% for k=1:(tstep-1)
% 
% x=data(k+1,:,1)';
% y=data(k+1,:,2)';
% z=data(k+1,:,3)';
% 
% for i=1:size(DT,1)
% for j=1:4
% 
% TXS(i,j,k)=x(DT(i,j));
% TYS(i,j,k)=y(DT(i,j));
% TZS(i,j,k)=z(DT(i,j));
% 
% end
% end
% %  figure(k+1)
% % fill3(TXS(:,:,k),TYS(:,:,k),TZS(:,:,k),C(i,:),'FaceAlpha',0.1);
% % hold on
% end
% 
% save('../Saved_data/Triangle_coordinates.mat',"TXS",'TYS','TZS')

%% Run only this part

% 
% % %%Get node coordinate data
% 
connectivity=importdata('/data1/sghosh29/Pore_collapse/Validation_July2024/Al/Al6/Processing_codes/Data_output_L/connectivity_Job1.txt');
connectivity(:,1)=[];

for i=1:length(time)
i
%this is calculated at thhe element nodes

elempressure= importdata(strcat('/data1/sghosh29/Pore_collapse/Validation_July2024/Al/Al6/Processing_codes/Data_output_L/','elempressure_Job1_Frame',int2str(i-1),'.txt'));
node_coordinates=importdata(strcat('/data1/sghosh29/Pore_collapse/Validation_July2024/Al/Al6/Processing_codes/Data_output_L/','nodeCoordinates_Job1_Frame',int2str(i-1),'.txt'));

nodepressure=zeros(size(node_coordinates,1),1);

for j=1:size(node_coordinates,1)
%[i j]
[row,col]=find(connectivity==j);

nodepressure(j,1)=sum(elempressure(row))/length(row);

end

writematrix(nodepressure,strcat('/data1/sghosh29/Pore_collapse/Analysis_Al_6/Node_pressures/nodepressure_Frame',int2str(i-1),'.txt'))

end

toc

% caxis([-2 2])
