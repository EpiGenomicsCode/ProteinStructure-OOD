#!/bin/bash

export PROTOCOL_BUFFERS_PYTHON_IMPLEMENTATION=python

export TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
export RUN_DIR="${WORKINGDIR}/run_${TIMESTAMP}"
export STATUS_FILE="${WORKINGDIR}/job_status_${TIMESTAMP}.txt"

export INPUT_DIR="${RUN_DIR}/input"
export CPU_OUTPUT="${RUN_DIR}/cpu_output"
export GPU_OUTPUT="${RUN_DIR}/gpu_output"
export STRUCT="${RUN_DIR}/structure"
export LOGDIR="${RUN_DIR}/logs"

# Alphafold 2

export ALPHAFOLD_BASE="/storage/icds/RISE/sw8/alphafold"
export ALPHAFOLD_DB="${ALPHAFOLD_BASE}/alphafold_databases"

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

# Alphafold 3

export ALPHAFOLD3_BASE="/storage/icds/RISE/sw8/alphafold3"
export ALPHAFOLD3_DB="${ALPHAFOLD3_BASE}/alphafold3/databases"
export ALPHAFOLD3_WEIGHTS="${ALPHAFOLD3_BASE}/alphafold3_weights"
export ALPHAFOLD3_CONTAINER="${ALPHAFOLD3_BASE}/singularity/alphafold3_241202.sif"
