#!/bin/bash
#SBATCH --partition=carter-compute
#SBATCH -o %x.out
#SBATCH -e %x.err
##############################################
# USAGE: sbatch --job-name=ctx_test --cpus-per-task=16 --mem-per-cpu=4G cisTarget.sh $adj_in $ranking $annotation $loom_in $out_file
# Date 02/17/2022
##############################################

date
echo -e "Job ID: $SLURM_JOB_ID\n"

# Configuring env (choose either singularity or conda)
source activate /cellar/users/aklie/opt/miniconda3/envs/single_cell_py

# Configure input arguments
adj_in=$1
ranking=$2
annotation=$3
loom_in=$4
out_file=$5

echo -e "Loading GRN from: $adj_in"
echo -e "Using regulatory feature database: $ranking"
echo -e "Using regulatory feature to TF annotation from: $annotation"
echo -e "Using expression in: $loom_in"
echo -e "Outputting regulons to: $out_file"

# Run the pruning and enrichment algorithm from the CLI
CMD="pyscenic ctx $adj_in \
$ranking \
--annotations_fname $annotation \
--expression_mtx_fname $loom_in \
--output $out_file \
--mask_dropouts \
--num_workers $SLURM_CPUS_PER_TASK"
echo -e "Running:\n $CMD"
$CMD

date
