# ProteinStructure-OOD

## Description
This project provides a web-based interface for running protein structure prediction jobs using AlphaFold on the ICDS Roar cluster via Open OnDemand.

## Features
- Supports AlphaFold prediction engine
- User-friendly form for job submission and allocation selection.
- Input validation for amino acid sequences

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

## Contact
For questions or issues, please contact vinaysmathew@psu.edu
