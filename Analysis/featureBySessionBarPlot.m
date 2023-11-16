% Author: Atanu Giri
% Date: 11/12/2023

% function featureBySessionBarPlot(feature)
%
% This function returns bar plot of a feature for each session as
% an avergare of all animal in that day
%
feature = 'approachavoid';
mergedTable = fetchGhrelinData(feature);

ghrToyratData = mergedTable(mergedTable.tasktypedone == 'ghr toyrat', :);
salToyratData = mergedTable(mergedTable.tasktypedone == 'sal toyrat', :);

uniqueGhrSession = unique(ghrToyratData.referencetime);
uniqueSalSession = unique(salToyratData.referencetime);

ghrSessionData = cell(1,5);
salSessionData = cell(1,5);


for i = 1:5
    figure(i);
    ghrSessionData{i} = ghrToyratData(ghrToyratData.referencetime == uniqueGhrSession(i),:);
    if isequal(feature, 'passing_center_25')
        tfGhr = isnan(ghrSessionData{i}.(feature));
        ghrSessionData{i}.(feature)(tfGhr) = 1;
    end
    avGhrFeature = mean(ghrSessionData{i}.(feature), 'omitnan');
    sdErrGhr = std(ghrSessionData{i}.(feature))/sqrt(length(ghrSessionData{i}.(feature)));

    salSessionData{i} = salToyratData(salToyratData.referencetime == uniqueSalSession(i),:);
    if isequal(feature, 'passing_center_25')
        tfSal = isnan(salSessionData{i}.(feature));
        salSessionData{i}.(feature)(tfSal) = 1;
    end
    avSalFeature = mean(salSessionData{i}.(feature), 'omitnan');
    sdErrSal = std(salSessionData{i}.(feature))/sqrt(length(salSessionData{i}.(feature)));

    bar(1:2, [avGhrFeature, avSalFeature]);
    hold on;
    errorbar(1:2, [avGhrFeature, avSalFeature], [sdErrGhr, sdErrSal], ...
        'LineStyle','none', 'LineWidth',2, 'Color','k');
    ylim([0, 1]);
    ylabel(sprintf('%s', feature), "FontSize", 20, 'Interpreter','latex');
    xticklabels({sprintf('Ghrelin%s',string(ghrSessionData{i}.referencetime(1))), ...
        sprintf('Saline%s',string(salSessionData{i}.referencetime(1)))});
    set(gcf, 'Windowstyle', 'docked');

    % Statistics
    [~, p] = ttest2(ghrSessionData{i}.(feature), salSessionData{i}.(feature));
    
end

% end