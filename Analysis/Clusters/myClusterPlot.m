% Author: Atanu Giri
% Date: 03/12/2024

function myClusterPlot(varargin)

% varargin = {'P2L1 Alcohol_approachavoid_fitting_param', 'P2L1 Ghrelin_approachavoid_fitting_param', ...
%     'P2L1 Ghr Alcohol_approachavoid_fitting_param'};

scriptDir = fileparts(mfilename('fullpath'));
myPath = fullfile(scriptDir, 'Mat files/');

FitData = cell(1, numel(varargin));

for grp = 1:numel(varargin)
    loadFile = load(fullfile(myPath, varargin{grp}));
    FitData{grp} = loadFile.trtmntFitData;
end

allA = cell(1, numel(varargin));
allB = cell(1, numel(varargin));
allC = cell(1, numel(varargin));
allRsq = cell(1, numel(varargin));

for grp = 1:numel(varargin)
    currentFitData = FitData{grp};

    % Loop through each cell of FitData
    for animal = 1:numel(currentFitData)
        % Get the current struct
        currentAnimalData = currentFitData{animal};

        for session = 1:length(currentAnimalData)
            if currentAnimalData(session).fitIndex == 2
                % Collect the fit params
                allA{grp} = [allA{grp}; currentAnimalData(session).a];
                allB{grp} = [allB{grp}; currentAnimalData(session).b];
                allC{grp} = [allC{grp}; currentAnimalData(session).c];
                allRsq{grp} = [allRsq{grp}; currentAnimalData(session).goodness];
            end
        end % end of 1st session
    end % end of 1st animal group

end % end of 1st treatment group

%% Cluster Plot
figure(1);
Colors = parula(numel(varargin));

for grp = 1:numel(varargin)
    plot3(allA{grp}, allB{grp}, allC{grp}, 'o', 'color', Colors(grp,:));
    hold on;
end

hold off;
fig1name = sprintf('cluster_%s',[varargin{:}]);

% Save figure
scriptDir = fileparts(mfilename('fullpath'));
folderName = 'Fig files';
myPath = fullfile(scriptDir, folderName);
% Check if the folder exists, if not, create it
if ~exist(myPath, 'dir')
    mkdir(myPath);
end

savefig(gcf, fullfile(myPath, fig1name));
close(gcf);

%% Histogram
bwArray = [0.05, 10, 0.15, 0.05];
histOfParam(allA, 'max', bwArray(1));
histOfParam(allB, 'slope', bwArray(2));
histOfParam(allC, 'shift', bwArray(3));
histOfParam(allRsq, 'R^2', bwArray(4));


%% Bar plot
myBarPlot(allA, 'max');
myBarPlot(allB, 'slope');
myBarPlot(allC, 'shift');
myBarPlot(allRsq, 'R^2');



%% Description of histOfParam
    function histOfParam(paramArray, paramName, currentBW)
        for idx = 1:numel(varargin)
            %             subplot(1,3,idx);
            h(idx) = histogram(paramArray{idx}, 'Normalization','pdf','FaceAlpha',0.7, ...
                'BinWidth', currentBW, 'FaceColor', Colors(idx,:));
            hold on;
        end

        hold off;
%         linkaxes([subplot(1,3,1), subplot(1,3,2), subplot(1,3,3)], 'y');
        title(sprintf('Histogram of %s', paramName), 'Interpreter','latex','FontSize',25);
        legend(h, varargin, 'Interpreter','none','Location','best');
        xlabel('value','Interpreter','latex');
        ylabel('probability density','Interpreter','latex');
        figname = sprintf('param_%s_hist_%s', paramName, [varargin{:}]);
        savefig(gcf, fullfile(myPath, figname));
        close(gcf);
    end


%% Description of myBarPlot
    function myBarPlot(paramArray, paramName)
        for idx = 1:numel(varargin)
            coeffArray = paramArray{idx};
            coeffArray = coeffArray(isfinite(coeffArray));
            meanCoeff = mean(coeffArray);
            stdErr = std(coeffArray)/sqrt(length(coeffArray));

            h(idx) = bar(idx, meanCoeff, 'FaceColor', Colors(idx,:));
            hold on;
            errorbar(idx, meanCoeff, stdErr, 'LineWidth', 1.5, 'Color','k');

        end

        hold off;
        title(sprintf('Bar plot of %s', paramName), 'Interpreter','latex','FontSize',25);
        legend(h, varargin, 'Interpreter', 'none', 'Location', 'best');
        figname = sprintf('param_%s_barplot_%s', paramName, [varargin{:}]);
        savefig(gcf, fullfile(myPath, figname));
        close(gcf);
    end

end