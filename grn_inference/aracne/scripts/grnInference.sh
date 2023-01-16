#!/bin/bash
#SBATCH --partition=carter-compute
#SBATCH -o %x.out
#SBATCH -e %x.err
##############################################
# USAGE: sbatch --job-name=grnInference_test --cpus-per-task=16 --mem-per-cpu=8G --time=14-00:00:00 grnInference.sh $tsv_in $tf_list $out_dir $pval
# Date 02/17/2022
##############################################

date
echo -e "Job ID: $SLURM_JOB_ID\n"

# Configuring env
ARACNE_PATH=/cellar/users/aklie/opt/ARACNe-AP/dist/aracne.jar

# Configure input arguments
tsv_in=$1
tf_list=$2
out_dir=$3
pval=$4

# Single bootstrap
CMD="java -jar $ARACNE_PATH -e $tsv_in -o $out_dir --tfs $tf_list --pvalue $pval  --seed 1 --threads $SLURM_CPUS_PER_TASK"
echo -e "Running:\n $CMD"
$CMD

date
