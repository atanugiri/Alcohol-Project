% Author: Atanu Giri
% Date: 12/01/2023

function featureForEach = masterFunForBarPlotOfFeature(feature, varargin)
%
% This function takes 'feature' and treatment type as input from 
% 'ghrelin_featuretable' and returns bar plot for that feature as 
% an average of all animals

% Example usage
% masterFunForBarPlotOfFeature('distance_until_limiting_time_stamp_old', 'P2L1 Baseline')

close all;

fprintf("Health types:\n");
fprintf("P2L1 Baseline, P2L1 Food deprivation, Initial task, Late task, P2L1 Saline, \n" + ...
    "P2L1 Ghrelin, P2L1L3 Saline, P2L1L3 Ghrelin, Sal toyrat, \n" + ...
    "Ghr toyrat, Sal toystick, Ghr toystick, Sal skewer, Ghr skewer, \n" + ...
    "Combined Sal toy, Combined Ghr toy, Alcohol bl, Boost, Alcohol, \n" + ...
    "Sal alcohol, Ghr alcohol\n");

if numel(varargin) >= 1
    treatment = varargin{1};
else
    treatment = input("Which health type do you want to analyze? ","s");
end

id = treatmentIDfun(treatment); % Get id list

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
    legend(sprintf('%s', treatment));


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
    legend([sprintf("%s Female", "", "%s Male", "", treatment, treatment)]);
end

ylabel(sprintf('%s', feature), 'Interpreter','none', 'FontSize', 25);
hold off;

% Save figure
figname = sprintf('%s_%s_bar',treatment,string(feature));
myPath = "/Users/atanugiri/Downloads/Saline Ghrelin Project/Analysis/Fig files";
savefig(gcf, fullfile(myPath, figname));

% Save mat files for Statistics
myStatPath = "/Users/atanugiri/Downloads/Saline Ghrelin Project/Analysis/Satistical analysis";
% save(fullfile(myStatPath, figname), "featureForEach");


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
