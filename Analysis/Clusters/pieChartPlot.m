% Author: Atanu Giri
% Date: 05/15/2024
%

function pieChartPlot(matFile)

% matFile = 'P2L1 BL for comb boost and alc_approachavoid_logistic4_fitting_param.mat';
[LA, slope, shift, UA, Rsq, ~] = allFitParam(sprintf('%s', matFile));

RsqThr = 0.75;
RsqArray = Rsq{1,1};
sigIdx = RsqArray >= RsqThr;
% filtRsq = RsqArray(sigIdx);

% filtShift = shift{1,1}(sigIdx);
% shift1 = sum(filtShift < 2.5)/sum(sigIdx);
% shift2 = sum(filtShift >= 2.5 & filtShift < 3.25)/sum(sigIdx);
% shift3 = sum(filtShift >= 3.25)/sum(sigIdx);

filtUA = UA{1,1}(sigIdx);
figure;
histogram(filtUA);
UA1 = sum(filtUA < 0.6)/sum(sigIdx);
UA2 = sum(filtUA >= 0.6 & filtUA < 0.8)/sum(sigIdx);
UA3 = sum(filtUA >= 0.8)/sum(sigIdx);


sig = sum(sigIdx);
nonSig = length(RsqArray) - sig;
fracNonSig = nonSig/(nonSig + sig);
% fracSig = sig/(nonSig + sig);
% pie([fracNonSig, shift1, shift2, shift3]);
% labels = {'Non sigmoidal', 'Sigmoidal (shift1)', 'Sigmoidal (shift2)', 'Sigmoidal (shift3)'};

pie([fracNonSig, UA1, UA2, UA3]);
labels = {'Non sigmoidal', 'Sigmoidal (UA1)', 'Sigmoidal (UA2)', 'Sigmoidal (UA3)'};

legend(labels, 'Interpreter','latex');

% Regex pattern to match everything up to the first underscore
pattern = '^(.*?)_';
match = regexp(matFile, pattern, 'tokens', 'once');
% If a match is found, return the captured group, else return empty
if ~isempty(match)
    titleStr = match{1};
else
    titleStr = '';
end

title(titleStr);

% Save figure
scriptDir = fileparts(mfilename('fullpath'));
myPath = fullfile(scriptDir, 'Fig files/');
figname = sprintf('pieChart_%s', titleStr);
savefig(gcf, fullfile(myPath, figname));

close(gcf);
end