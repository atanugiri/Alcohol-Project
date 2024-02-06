% Author: Atanu Giri
% Date: 12/01/2023

function featureForEach = masterFunForBarPlotOfFeature(feature)
%
% This function returns bar plot of a feature as an avergare of all animal
%
feature = 'distance_until_limiting_time_stamp_old';

fprintf("Health types:\n");
fprintf("Sal toyrat, Ghr toyrat, Sal toystick, Ghr toystick, Sal skewer, Ghr skewer\n");
health = input("Which health type do you want to analyze? ","s");

if strcmpi(health, "Sal toyrat")
    [id, ~, ~, ~, ~, ~] = extract_toy_expt_ids;
elseif strcmpi(health, "Ghr toyrat")
    [~, id, ~, ~, ~, ~] = extract_toy_expt_ids;
elseif strcmpi(health, "Sal toystick")
    [~, ~, id, ~, ~, ~] = extract_toy_expt_ids;
elseif strcmpi(health, "Ghr toystick")
    [~, ~, ~, id, ~, ~] = extract_toy_expt_ids;
elseif strcmpi(health, "Sal skewer")
    [~, ~, ~, ~, id, ~] = extract_toy_expt_ids;
elseif strcmpi(health, "Ghr skewer")
    [~, ~, ~, ~, ~, id] = extract_toy_expt_ids;
end

% Generate the idList from the filtered data
idList = strjoin(arrayfun(@num2str, id, 'UniformOutput', false), ',');

% Extract table corresponding to idList
data = fetchHealthDataTable(feature, idList);
data(isoutlier(data.distance_until_limiting_time_stamp_old),:) = [];

splitByGender = input("Do you want to split by gender? ('y', 'n'): ","s");

if strcmpi(splitByGender, 'n')
    [featureForEach, avFeature, stdErr] = barPlotValues(data, feature);
    % Plotting
    bar(avFeature);
    hold on;
    errorbar(avFeature,stdErr,'LineStyle', 'none', 'LineWidth', 1.5, ...
        'CapSize', 0, 'Color','k');
    legend(sprintf('%s', health));


elseif strcmpi(splitByGender, 'y')
    femaleData = data(strcmpi(data.gender,"female"),:);
    maleData = data(strcmpi(data.gender,"male"),:);
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
    legend([sprintf("%s Female", "", "%s Male", "", health, health)]);
end

ylabel(sprintf('%s', feature), 'Interpreter','none', 'FontSize', 25);
hold off;

% Save figure
figname = sprintf('%s_%s_bar',health,string(feature));
myPath = "/Users/atanugiri/Downloads/Saline Ghrelin Project/Analysis/Fig files";
savefig(gcf, fullfile(myPath, figname));

% Save mat files for Statistics
myStatPath = "/Users/atanugiri/Downloads/Saline Ghrelin Project/Analysis/Satistical analysis";
save(fullfile(myStatPath, figname), "featureForEach");


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

end
