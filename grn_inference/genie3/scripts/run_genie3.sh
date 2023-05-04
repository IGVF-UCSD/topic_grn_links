script=/cellar/users/aklie/projects/igvf/opt/genie3/scripts/make_regulons.py
exp_datasets=/cellar/users/aklie/projects/igvf/topic_grn_links/data/mouse_adrenal/preprocess/snrna/subset/filtered.h5ad
tf_file=/cellar/users/aklie/data/scenic/tf_lists/allTFs_mm.txt
out_path=/cellar/users/aklie/projects/igvf/topic_grn_links/grn_inference/genie3/results/mouse_adrenal/subset
method="RF"
n_cpu=4
log_file=${out_path}/log.txt
cmd="python $script \
    --h5ad_file $exp_file \
    --tf_file $tf_file \
    --out_path $out_path \
    --method $method \
    --n_cpu $n_cpu \
    --n_genes 100 \
    --log_file $log_file"
echo $cmd