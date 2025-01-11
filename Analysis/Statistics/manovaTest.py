import numpy as np
import pandas as pd
from statsmodels.multivariate.manova import MANOVA

def manovaTest(group1_data, group2_data):
    """
    Perform MANOVA on two groups and return Wilks' Lambda and p-value.
    """
    # Combine data and create group labels
    data = np.vstack([group1_data, group2_data])
    group_labels = ['Group1'] * group1_data.shape[0] + ['Group2'] * group2_data.shape[0]

    # Create DataFrame for MANOVA
    df = pd.DataFrame(data, columns=['Conc1', 'Conc2', 'Conc3', 'Conc4'])
    df['Group'] = group_labels

    # Perform MANOVA
    manova = MANOVA.from_formula('Conc1 + Conc2 + Conc3 + Conc4 ~ Group', data=df)
    result = manova.mv_test()

    # Extract Wilks' Lambda and p-value
    wilks_lambda = result.results['Group']['stat'].loc["Wilks' lambda", 'Value']
    p_value = result.results['Group']['stat'].loc["Wilks' lambda", 'Pr > F']

    # Print the results
    print(f"Wilks' Lambda: {wilks_lambda:.4f}")
    print(f"P-value: {p_value:.4f}")

    return wilks_lambda, p_value, result

