# Alcohol Project - Behavioral Analysis

## Overview

This MATLAB project analyzes behavioral data from experiments investigating alcohol's effects on approach-avoidance conflict tasks in animal models. The analysis includes psychometric function fitting, gender-specific behavioral patterns, and various statistical analyses.

## Author

Atanu Giri  
Date: February 15, 2024

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
│   ├── runme.m                      # Feature extraction execution script
│   ├── Feature Functions/           # Feature computation functions
│   └── Write to Featuretable Functions/  # Data export utilities
└── modify_figure_legend.ipynb       # Figure post-processing notebook
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

### Treatment Groups

The project analyzes multiple treatment conditions including:
- Baseline (BL) conditions
- Alcohol administration
- Boost treatments
- Combined alcohol and boost protocols
- Post-alcohol recovery
- Ghrelin (GHR) treatments

## Requirements

### Software
- MATLAB R2020a or later (recommended)
- Statistics and Machine Learning Toolbox
- Curve Fitting Toolbox
- Python integration (for MANOVA tests)

### Python Dependencies
- numpy
- scipy (for `manovaTest`)

## Usage

### Running the Full Analysis Pipeline

1. Navigate to the `Analysis/` directory
2. Open `run_me.m` in MATLAB
3. Execute the script to run all analyses:
   ```matlab
   run_me
   ```

### Running Feature Extraction

1. Navigate to the `Feature Extraction/` directory
2. Open `runme.m` in MATLAB
3. Execute the script:
   ```matlab
   runme
   ```

### Analyzing Specific Treatment Groups

Use the treatment ID extraction functions to filter data:
```matlab
ids = extract_alcohol_ids();
ids = extract_boost_ids();
ids = extract_combined_boost_alcohol_ids();
```

## Data Organization

The project expects:
- Raw behavioral data in `.mat` format
- Health/metadata tables in `.xlsx` format
- Coordinate data for trajectory analysis
- Session-level and trial-level behavioral metrics

## Key Analyses

### Figure 1: Overall Treatment Effects
- Sigmoid fitting to approach-avoidance behavior
- Psychometric plots across treatment phases
- Shift in inflection points during conflict task
- Approach rate changes

### Figure 2: Gender-Specific Effects
- Sex-stratified psychometric analyses
- Male vs. female response patterns
- Gender differences in alcohol effects

### Additional Analyses
- Vulnerable vs. resilient phenotypes
- Session and trial progression effects
- Conditional place preference
- Orthogonality calculations
- Feature biplot visualizations

## Output Files

Analysis generates:
- `.fig`: MATLAB figure files
- `.eps`: Publication-quality vector graphics
- `.png`, `.pdf`: Raster graphics
- `.xlsx`: Data tables
- `.mat`: Processed data matrices

## Notes

- Bad sessions are automatically cleaned using `cleanBadSessionsFromTable.m`
- Male subjects: aladdin, carl, jafar, jimi, jr, kobe, mike, scar, simba, sully
- Female subjects: alexis, fiona, harley, juana, kryssia, neftali, raven, renata, sarah, shakira
- The project uses bootstrap methods for statistical testing (1000 iterations)

## Citation

If you use this code in your research, please cite the associated publication.

## License

[Add appropriate license information]

## Contact

For questions or issues, please contact Atanu Giri.
