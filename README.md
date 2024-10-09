# ProteinStructure-OOD

## Description
This project provides a web-based interface for running protein structure prediction jobs using AlphaFold on the ICDS Roar cluster via Open OnDemand.

## Features
- Supports AlphaFold prediction engine
- User-friendly form for job submission and allocation selection
- GPU allocation requested only on succesful completion of MSA phase
- Input validation for amino acid sequences

## Coming Soon
- Open OnDemand 3.1 support
- ESM-Fold integration
- OpenFold integration
- Chai-1 integration

## Installation
Clone this repository into your Open OnDemand apps directory:

## Usage
1. Access the Open OnDemand dashboard
2. Navigate to the "Interactive Apps" section
3. Select "Protein Structure Prediction"
4. Fill out the form with your job details
5. Submit the job

## Configuration
The main configuration file is `form.yml.erb`. You can modify this file to adjust form fields, default values, and allocation options.

### Important Paths
The following paths need to be configured in the `alphafold.sh` script:

- `STORAGE_BASE`: Base storage path for general use.
- `ICDS_BASE`: ICDS base path. This contains all the necessary databases for AlphaFold, including:
  - UniRef90
  - MGnify
  - PDB mmCIF
  - UniProt
  - PDB seqres
  - UniRef30
  - BFD
  These databases are required for AlphaFold's operation and are common across all AlphaFold runs.

- `GROUP_BASE`: Group base path. This contains:
  - `ALPHAFOLD_CONTAINER`: Path to the AlphaFold container (.sif file). This file must be built using Singularity's sandbox mode.
  - `ALPHAFOLD_GPU_SCRIPT`: Path to the GPU script for running AlphaFold.

The ICDS_BASE and GROUP_BASE paths are typically set to common locations across all AlphaFold runs in your environment.

## Output
Job results will be available in the specified working directory. Key output files include:
- PDB structures (ranked_0.pdb being the highest-confidence model)
- MSA files
- result_model_*.pkl files containing detailed output and confidence scores

## Troubleshooting
Check the log files in the following directory for debugging: "Working_Directory"/run_[date_time]/logs/

## License
This project is licensed under the MIT License.

## Acknowledgements
This project utilizes AlphaFold, developed by DeepMind Technologies Limited. 

The research project is generously funded by Cornell University BRC Epigenomics Core Facility (RRID:SCR_021287), Penn State Institute for Computational and Data Sciences (RRID:SCR_025154) and Penn State University Center for Applications of Artificial Intelligence and Machine Learning to Industry Core Facility (RRID:SCR_022867).

## Contact
For questions or issues, please contact Vinay S Mathew - vinaysmathew@psu.edu
