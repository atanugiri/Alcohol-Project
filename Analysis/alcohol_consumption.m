% Author: Atanu Giri
% Date: 01/22/2025
%
% This script calculates the alcohol consumption by sex in 
% 'P2A Boost and alcohol' health group
%
males = {'aladdin', 'carl', 'jafar', 'jimi', 'jr', 'kobe', 'mike', 'scar', ...
'simba', 'sully'};
females = {'alexis', 'fiona', 'harley', 'juana', 'kryssia', 'neftali', ...
'raven', 'renata', 'sarah', 'shakira'};

% Get weights from Excel sheet
maleWts = [578, 592, 529, 513, 486, 562, 534, 500, 518, 616];
femaleWts = [264, 339, 334, 264, 282, 304, 294, 295, 311, 312];

% Alcohol consumption per mL
alcVol = [20, 10, 4, 1] ./100;

% Connect to database
datasource = 'live_database';
conn = database(datasource,'postgres','1234');

treatmentIDs = treatmentIDfun('P2A Boost and alcohol', conn);
treatmentIDs_str = strjoin(arrayfun(@num2str, treatmentIDs, 'UniformOutput', false), ',');
treatment_data = fetchHealthDataTable('approachavoid', treatmentIDs_str, conn);
treatment_data = cleanBadSessionsFromTable(treatment_data, 'approachavoid'); % Remove bad sessions

totalAlcConsumPerSessionMale = zeros(25, 4);
animalCtMale = zeros(25, 1);

totalAlcConsumPerSessionFemale = zeros(25, 4);
animalCtFemale = zeros(25, 1);

for animal = 1:numel(males)
    % Calculations for male
    [featureForEachMale, ~, trialCtMale] = psychometricFunValuesPerSession(treatment_data, ...
        'approachavoid', males{animal});

    approachNumMale = featureForEachMale.*trialCtMale;
    alcoholConsumedMale = (approachNumMale .* alcVol)/(maleWts(animal)*0.001);
    rowsMale = size(alcoholConsumedMale, 1);

    totalAlcConsumPerSessionMale(1:rowsMale, :) = totalAlcConsumPerSessionMale(1:rowsMale, :) + alcoholConsumedMale;
    animalCtMale(1:rowsMale, :) = animalCtMale(1:rowsMale, :) + 1;

    % Calculations for female
    [featureForEachFemale, ~, trialCtFemale] = psychometricFunValuesPerSession(treatment_data, ...
        'approachavoid', females{animal});

    approachNumFemale = featureForEachFemale.*trialCtFemale;
    alcoholConsumedFemale = (approachNumFemale .* alcVol)/(femaleWts(animal)*0.001);
    rowsFemale = size(alcoholConsumedFemale, 1);

    totalAlcConsumPerSessionFemale(1:rowsFemale, :) = totalAlcConsumPerSessionFemale(1:rowsFemale, :) + alcoholConsumedFemale;
    animalCtFemale(1:rowsFemale, :) = animalCtFemale(1:rowsFemale, :) + 1;
end

% Remove empty rows
validRowMale = animalCtMale ~= 0;
totalAlcConsumPerSessionMale = totalAlcConsumPerSessionMale(validRowMale, :);
animalCtMale = animalCtMale(validRowMale);

validRowFemale = animalCtFemale ~= 0;
totalAlcConsumPerSessionFemale = totalAlcConsumPerSessionFemale(validRowFemale, :);
animalCtFemale = animalCtFemale(validRowFemale);

% Obtain average alcohol consumption per animal
avAlcConsumPerSessionMale = totalAlcConsumPerSessionMale ./ animalCtMale;
avAlcConsumPerSessionFemale = totalAlcConsumPerSessionFemale ./ animalCtFemale;

%% Canculate mean alcohol consumtion per animal per session accross 4 conc
meanAlcConsumMale = mean(avAlcConsumPerSessionMale);
meanAlcConsumFemale = mean(avAlcConsumPerSessionFemale);

stdErrMale = std(avAlcConsumPerSessionMale)/sqrt(length(animalCtMale));
stdErrFemale = std(avAlcConsumPerSessionFemale)/sqrt(length(animalCtFemale));

% Plot figure
figure;
errorbar(1:4, meanAlcConsumMale, stdErrMale, 'DisplayName', 'Male', ...
    'LineWidth', 2, 'Color', 'b');
hold on;
errorbar(1:4, meanAlcConsumFemale, stdErrFemale, 'DisplayName', 'Female', ...
    'LineWidth', 2, 'Color', 'r');
hold off;

% Add label and legend
xlabel('Sucrose conc.', 'Interpreter','none', 'FontSize', 25);
ylabel(sprintf('Alcohol consumption\n(mL/kg)'), 'Interpreter', 'latex', 'FontSize', 25);
xticks(1:4);
label = {'0.5','2','5','9'};
set(gca,'xticklabel',label,'FontSize',15);
legend('show', 'Interpreter', 'none');


%% Canculate mean alcohol consumtion per animal per session
avAlcConsumOverAllConcMale = mean(avAlcConsumPerSessionMale, 2);
avAlcConsumOverAllConcFemale = mean(avAlcConsumPerSessionFemale, 2);

meanAlcConsumOverAllConcMale = mean(avAlcConsumOverAllConcMale);
meanAlcConsumOverAllConcFemale = mean(avAlcConsumOverAllConcFemale);

stdErrOverAllConcMale = std(avAlcConsumOverAllConcMale)/sqrt(length(animalCtMale));
stdErrOverAllConcFemale = std(avAlcConsumOverAllConcFemale)/sqrt(length(animalCtFemale));

% Data for plotting
means = [meanAlcConsumOverAllConcMale, meanAlcConsumOverAllConcFemale];
errors = [stdErrOverAllConcMale, stdErrOverAllConcFemale];

% Create a bar plot
figure;
barHandle = bar(means, 'FaceColor', 'flat'); % Bar plot
hold on;

% Set bar colors: blue for male, red for female
barHandle.CData(1, :) = [0 0 1]; % RGB for blue
barHandle.CData(2, :) = [1 0 0]; % RGB for red

% Add error bars
x = barHandle.XEndPoints; % Get x-coordinates of bar centers
errorbar(x, means, errors, 'k', 'linestyle', 'none', 'LineWidth', 1.5); % Error bars

% Customize the plot
xticks([1 2]); % Set x-ticks
xticklabels({'Male', 'Female'}); % Set x-tick labels
ylabel('Alcohol consumption (mL/kg)', 'Interpreter', 'latex', 'FontSize', 14);
set(gca, 'FontSize', 12);
hold off;

% Statistics
[~, p] = ttest2(avAlcConsumOverAllConcMale, avAlcConsumOverAllConcFemale);