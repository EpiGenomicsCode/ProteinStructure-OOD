# ICDS-Roar-OOD Protein Structure Prediction

## Description
This project provides a web-based interface for running protein structure prediction jobs using AlphaFold 2 and AlphaFold 3 on the ICDS Roar cluster via Open OnDemand v3. The app simplifies the process of submitting and monitoring AlphaFold jobs by providing a user-friendly interface and automated job management.

## Features

### Multiple Prediction Engines
- **AlphaFold 2**:
  - Supports AlphaFold v2.3.2 for protein structure prediction
  - Handles both monomer and multimer predictions
  - Uses full database configuration for maximum accuracy
  - Automated MSA generation and template search

- **AlphaFold 3** (New!):
  - Latest version of AlphaFold with improved accuracy
  - Supports protein-protein, protein-DNA/RNA, and protein-ligand complexes
  - Enhanced diffusion-based structure prediction
  - Requires acceptance of Google's terms of service

### Job Management
- **Two-phase execution**:
  - CPU phase for MSA/templates
  - GPU phase for prediction (set as a dependency)
- **Real-time job status monitoring**
- **Detailed progress tracking**
- **Automatic error handling and recovery**

### User Interface
- **Flexible Input Formats**:
  - FASTA sequence input for AlphaFold 2
  - JSON format input for AlphaFold 3 (following [official specifications](https://github.com/google-deepmind/alphafold3/blob/main/docs/input.md))
- **GPU allocation selection**
- **Working directory customization**
- **Real-time progress visualization**
- **Direct access to output files**

### Output Files
- **AlphaFold 2**:
  - PDB structure files (ranked by confidence)
  - Multiple Sequence Alignment (MSA) files
  - Detailed prediction metrics and confidence scores
  - Comprehensive log files

- **AlphaFold 3**:
  - CIF structure files
  - Ranking scores for multiple predictions
  - Detailed model outputs and metrics
  - Complete execution logs

## Prerequisites

### Database Setup
Both AlphaFold versions require genetic databases that must be set up before using the app:
- AlphaFold 2: Download using script from [AlphaFold repository](https://github.com/google-deepmind/alphafold)
- AlphaFold 3: Additional databases required for DNA/RNA/ligand predictions

### Singularity Containers
The app uses Singularity containers for execution:
- AlphaFold 2: Download from [Sylabs](https://cloud.sylabs.io/library/prehensilecode/alphafold_singularity/alphafold)
- AlphaFold 3: Requires official container from Google (subject to terms of use)

## Installation

1. Clone this repository into your Open OnDemand apps directory
2. Configure paths in `template/alphafold_env.sh`
3. Ensure all required databases are properly set up
4. Verify GPU compute capabilities (minimum 8.0 for AlphaFold 3)

## Usage

1. Access the Open OnDemand dashboard
2. Navigate to "Interactive Apps"
3. Select "Protein Structure Prediction"
4. Choose prediction engine (AlphaFold 2 or 3)
5. Fill out the form:
   - For AlphaFold 2: Enter protein sequence in FASTA format
   - For AlphaFold 3: Provide input in JSON format
   - Select GPU allocation
   - Choose working directory
6. Accept terms of service (required for AlphaFold 3)
7. Submit the job

### Input Format Examples

#### AlphaFold 2 (FASTA)
The app accepts protein sequences in FASTA format.

Example:
```
>sequence_name
MVKVGVNGFGRIGRLVTRAAFNSGKVDIVAINDPFIDLNYMVYMFQYDSTHGKFHGTVKA
ENGKLVINGNPITIFQERDPSKIKWGDAGAEYVVESTGVFTTMEKAGAHLQGGAKRVIIS
```

#### AlphaFold 3 (JSON) 

```
{
"name": "example_complex",
"sequences": [
{
"protein": {
"id": "protein_chain_A",
"sequence": "MVKVGVNG..."
}
}
],
"modelSeeds": [1, 2, 3]
}
```


### Output Files
The app generates the following output structure:

```
working_directory/
└── run_YYYYMMDD_HHMMSS/
├── input/
│ ├── [structure files] # Predicted structures
│ ├── [prediction data] # Detailed predictions
│ └── msas/ # Multiple sequence alignments
├── logs/ # Job logs
├── CPU-SLURM/ # CPU phase files
└── GPU-SLURM/ # GPU phase files
```


## Monitoring Jobs
The app provides real-time monitoring of:
- MSA generation progress
- Template search status
- Structure prediction progress
- Model relaxation status

## Troubleshooting
Common issues and solutions:

1. Job fails in CPU phase:
   - Check available disk space
   - Verify database paths
   - Examine CPU phase logs

2. GPU phase errors:
   - Verify GPU allocation
   - Check memory requirements
   - Review GPU phase logs
   - For AlphaFold 3: Ensure GPU compute capability ≥ 8.0

## License
This project is licensed under the MIT License.

## Acknowledgements
- AlphaFold by DeepMind Technologies Limited
- Singularity container by prehensilecode
- The research project is generously funded by Cornell University BRC Epigenomics Core Facility (RRID:SCR_021287), Penn State Institute for Computational and Data Sciences (RRID:SCR_025154) and Penn State University Center for Applications of Artificial Intelligence and Machine Learning to Industry Core Facility (RRID:SCR_022867)

## Contact
For questions or issues, please contact:
- Technical support: vinaysmathew@psu.edu
- ICDS support: icds@psu.edu