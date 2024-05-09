% Author: Atanu Giri
% Date: 04/16/2024
%
% Plots histogram of input parameter.
%
% Possible parameter names
% logistic3 fit: 'UA', 'slope', 'shift', 'Rsq'
% logistic4 fit: 'LA', 'slope', 'shift', 'UA', 'Rsq'
% BC fit: 'LA', 'slope', 'shift', 'UA', 'param_f', 'Rsq'
% LC fit: 'UA', 'slope', 'shift', 'UA_2', 'slope_2', 'shift_2', 'Rsq'
%
% Invokes allFitParam

function fitParamHistogram(param_name, splitbyGender, varargin)

% param_name = 'shift'; splitbyGender = 'y';
% varargin = {'P2L1L3 BL for comb boost and alc_approachavoid_logistic4_fitting_param', ...
%     'P2L1L3 Boost and alcohol_approachavoid_logistic4_fitting_param'};

if contains(varargin{1}, 'logistic3')
    [UA, slope, shift, Rsq, animals] = allFitParam(varargin{:});

elseif contains(varargin{1}, 'logistic4')
    [LA, slope, shift, UA, Rsq, animals] = allFitParam(varargin{:});

elseif contains(varargin{1}, 'BC')
    [LA, slope, shift, UA, param_f, Rsq] = allFitParam(varargin{:});

elseif contains(varargin{1}, 'LC')
    [UA, slope, shift, UA_2, slope_2, shift_2, Rsq] = allFitParam(varargin{:});

end

Colors = parula(numel(varargin));

% param_name_array = {'UA', 'slope', 'shift', 'LA', 'param_f', 'Rsq'};
% bwArray = [0.05, 10, 0.15, 0.05, 0.05, 0.05]; % Width of bin
%
% index = strcmpi(param_name_array, param_name);
% currentBW = bwArray(index);

if strcmpi(param_name, 'UA')
    param_array = UA;
elseif strcmpi(param_name, 'slope')
    param_array = slope;
elseif strcmpi(param_name, 'shift')
    param_array = shift;
elseif strcmpi(param_name, 'LA')
    param_array = LA;
elseif strcmpi(param_name, 'param_f')
    param_array = param_f;
elseif strcmpi(param_name, 'UA_2')
    param_array = UA_2;
elseif strcmpi(param_name, 'slope_2')
    param_array = slope_2;
elseif strcmpi(param_name, 'shift_2')
    param_array = shift_2;
elseif strcmpi(param_name, 'Rsq')
    param_array = Rsq;
end

% Seperate param_array into male and female
if strcmpi(splitbyGender, 'y')
    datasource = 'live_database';
    conn = database(datasource,'postgres','1234');

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
    end
end

scriptDir = fileparts(mfilename('fullpath'));
myPath = fullfile(scriptDir, 'Fig files/');

% Histogram
histOfParam(param_array, param_name);


%% Description of histOfParam
    function histOfParam(paramArray, param_name)
        for idx = 1:numel(varargin)

            %             h(idx) = histogram(paramArray{idx}, 'Normalization','pdf','FaceAlpha',0.7, ...
            %                 'BinWidth', currentBW, 'FaceColor', Colors(idx,:));

            if strcmpi(splitbyGender, 'y')
                subplot(1,2,1);
                [f_male, x_values_male] = ksdensity(paramArray{idx}{1});
                h_male(idx) = plot(x_values_male, f_male, 'LineWidth', 2, 'Color', Colors(idx,:));
                xlabel('value','Interpreter','latex');
                ylabel('probability density','Interpreter','latex');
                hold on;

                subplot(1,2,2);
                [f_female, x_values_female] = ksdensity(paramArray{idx}{2});
                h_female(idx) = plot(x_values_female, f_female, 'LineWidth', 2, 'Color', Colors(idx,:));
                xlabel('value','Interpreter','latex');
                hold on;

            else
                [f, x_values] = ksdensity(paramArray{idx}); % Compute KDE values and corresponding x-values
                h(idx) = plot(x_values, f, 'LineWidth', 2, 'Color', Colors(idx,:));
                hold on;
            end
        end

        hold off;
        sgtitle(sprintf('Histogram of %s', param_name), 'Interpreter','latex','FontSize',25);

        if strcmpi(splitbyGender, 'y')
            legend(h_female, varargin, 'Interpreter','none','Location','best');
            linkaxes([subplot(1,2,1), subplot(1,2,2)], 'y');
        end

        if ~strcmpi(splitbyGender, 'y')
            legend(h, varargin, 'Interpreter','none','Location','best');
            xlabel('value','Interpreter','latex');
            ylabel('probability density','Interpreter','latex');
        end

        if contains(varargin{1}, 'logistic3')
            if strcmpi(splitbyGender, 'y')
                figname = sprintf('logistic3_%s_hist_%s_MvF', param_name, [varargin{:}]);
            else
                figname = sprintf('logistic3_%s_hist_%s', param_name, [varargin{:}]);
            end

        elseif contains(varargin{1}, 'logistic4')
            if strcmpi(splitbyGender, 'y')
                figname = sprintf('logistic4_%s_hist_%s_MvF', param_name, [varargin{:}]);
            else
                figname = sprintf('logistic4_%s_hist_%s', param_name, [varargin{:}]);
            end

        elseif contains(varargin{1}, 'BC')
            figname = sprintf('BC_%s_hist_%s', param_name, [varargin{:}]);

        elseif contains(varargin{1}, 'LC')
            figname = sprintf('LC_%s_hist_%s', param_name, [varargin{:}]);

        end

        savefig(gcf, fullfile(myPath, figname));
        close(gcf);
    end

end