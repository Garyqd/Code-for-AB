clear
path='./Holocene records/';
path_m='./';
path_mm='./esacci_sss_NHv5.5/';
name1 = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 1_sites','Range','A11:A191');
lat = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 1_sites','Range','D11:D191');
lon = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 1_sites','Range','E11:E191');

name2 = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 2_records','Range','A14:A344');
cv = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 2_records','Range','E14:E344');
cvd = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 2_records','Range','F14:F344');
vpIR = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 2_records','Range','C14:C344');
season_temp = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 2_records','Range','G14:G344');

lon_esa=ncread([path_mm,'2010/ESACCI-SEASURFACESALINITY-L4-SSS-POLAR-MERGED_OI_Monthly_CENTRED_15Day_25kmEASE2_NH-20100115-fv5.5.nc'],'lon');
lat_esa=ncread([path_mm,'2010/ESACCI-SEASURFACESALINITY-L4-SSS-POLAR-MERGED_OI_Monthly_CENTRED_15Day_25kmEASE2_NH-20100115-fv5.5.nc'],'lat');

lon_cmems=ncread([path_m,'cmems_sss_199301_200304.nc'],'longitude');
lat_cmems=ncread([path_m,'cmems_sss_199301_200304.nc'],'latitude');
%% derive modern data
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

m=0;o=0;season=cell(length(name),5);
for i=1:height(name2)
if strcmp(cv.ClimateVariable{i},'salinity') && strcmp(cvd.ClimateVariableDetail{i},'sea_surface')
    if strcmp(name2.SiteShortName{i},o)==0
        n=1;m=m+1;
    end
    season{m,n}=season_temp.Seasonality{i};n=n+1;
    o=name2.SiteShortName{i};
end
end

%Below code until the next section can be changed to load('./ modern records at the Holocene record sites/sss_p.mat')
for i=1:length(target_lon)
dist = sqrt((lon_esa-target_lon(i)).^2+(lat_esa-target_lat(i)).^2);
[~, id] = min(dist,[],'all');
[ii_esa(i),jj_esa(i)]=ind2sub(size(lon_esa),id);


[~, ii_cmems(i)] = min(abs(lon_cmems - target_lon(i)));
[~, jj_cmems(i)] = min(abs(lat_cmems - target_lat(i)));
end

m=1;
for i=2010:2023
    for j=1:12
        if i==2010&&j==1
    sss_temp=ncread([path_mm,num2str(i),'/ESACCI-SEASURFACESALINITY-L4-SSS-POLAR-MERGED_OI_Monthly_CENTRED_15Day_25kmEASE2_NH-',num2str(i),num2str(j,'%02d'),'15-fv5.5.nc'],'sss');
    ssse_temp=ncread([path_mm,num2str(i),'/ESACCI-SEASURFACESALINITY-L4-SSS-POLAR-MERGED_OI_Monthly_CENTRED_15Day_25kmEASE2_NH-',num2str(i),num2str(j,'%02d'),'15-fv5.5.nc'],'sss_random_error');
        else
    sss_temp=ncread([path_mm,num2str(i),'/ESACCI-SEASURFACESALINITY-L4-SSS-POLAR-MERGED_OI_Monthly_CENTRED_15Day_25kmEASE2_NH-',num2str(i),num2str(j,'%02d'),'01-fv5.5.nc'],'sss');
    ssse_temp=ncread([path_mm,num2str(i),'/ESACCI-SEASURFACESALINITY-L4-SSS-POLAR-MERGED_OI_Monthly_CENTRED_15Day_25kmEASE2_NH-',num2str(i),num2str(j,'%02d'),'01-fv5.5.nc'],'sss_random_error');
    sss_temp2=ncread([path_mm,num2str(i),'/ESACCI-SEASURFACESALINITY-L4-SSS-POLAR-MERGED_OI_Monthly_CENTRED_15Day_25kmEASE2_NH-',num2str(i),num2str(j,'%02d'),'15-fv5.5.nc'],'sss');
    ssse_temp2=ncread([path_mm,num2str(i),'/ESACCI-SEASURFACESALINITY-L4-SSS-POLAR-MERGED_OI_Monthly_CENTRED_15Day_25kmEASE2_NH-',num2str(i),num2str(j,'%02d'),'15-fv5.5.nc'],'sss_random_error');
        end

    for k=1:length(target_lon)
    if i==2010&&j==1
    sss_esa(k,m)=sss_temp(ii_esa(k),jj_esa(k));
    sss_esa_e(k,m)=ssse_temp(ii_esa(k),jj_esa(k));
    else
    sss_esa(k,m)=sss_temp(ii_esa(k),jj_esa(k));
    sss_esa_e(k,m)=ssse_temp(ii_esa(k),jj_esa(k));
    sss_esa(k,m+1)=sss_temp2(ii_esa(k),jj_esa(k));
    sss_esa_e(k,m+1)=ssse_temp2(ii_esa(k),jj_esa(k));        
    end
    end

    if i==2010&&j==1
    m=m+1;
    else
    m=m+2;
    end

    end
end


sss_temp=ncread([path_m,'cmems_sss_199301_200304.nc'],'sos');
ssse_temp=ncread([path_m,'cmems_sss_199301_200304.nc'],'sos_error');
for k=1:length(target_lon)
    sss_cmems1(k,:)=sss_temp(ii_cmems(k),jj_cmems(k),:);
    sss_cmems_e1(k,:)=ssse_temp(ii_cmems(k),jj_cmems(k),:);
end
sss_temp=ncread([path_m,'cmems_sss_200305_201308.nc'],'sos');
ssse_temp=ncread([path_m,'cmems_sss_200305_201308.nc'],'sos_error');
for k=1:length(target_lon)
    sss_cmems2(k,:)=sss_temp(ii_cmems(k),jj_cmems(k),:);
    sss_cmems_e2(k,:)=ssse_temp(ii_cmems(k),jj_cmems(k),:);
end
sss_temp=ncread([path_m,'cmems_sss_201309_202312.nc'],'sos');
ssse_temp=ncread([path_m,'cmems_sss_201309_202312.nc'],'sos_error');
for k=1:length(target_lon)
    sss_cmems3(k,:)=sss_temp(ii_cmems(k),jj_cmems(k),:);
    sss_cmems_e3(k,:)=ssse_temp(ii_cmems(k),jj_cmems(k),:);
end
sss_temp=ncread([path_m,'cmems_sss_202401_202412.nc'],'sos');
ssse_temp=ncread([path_m,'cmems_sss_202401_202412.nc'],'sos_error');
for k=1:length(target_lon)
    sss_cmems4(k,:)=sss_temp(ii_cmems(k),jj_cmems(k),:);
    sss_cmems_e4(k,:)=ssse_temp(ii_cmems(k),jj_cmems(k),:);
end
clear ssse_temp
sss_cmems=cat(2,sss_cmems1,sss_cmems2,sss_cmems3,sss_cmems4);
sss_cmems_e=cat(2,sss_cmems_e1,sss_cmems_e2,sss_cmems_e3,sss_cmems_e4);
%% derive Holocene data
wj={'alaska-yukon-v2.xls','canadian-islands-greenland-v2.xls','fennoscandia-v2.xls','mainland-canada-v2.xls',...
    'north-atlantic-iceland-v2.xls','russian-arctic-v2.xls'};
wjm=wj{1};o=2;n=1;

age=cell(length(name),2);sss_h=cell(length(name),2);
for i=1:length(name)
    for j=n:nn(i)
    if strcmp(name2.SiteShortName{j},'')
        wjm=wj{o};o=o+1;
    end
    end
    n=nn(i);

    sheets = sheetnames([path,wjm]);
    x = replace(name{i},'‐','-');sheets_2 = replace(sheets,'‐','-');
    id = contains(sheets_2,x,'IgnoreCase',true);
    mSheets = sheets(id);
    
    table=readtable([path,wjm],'Sheet',mSheets);
    m=1;
    for j=1:length(table.Properties.VariableNames)
    if contains(table.Properties.VariableNames{j},'sss','IgnoreCase',true)
        sss_h{i,m}=table2array(table(:,j));
    
    for k=1:j-1
    if contains(table.Properties.VariableNames{j-k},'age','IgnoreCase',true)
        age{i,m}=table2array(table(:,j-k));
        break
    end
    end
    m=m+1;
    end
    end
end
%% processing modern data
sss_m_esa=cell(length(name),2);sss_m_cmems=cell(length(name),2);x=zeros(14,1);
for i=1:length(name)
    n=sum(~cellfun(@isempty, season(i,:)));
    for j=1:n

    if strcmp(season{i,j},'summer')
start_cols = [10, 11, 12, 13, 14, 15];
data = [];
for s = start_cols
    data = [data; sss_esa(i, s:24:size(sss_esa,2))];
end
sss_m_esa{i,j} = mean(data,1,'omitnan');

    sss_m_cmems{i,j}=(sss_cmems(i,6:12:end)+sss_cmems(i,7:12:end)+sss_cmems(i,8:12:end))./3;

    elseif strcmp(season{i,j},'winter')
    x(1) = mean([sss_esa(i,1), sss_esa(i,2), sss_esa(i,3), ...
             sss_esa(i,22), sss_esa(i,23)], 'omitnan');
start_cols = [24, 25, 26, 27, 46, 47];
data = [];
for s = start_cols
    data = [data; sss_esa(i, s:24:size(sss_esa,2))];
end
x(2:end) = mean(data,1,'omitnan');
    sss_m_esa{i,j}=x;

    sss_m_cmems{i,j}=(sss_cmems(i,12:12:end)+sss_cmems(i,1:12:end)+sss_cmems(i,2:12:end))./3;
    end

    end
end
sss_h(:,[1,2]) = sss_h(:,[2,1]);
age(:,[1,2]) = age(:,[2,1]);

years_cmems = 1993:2024;
years_esa   = 2010:2023;
target_years = 2005:2024;

avg_sss = zeros(12, 2);
for i = 1:12
    for j = 1:2
        cmems_seq = sss_m_cmems{i,j};
        esa_seq   = sss_m_esa{i,j};

        all_vals = [];

        [in_t, loc] = ismember(target_years, years_cmems);
        cmems_vals = cmems_seq(loc(in_t));
        all_vals = [all_vals; cmems_vals(:)];

        [in_t, loc] = ismember(target_years, years_esa);
        esa_vals = esa_seq(loc(in_t));
        all_vals = [all_vals; esa_vals(:)];

        avg_sss(i,j) = mean(all_vals, 'omitnan');
    end
end
%% plotting
ys={'r','b'};
for i=1:length(name)
    fig=figure;
    set(fig,'Visible','off')
    set(gcf,'outerposition',get(0,'screensize'),'color','white');
    n=sum(~cellfun(@isempty,sss_h(i,:)));

    for j=1:n
    
    axes('position',[0.08+0.48*(j-1),0.18,0.4,0.7]);
    xlabel('Sea surface salinity [PSU]','fontsize',35)
ylabel('Probability density','fontsize',35)

        if strcmp(name{i},'HU90')
        p10=prctile(sss_h{i,j}(1:81),10);zxz=min(sss_h{i,j}(1:81),[],'omitnan');% more records than age
        elseif strcmp(name{i},'HU84')
        p10=prctile(sss_h{i,j}(1:41),10);zxz=min(sss_h{i,j}(1:41),[],'omitnan');         
        else
        p10=prctile(sss_h{i,j}(:),10);zxz=min(sss_h{i,j}(:),[],'omitnan');
        end

hold on
    grid on;box on
        h=histogram(sss_h{i,j},10,'Normalization','probability','linewidth',2,'facecolor',ys{j});
        xx=xline(p10,'linestyle','--','color',ys{j},'linewidth',5);
        xx_2=xline(avg_sss(i,j),'linestyle','-','color',ys{j},'linewidth',5);
                 xl = xlim;
if avg_sss(i,j)<zxz
set(gca,'gridcolor',[0.7 0.7 0.7],'tickdir','in','gridalpha',0.2,'fontsize',30,'linewidth',3,'xlim',[avg_sss(i,j)-0.1 xl(2)])
else
set(gca,'gridcolor',[0.7 0.7 0.7],'tickdir','in','gridalpha',0.2,'fontsize',30,'linewidth',3)
end
hDummy1 = plot(NaN, NaN, '--','color',ys{j},'LineWidth', 5);
hDummy2 = plot(NaN, NaN, '-','color',ys{j},'LineWidth', 5);
legend([h hDummy1, hDummy2],'Holocene','10% variability','Present','Location','northeast','fontsize',35);legend('boxoff')

title(season{i,j},'fontsize',35)
    end

if n==1
text(0.5,1.15,name{i},'fontsize',35,'HorizontalAlignment','center','Units','normalized','VerticalAlignment','top')
else
text(-0.1,1.11,name{i},'fontsize',35,'HorizontalAlignment','center','Units','normalized','VerticalAlignment','top')
end

ff=getframe(gcf);
imwrite(ff.cdata,['./SSS_',name{i},'.jpg']);
end