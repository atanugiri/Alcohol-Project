% Author: Atanu Giri
% Date: 05/15/2024
%
% 
% Possible fit param: 'LA', 'slope', 'shift', 'UA' (From 4-param sig. fit)
%

function [ct_in_part, totalNonSig] = pieChartPlot(matFile, fitParam)

% matFile = 'P2L1 BL for comb boost and alc_approachavoid_logistic4_fitting_param.mat';
[LA, slope, shift, UA, Rsq, ~] = allFitParam(sprintf('%s', matFile));

RsqThr = 0.75; % Threshold to be sigmoid
RsqArray = Rsq{1,1};
sigIdx = RsqArray >= RsqThr;

if strcmpi(fitParam, 'LA')
    filtParam = LA{1,1}(sigIdx);
    paramPartVal = [0.1, 0.2];

elseif strcmpi(fitParam, 'slope')
    filtParam = slope{1,1}(sigIdx);
    paramPartVal = [25, 50];

elseif strcmpi(fitParam, 'shift')
    filtParam = shift{1,1}(sigIdx);
    paramPartVal = [2, 3];

elseif strcmpi(fitParam, 'UA')
    filtParam = UA{1,1}(sigIdx);
    paramPartVal = [0.6, 0.8];

else
    error('Provide correct fit parameter')

end

ct_in_part_1 = sum(filtParam < paramPartVal(1));
ct_in_part_2 = sum(filtParam >= paramPartVal(1) & filtParam < paramPartVal(2));
ct_in_part_3 = sum(filtParam >= paramPartVal(2));

ct_in_part = [ct_in_part_1, ct_in_part_2, ct_in_part_3];
frac_in_part = ct_in_part./length(RsqArray);

% Print data for samity check
fprintf('Total no of sigmoid:\n')
fprintf('%d ', ct_in_part);
fprintf('\n')
fprintf('Total frac of sigmoid:\n')
fprintf('%.2f\n', sum(frac_in_part));

sig = sum(sigIdx);
totalNonSig = length(RsqArray) - sig;
fprintf('Total no of non-sigmoid:\n')
fprintf('%d\n', totalNonSig);
fracNonSig = totalNonSig/(totalNonSig + sig);
fprintf('Total frac:\n')
fprintf('%.2f\n', sum([fracNonSig, frac_in_part]));

% Plotting
pie([frac_in_part, fracNonSig]);
labels = {sprintf('Sigmoidal (%s1)', fitParam), sprintf('Sigmoidal (%s2)', fitParam), ...
    sprintf('Sigmoidal (%s3)', fitParam), 'Non sigmoidal'};

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
figname = sprintf('pie_chart_%s_%s', fitParam, titleStr);
savefig(gcf, fullfile(myPath, figname));

close(gcf);