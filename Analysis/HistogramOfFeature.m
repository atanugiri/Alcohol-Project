    % Author: Atanu Giri
% Date: 02/11/2024

function HistogramOfFeature(feature, varargin)

% Example usage
% HistogramOfFeature('stoppingpts_per_unittravel_method6','t1','t2','t3');

% feature = 'entry_time_25'; varargin = {'t1','t2','t3'};

fprintf("Health types:\n");
fprintf("P2L1 Baseline, P2L1 Food deprivation, Initial task, Late task, P2L1 Saline, \n" + ...
    "P2L1 Ghrelin, P2L1L3 Saline, P2L1L3 Ghrelin, Sal toyrat, \n" + ...
    "Ghr toyrat, Sal toystick, Ghr toystick, Sal skewer, Ghr skewer, \n" + ...
    "Combined Sal toy, Combined Ghr toy, Sal alcohol, Ghr alcohol\n");

control = input("Which health type do you want for control? ","s");
controlID = treatmentIDfun(control);

% Prompt for each treatment group
treatmentGroups = {};
for i = 1:numel(varargin)
    treatmentGroups{i} = input("Which health type do you want for treatment? ","s");
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
ks_statistic = zeros(1, length(treatment_data));
for i = 1:numel(treatment_data)
    [~, p_value(i), ks_statistic(i)] = kstest2(control_data.(feature), treatment_data{i}.(feature));
end

%% Plotting histogram
all_data = [{control_data}, treatment_data];
Colors = lines(length(all_data));
for i = 1:length(all_data)
    hold on;
    histogram(all_data{i}.(feature),'Normalization','pdf','FaceAlpha',0.2, ...
        'FaceColor',Colors(i,:));

end
ylabel(sprintf('%s', feature), "Interpreter","none",'FontSize',25);
treatment_names = strjoin(treatmentGroups, ', ');
title(sprintf("%s vs % s", control, treatment_names));

% Add legend
legend_labels = [control, treatmentGroups];
legend(legend_labels, 'Location', 'best');

% Add p-values below the title
text_location_x = mean(xlim);
text_location_y = max(ylim);
for i = 1:length(p_value)
    text(text_location_x, text_location_y - i*0.1*text_location_y, sprintf('p-value %d: %.4f', ...
        i, p_value(i)), 'FontSize', 10, 'Color', 'k', 'HorizontalAlignment', 'center');
end
end