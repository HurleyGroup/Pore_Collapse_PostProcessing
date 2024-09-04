clc,clear all

time=[1:20];

hi=load('../Saved_data/Triangle_coordinates.mat');
TXS=hi.TXS;
TYS=hi.TYS;
TZS=hi.TZS;

nDT=size(TXS,1);




%Get node coordinate data

connectivity=importdata('/data1/sghosh29/Pore_collapse/Analysis_Al_6/Data_output/connectivity_Job1.txt');
connectivity(:,1)=[];

for i=1:length(time)

%this is calculated at thhe element nodes

node_coordinates(:,:,i)=importdata(strcat('/data1/sghosh29/Pore_collapse/Analysis_Al_6/Data_output/','nodeCoordinates_Job1_Frame',int2str(i-1),'.txt'));

nodepressure(:,:,i)=importdata(strcat('/data1/sghosh29/Pore_collapse/Analysis_Al_6/Data_output/Node_pressures/','nodepressure_Frame',int2str(i-1),'.txt'));

end
% 
% 
% % 
% count=1;
% 
% for t=1:length(time)%0:20:80
% 
% filename=strcat('DC_all_grains/Frame_',int2str(t-1),'.txt');
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
% % 
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
% % patch(YS0(i,:),ZS0(i,:),C(i,:));
% % hold on
% 
% end
% % 
% % %triangle Ys and Zs for later tsteps
% TYS=zeros(size(DT,1),3,length(time));
% TZS=zeros(size(DT,1),3,length(time));
% 
% for k=1:length(time)
% 
% x=data(k,:,1)';
% y=data(k,:,2)';
% z=data(k,:,3)';
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
% end
% % TXS(:,:,1)=XS0;
% % TYS(:,:,1)=YS0;
% % TZS(:,:,1)=ZS0;
% 
% save('Saved_data/Triangle_coordinates.mat',"TXS",'TYS','TZS')





 
%% 

% 
%%% %%----checking starts here 
% 
for i=1:length(time)% time loop

 for j=1:nDT % triangle loop
%[i j]
   xs=TXS(j,:,i);ys=TYS(j,:,i);zs=TZS(j,:,i);

     count=0;sumP=0;

     for k=1:size(node_coordinates,1)
      q_x=node_coordinates(k,1,i);
      q_y=node_coordinates(k,2,i);
      q_z=node_coordinates(k,3,i);

     inside_tetrahedron = funPtInTriCheckNd([xs;ys;zs]',[q_x q_y q_z]);

     if inside_tetrahedron==1 
         sumP=sumP+nodepressure(k,:,i);
         count=count+1;
     else
         sumP=sumP;
     end

     end

     Pavg(j,i)=sumP/count;

 end
end


save("/data1/sghosh29/Pore_collapse/Analysis_Al_6/Saved_data/Pressure_Triangles.mat","Pavg")
