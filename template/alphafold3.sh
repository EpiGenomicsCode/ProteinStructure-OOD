#!/bin/bash

JSON_INPUT_FILE="${1}"
USER="${2}" 
WORKINGDIR="${3}"
ACCOUNT="${4}"
STATUS_FILE="${5}"
RUN_ID="${6}"

update_status() {
    echo "${1}" > "${STATUS_FILE}"
}

handle_error() {
    echo "Error occurred: ${1}"
    update_status "failed"
    exit 1
}

trap 'error_code=$?; echo "Debug: Trap caught error ${error_code} at line ${BASH_LINENO[0]}"; if [[ ${error_code} -ne 0 ]]; then handle_error "Error ${error_code} at line ${BASH_LINENO[0]}"; fi' ERR

RUN_DIR="${WORKINGDIR}/run_${RUN_ID}"
INPUT_DIR="${RUN_DIR}/input"
CPU_OUTPUT="${RUN_DIR}/cpu_output"
GPU_OUTPUT="${RUN_DIR}/gpu_output"
STRUCT="${RUN_DIR}/structure"
LOGDIR="${RUN_DIR}/logs/${RUN_ID}"
JSON_DIR="${INPUT_DIR}"

AF3_CONTAINER="/storage/icds/RISE/sw8/alphafold3/singularity/alphafold3_241202.sif"
AF3_WEIGHTS="/storage/group/u1o/default/wkl2/CONTAINER/alphafold3_weights"
AF3_DB="/storage/icds/RISE/sw8/alphafold3/alphafold3/databases"

mkdir -p "${INPUT_DIR}" || handle_error "Failed to create input directory"
mkdir -p "${CPU_OUTPUT}" || handle_error "Failed to create CPU output directory"
mkdir -p "${GPU_OUTPUT}" || handle_error "Failed to create GPU output directory"
mkdir -p "${STRUCT}" || handle_error "Failed to create structure directory"
mkdir -p "${LOGDIR}" || handle_error "Failed to create log directory"

JSON_FILE="${INPUT_DIR}/input.json"

if [ -f "${JSON_INPUT_FILE}" ]; then
    echo "Debug: Received JSON input file"
    cp "${JSON_INPUT_FILE}" "${JSON_FILE}" || handle_error "Failed to copy JSON input file"
else
    handle_error "No valid JSON input file provided"
fi

echo "Debug: JSON input ready at ${JSON_FILE}"

NAME=$(python3 -c "import json; print(json.load(open('${JSON_FILE}'))['name'])") || handle_error "Failed to extract 'name' from JSON"
echo "Debug: Extracted name from JSON input: ${NAME}"

NAME_LOWER=$(echo "${NAME}" | tr '[:upper:]' '[:lower:]')
echo "Debug: Lowercase name: ${NAME_LOWER}"

GENERATED_JSON_FILE="/root/af_output/${NAME_LOWER}/${NAME_LOWER}_data.json"
echo "Debug: Expected generated JSON file: ${GENERATED_JSON_FILE}"

CPU_SLURM_SCRIPT="${CPU_OUTPUT}/cpu_job_${RUN_ID}.slurm"
cat <<EOF > "${CPU_SLURM_SCRIPT}"
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=32
#SBATCH --mem=128GB
#SBATCH --time=6:00:00
#SBATCH --partition=open
#SBATCH --output=${LOGDIR}/cpu_job_${RUN_ID}.log

echo "Debug: Starting AlphaFold 3 CPU job"

singularity exec \\
    --bind ${JSON_DIR}:/root/af_input \\
    --bind ${STRUCT}:/root/af_output \\
    --bind ${AF3_WEIGHTS}:/root/models \\
    --bind ${AF3_DB}:/root/public_databases \\
    ${AF3_CONTAINER} \\
    python3 /app/alphafold/run_alphafold.py \\
    --json_path=/root/af_input/\$(basename "${JSON_FILE}") \\
    --model_dir=/root/models \\
    --db_dir=/root/public_databases \\
    --output_dir=/root/af_output \\
    --run_data_pipeline=true \\
    --run_inference=false \\
    --jackhmmer_n_cpu=32 \\
    --nhmmer_n_cpu=32

EOF

echo "Debug: Created CPU SLURM script"

CPU_JOB_ID=$(sbatch "${CPU_SLURM_SCRIPT}" | awk '{print $4}') || handle_error "Failed to submit CPU job"
echo "Debug: CPU job submitted with ID: ${CPU_JOB_ID}"

GPU_SLURM_SCRIPT="${GPU_OUTPUT}/gpu_job_${RUN_ID}.slurm"
cat <<EOF > "${GPU_SLURM_SCRIPT}"
#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=8
#SBATCH --mem=60GB
#SBATCH --gpus=1
#SBATCH --time=10:00:00
#SBATCH --account=${ACCOUNT}
#SBATCH --partition=sla-prio
#SBATCH --output=${LOGDIR}/gpu_job_${RUN_ID}.log
#SBATCH --dependency=afterok:${CPU_JOB_ID}

echo "Debug: Starting AlphaFold 3 GPU job"
echo "Debug: Custom script path: \${CUSTOM_SCRIPT}"

singularity exec --nv \\
    --bind ${STRUCT}:/root/af_output \\
    --bind ${AF3_WEIGHTS}:/root/models \\
    --bind ${AF3_DB}:/root/public_databases \\
    --bind "\${CUSTOM_SCRIPT}:/app/alphafold/run_alphafold.py" \\
    ${AF3_CONTAINER} \\
    python3 /app/alphafold/run_alphafold.py \\
    --json_path=${GENERATED_JSON_FILE} \\
    --model_dir=/root/models \\
    --db_dir=/root/public_databases \\
    --output_dir=/root/af_output \\
    --run_data_pipeline=false \\
    --run_inference=true

EOF

echo "Debug: Created GPU SLURM script"
echo "Debug: JSON path: ${GENERATED_JSON_FILE}"
echo "Debug: Output dir: ${STRUCT}"
echo "Debug: Model dir: ${AF3_WEIGHTS}"

GPU_JOB_ID=$(sbatch "${GPU_SLURM_SCRIPT}" | awk '{print $4}') || handle_error "Failed to submit GPU job"
echo "Debug: GPU job submitted with ID: ${GPU_JOB_ID}"

monitor_jobs() {
    local cpu_id=${1}
    local gpu_id=${2}

    while true; do
        CPU_STATE=$(squeue -j "${cpu_id}" -h -o %t 2>/dev/null)
        GPU_STATE=$(squeue -j "${gpu_id}" -h -o %t 2>/dev/null)

        echo "Debug: CPU Job State: ${CPU_STATE}, GPU Job State: ${GPU_STATE}"

        if [[ -z "${CPU_STATE}" && -z "${GPU_STATE}" ]]; then
            sleep 10

            cpu_status=$(sacct -j "${cpu_id}" --format=State -n | head -1 | tr -d ' ')
            gpu_status=$(sacct -j "${gpu_id}" --format=State -n | head -1 | tr -d ' ')

            echo "Debug: Final CPU status: ${cpu_status}"
            echo "Debug: Final GPU status: ${gpu_status}"

            if [[ "${cpu_status}" == "COMPLETED" && "${gpu_status}" == "COMPLETED" ]]; then
                OUTPUT_DIR="${STRUCT}/${NAME_LOWER}"
                TOP_MODEL="${OUTPUT_DIR}/${NAME_LOWER}_model.cif"
                RANKING_FILE="${OUTPUT_DIR}/ranking_scores.csv"

                if [[ -d "${OUTPUT_DIR}" && -f "${TOP_MODEL}" && -f "${RANKING_FILE}" ]]; then
                    update_status "completed"
                    exit 0
                fi
            fi

            echo "Debug: Job completion check failed"
            echo "Debug: Checking logs..."
            cat "${LOGDIR}/cpu_job_${RUN_ID}.log" 2>/dev/null
            cat "${LOGDIR}/gpu_job_${RUN_ID}.log" 2>/dev/null
            update_status "failed"
            exit 1
        fi

        sleep 60
    done
}

echo "Debug: Starting job monitoring"
monitor_jobs "${CPU_JOB_ID}" "${GPU_JOB_ID}"
