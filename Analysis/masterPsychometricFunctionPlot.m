% Author: Atanu Giri
% Date: 12/04/2023

function featureForEachSubjectId = masterPsychometricFunctionPlot(feature, varargin)
%
% This function takes 'feature' and treatment type as input from 
% 'ghrelin_featuretable' and returns psychometric plot for that feature as 
% an average of all animals

% Example usage
% masterPsychometricFunctionPlot('distance_until_limiting_time_stamp_old', 'P2L1 Baseline')

close all;

fprintf("Health types:\n");
fprintf("P2L1 Baseline, P2L1 Food deprivation, Oxy, Incubation, \n" + ...
    "Initial task, Late task, P2L1 Saline, \n" + ...
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
% data(isoutlier(data.distance_until_limiting_time_stamp_old),:) = [];

% Plotting
x = 1:4;
figure;
hold on;

splitByGender = input("Do you want to split by gender? ('y', 'n'): ","s");

if strcmpi(splitByGender, 'n')
    [~, avFeature, stdErr] = psychometricFunValues(data, feature);
    plot(x, avFeature, 'LineWidth', 2, 'Color', 'k');
    errorbar(x,avFeature,stdErr,'LineStyle', 'none', 'LineWidth', 1.5, ...
        'CapSize', 0, 'Color','k');
    legend(sprintf('%s', treatment));

elseif strcmpi(splitByGender, 'y')
    femaleData = data(strcmpi(data.gender,"female"),:);
    maleData = data(strcmpi(data.gender,"male"),:);
    [~, avFeatureF, stdErrF] = psychometricFunValues(femaleData, feature);
    [~, avFeatureM, stdErrM] = psychometricFunValues(maleData, feature);
    avFeature = [avFeatureF; avFeatureM];
    stdErr = [stdErrF; stdErrM];
    color = ['r';'b'];
    for gender = 1:2
        plot(x, avFeature(gender,:), 'LineWidth', 2, 'Color', color(gender));
        errorbar(x, avFeature(gender,:), stdErr(gender,:),'LineStyle', ...
            'none', 'LineWidth', 1.5, 'CapSize', 0, 'Color','k');
    end
    legend([sprintf("%s Female", "", "%s Male", "", treatment, treatment)]);
end

ylabel(sprintf('%s', feature), 'Interpreter','none');
xticks(1:4);
label = {'0.5','2','5','9'};
set(gca,'xticklabel',label,'FontSize',15);

% Save figure
figname = sprintf('%s_%s',treatment,string(feature));
myPath = "/Users/atanugiri/Downloads/Saline Ghrelin Project/Analysis/Fig files";
savefig(gcf, fullfile(myPath, figname));
end % end of masterPsychometricFunctionPlot
