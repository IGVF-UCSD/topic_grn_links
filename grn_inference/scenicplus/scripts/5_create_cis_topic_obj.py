import os
import sys
import warnings
import pickle
import scanpy as sc
from pycisTopic.cistopic_class import create_cistopic_object_from_fragments, merge

# Set-up
warnings.simplefilter(action='ignore', category=FutureWarning)
_stderr = sys.stderr
null = open(os.devnull,'wb')

# Dirs and paths
work_dir = 'mouse_adrenal'

# Get the cell metadata again
adata = sc.read_h5ad(os.path.join(work_dir, 'scRNA/adata.h5ad'))
scRNA_bc = adata.obs_names
cell_data = adata.obs
del(adata)

# Load in the paths to your fragment files and turn them into a dictionary
frag_files = glob.glob("/cellar/users/aklie/data/igvf/topic_grn_links/mouse_adrenal/encode/fragments/*/*/*/*/*/*.tsv.gz")
fragments_dict = dict(zip([file.split("/")[-6] for file in frag_files], frag_files))

# Load the path to regions, same for all samples
path_to_regions = dict.fromkeys(fragments_dict.keys(), os.path.join(work_dir, 'scATAC/consensus_peak_calling/consensus_regions.bed'))

# Other data
path_to_blacklist= '../../pycisTopic/blacklist/hg38-blacklist.v2.bed'
metadata_bc = pickle.load(open(os.path.join(work_dir, 'scATAC/quality_control/metadata_bc.pkl'), 'rb'))
bc_passing_filters = pickle.load(open(os.path.join(work_dir, 'scATAC/quality_control/bc_passing_filters.pkl'), 'rb'))

# Grab the barcodes from the RNA to intersect with when creating cistopic objects
quality_rna_bcs = cell_data["barcode"].values

# Create cistopic objects one at a time from fragments
cistopic_objs = []
for sample in fragments_dict:
    print("Sample", sample)
    cistopic_obj = create_cistopic_object_from_fragments(
        path_to_fragments=fragments_dict[sample],
        path_to_regions=path_to_regions[sample],
        path_to_blacklist=path_to_blacklist,
        metrics=metadata_bc[sample],
        valid_bc=list(set(bc_passing_filters[sample]) & set(quality_rna_bcs)),
        n_cpu=1,
        project=sample,
        split_pattern='-'
    )
    cistopic_objs.append(cistopic_obj)
    
# Merge
cistopic_obj = merge(cistopic_objs, project="mouse_adrenal")

# Save the cistopic object
pickle.dump(
    cistopic_obj,
    open(os.path.join(work_dir, 'scATAC/cistopic_obj.pkl'), 'wb')
)

# Add cell medata from RNA
cistopic_obj.add_cell_data(cell_data.set_index("atac_bc_sample"), split_pattern="-")

# Save the cistopic object
pickle.dump(
    cistopic_obj,
    open(os.path.join(work_dir, 'scATAC/cistopic_obj.pkl'), 'wb')
)
