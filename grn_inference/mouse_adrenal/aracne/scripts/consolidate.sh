#!/bin/bash
#SBATCH --partition=carter-compute
#SBATCH -o %x.out
#SBATCH -e %x.err
##############################################
# USAGE: sbatch --job-name=consolidate_test --cpus-per-task=32 --mem-per-cpu=4G --time=14-00:00:00 consolidate.sh $out_dir
# Date 02/17/2022
##############################################

date
echo -e "Job ID: $SLURM_JOB_ID\n"

# Configuring env
ARACNE_PATH=/cellar/users/aklie/opt/ARACNe-AP/dist/aracne.jar

# Configure input arguments
out_dir=$1

# Consolidate bootstraps
CMD="java -jar $ARACNE_PATH -o $out_dir --consolidate"
echo -e "Running:\n $CMD"
$CMD

date
