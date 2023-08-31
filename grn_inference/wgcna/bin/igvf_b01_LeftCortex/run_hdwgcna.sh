%%bash
rds_obj="/cellar/users/aklie/data/igvf/topic_grn_links/mouse_adrenal/auxiliary_data/snrna/adrenal_Parse_10x_integrated.rds"
name="mouse_adrenal"
out_dir="/cellar/users/aklie/projects/igvf/topic_grn_links/grn_inference/hdwgcna/results/mouse_adrenal/"
cd scripts
sbatch --job-name=prepForNetworkConstruction_mouse_adrenal --cpus-per-task=16 --mem=128G prepForNetworkConstruction.sh $rds_obj $name $out_dir