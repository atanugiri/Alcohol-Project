% Author: Atanu Giri
% Date: 02/14/2024

function [h, figname] = cdfOfFeature(feature, varargin)

% Example usage
% cdfOfFeature('stoppingpts_per_unittravel_method6','P2L1 Saline','P2L1 Ghrelin','Sal alcohol');

% feature = 'stoppingpts_per_unittravel_method6'; 
% varargin = {'P2L1 Saline','P2L1 Ghrelin','Sal alcohol'};

fprintf("Health types:\n");
fprintf("P2L1 Baseline, P2L1 Food deprivation, Initial task, Late task, P2L1 Saline, \n" + ...
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
% if ~strcmpi(feature,'approachavoid')
%     saline_toy_data(isoutlier(saline_toy_data.distance_until_limiting_time_stamp_old),:) = [];
% end

treatment_data = cell(1, numel(treatmentIDs_str));
for i = 1:numel(treatmentIDs_str)
    treatment_data{i} = fetchHealthDataTable(feature, treatmentIDs_str{i});
end

%% Statistics
p_value = zeros(1, length(treatment_data));
t_stat = zeros(1, length(treatment_data));
for i = 1:numel(treatment_data)
    [~, p_value(i)] = ttest2(control_data.(feature), treatment_data{i}.(feature));
end

%% Plotting cdf
h = figure;
all_data = [{control_data}, treatment_data];
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
figname = sprintf("%s_%s vs % s", feature, control, treatment_names);

% Add legend
legend_labels = [control, treatmentGroups];
legend(legend_labels, 'Location', 'best');

% Add p-values below the title
text_location_x = mean(xlim);
text_location_y = max(ylim);
for i = 1:length(p_value)
    text(text_location_x, text_location_y - i*0.1*text_location_y, sprintf('p-value: %.4e', ...
        p_value(i)), 'FontSize', 10, 'Color', 'k', 'HorizontalAlignment', 'center');
end
end