% Author: Atanu Giri
% Date: 04/16/2024
%
% Generates density plot of input parameter.
%
% Possible parameter names
% logistic3 fit: 'UA', 'slope', 'shift', 'Rsq'
% logistic4 fit: 'LA', 'slope', 'shift', 'UA', 'Rsq'
% GP fit: 'LA', 'slope', 'shift', 'UA', 'Rsq'
%
% Invokes allFitParam

function varargout = fitParamHistogram(param_name, feature, fitType, splitbyGender, varargin)

% param_name = 'UA';
% feature = 'approachavoid';
% fitType = 2;
% splitbyGender = 'n';
% varargin = {'P2L1L3 BL for comb boost and alc','P2L1L3 Boost and alcohol'};

% Files to fetch
fitTypeNames = ["logistic3", "logistic4", "GP"];
files = strcat(varargin, '_', feature, sprintf('_%s_fitting_param', fitTypeNames(fitType)));

if contains(files{1}, 'logistic3')
    [UA, slope, shift, Rsq, animals] = allFitParam(files{:});
    featureMap = struct('UA', UA, 'slope', slope, 'shift', shift, 'Rsq', Rsq);

elseif contains(files{1}, 'logistic4')
    [LA, slope, shift, UA, Rsq, animals] = allFitParam(files{:});
    featureMap = struct('LA', LA, 'slope', slope, 'shift', shift, 'UA', UA, ...
        'Rsq', Rsq);

elseif contains(files{1}, 'GP')
    [LA, slope, shift, UA, Rsq, animals] = allFitParam(files{:});
    featureMap = struct('LA', LA, 'slope', slope, 'shift', shift, 'UA', UA, ...
        'Rsq', Rsq);
end

param_array = cell(1, numel(varargin));
for i = 1:numel(varargin)
    param_array{i} = featureMap(i).(param_name);
end

varargout{1} = param_array;
Colors = parula(numel(varargin));

% Seperate param_array into male and female
if strcmpi(splitbyGender, 'y')
    datasource = 'live_database';
    conn = database(datasource,'postgres','1234');

    maleParam = cell(1, numel(varargin));
    femaleParam = cell(1, numel(varargin));


    for grp = 1:numel(varargin)
        animalStr = strjoin(animals{grp}, "','");
        genderQ = sprintf("SELECT DISTINCT(subjectid), gender FROM live_table WHERE " + ...
            "subjectid IN ('%s')", animalStr);
        genderD = fetch(conn, genderQ);

        genderD.subjectid = string(genderD.subjectid);
        genderD.gender = string(genderD.gender);

        maleAnimals = genderD.subjectid(strcmpi(genderD.gender, 'male'));
        femaleAnimals = genderD.subjectid(strcmpi(genderD.gender, 'female'));

        maleFilter = ismember(animals{grp}, maleAnimals);
        femaleFilter = ismember(animals{grp}, femaleAnimals);

        maleData = param_array{grp}(maleFilter);
        femaleData = param_array{grp}(femaleFilter);

        param_array{grp} = [];

        param_array{grp}{1} = maleData;
        param_array{grp}{2} = femaleData;

        maleParam{grp} = maleData;
        femaleParam{grp} = femaleData;

    end

    varargout{1} = maleParam; varargout{2} = femaleParam;
end

scriptDir = fileparts(mfilename('fullpath'));
figPath = fullfile(scriptDir, 'Fig files/');

% Histogram
histOfParam(param_array, param_name);


%% Description of histOfParam
    function histOfParam(paramArray, param_name)
        figure;
        for idx = 1:numel(varargin)
            if strcmpi(splitbyGender, 'y')
                subplot(1,2,1);
                [f_male, x_values_male] = ksdensity(paramArray{idx}{1});
                plot(x_values_male, f_male, 'LineWidth', 2, 'Color', Colors(idx,:));
                xlabel('value','Interpreter','latex');
                ylabel('probability density','Interpreter','latex');
                hold on;

                subplot(1,2,2);
                [f_female, x_values_female] = ksdensity(paramArray{idx}{2});
                plot(x_values_female, f_female, 'LineWidth', 2, 'Color', Colors(idx,:));
                xlabel('value','Interpreter','latex');
                hold on;

            else
                [f, x_values] = ksdensity(paramArray{idx}); % Compute KDE values and corresponding x-values
                plot(x_values, f, 'LineWidth', 2, 'Color', Colors(idx,:));
                hold on;
            end
        end

        hold off;
        sgtitle(sprintf('Histogram of %s', param_name), 'Interpreter','latex','FontSize',25);
        legendLabels = varargin;

        if strcmpi(splitbyGender, 'y')
            legend(legendLabels, 'Interpreter','none','Location','best');
            linkaxes([subplot(1,2,1), subplot(1,2,2)], 'y');
        end

        if ~strcmpi(splitbyGender, 'y')
            legend(legendLabels, 'Interpreter','none','Location','best');
            xlabel('value','Interpreter','latex');
            ylabel('probability density','Interpreter','latex');
        end

        % Save figure
        figname = sprintf('density_plot_%s_%s_%s_%s', param_name, feature, ...
            [legendLabels{:}], fitTypeNames(fitType));
        savefig(gcf, fullfile(figPath, figname));
    end

end