% Author: Atanu Giri
% Date: 04/04/2024
%
% This function takes treatment group, feature and animal name as input and
% plots the psychometric function per session.
%
% Example usage:
% individualPsychPlotPerSession('approachavoid','P2L1 Ghrelin', 'sully')

%% Invokes individualPsychValuesPerSession

function individualPsychPlotPerSession(feature, trtGroup, animal)

[featureList, sessionList] = individualPsychValuesPerSession(feature, trtGroup, animal);

x = [1,2,3,4];
Colors = parula(size(featureList, 1));
figure;

for session = 1:size(featureList)
    % Check for NaN values in y
    if any(isnan(featureList))
        disp('Skipping iteration due to NaN values in y.');
        continue; % Skip the current iteration
    end

    plot(x, featureList(session, :), 'LineWidth', 2, 'Color', Colors(session,:), ...
        'DisplayName', sessionList(session));
    hold on;
end

ylim([0, 1]);
title(sprintf('%s %s', trtGroup, animal));
legend('show', 'Location', 'best');
ylabel(sprintf('%s', feature), "Interpreter","none");

% Figure name
figname = sprintf('%s_%s_%s_sessions_psych',trtGroup, animal, feature);

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