function power = estimateKStest2Power(x1, x2, numSimulations)
    % Estimate power for KStest2 between two arrays

    n1 = length(x1);
    n2 = length(x2);

    power = 0;

    for i = 1:numSimulations
        % Sample with replacement from x1 and x2
        x1_sim = randsample(x1, n1, true);
        x2_sim = randsample(x2, n2, true);

        % Perform KStest2
        [~, pValue] = kstest2(x1_sim, x2_sim);

        % Increment power if null hypothesis is rejected
        if pValue < 0.05
            power = power + 1;
        end
    end

    power = power / numSimulations;
end