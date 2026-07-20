clear
load('./M_boundaries.mat');load('./H_boundaries.mat');
%% plotting

figure
set(gcf,'color','white','outerposition',get(0,'screensize'))

% ---------- 1. SAT ----------
subplot(2,2,1)
hold on
box on
grid on

x = [1 2 3];
y = [sat_p90_h sat_p90 sat_mod];

scatter(1,sat_p90_h,180,'k','filled','MarkerEdgeColor','k','LineWidth',1.5)
scatter(2,sat_p90,180,'b','filled','MarkerEdgeColor','k','LineWidth',1.5)
scatter(3,sat_mod,180,'r','filled','MarkerEdgeColor','k','LineWidth',1.5)

xlim([0.5 3.5])
xticks([1 2 3])
xticklabels({'M boundary','H boundary','Modern state'})
title('(a) Arctic Amplification (summer, >85% Holocene records)','fontsize',23,'fontweight','bold')
set(gca,'fontsize',20,'linewidth',2,'tickdir','in','gridalpha',0.25)
ylabel('Surface air temperature [degC]','fontsize',20)

yr = max(y) - min(y);
if yr == 0
    yr = max(abs(mean(y))*0.1,1);
end
ylim([min(y)-0.25*yr, max(y)+0.25*yr])

text(1,sat_p90_h+0.05,num2str(sat_p90_h,'%.2f'), ...
    'VerticalAlignment','bottom','HorizontalAlignment','center','fontsize',18)
text(2,sat_p90+0.04,num2str(sat_p90,'%.2f'), ...
    'VerticalAlignment','bottom','HorizontalAlignment','center','fontsize',18)
text(3,sat_mod+0.04,num2str(sat_mod,'%.2f'), ...
    'VerticalAlignment','bottom','HorizontalAlignment','center','fontsize',18)

ax = gca;
pos = ax.Position;
xl = ax.XLim;
yl = ax.YLim;

x_start = 1.02;
x_end   = 2.98;
y_start = y(1) + 0.02*(y(3)-y(1));
y_end   = y(1) + 0.98*(y(3)-y(1));

x_start_n = pos(1) + (x_start - xl(1)) / (xl(2)-xl(1)) * pos(3);
x_end_n   = pos(1) + (x_end   - xl(1)) / (xl(2)-xl(1)) * pos(3);
y_start_n = pos(2) + (y_start - yl(1)) / (yl(2)-yl(1)) * pos(4);
y_end_n   = pos(2) + (y_end   - yl(1)) / (yl(2)-yl(1)) * pos(4);

annotation('arrow', [x_start_n x_end_n], [y_start_n y_end_n], ...
    'Color',[0.45 0.45 0.45], ...
    'LineWidth',2, ...
    'HeadLength',10, ...
    'HeadWidth',10);

x_start = 2.02;
x_end   = 2.98;
y_start = y(2) + 0.02*(y(3)-y(2));
y_end   = y(2) + 0.98*(y(3)-y(2));

x_start_n = pos(1) + (x_start - xl(1)) / (xl(2)-xl(1)) * pos(3);
x_end_n   = pos(1) + (x_end   - xl(1)) / (xl(2)-xl(1)) * pos(3);
y_start_n = pos(2) + (y_start - yl(1)) / (yl(2)-yl(1)) * pos(4);
y_end_n   = pos(2) + (y_end   - yl(1)) / (yl(2)-yl(1)) * pos(4);

annotation('arrow', [x_start_n x_end_n], [y_start_n y_end_n], ...
    'Color',[0.45 0.45 0.45], ...
    'LineWidth',2, ...
    'HeadLength',10, ...
    'HeadWidth',10);


% ---------- 2. SSS ----------
subplot(2,2,2)
hold on
box on
grid on

x = [1 2 3];
y = [-sss_p10_h -sss_p10 -sss_mod];

scatter(1,-sss_p10_h,180,'k','filled','MarkerEdgeColor','k','LineWidth',1.5)
scatter(2,-sss_p10,180,'b','filled','MarkerEdgeColor','k','LineWidth',1.5)
scatter(3,-sss_mod,180,'r','filled','MarkerEdgeColor','k','LineWidth',1.5)

xlim([0.5 3.5])
xticks([1 2 3])
xticklabels({'M boundary','H boundary','Modern state'})
yticks([-31 -30.5 -30 -29.5 -29])
yticklabels([31 30.5 30 29.5 29])
ylabel('Sea surface salinity [PSU]','fontsize',20)
title('(b) Freshwater Accumulation (Pacific sector, winter)','fontsize',23,'fontweight','bold')
set(gca,'fontsize',20,'linewidth',2,'tickdir','in','gridalpha',0.25)

yr = max(y) - min(y);
if yr == 0
    yr = max(abs(mean(y))*0.1,1);
end
ylim([min(y)-0.25*yr, max(y)+0.25*yr])

text(1,-sss_p10_h+0.09,num2str(sss_p10_h,'%.2f'), ...
    'VerticalAlignment','bottom','HorizontalAlignment','center','fontsize',18)
text(2,-sss_p10+0.19,num2str(sss_p10,'%.2f'), ...
    'VerticalAlignment','bottom','HorizontalAlignment','center','fontsize',18)
text(3,-sss_mod+0.07,num2str(sss_mod,'%.2f'), ...
    'VerticalAlignment','bottom','HorizontalAlignment','center','fontsize',18)

ax = gca;
pos = ax.Position;
xl = ax.XLim;
yl = ax.YLim;

x_start = 1.02;
x_end   = 2.98;
y_start = y(1) + 0.02*(y(3)-y(1));
y_end   = y(1) + 0.98*(y(3)-y(1));

x_start_n = pos(1) + (x_start - xl(1)) / (xl(2)-xl(1)) * pos(3);
x_end_n   = pos(1) + (x_end   - xl(1)) / (xl(2)-xl(1)) * pos(3);
y_start_n = pos(2) + (y_start - yl(1)) / (yl(2)-yl(1)) * pos(4);
y_end_n   = pos(2) + (y_end   - yl(1)) / (yl(2)-yl(1)) * pos(4);

annotation('arrow', [x_start_n x_end_n], [y_start_n y_end_n], ...
    'Color',[0.45 0.45 0.45], ...
    'LineWidth',2, ...
    'HeadLength',10, ...
    'HeadWidth',10);


x_start = 2.02;
x_end   = 2.98;
y_start = y(2) + 0.02*(y(3)-y(2));
y_end   = y(2) + 0.98*(y(3)-y(2));

x_start_n = pos(1) + (x_start - xl(1)) / (xl(2)-xl(1)) * pos(3);
x_end_n   = pos(1) + (x_end   - xl(1)) / (xl(2)-xl(1)) * pos(3);
y_start_n = pos(2) + (y_start - yl(1)) / (yl(2)-yl(1)) * pos(4);
y_end_n   = pos(2) + (y_end   - yl(1)) / (yl(2)-yl(1)) * pos(4);

annotation('arrow', [x_start_n x_end_n], [y_start_n y_end_n], ...
    'Color',[0.45 0.45 0.45], ...
    'LineWidth',2, ...
    'HeadLength',10, ...
    'HeadWidth',10);


% ---------- 3. SST summer ----------
subplot(2,2,3)
hold on
box on
grid on

x = [1 2 3];
y = [sst_p90_summer_h sst_p90_summer sst_mod_summer];

scatter(1,sst_p90_summer_h,180,'k','filled','MarkerEdgeColor','k','LineWidth',1.5)
scatter(2,sst_p90_summer,180,'b','filled','MarkerEdgeColor','k','LineWidth',1.5)
scatter(3,sst_mod_summer,180,'r','filled','MarkerEdgeColor','k','LineWidth',1.5)

xlim([0.5 3.5])
xticks([1 2 3])
xticklabels({'M boundary','H boundary','Modern state'})
title('(c) Ocean Warming (Atlantic inflow region, summer)','fontsize',23,'fontweight','bold')
set(gca,'fontsize',20,'linewidth',2,'tickdir','in','gridalpha',0.25)
ylabel('Sea surface temperature [degC]','fontsize',20)

yr = max(y) - min(y);
if yr == 0
    yr = max(abs(mean(y))*0.1,1);
end
ylim([min(y)-0.25*yr, max(y)+0.25*yr])

text(1,sst_p90_summer_h+0.04,num2str(sst_p90_summer_h,'%.2f'), ...
    'VerticalAlignment','bottom','HorizontalAlignment','center','fontsize',18)
text(2,sst_p90_summer+0.03,num2str(sst_p90_summer,'%.2f'), ...
    'VerticalAlignment','bottom','HorizontalAlignment','center','fontsize',18)
text(3,sst_mod_summer+0.03,num2str(sst_mod_summer,'%.2f'), ...
    'VerticalAlignment','bottom','HorizontalAlignment','center','fontsize',18)

ax = gca;
pos = ax.Position;
xl = ax.XLim;
yl = ax.YLim;

x_start = 1.02;
x_end   = 2.98;
y_start = y(1) + 0.02*(y(3)-y(1));
y_end   = y(1) + 0.98*(y(3)-y(1));

x_start_n = pos(1) + (x_start - xl(1)) / (xl(2)-xl(1)) * pos(3);
x_end_n   = pos(1) + (x_end   - xl(1)) / (xl(2)-xl(1)) * pos(3);
y_start_n = pos(2) + (y_start - yl(1)) / (yl(2)-yl(1)) * pos(4);
y_end_n   = pos(2) + (y_end   - yl(1)) / (yl(2)-yl(1)) * pos(4);

annotation('arrow', [x_start_n x_end_n], [y_start_n y_end_n], ...
    'Color',[0.45 0.45 0.45], ...
    'LineWidth',2, ...
    'HeadLength',10, ...
    'HeadWidth',10);

x_start = 2.02;
x_end   = 2.98;
y_start = y(2) + 0.02*(y(3)-y(2));
y_end   = y(2) + 0.98*(y(3)-y(2));

x_start_n = pos(1) + (x_start - xl(1)) / (xl(2)-xl(1)) * pos(3);
x_end_n   = pos(1) + (x_end   - xl(1)) / (xl(2)-xl(1)) * pos(3);
y_start_n = pos(2) + (y_start - yl(1)) / (yl(2)-yl(1)) * pos(4);
y_end_n   = pos(2) + (y_end   - yl(1)) / (yl(2)-yl(1)) * pos(4);

annotation('arrow', [x_start_n x_end_n], [y_start_n y_end_n], ...
    'Color',[0.45 0.45 0.45], ...
    'LineWidth',2, ...
    'HeadLength',10, ...
    'HeadWidth',10);


% ---------- 4. SST winter ----------
subplot(2,2,4)
hold on
box on
grid on

x = [1 2 3];
y = [sst_p90_winter_h sst_p90_winter sst_mod_winter];

scatter(1,sst_p90_winter_h,180,'k','filled','MarkerEdgeColor','k','LineWidth',1.5)
scatter(2,sst_p90_winter,180,'b','filled','MarkerEdgeColor','k','LineWidth',1.5)
scatter(3,sst_mod_winter,180,'r','filled','MarkerEdgeColor','k','LineWidth',1.5)

xlim([0.5 3.5])
xticks([1 2 3])
xticklabels({'M boundary','H boundary','Modern state'})
title('(d) Ocean Warming (Atlantic inflow region, winter)','fontsize',23,'fontweight','bold')
set(gca,'fontsize',20,'linewidth',2,'tickdir','in','gridalpha',0.25)
ylabel('Sea surface temperature [degC]','fontsize',20)

yr = max(y) - min(y);
if yr == 0
    yr = max(abs(mean(y))*0.1,1);
end
ylim([min(y)-0.25*yr, max(y)+0.25*yr])

text(1,sst_p90_winter_h+0.08,num2str(sst_p90_winter_h,'%.2f'), ...
    'VerticalAlignment','bottom','HorizontalAlignment','center','fontsize',18)
text(2,sst_p90_winter+0.07,num2str(sst_p90_winter,'%.2f'), ...
    'VerticalAlignment','bottom','HorizontalAlignment','center','fontsize',18)
text(3,sst_mod_winter+0.07,num2str(sst_mod_winter,'%.2f'), ...
    'VerticalAlignment','bottom','HorizontalAlignment','center','fontsize',18)

ax = gca;
pos = ax.Position;
xl = ax.XLim;
yl = ax.YLim;

x_start = 1.02;
x_end   = 2.98;
y_start = y(1) + 0.02*(y(3)-y(1));
y_end   = y(1) + 0.98*(y(3)-y(1));

x_start_n = pos(1) + (x_start - xl(1)) / (xl(2)-xl(1)) * pos(3);
x_end_n   = pos(1) + (x_end   - xl(1)) / (xl(2)-xl(1)) * pos(3);
y_start_n = pos(2) + (y_start - yl(1)) / (yl(2)-yl(1)) * pos(4);
y_end_n   = pos(2) + (y_end   - yl(1)) / (yl(2)-yl(1)) * pos(4);

annotation('arrow', [x_start_n x_end_n], [y_start_n y_end_n], ...
    'Color',[0.45 0.45 0.45], ...
    'LineWidth',2, ...
    'HeadLength',10, ...
    'HeadWidth',10);

x_start = 2.02;
x_end   = 2.98;
y_start = y(2) + 0.02*(y(3)-y(2));
y_end   = y(2) + 0.98*(y(3)-y(2));

x_start_n = pos(1) + (x_start - xl(1)) / (xl(2)-xl(1)) * pos(3);
x_end_n   = pos(1) + (x_end   - xl(1)) / (xl(2)-xl(1)) * pos(3);
y_start_n = pos(2) + (y_start - yl(1)) / (yl(2)-yl(1)) * pos(4);
y_end_n   = pos(2) + (y_end   - yl(1)) / (yl(2)-yl(1)) * pos(4);

annotation('arrow', [x_start_n x_end_n], [y_start_n y_end_n], ...
    'Color',[0.45 0.45 0.45], ...
    'LineWidth',2, ...
    'HeadLength',10, ...
    'HeadWidth',10);