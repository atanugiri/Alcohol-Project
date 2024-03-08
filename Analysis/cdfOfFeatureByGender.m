% Author: Atanu Giri
% Date: 02/18/2024

function [h, figname] = cdfOfFeatureByGender(feature, varargin)

% Example usage
% cdfOfFeatureByGender('P2L1 Ghrelin','Ghr alcohol');

% feature = 'stoppingpts_per_unittravel_method6';
% varargin = {'P2L1 Saline','P2L1 Ghrelin'};

fprintf("Health types:\n");
fprintf("P2L1 Baseline, P2L1 Food deprivation, Oxy, Incubation, \n" + ...
    "Initial task, Late task, P2L1 Saline, \n" + ...
    "P2L1 Ghrelin, P2L1L3 Saline, P2L1L3 Ghrelin, Sal toyrat, \n" + ...
    "Ghr toyrat, Sal toystick, Ghr toystick, Sal skewer, Ghr skewer, \n" + ...
    "Combined Sal toy, Combined Ghr toy, Alcohol bl, Boost, Alcohol, \n" + ...
    "Sal alcohol, Ghr alcohol\n");

if numel(varargin) >= 1
    control = varargin{1};
else
    control = input("Which health type do you want for control? ","s");
end

controlID = treatmentIDfun(control);

treatmentGroups = {};
if numel(varargin) >= 2
    for i = 2:numel(varargin)
        treatmentGroups{i-1} = varargin{i};
    end
else
    treatmentGroups = input("Which health type do you want for treatment? ","s");
end

treatmentIDs = cell(1, numel(treatmentGroups));
for i = 1:numel(treatmentGroups)
    treatmentIDs{i} = treatmentIDfun(treatmentGroups{i});
end

% Generate the idList from the filtered data
controlID = strjoin(arrayfun(@num2str, controlID, 'UniformOutput', false), ',');
treatmentIDs_str = cellfun(@(x) strjoin(arrayfun(@num2str, x, 'UniformOutput', ...
    false), ','), treatmentIDs, 'UniformOutput', false);

control_data = fetchHealthDataTable(feature, controlID);
control_data_male = control_data(ismember(control_data.gender, ["male", "Male"]),:);
control_data_female = control_data(ismember(control_data.gender, ["Female", "female"]),:);

treatment_data = cell(1, numel(treatmentIDs_str));
treatment_data_male = cell(1, numel(treatmentIDs_str));
treatment_data_female = cell(1, numel(treatmentIDs_str));


for i = 1:numel(treatmentIDs_str)
    treatment_data{i} = fetchHealthDataTable(feature, treatmentIDs_str{i});
    treatment_data_male{i} = treatment_data{i}(ismember(treatment_data{i}.gender, ...
        ["male", "Male"]),:);
    treatment_data_female{i} = treatment_data{i}(ismember(treatment_data{i}.gender, ...
        ["female", "Female"]),:);
end


%% Statistics
p_value_male = zeros(1, length(treatment_data));
p_value_female = zeros(1, length(treatment_data));

for i = 1:numel(treatment_data)
    [~, p_value_male(i)] = ttest2(control_data_male.(feature), treatment_data_male{i}.(feature));
    [~, p_value_female(i)] = ttest2(control_data_female.(feature), treatment_data_female{i}.(feature));
end

%% Plotting cdf
h = figure;
all_data = [{control_data_male}, {control_data_female} treatment_data_male, treatment_data_female];
Colors = lines(length(all_data));
for i = 1:length(all_data)
    hold on;
    l = cdfplot(all_data{i}.(feature));
    set(l, 'LineWidth', 2);

end
xlabel(sprintf('%s', feature), "Interpreter","none",'FontSize',25);
ylabel("F(x)", "Interpreter","none",'FontSize',25);
treatment_names = strjoin(treatmentGroups, ', ');
title(sprintf("%s vs % s", control, treatment_names));
figname = sprintf("MvF %s_%s vs % s", feature, control, treatment_names);

% Add legend
legend_labels = [control, treatmentGroups];
groups = {'male', 'female'};
% Initialize an empty cell array to store new legend labels
new_legend_labels = cell(1, numel(legend_labels) * numel(groups));

% Loop through each label and group to generate new legend labels
counter = 1;
for i = 1:numel(legend_labels)
    for j = 1:numel(groups)
        new_legend_labels{counter} = [legend_labels{i} ' ' groups{j}];
        counter = counter + 1;
    end
end

legend(new_legend_labels, 'Location', 'best');

% Add p-values below the title
text_location_x = mean(xlim);
text_location_y = max(ylim);
for i = 1:length(p_value_male)
    text(text_location_x, text_location_y - i*0.1*text_location_y, sprintf('p-value Male: %.4e', ...
        p_value_male(i)), 'FontSize', 10, 'Color', 'k', 'HorizontalAlignment', 'center');
end

for i = 1:length(p_value_female)
    text(text_location_x, text_location_y - (length(p_value_male) + i) * 0.1 * text_location_y, ...
        sprintf('p-value Female: %.4e', p_value_female(i)), ...
        'FontSize', 10, 'Color', 'k', 'HorizontalAlignment', 'center');
end

end