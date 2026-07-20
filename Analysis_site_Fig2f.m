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
%% derive Holocene data
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
%% processing modern data
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
%% plotting
ys={'r','b','g'};
for i=1:length(name)
    fig=figure;
    set(fig,'Visible','off')
    set(gcf,'outerposition',get(0,'screensize'),'color','white');
    n=sum(~cellfun(@isempty,sst_h(i,:)));

    for j=1:n
    if strcmp(name{i},'GIK23258') && (j==1 || j==4)
        if j==4
            continue
        end   
        data = vertcat(sst_h{i,[1,4]});
        p90=prctile(data(:), 90);zdz=max(data(:),[],'omitnan');
        axes('position',[0.07+0.33*(j-1),0.18,0.25,0.7]);
        hold on
        grid on;box on
        h=histogram(data(:),10,'Normalization','probability','linewidth',2,'facecolor',ys{j});
        xx=xline(p90,'linestyle','--','color',ys{j},'linewidth',5);
        xx_2=xline(mean(sst_m{i,j}(end-19:end)),'linestyle','-','color',ys{j},'linewidth',5);
        xl = xlim;
if mean(sst_m{i,j}(end-19:end))>zdz
set(gca,'gridcolor',[0.7 0.7 0.7],'tickdir','in','gridalpha',0.2,'fontsize',30,'linewidth',3,'xlim',[xl(1) mean(sst_m{i,j}(end-19:end))+0.1])
else
set(gca,'gridcolor',[0.7 0.7 0.7],'tickdir','in','gridalpha',0.2,'fontsize',30,'linewidth',3)
end
xlabel('Sea surface temperature [°C]','fontsize',30)
ylabel('Probability density','fontsize',30)
hDummy1 = plot(NaN, NaN, '--','color',ys{j},'LineWidth', 5);
hDummy2 = plot(NaN, NaN, '-','color',ys{j},'LineWidth', 5);
legend([h hDummy1, hDummy2],'Meghalayan','90% variability','Present','Location','northeast','fontsize',30);legend('boxoff')
title(season{i,j},'fontsize',30)


    elseif strcmp(name{i},'JM01-1199')
        if j>1
            continue
        end
        data = vertcat(sst_h{i,1:end});
        p90=prctile(data(:), 90);zdz=max(data(:),[],'omitnan');
        axes('position',[0.08+0.48*(j-1),0.18,0.4,0.7]);
        hold on
        grid on;box on
        h=histogram(data(:),10,'Normalization','probability','linewidth',2,'facecolor',ys{j});
        xx=xline(p90,'linestyle','--','color',ys{j},'linewidth',5);
        xx_2=xline(mean(sst_m{i,j}(end-19:end)),'linestyle','-','color',ys{j},'linewidth',5);
                xl = xlim;
if mean(sst_m{i,j}(end-19:end))>zdz
set(gca,'gridcolor',[0.7 0.7 0.7],'tickdir','in','gridalpha',0.2,'fontsize',30,'linewidth',3,'xlim',[xl(1) mean(sst_m{i,j}(end-19:end))+0.1])
else
set(gca,'gridcolor',[0.7 0.7 0.7],'tickdir','in','gridalpha',0.2,'fontsize',30,'linewidth',3)
end
xlabel('Sea surface temperature [°C]','fontsize',35)
ylabel('Probability density','fontsize',35)
hDummy1 = plot(NaN, NaN, '--','color',ys{j},'LineWidth', 5);
hDummy2 = plot(NaN, NaN, '-','color',ys{j},'LineWidth', 5);
legend([h hDummy1, hDummy2],'Meghalayan','90% variability','Present','Location','northeast','fontsize',35);legend('boxoff')
title(season{i,j},'fontsize',35)

    elseif strcmp(name{i},'LO09') && j~=2
    if j==3 || j==4 
        continue
    end
    data = vertcat(sst_h{i,[1,3,4]});
    p90=prctile(data(:), 90);zdz=max(data(:),[],'omitnan');
    axes('position',[0.08+0.48*(j-1),0.18,0.4,0.7]);
    hold on
    grid on;box on
            
    h=histogram(data(:),10,'Normalization','probability','linewidth',2,'facecolor',ys{j});
    xx=xline(p90,'linestyle','--','color',ys{j},'linewidth',5);
    xx_2=xline(mean(sst_m{i,j}(end-19:end)),'linestyle','-','color',ys{j},'linewidth',5);
    xl = xlim;
if mean(sst_m{i,j}(end-19:end))>zdz
set(gca,'gridcolor',[0.7 0.7 0.7],'tickdir','in','gridalpha',0.2,'fontsize',30,'linewidth',3,'xlim',[xl(1) mean(sst_m{i,j}(end-19:end))+0.1])
else
set(gca,'gridcolor',[0.7 0.7 0.7],'tickdir','in','gridalpha',0.2,'fontsize',30,'linewidth',3)
end
xlabel('Sea surface temperature [°C]','fontsize',35)
ylabel('Probability density','fontsize',35)
hDummy1 = plot(NaN, NaN, '--','color',ys{j},'LineWidth', 5);
hDummy2 = plot(NaN, NaN, '-','color',ys{j},'LineWidth', 5);
legend([h hDummy1, hDummy2],'Meghalayan','90% variability','Present','Location','northeast','fontsize',35);legend('boxoff')
title(season{i,j},'fontsize',35)

    elseif strcmp(name{i},'MD95-2011') && j~=2
        if j>2
            continue
        end   
        data = vertcat(sst_h{i,[1,3]});
        p90=prctile(data(:), 90);zdz=max(data(:),[],'omitnan');
        axes('position',[0.08+0.48*(j-1),0.18,0.4,0.7]);
        hold on
        grid on;box on
                
        h=histogram(data(:),10,'Normalization','probability','linewidth',2,'facecolor',ys{j});
        xx=xline(p90,'linestyle','--','color',ys{j},'linewidth',5);
        xx_2=xline(mean(sst_m{i,j}(end-19:end)),'linestyle','-','color',ys{j},'linewidth',5);
        xl = xlim;
if mean(sst_m{i,j}(end-19:end))>zdz
set(gca,'gridcolor',[0.7 0.7 0.7],'tickdir','in','gridalpha',0.2,'fontsize',30,'linewidth',3,'xlim',[xl(1) mean(sst_m{i,j}(end-19:end))+0.1])
else
set(gca,'gridcolor',[0.7 0.7 0.7],'tickdir','in','gridalpha',0.2,'fontsize',30,'linewidth',3)
end
xlabel('Sea surface temperature [°C]','fontsize',35)
ylabel('Probability density','fontsize',35)
hDummy1 = plot(NaN, NaN, '--','color',ys{j},'LineWidth', 5);
hDummy2 = plot(NaN, NaN, '-','color',ys{j},'LineWidth', 5);
legend([h hDummy1, hDummy2],'Meghalayan','90% variability','Present','Location','northeast','fontsize',35);legend('boxoff')
title('August','fontsize',35)
    else
    if strcmp(name{i},'GIK23258')
    axes('position',[0.07+0.33*(j-1),0.18,0.25,0.7]);
        xlabel('Sea surface temperature [°C]','fontsize',30)
ylabel('Probability density','fontsize',30)
    else
    axes('position',[0.08+0.48*(j-1),0.18,0.4,0.7]);
    xlabel('Sea surface temperature [°C]','fontsize',35)
ylabel('Probability density','fontsize',35)
    end

        p90=prctile(sst_h{i,j}(:),90);zdz=max(sst_h{i,j}(:),[],'omitnan');

hold on
    grid on;box on
        h=histogram(sst_h{i,j},10,'Normalization','probability','linewidth',2,'facecolor',ys{j});
        xx=xline(p90,'linestyle','--','color',ys{j},'linewidth',5);
        xx_2=xline(mean(sst_m{i,j}(end-19:end)),'linestyle','-','color',ys{j},'linewidth',5);
                 xl = xlim;
if mean(sst_m{i,j}(end-19:end))>zdz
set(gca,'gridcolor',[0.7 0.7 0.7],'tickdir','in','gridalpha',0.2,'fontsize',30,'linewidth',3,'xlim',[xl(1) mean(sst_m{i,j}(end-19:end))+0.1])
else
set(gca,'gridcolor',[0.7 0.7 0.7],'tickdir','in','gridalpha',0.2,'fontsize',30,'linewidth',3)
end
hDummy1 = plot(NaN, NaN, '--','color',ys{j},'LineWidth', 5);
hDummy2 = plot(NaN, NaN, '-','color',ys{j},'LineWidth', 5);
if strcmp(name{i},'GIK23258')
legend([h hDummy1, hDummy2],'Meghalayan','90% variability','Present','Location','northeast','fontsize',30);legend('boxoff')
else
legend([h hDummy1, hDummy2],'Meghalayan','90% variability','Present','Location','northeast','fontsize',35);legend('boxoff')
end

if strcmp(name{i},'GGC19')
title(season{i,2+j-1},'fontsize',35)
elseif strcmp(name{i},'GIK23258')
if j==2
title('annual','fontsize',30)
else
title('winter','fontsize',30)
end
elseif strcmp(name{i},'LO09') && j==2
title('February','fontsize',35)
elseif strcmp(name{i},'MD95-2011') && j==2
title('annual','fontsize',35) 
elseif strcmp(name{i},'MD99-2322')
title('summer','fontsize',35)
elseif strcmp(name{i},'RAPID-12')
title('late spring/early summer','fontsize',35)
elseif strcmp(name{i},'MSM05-712')
if j==1
title('winter','fontsize',35)
else
title(season{i,1},'fontsize',35)
end
elseif strcmp(name{i},'Troll28-03')
title(season{i,2},'fontsize',35)
else
title(season{i,j},'fontsize',35)
end

    end
    end

if strcmp(name{i},'GIK23258')
text(-0.815,1.128,'GIK23258','fontsize',30,'HorizontalAlignment','center','Units','normalized','VerticalAlignment','top')
elseif strcmp(name{i},'JM01-1199')||n==1
text(0.5,1.15,name{i},'fontsize',35,'HorizontalAlignment','center','Units','normalized','VerticalAlignment','top')
else
text(-0.1,1.11,name{i},'fontsize',35,'HorizontalAlignment','center','Units','normalized','VerticalAlignment','top')
end

ff=getframe(gcf);
imwrite(ff.cdata,['./SST_',name{i},'.jpg']);
end