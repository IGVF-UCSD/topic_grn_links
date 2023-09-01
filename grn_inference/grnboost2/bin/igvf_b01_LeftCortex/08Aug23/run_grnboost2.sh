script=/cellar/users/aklie/projects/igvf/opt/grnboost2/scripts/run_scenic_grnboost2.sh
tf_list=/cellar/users/aklie/data/scenic/tf_lists/allTFs_mm.txt
out_dir=/cellar/users/aklie/projects/igvf/topic_grn_links/grn_inference/grnboost2/results/igvf_b01_LeftCortex
output_dir=/cellar/users/aklie/projects/igvf/topic_grn_links/grn_inference/grnboost2/scripts/igvf_b01_LeftCortex/out
error_dir=/cellar/users/aklie/projects/igvf/topic_grn_links/grn_inference/grnboost2/scripts/igvf_b01_LeftCortex/err

# Microglia_B6J
loom_in=/cellar/users/aklie/data/igvf/topic_grn_links/loom/igvf_b01_LeftCortex/0.05/Microglia_B6J.loom
out_file=$out_dir/Microglia_B6J_adj.tsv
cmd="sbatch \
    --job-name=run_scenic_grnboost2_igvf_b01_LeftCortex_Microglia_B6J \
    --output=$output_dir/%x.%A.out \
    --error=$error_dir/%x.%A.err \
    --cpus-per-task=8 \
    --mem-per-cpu=8G \
    --time=14-00:00:00 \
    $script \
    $loom_in $tf_list $out_file"
echo -e "Running:\n $cmd"
$cmd

# Microglia_CASTJ
loom_in=/cellar/users/aklie/data/igvf/topic_grn_links/loom/igvf_b01_LeftCortex/0.05/Microglia_CASTJ.loom
out_file=$out_dir/Microglia_CASTJ_adj.tsv
cmd="sbatch \
    --job-name=run_scenic_grnboost2_igvf_b01_LeftCortex_Microglia_CASTJ \
    --output=$output_dir/%x.%A.out \
    --error=$error_dir/%x.%A.err \
    --cpus-per-task=8 \
    --mem-per-cpu=8G \
    --time=14-00:00:00 \
    $script \
    $loom_in $tf_list $out_file"
echo -e "Running:\n $cmd"
$cmd

# All subsets in loom dir
script=/cellar/users/aklie/projects/igvf/opt/grnboost2/scripts/run_scenic_grnboost2_array.sh
loom_dir=/cellar/users/aklie/data/igvf/topic_grn_links/loom/igvf_b01_LeftCortex/0.05
cmd="sbatch \
    --job-name=run_scenic_grnboost2_array_igvf_b01_LeftCortex \
    --output=$output_dir/%x.%A_%a.out \
    --error=$error_dir/%x.%A_%a.err \
    --array=1-14%10 \
    --cpus-per-task=8 \
    --mem-per-cpu=8G \
    --time=14-00:00:00 \
    $script \
    $loom_dir $tf_list $out_dir"
echo -e "Running:\n $cmd"
#$cmd