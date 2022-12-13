#!/bin/bash
#SBATCH --partition=carter-compute
#SBATCH -o %x.out
#SBATCH -e %x.err
##############################################
# USAGE: sbatch --job-name=grn_test --cpus-per-task=32 --mem-per-cpu=4G --time=02-00:00:00 $loom_in $tf_list $out_file $method
# USAGE:  --export=IN=$DATA_DIR,OUT=$OUT_DIR,EXPR_MAT=$E_MAT,TF_LIST=$TFS,P_VAL=$P,NUM_BOOTSTRAPS=NUM aracne.sbatch
# Date 02/17/2022
##############################################
# Configuring env
ARACNE_PATH=/cellar/users/aklie/opt/ARACNe-AP/dist/aracne.jar

# Useful debugging outputs
echo -e "Outputting files to $OUT"
echo -e "Expression data should be in $IN/$EXPR_MAT"
echo -e "TFs should be in $TF_LIST"
echo -e "Bootstrapping over $NUM_BOOTSTRAPS runs"
echo -e "Consolidating with Bonferonni p-value = $P_VAL"

# Set-up timer
start=$SECONDS
cd $IN

# Calculate threshold
java -jar $ARACNE_PATH -e $EXPR_MAT -o $OUT --tfs $TF_LIST --pvalue $P_VAL --seed -1 --threads $SLURM_CPUS_PER_TASK --calculateThreshold
    
# Bootstrap on samples
for i in $(seq $NUM_BOOTSTRAPS)
do
java -jar $ARACNE_PATH -e $EXPR_MAT -o $OUT --tfs $TF_LIST --pvalue $P_VAL --threads $SLURM_CPUS_PER_TASK --seed $i
done
   
# Consolidate bootstraps
java -jar $ARACNE_PATH -o $OUT --consolidate

# Ouptut time of command
duration=$(( SECONDS - start ))
echo -e "\nTime elapsed for this job of array in seconds: $duration"