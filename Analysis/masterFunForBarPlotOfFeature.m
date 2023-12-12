% Author: Atanu Giri
% Date: 12/01/2023

% function masterFunForBarPlotOfFeature(feature)
%
% This function returns bar plot of a feature as an avergare of all animal
%
feature = 'passing_center_40';
data = fetchGhrelinData(feature);
data(data.subjectid == "none",:) = [];

femaleData = data(strcmpi(data.gender,"female"),:);
maleData = data(strcmpi(data.gender,"male"),:);

splitByGender = input("Do you want to split by gender? ('y', 'n'): ","s");

if strcmpi(splitByGender, 'n')
    [featureForEach, avFeature, stdErr] = barPlotValues(data, feature);
    % Plotting
    bar(avFeature);
    hold on;
    errorbar(avFeature,stdErr,'LineStyle', 'none', 'LineWidth', 1.5, ...
        'CapSize', 0, 'Color','k');

elseif strcmpi(splitByGender, 'y')
    [featureForF, avFeatureF, stdErrF] = barPlotValues(femaleData, feature);
    [featureForM, avFeatureM, stdErrM] = barPlotValues(maleData, feature);
    % Plotting
    x = [1,2];
    figure;
    hold on;
    myData = [avFeatureF, avFeatureM];
    color = ['r','b'];
    for i = 1:length(myData)
        h = bar(x(i), myData(i));
        set(h,'FaceColor',color(i));
    end
    
    errorbar(x,[avFeatureF,avFeatureM],[stdErrF,stdErrM],'LineStyle', 'none', ...
        'LineWidth', 1.5,'CapSize', 0, 'Color','k');
    hold off;
end


%% Description of barPlotValues
function [featureForEach, avFeature, stdErr] = barPlotValues(dataTable, feature)
% dataTable = femaleData; % for testing
uniqueSubjectid = unique(dataTable.subjectid);
featureForEach = zeros(length(uniqueSubjectid),1);

for subject = 1:length(uniqueSubjectid)
    featureArray = dataTable.(feature)(dataTable.subjectid == uniqueSubjectid(subject), :);
    featureArray = featureArray(isfinite(featureArray));
    featureForEach(subject) = sum(featureArray)/length(featureArray);
end

avFeature = mean(featureForEach);
stdErr = std(featureForEach)/sqrt(length(featureForEach));
end

% end
