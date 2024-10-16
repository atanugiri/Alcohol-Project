% Author: Atanu Giri
% Date: 09/18/2024
%

males = {'aladdin', 'carl', 'jafar', 'jimi', 'jr', 'kobe', 'mike', 'scar', ...
'simba', 'sully'};
females = {'alexis', 'fiona', 'harley', 'juana', 'kryssia', 'neftali', ...
'raven', 'renata', 'sarah', 'shakira'};

% Get weights from Excel sheet
maleWts = [578, 592, 529, 513, 486, 562, 534, 500, 518, 616];
femaleWts = [264, 339, 334, 264, 282, 304, 294, 295, 311, 312];

% Alcohol consumption per mL
alcVol = [(20/100), (10/100), (4/100), (1/100)]';

% Calculate approach rate for each animal
avFeatureMale = zeros(4, numel(males));
avFeatureFemale = zeros(4, numel(females));

parfor animal = 1:numel(males)
    featureList = individualPsychValuesPerSession('approachavoid', ...
        'P2A Boost and alcohol', males{animal});
    avFeatureMale(:, animal) = mean(featureList);

    featureList = individualPsychValuesPerSession('approachavoid', ...
        'P2A Boost and alcohol', females{animal});
    avFeatureFemale(:, animal) = mean(featureList);

end

maleConsum = (alcVol.*avFeatureMale) ./maleWts;
maleConsumMean = mean(maleConsum, 2);
stdErrMale = std(maleConsum, 0, 2)/sqrt(length(maleWts));

%% Plotting
figure;
plot(1:4, maleConsumMean, 'Color','b', 'LineWidth', 2);
hold on;
errorbar(maleConsumMean, stdErrMale, 'LineStyle','none', 'Color','k', 'LineWidth',1.5);
xlabel('Sucrose conc.');
ylabel('Alc. consumption (mL/kg)');
title('Alcohol consumption');

femaleConsum = (alcVol.*avFeatureFemale) ./femaleWts;
femaleConsumMean = mean(femaleConsum, 2);
stdErrFemale = std(femaleConsum, 0, 2)/sqrt(length(femaleWts));

plot(1:4, femaleConsumMean, 'Color','r', 'LineWidth',2);
errorbar(femaleConsumMean, stdErrFemale, 'LineStyle','none', 'Color','k', 'LineWidth',1.5);
hold off;

% Statistics
T1 = maleConsum';
T2 = femaleConsum';
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);
text(max(0.8*xlim), max(0.8*ylim), sprintf('p = %s', num2str(p)));

%% Overall
maleConsumOverall = mean(maleConsum);
femaleConsumOverall = mean(femaleConsum);
figure;
overallMean = [mean(maleConsumOverall), mean(femaleConsumOverall)];
b = bar(overallMean, 'FaceColor','flat');
b.CData(1,:) = [0 0 1]; 
b.CData(2,:) = [1 0 0];
hold on;
errorbar(overallMean, [std(maleConsumOverall)/sqrt(length(maleConsumOverall)), ...
    std(femaleConsumOverall)/sqrt(length(femaleConsumOverall))], ...
    'Color', 'k', 'LineWidth',1.5, 'LineStyle','none');
hold off;
ylabel('Alc. consumption (mL/kg)');

% Statistics
[~, p] = ttest2(maleConsumOverall, femaleConsumOverall);
text(max(0.8*xlim), max(0.8*ylim), sprintf('p = %.4f', p));

%% Approach rate comparison
arMale = avFeatureMale';
arFemale = avFeatureFemale';

avARmale = mean(arMale);
avARfemale = mean(arFemale);

figure;
plot(1:4, avARmale, 'Color','b', 'LineWidth', 2);
hold on;
errorbar(avARmale, std(arMale)/sqrt(size(arMale, 1)), ...
    'LineStyle','none', 'Color','k', 'LineWidth',1.5);
plot(1:4, avARfemale, 'Color','r', 'LineWidth', 2);
errorbar(avARfemale, std(arFemale)/sqrt(size(arFemale, 1)), ...
    'LineStyle','none', 'Color','k', 'LineWidth',1.5);

xlabel('Sucrose conc.');
ylabel('Approach rate');
ylim([0, 1]);

% Statistics
T1 = arMale;
T2 = arFemale;
data = [T1; T2];
group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
[d, p, stats] = manova1(data, group);
text(max(0.8*xlim), max(0.8*ylim), sprintf('p = %s', num2str(p)));