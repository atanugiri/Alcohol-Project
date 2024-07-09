% Author: Atanu Giri
% Date: 06/30/2024
% This function plots average value and standard deviation of the input
% treatment group. Invokes masterPsychometricFunctionPlot.

function varargout = sensitivityAnalysis(feature, splitByGender, trtmntGrp)

% feature = 'approachavoid';
% splitByGender = 'y';
% trtmntGrp = 'P2L1L3 Boost and alcohol';

if strcmpi(splitByGender, 'n')
    featureForEach = masterPsychometricFunctionPlot(feature, splitByGender, trtmntGrp);
    varargout{1} = featureForEach;

    % Calculate the mean and standard deviation
    mean_y = mean(featureForEach{1});
    std_y = std(featureForEach{1});

elseif strcmpi(splitByGender, 'y')
    [featureForEachMale, featureForEachFemale] = ...
        masterPsychometricFunctionPlot(feature, splitByGender, trtmntGrp);
    varargout{1} = featureForEachMale;
    varargout{2} = featureForEachFemale;

    % Calculate the mean and standard deviation
    mean_y_male = mean(featureForEachMale{1});
    std_y_male = std(featureForEachMale{1});

    mean_y_female = mean(featureForEachFemale{1});
    std_y_female = std(featureForEachFemale{1});

else
    error('Check input.');
end


% Create the figure
figure;
hold on;
x = 1:4;
label = {'0.5','2','5','9'};

if strcmpi(splitByGender, 'n')
    % Plot the average line
    plot(x, mean_y, 'LineWidth', 2);

    % Plot the shaded area
    fill([x, fliplr(x)], [mean_y + std_y, fliplr(mean_y - std_y)], ...
        'b', 'FaceAlpha', 0.2, 'EdgeColor', 'none');

    % Add labels and title
    xlabel('Sucrose conc.');
    ylabel(sprintf('%s', feature));
    title(sprintf('Sensitivity of\n%s', trtmntGrp));

    xticks(1:4);
    set(gca,'xticklabel',label,'FontSize',15);

elseif strcmpi(splitByGender, 'y')
    subplot(1,2,1);
    plot(x, mean_y_male, 'LineWidth', 2);
    hold on;
    fill([x, fliplr(x)], [mean_y_male + std_y_male, fliplr(mean_y_male - std_y_male)], ...
        'b', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
    title("Male", 'Interpreter','latex', 'FontSize', 25);
    ylabel(sprintf('%s', feature), 'Interpreter','none');
    xlabel('Sucrose conc.', 'Interpreter','none', 'FontSize', 25);
    xticks(1:4);
    set(gca,'xticklabel',label,'FontSize',15);


    subplot(1,2,2);
    plot(x, mean_y_female, 'LineWidth', 2);
    hold on;
    fill([x, fliplr(x)], [mean_y_female + std_y_female, fliplr(mean_y_female - std_y_female)], ...
        'b', 'FaceAlpha', 0.2, 'EdgeColor', 'none');
    title("Female", 'Interpreter','latex', 'FontSize', 25);
    xlabel('Sucrose conc.', 'Interpreter','none', 'FontSize', 25);
    xticks(1:4);
    set(gca,'xticklabel',label,'FontSize',15);

    sgtitle(sprintf('Sensitivity of\n%s', trtmntGrp));

end

% Optionally add grid and legend
legend('Average', 'Sensitivity');

hold off;

% Figure name
if strcmpi(splitByGender, 'n')
    figname = sprintf('Sensitivity_%s_%s',trtmntGrp,feature);
elseif strcmpi(splitByGender, 'y')
    figname = sprintf('Sensitivity_MvF_%s_%s',trtmntGrp,feature);
end

% Save figure
scriptDir = fileparts(mfilename('fullpath'));
folderName = 'Fig files';
myPath = fullfile(scriptDir, folderName);
% Check if the folder exists, if not, create it
if ~exist(myPath, 'dir')
    mkdir(myPath);
end

savefig(gcf, fullfile(myPath, figname));

end