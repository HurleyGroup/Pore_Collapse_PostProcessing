clc,clear all
tic
count=1;

rng(1)

time=1:40;

tstep=length(time);

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


load('/data1/sghosh29/Pore_collapse/Analysis_Al_6/Saved_data/Triangle_coordinates.mat');
TXS=TXS+x_lower;
TYS=TYS+y_lower;
TZS=TZS+z_lower;

nDT=size(TXS,1);


%% 

% %%Calculate bagi strains
% 

 XS0=TXS(:,:,1);
 YS0=TYS(:,:,1);
 ZS0=TZS(:,:,1);

for t=1:length(time)
 
    
 XS1=TXS(:,:,t);
 YS1=TYS(:,:,t);
 ZS1=TZS(:,:,t);
 
for i=1:nDT

    [t i]

% E=zeros(3,3);

tet=[1 1 1 1;XS0(i,1) XS0(i,2) XS0(i,3) XS0(i,4);YS0(i,1) YS0(i,2) YS0(i,3) YS0(i,4);ZS0(i,1) ZS0(i,2) ZS0(i,3) ZS0(i,4)];
Vtet=det(tet)/6;

U1=XS1(i,:)-XS0(i,:);
V1=YS1(i,:)-YS0(i,:);
W1=ZS1(i,:)-ZS0(i,:);

Dmatrix=[U1;V1;W1];

% Method 3: Based on formula from Document on the internet here beta 1 is
% omega 1 and so forth https://link.springer.com/chapter/10.1007/978-3-540-70698-4_15
% search linear tetrahedral elements on Google

omega_a1=-det([1 YS0(i,2) ZS0(i,2);1 YS0(i,3) ZS0(i,3);1 YS0(i,4) ZS0(i,4)]);
omega_b1=det([1 YS0(i,1) ZS0(i,1);1 YS0(i,3) ZS0(i,3);1 YS0(i,4) ZS0(i,4)]);
omega_c1=-det([1 YS0(i,1) ZS0(i,1);1 YS0(i,2) ZS0(i,2);1 YS0(i,4) ZS0(i,4)]);
omega_d1=det([1 YS0(i,1) ZS0(i,1);1 YS0(i,2) ZS0(i,2);1 YS0(i,3) ZS0(i,3)]);

theta_a1=det([1 XS0(i,2) ZS0(i,2);1 XS0(i,3) ZS0(i,3);1 XS0(i,4) ZS0(i,4)]);
theta_b1=-det([1 XS0(i,1) ZS0(i,1);1 XS0(i,3) ZS0(i,3);1 XS0(i,4) ZS0(i,4)]);
theta_c1=det([1 XS0(i,1) ZS0(i,1);1 XS0(i,2) ZS0(i,2);1 XS0(i,4) ZS0(i,4)]);
theta_d1=-det([1 XS0(i,1) ZS0(i,1);1 XS0(i,2) ZS0(i,2);1 XS0(i,3) ZS0(i,3)]);

pi_a1=-det([1 XS0(i,2) YS0(i,2);1 XS0(i,3) YS0(i,3);1 XS0(i,4) YS0(i,4)]);
pi_b1=det([1 XS0(i,1) YS0(i,1);1 XS0(i,3) YS0(i,3);1 XS0(i,4) YS0(i,4)]);
pi_c1=-det([1 XS0(i,1) YS0(i,1);1 XS0(i,2) YS0(i,2);1 XS0(i,4) YS0(i,4)]);
pi_d1=det([1 XS0(i,1) YS0(i,1);1 XS0(i,2) YS0(i,2);1 XS0(i,3) YS0(i,3)]);

Cmatrix=[omega_a1 theta_a1 pi_a1;omega_b1 theta_b1 pi_b1;omega_c1 theta_c1 pi_c1;omega_d1 theta_d1 pi_d1];

grad_u=(1/(6*Vtet))*Dmatrix*Cmatrix;

E=0.5*[grad_u+grad_u'+grad_u*grad_u'];

Evol(i,t)=trace(E);

end
end

% plot(Evol)
% % 
% length(Evol(Evol>0))

save("/data1/sghosh29/Pore_collapse/Analysis_Al_6/Saved_data/Bagi_Strain_Triangles.mat","Evol")
 % toc
