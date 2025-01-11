import numpy as np
from scipy.stats import f

def compute_manova_power(wilks_lambda, n1, n2, num_dependent_vars, alpha=0.05):
    """
    Compute the power of a MANOVA test using Wilks' Lambda and the F-distribution.

    Parameters:
    - wilks_lambda: Wilks' Lambda value from MANOVA results.
    - n1: Number of observations in group 1.
    - n2: Number of observations in group 2.
    - num_dependent_vars: Number of dependent variables.
    - alpha: Significance level (default 0.05).

    Returns:
    - power: Calculated power of the MANOVA test.
    """
    # Validate inputs
    if wilks_lambda <= 0 or wilks_lambda >= 1:
        raise ValueError("Wilks' Lambda must be between 0 and 1.")

    # Total sample size
    n_total = n1 + n2

    # Degrees of freedom
    df_between = num_dependent_vars
    df_within = n_total - num_dependent_vars - 1

    if df_within <= 0:
        raise ValueError("Degrees of freedom within (df_within) must be greater than 0.")

    # Calculate eta squared (effect size)
    eta_squared = 1 - wilks_lambda

    # Calculate the noncentrality parameter
    noncentrality_param = (eta_squared / (1 - eta_squared)) * df_between * df_within

    # Critical F-value for the given alpha
    f_critical = f.ppf(1 - alpha, df_between, df_within)

    # Power of the test
    power = 1 - f.cdf(f_critical, df_between, df_within, noncentrality_param)

    return power