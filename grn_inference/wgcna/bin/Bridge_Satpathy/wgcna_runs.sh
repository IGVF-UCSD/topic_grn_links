#!/bin/bash
#SBATCH --partition=carter-compute
#SBATCH --output=/cellar/users/aklie/projects/igvf/topic_grn_links/grn_inference/wgcna/bin/Bridge_Satpathy/out/%x.%A_%a.out
#SBATCH --error=/cellar/users/aklie/projects/igvf/topic_grn_links/grn_inference/wgcna/bin/Bridge_Satpathy/err/%x.%A_%a.err
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=16G
#SBATCH --time=01-00:00:00

#####
# USAGE:
# sbatch --job-name=WGCNA_Bridge_Satpathy --array=1-NUM_LINES wgcna_runs.sh $CSV_PATH
#####

# Date
date
echo -e "Job ID: $SLURM_JOB_ID\n"

# Configuring env (choose either singularity or conda)
source activate /cellar/users/aklie/opt/miniconda3/envs/scverse-lite-py38

# The path to your bash script
PYTHON_SCRIPT_PATH=/cellar/users/aklie/opt/igvf-ucsd/wgcna_pipeline/pywgcna/pywgcna_grn.py

# The path to your csv file
CSV_PATH=$1

# Extract the run ID from the csv file and remove the file extension
RUN_ID=$(basename $CSV_PATH .csv)

# Extract the relevant line from the csv
LINE=$(awk "NR==$SLURM_ARRAY_TASK_ID+1" $CSV_PATH)

# Split the line by commas (assuming your csv is comma-separated)
IFS=',' read -ra ADDR <<< "$LINE"
h5ad_in=${ADDR[0]}
out_dir=${ADDR[1]}
tf_list=${ADDR[2]}
network_type=${ADDR[3]}
layer=${ADDR[4]}

# Log the extracted arguments
echo "---"
echo "Currently printing arguments for run_id: ${RUN_ID}_${SLURM_ARRAY_TASK_ID}"
echo "h5ad_in: $h5ad_in"
echo "out_dir: $out_dir"
echo "tf_list: $tf_list"
echo "network_type: $network_type"
echo "layer: $layer"
cmd="python $PYTHON_SCRIPT_PATH --h5ad_path $h5ad_in --out_dir $out_dir --tf_list $tf_list --network_type $network_type --layer $layer"
echo "Running: $cmd"
echo -e "---\n\n"

# Run the bash script
echo "WGCNA script commands below"
echo "---------------------------"
eval $cmd
