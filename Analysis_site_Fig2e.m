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

load('./ modern records at the Holocene record sites/sss_p.mat')
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

tmax = 4200; % Meghalayan: last 4.2 ka, age in yr BP
for ii = 1:numel(sss_h)
    if ~isempty(sss_h{ii}) && ~isempty(age{ii})
        nmin = min(numel(age{ii}), numel(sss_h{ii}));
        a = age{ii}(1:nmin);
        v = sss_h{ii}(1:nmin);
        a = a(:);
        v = v(:);
        keep = a <= tmax & ~isnan(a) & ~isnan(v);
        age{ii} = a(keep);
        sss_h{ii} = v(keep);
    end
end

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

        p10=prctile(sss_h{i,j}(:),10);zxz=min(sss_h{i,j}(:),[],'omitnan');

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
legend([h hDummy1, hDummy2],'Meghalayan','10% variability','Present','Location','northeast','fontsize',35);legend('boxoff')

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