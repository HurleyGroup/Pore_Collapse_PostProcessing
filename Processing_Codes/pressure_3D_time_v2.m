clc,clear all

time=1:40;

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

tstep=length(time);

load('/data1/sghosh29/Pore_collapse/Analysis_Al_6/Saved_data/Triangle_coordinates.mat');
TXS=TXS+x_lower;
TYS=TYS+y_lower;
TZS=TZS+z_lower;

nDT=size(TXS,1);

% %Get node coordinate data
% 
% connectivity=importdata('/data1/sghosh29/Pore_collapse/Validation_July2024/OS/OS3/Processing_codes/Data_output_L/connectivity_Job1.txt');
% connectivity(:,1)=[];

for i=1:length(time)

%this is calculated at the element nodes

node_coordinates(:,:,i)=importdata(strcat('/data1/sghosh29/Pore_collapse/Validation_July2024/Al/Al6/Processing_codes/Data_output_L/','nodeCoordinates_Job1_Frame',int2str(i-1),'.txt'));
nodepressure(:,:,i)=importdata(strcat('/data1/sghosh29/Pore_collapse/Analysis_Al_6/Node_pressures/','nodepressure_Frame',int2str(i-1),'.txt'));

end

 
%% 

% 
%%% %%----checking starts here 
% 
for i=1:length(time)% time loop
  i
 for j=1:nDT % triangle loop
   % [i j]
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


 save("/data1/sghosh29/Pore_collapse/Analysis_Al_6/Saved_data/Pressure_Triangles_corrected.mat","Pavg")
