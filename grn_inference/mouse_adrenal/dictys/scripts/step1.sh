#!/bin/bash
#SBATCH --partition=carter-compute
#SBATCH -o %x.out
#SBATCH -e %x.err
##############################################
# USAGE: sbatch --job-name=grn_test --cpus-per-task=32 --mem-per-cpu=4G --time=02-00:00:00 $loom_in $tf_list $out_file $method
# Date 02/17/2022
##############################################

date
echo -e "Job ID: $SLURM_JOB_ID\n"

# Configuring env (choose either singularity or conda)
source activate /cellar/users/aklie/opt/miniconda3/envs/scverse-py38

# Configure input arguments
loom_in=$1
tf_list=$2
out_file=$3
method=$4

echo -e "Loading loom file: $loom_in"
echo -e "Using tfs in: $tf_list"
echo -e "Outputting to: $out_file"
echo -e "Running using the $method algorithm"

# Run network inference from the CLI
CMD="pyscenic grn $loom_in $tf_list -o $out_file -m $method --num_workers $SLURM_CPUS_PER_TASK"
echo -e "Running:\n $CMD"
$CMD

date
