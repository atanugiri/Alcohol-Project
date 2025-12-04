# Alcohol Project - Behavioral Analysis

## Overview

This MATLAB project analyzes behavioral data from experiments investigating alcohol's effects on approach-avoidance conflict tasks in animal models. The analysis includes psychometric function fitting, gender-specific behavioral patterns, and various statistical analyses.

## Project Structure

```
Alcohol-Project/
├── Analysis/                          # Main analysis scripts
│   ├── run_me.m                      # Primary execution script
│   ├── Extract treatment ID functions/ # Treatment group identification
│   ├── Misc files/                   # Supplementary analysis scripts
│   ├── Sigmoid fitting/              # Psychometric curve fitting functions
│   └── Statistics/                   # Statistical analysis tools
├── Feature Extraction/               # Behavioral feature extraction
│   ├── Feature Functions/           # Feature computation functions
│   └── Write to Featuretable Functions/  # Data export utilities
└── modify_figure_legend.ipynb       # Figure post-processing notebook
```

## Requirements

### Software
- MATLAB R2020a or later (recommended)
- Statistics and Machine Learning Toolbox
- Curve Fitting Toolbox
- Python integration (for MANOVA tests)
- PostgreSQL (for database queries)

### Python Dependencies
- numpy
- scipy (for `manovaTest`)

### Data Setup

The analysis functions require access to behavioral data tables stored in a PostgreSQL database:

1. Download the required data tables from Harvard Dataverse:
   - **Dataset URL**: https://doi.org/10.7910/DVN/YVPYUJ
   - Download `ghrelin_featuretable.tar.gz`
   - Download `live_table.tar.gz`

2. Set up a local PostgreSQL database and import the tables

3. Configure database connection parameters in the analysis scripts to point to your local database

> **Note:** The code contains hardcoded database connection settings that will need to be modified for your local setup. You'll need to update host addresses and connection parameters throughout the codebase.

## Usage

### Running the Full Analysis Pipeline

1. Navigate to the `Analysis/` directory
2. Open `run_me.m` in MATLAB
3. Execute the script to run all analyses:
   ```matlab
   run_me
   ```

### Analyzing Specific Treatment Groups

Use the treatment ID extraction functions to filter data:
```matlab
ids = extract_alcohol_ids();
ids = extract_boost_ids();
ids = extract_combined_boost_alcohol_ids();
```

## Key Analysis Components

### Main Analysis Scripts (`Analysis/`)

- **`run_me.m`**: Primary analysis pipeline orchestrating all major analyses
- **Psychometric Analysis**:
  - `masterPsychometricFunctionPlot.m`: Generate psychometric function plots
  - `individualPsychometricPlotOverlay.m`: Plot individual session psychometrics
  - `overlayPsychometricFunctions.m`: Overlay multiple psychometric curves
  - `temporalPsychometricPlot.m`: Time-series psychometric analysis
  
- **Behavioral Metrics**:
  - `approachRateAtDifferentCost.m`: Analyze approach behavior at varying costs
  - `analyzeConditionalPlacePreferance.m`: CPP analysis
  - `alcohol_consumption.m`: Alcohol consumption patterns
  
- **Statistical Analysis**:
  - `sensitivityAnalysis.m`: Sensitivity analysis of parameters
  - `varianceAnalysis.m`: Variance component analysis
  - `pcAnalysis.m`: Principal component analysis
  
- **Sigmoid Fitting**: Curve fitting for psychometric functions
  - `allFitParam.m`: Extract all fitting parameters
  - `sigmoid_fit.m`: Fit sigmoid curves to behavioral data

### Feature Extraction (`Feature Extraction/`)

- **Spatial Analysis**:
  - `coordinateNormalization.m`: Normalize maze coordinates
  - `trajectoryPlot.m`: Visualize animal trajectories
  - `VisualizeMaze.m`: Maze visualization tools
  
- **Feature Computation**: Extract behavioral features from raw data
- **Data Management**: Write extracted features to feature tables

## Experimental Design

The experiment used seven task types: Pre-alcohol non-conflict, Pre-alcohol conflict, Alcohol task, Non-conflict Proximal-post-alcohol, Conflict Proximal-post-alcohol, Non-conflict Distal-post-alcohol, Conflict Distal-post-alcohol.

> **Note:** In the code, treatment group names may differ from these published names. Use the functions in `Extract treatment ID functions/` to map between code identifiers and experimental conditions.

## Notes

- Bad sessions are automatically cleaned using `cleanBadSessionsFromTable.m`
- The project uses bootstrap methods for statistical testing (1000 iterations)

## Citation

If you use this code in your research, please cite the associated publication.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Contact

For questions or issues, please contact Atanu Giri.
