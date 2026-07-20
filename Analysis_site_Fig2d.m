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
%% derive Holocene data
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
%% processing modern data
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
%% plotting
ys={'r','b'};
for i=1:length(name)
    fig=figure;
    set(fig,'Visible','off')
    set(gcf,'outerposition',get(0,'screensize'),'color','white');
   n=sum(~cellfun(@isempty, sat_h(i,:)));

    for j=1:n

   if strcmp(name{i}, 'KR02')
        if j>1
            continue
        end
        data = cell2mat(sat_h(i,1:end));
        p90=prctile(data(:),90);zdz=max(data(:),[],'omitnan');
        axes('position',[0.08+0.48*(j-1),0.18,0.4,0.7]);
        hold on
        grid on;box on
        h=histogram(data(:),10,'Normalization','probability','linewidth',2,'facecolor',ys{j});
        xx=xline(p90,'linestyle','--','color',ys{j},'linewidth',5);
        xx_2=xline(mean(sat_m{i,j}(end-19:end)),'linestyle','-','color',ys{j},'linewidth',5);
                xl = xlim;
if mean(sat_m{i,j}(end-19:end))>zdz
set(gca,'gridcolor',[0.7 0.7 0.7],'tickdir','in','gridalpha',0.2,'fontsize',30,'linewidth',3,'xlim',[xl(1) mean(sat_m{i,j}(end-19:end))+0.1])
else
set(gca,'gridcolor',[0.7 0.7 0.7],'tickdir','in','gridalpha',0.2,'fontsize',30,'linewidth',3)
end
xlabel('Surface air temperature [°C]','fontsize',35)
ylabel('Probability density','fontsize',35)
hDummy1 = plot(NaN, NaN, '--','color',ys{j},'LineWidth', 5);
hDummy2 = plot(NaN, NaN, '-','color',ys{j},'LineWidth', 5);
legend([h hDummy1, hDummy2],'Meghalayan','90% variability','Present','Location','northeast','fontsize',35);legend('boxoff')
        title(season{i,1},'fontsize',35)

   elseif ismember(name{i}, {'trout','lake850','njulla','oykjamyrtjorn','sjuuodjijaure','toskaljavri','vuoskkujavri','holebudalen','tsuolbmajavri'})     
        
        if strcmp(name{i},'vuoskkujavri')
        if j==1   
    axes('position',[0.08+0.48*(j-1),0.18,0.4,0.7]);
    xlabel('Surface air temperature [°C]','fontsize',35)
ylabel('Probability density','fontsize',35)


        p90=prctile(sat_h{i,j}(:),90);zdz=max(sat_h{i,j}(:),[],'omitnan');

hold on
    grid on;box on
        h=histogram(sat_h{i,j},10,'Normalization','probability','linewidth',2,'facecolor',ys{j});
        xx=xline(p90,'linestyle','--','color',ys{j},'linewidth',5);
        xx_2=xline(mean(sat_m{i,j}(end-19:end)),'linestyle','-','color',ys{j},'linewidth',5);
                 xl = xlim;
if mean(sat_m{i,j}(end-19:end))>zdz
set(gca,'gridcolor',[0.7 0.7 0.7],'tickdir','in','gridalpha',0.2,'fontsize',30,'linewidth',3,'xlim',[xl(1) mean(sat_m{i,j}(end-19:end))+0.1])
else
set(gca,'gridcolor',[0.7 0.7 0.7],'tickdir','in','gridalpha',0.2,'fontsize',30,'linewidth',3)
end
hDummy1 = plot(NaN, NaN, '--','color',ys{j},'LineWidth', 5);
hDummy2 = plot(NaN, NaN, '-','color',ys{j},'LineWidth', 5);
legend([h hDummy1, hDummy2],'Meghalayan','90% variability','Present','Location','northeast','fontsize',35);legend('boxoff')
title(season{i,1},'fontsize',35)

        continue
        elseif j>2
            continue
        end

        else
  if j>1
  continue
  end
        end

    
    ages_all = [];
    vals_all = [];
    if strcmp(name{i},'vuoskkujavri')
        ks=2;
    else
        ks=1;
    end

    for k = ks:n
            age_col = age{i,k}(:);
            val_col = sat_h{i,k}(:);
            ages_all = [ages_all; age_col];
            vals_all = [vals_all; val_col];
    end
   
        p90 = prctile(vals_all, 90);
    zdz = max(vals_all, [], 'omitnan');
    
    axes('position',[0.08+0.48*(j-1),0.18,0.4,0.7]);
        hold on
        grid on;box on
        h=histogram(vals_all,10,'Normalization','probability','linewidth',2,'facecolor',ys{j});
        xx=xline(p90,'linestyle','--','color',ys{j},'linewidth',5);
        xx_2=xline(mean(sat_m{i,j}(end-19:end)),'linestyle','-','color',ys{j},'linewidth',5);
                xl = xlim;
if mean(sat_m{i,j}(end-19:end))>zdz
set(gca,'gridcolor',[0.7 0.7 0.7],'tickdir','in','gridalpha',0.2,'fontsize',30,'linewidth',3,'xlim',[xl(1) mean(sat_m{i,j}(end-19:end))+0.1])
else
set(gca,'gridcolor',[0.7 0.7 0.7],'tickdir','in','gridalpha',0.2,'fontsize',30,'linewidth',3)
end
xlabel('Surface air temperature [°C]','fontsize',35)
ylabel('Probability density','fontsize',35)
hDummy1 = plot(NaN, NaN, '--','color',ys{j},'LineWidth', 5);
hDummy2 = plot(NaN, NaN, '-','color',ys{j},'LineWidth', 5);
legend([h hDummy1, hDummy2],'Meghalayan','90% variability','Present','Location','northeast','fontsize',35);legend('boxoff')


    if strcmp(name{i},'vuoskkujavri')
title(season{i,2},'fontsize',35)
    else
title(season{i,1},'fontsize',35)
    end


    else

    axes('position',[0.08+0.48*(j-1),0.18,0.4,0.7]);
    xlabel('Surface air temperature [°C]','fontsize',35)
ylabel('Probability density','fontsize',35)


        p90=prctile(sat_h{i,j}(:),90);zdz=max(sat_h{i,j}(:),[],'omitnan');

hold on
    grid on;box on
        h=histogram(sat_h{i,j},10,'Normalization','probability','linewidth',2,'facecolor',ys{j});
        xx=xline(p90,'linestyle','--','color',ys{j},'linewidth',5);
        xx_2=xline(mean(sat_m{i,j}(end-19:end)),'linestyle','-','color',ys{j},'linewidth',5);
                 xl = xlim;
if mean(sat_m{i,j}(end-19:end))>zdz
set(gca,'gridcolor',[0.7 0.7 0.7],'tickdir','in','gridalpha',0.2,'fontsize',30,'linewidth',3,'xlim',[xl(1) mean(sat_m{i,j}(end-19:end))+0.1])
else
set(gca,'gridcolor',[0.7 0.7 0.7],'tickdir','in','gridalpha',0.2,'fontsize',30,'linewidth',3)
end
hDummy1 = plot(NaN, NaN, '--','color',ys{j},'LineWidth', 5);
hDummy2 = plot(NaN, NaN, '-','color',ys{j},'LineWidth', 5);
legend([h hDummy1, hDummy2],'Meghalayan','90% variability','Present','Location','northeast','fontsize',35);legend('boxoff')
 
title(season{i,j},'fontsize',35)

    end
    end

if ~strcmp(name{i},'upper_fly')
if n==1 || ismember(name{i}, {'KR02','trout','lake850','njulla','oykjamyrtjorn','sjuuodjijaure','toskaljavri','holebudalen','tsuolbmajavri'})     
text(0.5,1.15,name{i},'fontsize',35,'HorizontalAlignment','center','Units','normalized','VerticalAlignment','top')
else
text(-0.1,1.11,name{i},'fontsize',35,'HorizontalAlignment','center','Units','normalized','VerticalAlignment','top')
end
else
text(0.5,1.15,'upper fly','fontsize',35,'HorizontalAlignment','center','Units','normalized','VerticalAlignment','top')
end

ff=getframe(gcf);
imwrite(ff.cdata,['./SAT_',name{i},'.jpg']);
end
