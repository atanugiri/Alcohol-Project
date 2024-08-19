% Author: Atanu Giri
% Date: 07/04/2024
%
function myClusterPlot2(varargin)

varargin = {'P2L1L3 Boost and alcohol_approachavoid_fitting_param.mat', ...
'P2A Boost and alcohol_approachavoid_fitting_param.mat'};

scriptDir = fileparts(mfilename('fullpath'));
myPath = fullfile(scriptDir, 'Mat files for cluster/');

% Placeholder for coefficients
a = cell(1, numel(varargin));
b = cell(1, numel(varargin));
c = cell(1, numel(varargin));

for grp = 1:numel(varargin)
    loadFile = load(fullfile(myPath, varargin{grp}));
    currentFitData = loadFile.trtmntFitData;
    currentFitData = currentFitData(~cellfun(@isempty, currentFitData));
    fitParam = cellfun(@(x) x.fit_params, currentFitData, 'UniformOutput', false);

    for session = 1:numel(fitParam)
        if length(fitParam{session}) >= 3
            a{grp} = [a{grp}; fitParam{session}(1)];
            b{grp} = [b{grp}; fitParam{session}(2)];
            c{grp} = [c{grp}; fitParam{session}(3)];
        end
    end

    a{grp} = log(abs(a{grp})); 
    b{grp} = log(abs(b{grp})); 
    c{grp} = log(abs(c{grp}));
end

% Cluster Plot
figure;
Colors = parula(numel(varargin));

for grp = 1:numel(varargin)
    h(grp) = plot3(a{grp}, b{grp}, c{grp}, 'o','MarkerFaceColor', Colors(grp,:), ...
        'MarkerEdgeColor', Colors(grp,:));
    hold on;
end

% Label the axes
xlabel('log(abs(a))');
ylabel('log(abs(b))');
zlabel('log(abs(c))');
legend(h, varargin, 'Interpreter','none', 'Location','northeast');

% Save figure
figDir = fileparts(mfilename('fullpath'));
figFolder = 'Fig files for cluster';
figPath = fullfile(figDir, figFolder);
% Check if the folder exists, if not, create it
if ~exist(figPath, 'dir')
    mkdir(figPath);
end

% Initialize a cell array to hold the first parts of each entry
first_parts = cell(size(varargin));

% Loop through varargin and extract the first part of each string
for i = 1:numel(varargin)
    % Split the string at the underscore
    parts = strsplit(varargin{i}, '_');
    % Take the first part
    first_parts{i} = parts{1};
end

% Concatenate the first parts with a space separator
figname = strjoin(first_parts, '_');
savefig(gcf, fullfile(figPath, figname));