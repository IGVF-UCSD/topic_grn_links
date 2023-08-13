script=/cellar/users/aklie/projects/igvf/opt/scenic/scripts/SCENIC_singlerun.sh
log_dir=/cellar/users/aklie/projects/igvf/topic_grn_links/grn_inference/scenic/bin/igvf_b01_LeftCortex/out
error_dir=/cellar/users/aklie/projects/igvf/topic_grn_links/grn_inference/scenic/bin/igvf_b01_LeftCortex/err
tf_list=/cellar/users/aklie/data/scenic/tf_lists/allTFs_mm.txt
ranking=/cellar/users/aklie/data/scenic/databases/mm10_10kbp_up_10kbp_down_full_tx_v10_clust.genes_vs_motifs.rankings.feather
annotation=/cellar/users/aklie/data/scenic/annotations/motifs-v10nr_clust-nr.mgi-m0.001-o0.0.tbl
method="grnboost2"
out_dir=/cellar/users/aklie/projects/igvf/topic_grn_links/grn_inference/scenic/results/igvf_b01_LeftCortex/0.05

# Microglia_B6J
loom_in=/cellar/users/aklie/data/igvf/topic_grn_links/loom/igvf_b01_LeftCortex/0.05/Microglia_B6J.loom
out_name=$out_dir/Microglia_B6J
cmd="sbatch \
    --job-name=SCENIC_singlerun_igvf_b01_LeftCortex_Microglia_B6J \
    --output=$log_dir/%x.%A.out \
    --error=$error_dir/%x.%A.err \
    --cpus-per-task=4 \
    --mem=32G \
    --time=14-00:00:00 \
    $script \
    $loom_in $tf_list $ranking $annotation $method $out_name"
echo $cmd
eval $cmd

# Microglia_CASTJ
loom_in=/cellar/users/aklie/data/igvf/topic_grn_links/loom/igvf_b01_LeftCortex/0.05/Microglia_CASTJ.loom
out_name=$out_dir/Microglia_CASTJ
cmd="sbatch \
    --job-name=SCENIC_singlerun_igvf_b01_LeftCortex_Microglia_CASTJ \
    --output=$log_dir/%x.%A.out \
    --error=$error_dir/%x.%A.err \
    --cpus-per-task=4 \
    --mem=32G \
    --time=14-00:00:00 \
    $script \
    $loom_in $tf_list $ranking $annotation $method $out_name"
echo $cmd
eval $cmd