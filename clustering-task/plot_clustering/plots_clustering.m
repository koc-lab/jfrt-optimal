clc
clear
close all


% Clustering 1

load err
err1 = err;
err1_mean = mean(err1,3);

tim = 0.84:0.02:1.16;
gim = 0.84:0.02:1.16;

figure()

surf(gim,tim,err1_mean)

xlabel('Graph order \beta')
ylabel('Time order \alpha')
zlabel('Percentage accuracy (PA)')



load err_twenty.mat
err2 = err;
err2_mean = mean(err2,3);

tim = 0.84:0.02:1.16;
gim = 0.84:0.02:1.16;

figure()

surf(gim,tim,err2_mean)

xlabel('Graph order \beta')
ylabel('Time order \alpha')
zlabel('Percentage accuracy (PA)')
%ordinary, best graph, best frac, best of both.
ordinary = squeeze(err1(9,9,:));
[~,idxg] = sort(err1_mean(9,:),'descend');
[~,idxt] = sort(err1_mean(:,9),'descend');
best = squeeze(err1(4,12,:));
bestg = squeeze(err1(9,idxg(1),:));
bestt = squeeze(err1(idxt(1),9,:));
load ordinary10result.mat

err10dft = load('dft_result.mat').mat.snr10;
err10gft = load('gft_result.mat').mat.snr10;
snr10comparison = [err10ord,err10dft,err10gft,ordinary,bestg,bestt,best];

figure()
row1 = {'Signal', 'DFT', 'GFT', 'JFT', 'JFRTg', 'JFRTt', 'JFRT'};
row2 = median(snr10comparison);
labelArray = [row1; compose('%.2f%%',row2)]; 
labelArray = strjust(pad(labelArray), 'center');
tickLabels = strtrim(sprintf('%s\\newline%s\n', labelArray{:}));
boxplot(snr10comparison,{row1, row2},'sym','+','color','k','ExtremeMode','compress','Widths',0.3,'Symbol','o','OutlierSize',1)
ax = gca(); 
ax.XTick = 1:7; 
ax.XTickLabel = tickLabels;
ylabel('Classification accuracy','Fontsize',13)
set(gca,'Fontsize',13)
ax = get(gca,'children');
obj = ax.Children;
for ii=1:numel(obj)
    if strcmpi(obj(ii).Tag,'Outliers')
        set(obj(ii),'MarkerSize',5)
    elseif strcmpi(obj(ii).Tag,{'Box' 'Lower Whisker' 'Upper Whisker' 'Lower Adjacent Value' 'Lower Adjacent Value' })
        set(obj(ii),'LineWidth',1);
    elseif strcmpi(obj(ii).Tag,{ 'Median'})
        set(obj(ii),'LineWidth',2,'Color',[1.0 0.644 0]);
    end
end
ylim([40, 100]);
grid on;
ordinary = squeeze(err2(9,9,:));
[~,idxg] = sort(err2_mean(9,:),'descend');
[~,idxt] = sort(err2_mean(:,9),'descend');
best = squeeze(err2(4,12,:));
bestg = squeeze(err2(9,idxg(1),:));
bestt = squeeze(err2(idxt(1),9,:));
load ordinary20result.mat

err20dft = load('dft_result.mat').mat.snr20;
err20gft = load('gft_result.mat').mat.snr20;
snr20comparison = [err20ord,err20dft,err20gft,ordinary,bestg,bestt,best];

figure()
row1 = {'Signal', 'DFT', 'GFT', 'JFT', 'JFRTg', 'JFRTt', 'JFRT'};
row2 = median(snr20comparison);
labelArray = [row1; compose('%.2f%%',row2)]; 
labelArray = strjust(pad(labelArray), 'center');
tickLabels = strtrim(sprintf('%s\\newline%s\n', labelArray{:}));
boxplot(snr20comparison, {row1, row2},'sym','+','color','k','ExtremeMode','compress','Widths',0.3,'Symbol','o','OutlierSize',1)
ax = gca(); 
ax.XTick = 1:7; 
ax.XTickLabel = tickLabels;

ylabel('Classification accuracy','Fontsize',13)
set(gca,'Fontsize',13)
ax = get(gca,'children');
obj = ax.Children;
for ii=1:numel(obj)
    if strcmpi(obj(ii).Tag,'Outliers')
        set(obj(ii),'MarkerSize',5)
    elseif strcmpi(obj(ii).Tag,{'Box' 'Lower Whisker' 'Upper Whisker' 'Lower Adjacent Value' 'Lower Adjacent Value'})
        set(obj(ii),'LineWidth',1);
    elseif strcmpi(obj(ii).Tag,{ 'Median'})
        set(obj(ii),'LineWidth',2,'Color',[1.0 0.644 0]);
    end
end
ylim([40, 100])
grid on;
