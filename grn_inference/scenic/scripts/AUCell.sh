#!/bin/bash
#SBATCH --partition=carter-compute
#SBATCH -o %x.out
#SBATCH -e %x.err
##############################################
# USAGE: sbatch --job-name=aucell_test --cpus-per-task=16 --mem-per-cpu=4G AUCell.sh $loom_in $regulon_in $out_file
# Date 02/17/2022
##############################################

date
echo -e "Job ID: $SLURM_JOB_ID\n"

# Configuring env (choose either singularity or conda)
source activate /cellar/users/aklie/opt/miniconda3/envs/scverse-py38

# Configure input arguments
loom_in=$1
regulon_in=$2
out_file=$3

echo -e "Using expression in: $loom_in"
echo -e "Loading regulons from: $regulon_in"
echo -e "Outputting AUCell activities to: $out_file"

# Run the cell activity enrichment algorithm from the command line
CMD="pyscenic aucell \
$loom_in \
$regulon_in \
--output $out_file \
--num_workers $SLURM_CPUS_PER_TASK"
echo -e "Running:\n $CMD"
$CMD

date
