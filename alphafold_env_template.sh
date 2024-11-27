#!/bin/bash

export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python

export ALPHAFOLD_BASE="/path/to/alphafold"
export ALPHAFOLD_DB="${ALPHAFOLD_BASE}/alphafold_databases"

export CURRENT_DATE=$(date +"%Y%m%d_%H%M%S")
export RUN_DIR="${WORKINGDIR}/run_${CURRENT_DATE}"

export CPU_OUTPUT="${RUN_DIR}/CPU-SLURM"
export GPU_OUTPUT="${RUN_DIR}/GPU-SLURM"
export STRUCT="${RUN_DIR}"
export LOGDIR="${RUN_DIR}/logs"

export UNIREF90_PATH="${ALPHAFOLD_DB}/uniref90/uniref90.fasta"
export MGNIFY_PATH="${ALPHAFOLD_DB}/mgnify/mgy_clusters_2022_05.fa"
export TEMPLATE_MMCIF_PATH="${ALPHAFOLD_DB}/pdb_mmcif/mmcif_files"
export OBSOLETE_PDBS_PATH="${ALPHAFOLD_DB}/pdb_mmcif/obsolete.dat"
export UNIPROT_PATH="${ALPHAFOLD_DB}/uniprot/uniprot.fasta"
export PDB_SEQRES_PATH="${ALPHAFOLD_DB}/pdb_seqres/pdb_seqres.txt"
export UNIREF30_PATH="${ALPHAFOLD_DB}/uniref30/UniRef30_2021_03"
export BFD_PATH="${ALPHAFOLD_DB}/bfd/bfd_metaclust_clu_complete_id30_c90_final_seq.sorted_opt"

export ALPHAFOLD_CONTAINER="${ALPHAFOLD_BASE}/singularity/alphafold_2.3.2-1.sif"
export ALPHAFOLD_GPU_SCRIPT="${ALPHAFOLD_BASE}/scripts/run/run_alphafold-gpu_2.3.2.py"

export HHBLITS_BINARY_PATH="${ALPHAFOLD_BASE}/hh-suite/bin/hhblits"

export JOB_NAME="alphafold_job_${USER}"
export FASTA_FILE="${CPU_OUTPUT}/input.fasta"
