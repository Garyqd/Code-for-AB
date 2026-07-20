%based on the results derived from Analysis_site_Fig2a-c.m
clear
path='./Holocene records/';
name1 = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 1_sites','Range','A11:A191');
lat = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 1_sites','Range','D11:D191');
lon = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 1_sites','Range','E11:E191');

name2 = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 2_records','Range','A14:A344');
cv = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 2_records','Range','E14:E344');
cvd = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 2_records','Range','F14:F344');
vpIR = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 2_records','Range','C14:C344');
season_temp = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 2_records','Range','G14:G344');
%% sat
m=1;o=0;
for i=1:height(name2)
if strcmp(cv.ClimateVariable{i},'temp') && strcmp(cvd.ClimateVariableDetail{i},'air') && strcmp(vpIR.vplRRecord{i},'temp')
    if strcmp(name2.SiteShortName{i},o)
        continue
    end
    wz=find(strcmpi(name1.AlaskaAndYukon,name2.SiteShortName{i}));
    target_lon(m)=lon.Var1(wz);target_lat(m)=lat.Var1(wz);name{m}=name2.SiteShortName{i};nn(m)=i;m=m+1;
    o=name2.SiteShortName{i};
end
end

[~, idx] = sort(lower(name)); 
name_sorted = name(idx); 
target_lon_sorted = target_lon(idx);
target_lat_sorted = target_lat(idx);

figure
m_proj('stereographic','lat',90,'long',0,'radius',35)
shading flat
m_grid('tickdir','out','xtick',[],'ytick',[],'xticklabel',[],'yticklabel',[],'ticklength',0.015,'fontsize',17,'linewidth',2,'linest','--')
hold on
m_coast('patch',[0.65 0.65 0.65],'edgecolor','none');
m_text(180,53,'Arctic Amplification','fontsize',35,'horizontalalignment','center')
for i=1:length(name)
if ismember(i,[2,9,10,14,21,22,31,36,44,45,65,68,70,74])
m_plot(target_lon_sorted(i),target_lat_sorted(i),'o','MarkerSize',15,'MarkerEdgeColor',[1 0.84 0],'MarkerFaceColor',[1 0.84 0])
elseif ismember(i,[4,6,7,11,17,18,19,23,24,27,28,33,37,41,42,43,47,51,52,54,56,59,62,67,75])
m_plot(target_lon_sorted(i),target_lat_sorted(i),'ro','MarkerSize',15,'MarkerEdgeColor','r','MarkerFaceColor','r')
else
m_plot(target_lon_sorted(i),target_lat_sorted(i),'o','MarkerSize',15,'MarkerEdgeColor',[0.13 0.55 0.13],'MarkerFaceColor',[0.13 0.55 0.13])
end
end
%% sss
clear target_lon target_lat name nn
m=1;o=0;
for i=1:height(name2)
if strcmp(cv.ClimateVariable{i},'salinity') && strcmp(cvd.ClimateVariableDetail{i},'sea_surface')
    if strcmp(name2.SiteShortName{i},o)
        continue
    end
    wz=find(strcmp(name1.AlaskaAndYukon,name2.SiteShortName{i}));
    target_lon(m)=lon.Var1(wz);target_lat(m)=lat.Var1(wz);name{m}=name2.SiteShortName{i};nn(m)=i;m=m+1;
    o=name2.SiteShortName{i};
end
end


[~, idx] = sort(lower(name)); 
name_sorted = name(idx); 
target_lon_sorted = target_lon(idx);
target_lat_sorted = target_lat(idx);

figure
m_proj('stereographic','lat',90,'long',0,'radius',35)
shading flat
m_grid('tickdir','out','xtick',[],'ytick',[],'xticklabel',[],'yticklabel',[],'ticklength',0.015,'fontsize',17,'linewidth',2,'linest','--')
hold on
m_coast('patch',[0.65 0.65 0.65],'edgecolor','none');
m_text(180,53,'Freshwater Accumulation','fontsize',35,'horizontalalignment','center')
for i=1:length(name)
if i==11
m_plot(target_lon_sorted(i),target_lat_sorted(i),'o','MarkerSize',15,'MarkerEdgeColor',[1 0.84 0],'MarkerFaceColor',[1 0.84 0])
elseif ismember(i,[2,3])
m_plot(target_lon_sorted(i),target_lat_sorted(i),'ro','MarkerSize',15,'MarkerEdgeColor','r','MarkerFaceColor','r')
else
m_plot(target_lon_sorted(i),target_lat_sorted(i),'o','MarkerSize',15,'MarkerEdgeColor',[0.13 0.55 0.13],'MarkerFaceColor',[0.13 0.55 0.13])
end
end
%% sst
clear target_lon target_lat name nn
m=1;o=0;
for i=1:height(name2)
if strcmp(cv.ClimateVariable{i},'temp') && (strcmp(cvd.ClimateVariableDetail{i},'sea_surface')||strcmp(cvd.ClimateVariableDetail{i},'near_surface'))
    if strcmp(name2.SiteShortName{i},o)
        continue
    end
    wz=find(strcmp(name1.AlaskaAndYukon,name2.SiteShortName{i}));
    target_lon(m)=lon.Var1(wz);target_lat(m)=lat.Var1(wz);name{m}=name2.SiteShortName{i};nn(m)=i;m=m+1;
    o=name2.SiteShortName{i};
end
end
name={name{1:18},name{20:22},name{24:end}};
target_lon = target_lon([1:18, 20:22, 24:end]);
target_lat = target_lat([1:18, 20:22, 24:end]);


[~, idx] = sort(lower(name)); 
name_sorted = name(idx); 
target_lon_sorted = target_lon(idx);
target_lat_sorted = target_lat(idx);

figure
m_proj('stereographic','lat',90,'long',0,'radius',35)
shading flat
m_grid('tickdir','out','xtick',[],'ytick',[],'xticklabel',[],'yticklabel',[],'ticklength',0.015,'fontsize',17,'linewidth',2,'linest','--')
hold on
m_coast('patch',[0.65 0.65 0.65],'edgecolor','none');
m_text(180,53,'Ocean Warming','fontsize',35,'horizontalalignment','center')
for i=1:length(name)
if ismember(i,14)
m_plot(target_lon_sorted(i),target_lat_sorted(i),'o','MarkerSize',15,'MarkerEdgeColor',[1 0.84 0],'MarkerFaceColor',[1 0.84 0])
elseif ismember(i,[2,4,19,20,22,24])
m_plot(target_lon_sorted(i),target_lat_sorted(i),'ro','MarkerSize',15,'MarkerEdgeColor','r','MarkerFaceColor','r')
else
m_plot(target_lon_sorted(i),target_lat_sorted(i),'o','MarkerSize',15,'MarkerEdgeColor',[0.13 0.55 0.13],'MarkerFaceColor',[0.13 0.55 0.13])
end
end
