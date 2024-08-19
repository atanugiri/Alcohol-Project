% Author: Atanu Giri
% Date: 07/31/2024

function vulnerableVsResilient(gender, varargin)
% gender = 'female';
% varargin = {'P2L1 BL for comb boost and alc', 'P2L1L3 BL for comb boost and alc', ...
%     'P2A Boost and alcohol'};

if strcmpi(gender, 'male')
    animalList = {'aladdin', 'carl', 'jafar', 'jimi', 'jr', 'kobe', 'mike', ...
        'scar', 'simba', 'sully'};
elseif strcmpi(gender, 'female')
    animalList = {'alexis', 'fiona', 'harley', 'juana', 'kryssia', 'neftali', ...
        'raven', 'renata', 'sarah', 'shakira'};
end

featureLists = cell(numel(varargin), numel(animalList));
for grp = 1:numel(varargin)
    loadFile = load(sprintf('%sFeatureLists_%s.mat', gender, varargin{grp}));
    featureLists(grp, :) = loadFile.featureList;
end

% Initialize an array to store the results
results = zeros(3, numel(animalList));
resultsLegend = cell(3, 1);

% Perform comparisons
for animal = 1:numel(animalList)
    for i = 1:numel(varargin) - 1
        for j = i+1:numel(varargin)
            T1 = featureLists{i, animal};
            T2 = featureLists{j, animal};

            if find(all(T1 == 0)) == find(all(T2 == 0))
                ZeroColId = find(all(T1 == 0));

                tempT1 = T1;
                tempT2 = T2;
                tempT1(:, ZeroColId) = [];
                tempT2(:, ZeroColId) = [];

                % Perform MANOVA
                data = [tempT1; tempT2];
                group = [repmat({'T1'}, size(tempT1,1), 1); repmat({'T2'}, size(tempT2,1), 1)];
                [~, p] = manova1(data, group);
            else
                % Compare 'P2L1 BL for comb boost and alc' vs 'P2L1L3 BL for comb boost and alc'
                data = [T1; T2];
                group = [repmat({'T1'}, size(T1,1), 1); repmat({'T2'}, size(T2,1), 1)];
                % Perform MANOVA
                [~, p] = manova1(data, group);
            end

            % Store the results
            results(i+j-2, animal) = p;
            resultsLegend{i+j-2} = sprintf('%s vs %s', varargin{i}, varargin{j});
        end
    end
end

% Create the bar plot
figure;
bar(results', 'grouped');
xlabel('Animals');
ylabel('p-value');
set(gca, 'XTickLabel', animalList);
title('Comparison of Approach Rates for Different Treatment Groups');

% Add a horizontal dotted line at y = 0.05
hold on;
yline(0.05, '--k', 'LineWidth', 1.5, 'Color', 'r');
hold off;
legend(resultsLegend{:}, 'p = 0.05', 'Location', 'Best');