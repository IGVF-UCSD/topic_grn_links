#!/bin/bash
#SBATCH --partition=carter-compute
#SBATCH -o %x.out
#SBATCH -e %x.err
##############################################
# USAGE: sbatch --job-name=grnInference_test --cpus-per-task=16 --mem-per-cpu=8G --time=14-00:00:00 grnInference.sh $tsv_in $tf_list $out_dir $pval $num_bootstraps
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
num_bootstraps=$5

# Example command
CMD="java -jar $ARACNE_PATH -e $tsv_in -o $out_dir --tfs $tf_list --pvalue $pval --threads $SLURM_CPUS_PER_TASK --seed i"
echo -e "Running:\n $CMD"
    
# Bootstrap on samples
for i in $(seq $num_bootstraps)
do
    CMD="java -jar $ARACNE_PATH -e $tsv_in -o $out_dir --tfs $tf_list --pvalue $pval --threads $SLURM_CPUS_PER_TASK --seed $i"
    $CMD
    echo -e "\n"
done

date
