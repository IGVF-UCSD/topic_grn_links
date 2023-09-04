#!/bin/bash
#SBATCH --partition=carter-compute
#SBATCH --output=./logs/%x.%A_%a.out
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=16G
#SBATCH --time=01-00:00:00

#####
# USAGE:
# sbatch --job-name=SCENIC_igvf_b01_LeftCortex --array=1-NUM_LINES scenic_runs.sh $CSV_PATH
#####

# Date
date
echo -e "Job ID: $SLURM_JOB_ID\n"

# Configuring env (choose either singularity or conda)
source activate /cellar/users/aklie/opt/miniconda3/envs/scenicplus

# The path to your bash script
BASH_SCRIPT_PATH=/cellar/users/aklie/projects/igvf/topic_grn_links/opt/scenic_pipeline/bin/SCENIC_multirun.sh

# The path to your csv file
CSV_PATH=$1

# Extract the run ID from the csv file and remove the file extension
RUN_ID=$(basename $CSV_PATH .csv)

# Extract the relevant line from the csv
LINE=$(awk "NR==$SLURM_ARRAY_TASK_ID+1" $CSV_PATH)

# Split the line by commas (assuming your csv is comma-separated)
IFS=',' read -ra ADDR <<< "$LINE"
loom_in=${ADDR[0]}
out_dir=${ADDR[1]}
tf_list=${ADDR[2]}
ranking_db=${ADDR[3]}
annotation_db=${ADDR[4]}
num_runs=${ADDR[5]}

# Make the output directory if it doesn't exist, mostly for logging since the script will make the directory anyway
if [ ! -d $out_dir ]
then
    mkdir -p $out_dir
fi

# Log the extracted arguments
echo "---"
echo "Currently printing arguments for run_id: ${RUN_ID}_${SLURM_ARRAY_TASK_ID}"
echo "loom_in: $loom_in"
echo "out_dir: $out_dir"
echo "tf_list: $tf_list"
echo "ranking_db: $ranking_db"
echo "annotation_db: $annotation_db"
echo "num_runs: $num_runs"
cmd="bash $BASH_SCRIPT_PATH $loom_in $out_dir $tf_list $ranking_db $annotation_db $num_runs >> $out_dir/out.txt 2>>$out_dir/err.txt"
echo "Running: $cmd"
echo -e "---\n\n"
echo "Output and error files for the run will be located in $out_dir"
eval $cmd
