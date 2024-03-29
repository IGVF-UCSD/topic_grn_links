script=/cellar/users/aklie/opt/igvf-ucsd/aracne/scripts/ARACNe_array.sh
log_dir=/cellar/users/aklie/projects/igvf/topic_grn_links/grn_inference/aracne/bin/igvf_b01_LeftCortex/out
error_dir=/cellar/users/aklie/projects/igvf/topic_grn_links/grn_inference/aracne/bin/igvf_b01_LeftCortex/err
tsv_dir=/cellar/users/aklie/data/igvf/topic_grn_links/tables/igvf_b01_LeftCortex/0.05/Microglia
pval="1E-8"
num_bootstraps="10"
out_dir=/cellar/users/aklie/projects/igvf/topic_grn_links/grn_inference/aracne/results/igvf_b01_LeftCortex/0.05

# tfs
tf_list=/cellar/users/aklie/data/aracne/tf_cotf_signalling_list/mouse/tf_mus_symbol.txt
tf_type="tfs"
cmd="sbatch \
    --job-name=ARACNe_array_igvf_b01_LeftCortex_filtered_0.05_tfs \
    --output=$log_dir/%x.%A_%a.out \
    --error=$error_dir/%x.%A_%a.err \
    --array=1-3%3 \
    --cpus-per-task=4 \
    --mem=8G \
    --time=14-00:00:00 \
    $script \
    $tsv_dir $tf_list $tf_type $out_dir $pval $num_bootstraps"
echo $cmd
eval $cmd

# cotfs
tf_list=/cellar/users/aklie/data/aracne/tf_cotf_signalling_list/mouse/cotf_mus_symbol.txt
tf_type="cotfs"
cmd="sbatch \
    --job-name=ARACNe_array_igvf_b01_LeftCortex_filtered_0.05_cotfs \
    --output=$log_dir/%x.%A_%a.out \
    --error=$error_dir/%x.%A_%a.err \
    --array=1-3%3 \
    --cpus-per-task=4 \
    --mem=8G \
    --time=14-00:00:00 \
    $script \
    $tsv_dir $tf_list $tf_type $out_dir $pval $num_bootstraps"
echo $cmd
eval $cmd

# surface 
tf_list=/cellar/users/aklie/data/aracne/tf_cotf_signalling_list/mouse/surface_mus_symbol.txt
tf_type="surface"
cmd="sbatch \
    --job-name=ARACNe_array_igvf_b01_LeftCortex_filtered_0.05_surface \
    --output=$log_dir/%x.%A_%a.out \
    --error=$error_dir/%x.%A_%a.err \
    --array=1-3%3 \
    --cpus-per-task=4 \
    --mem=8G \
    --time=14-00:00:00 \
    $script \
    $tsv_dir $tf_list $tf_type $out_dir $pval $num_bootstraps"
echo $cmd
eval $cmd
