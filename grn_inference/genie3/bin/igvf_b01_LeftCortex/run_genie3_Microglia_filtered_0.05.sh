script=/cellar/users/aklie/projects/igvf/opt/genie3/scripts/run_scenic_genie3.sh
tf_list=/cellar/users/aklie/data/scenic/tf_lists/allTFs_mm.txt
out_dir=/cellar/users/aklie/projects/igvf/topic_grn_links/grn_inference/genie3/results/igvf_b01_LeftCortex/0.05/Microglia
output_dir=/cellar/users/aklie/projects/igvf/topic_grn_links/grn_inference/genie3/bin/igvf_b01_LeftCortex/out
error_dir=/cellar/users/aklie/projects/igvf/topic_grn_links/grn_inference/genie3/bin/igvf_b01_LeftCortex/err

# Microglia_B6J
loom_in=/cellar/users/aklie/data/igvf/topic_grn_links/loom/igvf_b01_LeftCortex/0.05/Microglia/B6J_filtered.loom
out_file=$out_dir/B6J_adj.tsv
cmd="sbatch \
--job-name=run_scenic_genie3_igvf_b01_LeftCortex_Microglia_B6J_filtered_0.05 \
--output=$output_dir/%x.%A.out \
--error=$error_dir/%x.%A.err \
--cpus-per-task=8 \
--mem-per-cpu=8G \
--time=14-00:00:00 \
$script \
$loom_in $tf_list $out_file"
echo -e "Running:\n $cmd"
#$cmd

# Microglia_CASTJ
loom_in=/cellar/users/aklie/data/igvf/topic_grn_links/loom/igvf_b01_LeftCortex/0.05/Microglia/CASTJ_filtered.loom
out_file=$out_dir/CASTJ_adj.tsv
cmd="sbatch \
--job-name=run_scenic_genie3_igvf_b01_LeftCortex_Microglia_CASTJ_filtered_0.05 \
--output=$output_dir/%x.%A.out \
--error=$error_dir/%x.%A.err \
--cpus-per-task=8 \
--mem-per-cpu=8G \
--time=14-00:00:00 \
$script \
$loom_in $tf_list $out_file"
echo -e "Running:\n $cmd"
$cmd

# All Microglia
loom_in=/cellar/users/aklie/data/igvf/topic_grn_links/loom/igvf_b01_LeftCortex/0.05/Microglia/filtered.loom
out_file=$out_dir/filtered_adj.tsv
cmd="sbatch \
--job-name=run_scenic_genie3_igvf_b01_LeftCortex_Microglia_filtered_0.05 \
--output=$output_dir/%x.%A.out \
--error=$error_dir/%x.%A.err \
--cpus-per-task=8 \
--mem-per-cpu=8G \
--time=14-00:00:00 \
$script \
$loom_in $tf_list $out_file"
echo -e "Running:\n $cmd"
$cmd