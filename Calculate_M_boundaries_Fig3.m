%% SAT: Arctic amplification
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

m=0;o=0;season=cell(length(name),5);
for i=1:height(name2)
if strcmp(cv.ClimateVariable{i},'temp') && strcmp(cvd.ClimateVariableDetail{i},'air') && strcmp(vpIR.vplRRecord{i},'temp')
    if strcmp(name2.SiteShortName{i},o)==0
        n=1;m=m+1;
    end
    season{m,n}=season_temp.Seasonality{i};n=n+1;
    o=name2.SiteShortName{i};
end
end

load('./ modern records at the Holocene record sites/sat_p.mat')

wj={'alaska-yukon-v2.xls','canadian-islands-greenland-v2.xls','fennoscandia-v2.xls','mainland-canada-v2.xls',...
    'north-atlantic-iceland-v2.xls','russian-arctic-v2.xls'};
wjm=wj{1};o=2;n=1;

age=cell(length(name),5);sat_h=cell(length(name),5);
for i=1:length(name)
    for j=n:nn(i)
    if strcmp(name2.SiteShortName{j},'')
        wjm=wj{o};o=o+1;
    end
    end
    n=nn(i);

    sheets = sheetnames([path,wjm]);
    sheets_2 = regexprep(sheets, '[åä]', 'a');% å,ä→a
    sheets_2 = regexprep(sheets_2, '[öøØ]', 'o');% ö,ø→o

    x = replace(name{i},'‐','-');sheets_2 = replace(sheets_2,'‐','-');
    if strcmp(name{i},'akvaqiak')
    id = contains(sheets_2,'akvaquak','IgnoreCase',true);
    elseif strcmp(name{i},'screaminglynx')
    id = contains(sheets_2,'Screaming Lynx','IgnoreCase',true);
    elseif strcmp(name{i},'upper_fly')  
    id = contains(sheets_2,'Upper Fly','IgnoreCase',true);
    elseif strcmp(name{i},'qipisargo')  
    id = contains(sheets_2,'Qisirarqo','IgnoreCase',true);
    elseif strcmp(name{i},'KP2')  
    id = contains(sheets_2,'KP-2','IgnoreCase',true);
    elseif strcmp(name{i},'LR01') 
    id = contains(sheets_2,'LR1','IgnoreCase',true);
    elseif strcmp(name{i},'s53s52') 
    id = contains(sheets_2,'S53&S52','IgnoreCase',true);
    else
    id = contains(sheets_2,x,'IgnoreCase',true);
    end

    mSheets = sheets(id);
    table=readtable([path,wjm],'Sheet',mSheets);

    m=1;
    for j=1:length(table.Properties.VariableNames)
    if contains(table.Properties.VariableNames{j},["MTCO","MTWA","Temperature"],'IgnoreCase',true)...
        && ~contains(table.Properties.VariableNames{j},"error",'IgnoreCase', true)
        sat_h{i,m}=table2array(table(:,j));
    
    for k=1:j-1
    if contains(table.Properties.VariableNames{j-k},'age','IgnoreCase',true)
        if strcmp(name{i},'tornetrask')
        age{i,m}=table2array(table(:,j-k-1));
        else    
        age{i,m}=table2array(table(:,j-k));
        end
        break
    end
    end
    m=m+1;
    end
    end
end

sat_m=cell(length(name),5);
reshaped_sat=reshape(sat',[12,552/12,length(name)]);
for i=1:length(name)

    n=sum(~cellfun(@isempty, season(i,:)));
    for j=1:n

    if strcmp(season{i,j},'coldest')
    sat_m{i,j}=squeeze(min(reshaped_sat(:,:,i),[],1));
    elseif strcmp(season{i,j},'warmest')
    sat_m{i,j}=squeeze(max(reshaped_sat(:,:,i),[],1));
    elseif strcmp(season{i,j},'summer') || strcmp(season{i,j},'JJA')
    sat_m{i,j}=(sat(i,6:12:end)+sat(i,7:12:end)+sat(i,8:12:end))./3;
    elseif strcmp(season{i,j},'winter')
    sat_m{i,j}=(sat(i,12:12:end)+sat(i,1:12:end)+sat(i,2:12:end))./3;
    elseif strcmp(season{i,j},'July')    
    sat_m{i,j}=sat(i,7:12:end);
    elseif strcmp(season{i,j},'January')   
    sat_m{i,j}=sat(i,1:12:end);
    elseif strcmp(season{i,j},'MJJA')   
    sat_m{i,j}=(sat(i,5:12:end)+sat(i,6:12:end)+sat(i,7:12:end)+sat(i,8:12:end))./4;
    elseif strcmp(season{i,j},'annual')
    sat_m{i,j}=squeeze(mean(reshaped_sat(:,:,i),1));

    end
    end
end

sat_h([29,33,44,59],[1,2]) = sat_h([29,33,44,59],[2,1]);
age([29,33,44,59],[1,2]) = age([29,33,44,59],[2,1]);
sat_h{17,1}=sat_h{17,1}(1:880);
age{17,1}=age{17,1}(1:880);
sat_h(68,1:5) = {sat_h{68,4}, sat_h{68,1}, sat_h{68,2}, sat_h{68,3}, []};
age(68,1:5) = {age{68,4}, age{68,1}, age{68,2}, age{68,3}, []};

tmax = 4200; % Meghalayan: last 4.2 ka, age in yr BP
for ii = 1:numel(sat_h)
    if ~isempty(sat_h{ii}) && ~isempty(age{ii})
        nmin = min(numel(age{ii}), numel(sat_h{ii}));
        a = age{ii}(1:nmin);
        v = sat_h{ii}(1:nmin);
        a = a(:);
        v = v(:);
        keep = a <= tmax & ~isnan(a) & ~isnan(v);
        age{ii} = a(keep);
        sat_h{ii} = v(keep);
    end
end

sat_m{38,2}=sat_m{38,1};
sat_m{67,3}=sat_m{67,2};

exclude = {'annual','coldest','January','MJJA'};

notEmpty = ~cellfun(@isempty, season);

isText  = cellfun(@(x) ischar(x) || isstring(x), season);

notExcluded = true(size(season));
notExcluded(isText) = ~ismember(season(isText), exclude);

mask = notEmpty & notExcluded;


selected_h = cellfun(@(x) x(:)', sat_h(mask), 'UniformOutput', false);
data_h = [selected_h{:}];

selected_m = sat_m(mask);
last20 = cellfun(@(x) x(max(1, end-19):end), selected_m, 'UniformOutput', false);
data_m_last20 = [last20{:}];
avg_m = mean(data_m_last20);

p90_sites = [];
bin_width = 1;
site_data = cell(length(name),1);
all_vals_for_edges = [];

for i = 1:length(name)
    site_vals = [];
    for j = 1:size(sat_h,2)
        if mask(i,j) && ~isempty(sat_h{i,j})
            site_vals = [site_vals; sat_h{i,j}(:)];
        end
    end
    if numel(site_vals) >= 10
        p90_sites = [p90_sites; prctile(site_vals,90)];
        site_data{i} = site_vals;
        all_vals_for_edges = [all_vals_for_edges; site_vals];

    end

end
p90 = mean(p90_sites,'omitnan');

sat_p90 = p90;        % Holocene/Meghalayan 90% boundary
sat_mod = avg_m;        % modern last 20-year mean
%% SST: Ocean warming, Atlantic inflow region
clearvars -except sat_p90 sat_mod
path='./Holocene records/';
name1 = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 1_sites','Range','A11:A191');
lat = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 1_sites','Range','D11:D191');
lon = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 1_sites','Range','E11:E191');

name2 = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 2_records','Range','A14:A344');
cv = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 2_records','Range','E14:E344');
cvd = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 2_records','Range','F14:F344');
vpIR = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 2_records','Range','C14:C344');
season_temp = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 2_records','Range','G14:G344');

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

m=0;o=0;season=cell(length(name),5);
for i=1:height(name2)
if strcmp(cv.ClimateVariable{i},'temp') && (strcmp(cvd.ClimateVariableDetail{i},'sea_surface')||strcmp(cvd.ClimateVariableDetail{i},'near_surface'))
    if strcmp(name2.SiteShortName{i},o)==0
        n=1;m=m+1;
    end
    season{m,n}=season_temp.Seasonality{i};n=n+1;
    o=name2.SiteShortName{i};
end
end

load('./ modern records at the Holocene record sites/sst_p.mat')

wj={'alaska-yukon-v2.xls','canadian-islands-greenland-v2.xls','fennoscandia-v2.xls','mainland-canada-v2.xls',...
    'north-atlantic-iceland-v2.xls','russian-arctic-v2.xls'};
wjm=wj{1};o=2;n=1;

sst=sst([1:18,20:22,24:end],:);name={name{1:18},name{20:22},name{24:end}};nn=nn([1:18,20:22,24:end]);
season=season([1:18,20:22,24:end],:);

age=cell(length(name),5);sst_h=cell(length(name),5);
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
    if contains(table.Properties.VariableNames{j},["sst","Temperature"],'IgnoreCase',true)
        sst_h{i,m}=table2array(table(:,j));
    
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
sst_h{23,3}=[];age{23,3}=[];


sst_m=cell(length(name),5);
reshaped_sst=reshape(sst',[12,552/12,length(name)]);
for i=1:length(name)

    if strcmp(name{i},'GIK23258')
    sst_m{i,1}=(sst(i,6:12:end)+sst(i,7:12:end)+sst(i,8:12:end))./3;
    sst_m{i,2}=squeeze(mean(reshaped_sst(:,:,i),1));
    sst_m{i,3}=(sst(i,12:12:end)+sst(i,1:12:end)+sst(i,2:12:end))./3;
    sst_m{i,4}=sst_m{i,1};
    continue
    elseif strcmp(name{i},'JM01-1199')
    sst_m{i,1}=(sst(i,6:12:end)+sst(i,7:12:end)+sst(i,8:12:end))./3;
    sst_m{i,2}=sst_m{i,1};sst_m{i,3}=sst_m{i,1};sst_m{i,4}=sst_m{i,1};sst_m{i,5}=sst_m{i,1};
    continue
    elseif strcmp(name{i},'LO09')
    sst_m{i,1}=sst(i,8:12:end);sst_m{i,2}=sst(i,2:12:end);
    sst_m{i,3}=sst_m{i,1};sst_m{i,4}=sst_m{i,1};
    continue
    elseif strcmp(name{i},'MD99-2322')
    sst_m{i,1}=(sst(i,6:12:end)+sst(i,7:12:end)+sst(i,8:12:end))./3;
    continue
    elseif strcmp(name{i},'RAPID-12')
    sst_m{i,1}=(sst(i,5:12:end)+sst(i,6:12:end))./2;
    continue
    elseif strcmp(name{i},'MSM05-712')
    sst_m{i,1}=(sst(i,12:12:end)+sst(i,1:12:end)+sst(i,2:12:end))./3;
    sst_m{i,2}=(sst(i,6:12:end)+sst(i,7:12:end)+sst(i,8:12:end))./3;
    continue
    elseif strcmp(name{i},'Troll28-03')
    sst_m{i,1}=(sst(i,6:12:end)+sst(i,7:12:end)+sst(i,8:12:end))./3;
    sst_h{i,2}=[];age{i,2}=[];
    continue    
    end

    n=sum(~cellfun(@isempty, season(i,:)));
    for j=1:n
        
    if strcmp(season{i,j},'summer') || strcmp(season{i,j},'JJA')
    sst_m{i,j}=(sst(i,6:12:end)+sst(i,7:12:end)+sst(i,8:12:end))./3;
    elseif strcmp(season{i,j},'winter')
    sst_m{i,j}=(sst(i,12:12:end)+sst(i,1:12:end)+sst(i,2:12:end))./3;
    elseif strcmp(season{i,j},'July')    
    sst_m{i,j}=sst(i,7:12:end);
    elseif strcmp(season{i,j},'August')   
    sst_m{i,j}=sst(i,8:12:end);
    elseif strcmp(season{i,j},'annual')

    if strcmp(name{i},'GGC19')
    sst_h{i,j}=sst_h{i,j+2};sst_h{i,j+1}=sst_h{i,j+3};sst_h{i,j+2}=[];sst_h{i,j+3}=[];
    age{i,j}=age{i,j+2};age{i,j+1}=age{i,j+3};age{i,j+2}=[];age{i,j+3}=[];
    continue
    else
    sst_m{i,j}=squeeze(mean(reshaped_sst(:,:,i),1));
    end

    end


    end
end
sst_m{1,1}=sst_m{1,2};sst_m{1,2}=sst_m{1,3};sst_m{1,3}=[];

sst_h([1:9,13,24],[1,2]) = sst_h([1:9,13,24],[2,1]);
age([1:9,13,24],[1,2]) = age([1:9,13,24],[2,1]);
age{16,3}=age{16,3}.*1000;%ka
tmax = 4200; % Meghalayan: last 4.2 ka, age in yr BP
for ii = 1:numel(sst_h)
    if ~isempty(sst_h{ii}) && ~isempty(age{ii})
        nmin = min(numel(age{ii}), numel(sst_h{ii}));
        a = age{ii}(1:nmin);
        v = sst_h{ii}(1:nmin);
        a = a(:);
        v = v(:);
        keep = a <= tmax & ~isnan(a) & ~isnan(v);
        age{ii} = a(keep);
        sst_h{ii} = v(keep);
    end
end


data_h_summer = [];
data_m_summer = [];
data_h_winter = [];
data_m_winter = [];
p90_sites_summer = [];p90_sites_winter = [];
for i = 1:length(name)
        site_vals_summer = [];site_vals_winter = [];
    if ismember(name{i}, {'GIK23258','JM01-1199','MD95-2011','MSM05-712','PL-96','Troll28-03'})
        if strcmp(name{i},'GIK23258')
         site_vals_summer = [site_vals_summer; sst_h{i,1}(:);sst_h{i,4}(:)];
         site_vals_winter = [site_vals_winter; sst_h{i,3}(:)];
        data_h_summer = [data_h_summer; sst_h{i,1}; sst_h{i,4}];
        data_h_winter = [data_h_winter; sst_h{i,3}];
        data_m_summer = [data_m_summer; sst_m{i,1}(end-19:end)];
        data_m_winter = [data_m_winter; sst_m{i,3}(end-19:end)];
        elseif strcmp(name{i},'JM01-1199')
            for j=1:5
        data_h_summer = [data_h_summer; sst_h{i,j}];
        site_vals_summer = [site_vals_summer; sst_h{i,j}(:)];
            end
        data_m_summer = [data_m_summer; sst_m{i,1}(end-19:end)];
        elseif strcmp(name{i},'MD95-2011')
        site_vals_summer = [site_vals_summer; sst_h{i,1}(:); sst_h{i,3}(:)];
        data_h_summer = [data_h_summer; sst_h{i,1}; sst_h{i,3}];
        data_m_summer = [data_m_summer; sst_m{i,1}(end-19:end)];
        elseif strcmp(name{i},'MSM05-712')
        site_vals_summer = [site_vals_summer; sst_h{i,2}(:)];
        site_vals_winter = [site_vals_winter; sst_h{i,1}(:)];
        data_h_summer = [data_h_summer; sst_h{i,2}];
        data_h_winter = [data_h_winter; sst_h{i,1}];
        data_m_summer = [data_m_summer; sst_m{i,2}(end-19:end)];
        data_m_winter = [data_m_winter; sst_m{i,1}(end-19:end)];
        elseif strcmp(name{i},'PL-96')
        site_vals_summer = [site_vals_summer; sst_h{i,1}(:)];
        site_vals_winter = [site_vals_winter; sst_h{i,2}(:)];
        data_h_summer = [data_h_summer; sst_h{i,1}];
        data_h_winter = [data_h_winter; sst_h{i,2}];
        data_m_summer = [data_m_summer; sst_m{i,1}(end-19:end)];
        data_m_winter = [data_m_winter; sst_m{i,2}(end-19:end)];
        elseif strcmp(name{i},'Troll28-03')
        site_vals_summer = [site_vals_summer; sst_h{i,1}(:)];
        data_h_summer = [data_h_summer; sst_h{i,1}];
        data_m_summer = [data_m_summer; sst_m{i,1}(end-19:end)];
        end
    end
    if numel(site_vals_summer) >= 10
        p90_sites_summer = [p90_sites_summer; prctile(site_vals_summer,90)];
    end
    if numel(site_vals_winter) >= 10
        p90_sites_winter = [p90_sites_winter; prctile(site_vals_winter,90)];
    end
end

data_m_summer = mean(data_m_summer, 'all', 'omitnan');
data_m_winter = mean(data_m_winter, 'all', 'omitnan');
p90_summer = mean(p90_sites_summer,'omitnan');p90_winter = mean(p90_sites_winter,'omitnan');


sst_p90_summer = p90_summer;
sst_mod_summer = data_m_summer;

sst_p90_winter = p90_winter;
sst_mod_winter = data_m_winter;

%% SSS: Freshwater accumulation, Pacific sector
clearvars -except sat_p90 sat_mod sst_p90_winter sst_mod_winter sst_p90_summer sst_mod_summer
path='./Holocene records/';
name1 = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 1_sites','Range','A11:A191');
lat = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 1_sites','Range','D11:D191');
lon = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 1_sites','Range','E11:E191');

name2 = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 2_records','Range','A14:A344');
cv = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 2_records','Range','E14:E344');
cvd = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 2_records','Range','F14:F344');
vpIR = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 2_records','Range','C14:C344');
season_temp = readtable([path,'tables-1-2-s1-v2.xlsx'],'Sheet','Table 2_records','Range','G14:G344');

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


all_vals = cell(12,2);

for i = 1:12
    for j = 1:2
        cmems_seq = sss_m_cmems{i,j};
        esa_seq   = sss_m_esa{i,j};

        [in_t, loc] = ismember(target_years, years_cmems);
        cmems_vals = cmems_seq(loc(in_t));
        all_vals{i,j} = [all_vals{i,j}; cmems_vals(:)]; 

        [in_t, loc] = ismember(target_years, years_esa);
        esa_vals = esa_seq(loc(in_t));
        all_vals{i,j} = [all_vals{i,j}; esa_vals(:)]; 
    end
end


data_h = [];
avg_sss = [];
for i = 1:length(name)
    if ismember(name{i}, {'GGC19','HLC0501','P1B3'})
        data_h = [data_h; sss_h{i,2}];   
        avg_sss = [avg_sss; all_vals{i,2}]; 
    end
end
avg_sss = mean(avg_sss, 'all', 'omitnan');


p10_sites = [];
for i = 1:length(name)
    site_vals = [];
        if ~isempty(sss_h{i,2})&&ismember(name{i}, {'GGC19','HLC0501','P1B3'})
            site_vals = [site_vals; sss_h{i,2}(:)];
        end
    if numel(site_vals) >= 10
        p10_sites = [p10_sites; prctile(site_vals,10)];
    end
end
p10 = mean(p10_sites,'omitnan');


sss_p10 = p10;        % Holocene 10% boundary
sss_mod = avg_sss;        % modern last 20-year mean

sss_p10_h=sss_p10;sat_p90_h=sat_p90;sst_p90_summer_h=sst_p90_summer;sst_p90_winter_h=sst_p90_winter;
save('./M_boundaries.mat','sss_p10_h','sat_p90_h','sst_p90_summer_h','sst_p90_winter_h')