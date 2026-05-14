clc,clear all,close all

%%Left Impact


load('CF_Data_R.mat')

x=CFV_data(:,1);

res=0.025;

CF0=CFV_data(:,2);

plot(x,CF0)
hold on

threshold =150;


for i=2:(size(CFV_data,2)-2)

    time(i)=i*153e-9;

    CF(:,i)=CFV_data(:,i+2);

    plot(x, CF(:,i))
    hold on

% 
reversed_CF=flip(CF(:,i));

idx_CR=numel(CF(:,i))-find(reversed_CF(2:end)==65536,1);

CR_pos(i)=idx_CR*res;


diff=abs(CF(:,i)-CF0);

% Reverse the vector
reversed_vector = diff(end:-1:1);

% Find the index of the first value greater than the threshold
index_in_reversed = find(reversed_vector > threshold, 1);

% Convert the reversed index to the original index
compaction_xpos(i) = (numel(diff) - index_in_reversed + 1)*res;


xline(compaction_xpos(i),'-',{'CF Position'})
hold on
% 
% xline(CR_pos,'-',{'CR Position'})

CF_width=compaction_xpos(i)-CR_pos(i);



CF_pos(i)=compaction_xpos(i);


end

% p=polyfit(time, CF_xpos,1);
% 

figure(2)

plot(CF_pos(2:33),time(2:33)/1e-9,'-^','LineWidth',1,'Color','k')
ylabel('time (ns)','Interpreter','latex')
xlabel('X position (mm)','Interpreter','latex')





%%%%%Now superpose experimental data on this
% 
texp=[0,1,3,5,7,9,11,13]*153e-9+2e-6+0*153e-9;
% 
 xini=1024;
% 
 time_exp=[texp(3),texp(4),texp(5),texp(6),texp(7),texp(8)];
% 
 CFPos_exp=abs([980,905,826,719,626,520]-xini)*2.5e-6+3.5e-3;
% 
hold on;

plot(CFPos_exp/1e-3,time_exp/1e-9,'o','MarkerSize',8,'LineWidth',1,'Color','k','MarkerFaceColor','k');
% title('Shot 22-2-118')

legend('Simulation','Experiment','location','northwest','interpreter','latex')
% set(gca,'fontname','Impact')

ax=gca;
ax.XAxis.TickLabelInterpreter='latex';
ax.YAxis.TickLabelInterpreter='latex';
set(gca,'Linewidth',1);
box on;
set(gca,'FontSize',16)


f=gcf;
exportgraphics(f,'/data1/sghosh29/SG_abaqus/Validation_Feb2023/Aluminum/Plots/Al_3_Validation.png','Resolution',500)



%---------------Right is useless

% figure(3)
% 
% 
% load('CF_Data_L.mat')
% 
% x=CFV_data(:,1);
% 
% res=0.025;
% 
% CF0=CFV_data(:,2);
% 
% plot(x,CF0)
% hold on
% 
% threshold =100;
% 
% 
% for i=2:(size(CFV_data,2)-2)
% 
%     time(i)=i*153e-9;
% 
%     CF(:,i)=CFV_data(:,i+2);
% 
%     plot(x, CF(:,i))
%     hold on
% 
% % 
% % reversed_CF=flip(CF(:,i));
% % 
% % idx_CR=numel(CF(:,i))-find(reversed_CF(2:end)==65536,1);
% % 
% % CR_pos(i)=idx_CR*res;
% 
% 
% diff=abs(CF(:,i)-CF0);
% 
% % Reverse the vector
% % reversed_vector = diff(end:-1:1);
% 
% % Find the index of the first value greater than the threshold
% index_in_reversed = find(diff > threshold, 1);
% 
% % Convert the reversed index to the original index
% compaction_xpos(i) = ( index_in_reversed + 1)*res;
% 
% 
% xline(compaction_xpos(i),'-',{'CF Position'})
% hold on
% % 
% % xline(CR_pos,'-',{'CR Position'})
% 
% CF_width=compaction_xpos(i)-CR_pos(i);
% 
% 
% 
% CF_pos(i)=compaction_xpos(i);
% 
% 
% end
% 
% % p=polyfit(time, CF_xpos,1);
% % 
% 
% figure(4)
% 
% plot(max(x)-CF_pos(2:33),time(2:33)/1e-9,'b-.','LineWidth',2)
% ylabel('time (ns)')
% xlabel('X position (mm)')
% 
% 
% 
% hold on
% 
% 
% 
% plot(CFPos_exp/1e-3,time_exp/1e-9,'r*');
% title('Shot 22-2-118')
% 
% % 
% % 
% % 
