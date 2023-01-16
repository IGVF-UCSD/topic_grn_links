import os
import sys
import warnings
import scanpy as sc
import pycisTopic
import scanpy as sc
import glob
import pandas as pd
import pyranges as pr
import requests
import pickle
from pycisTopic.pseudobulk_peak_calling import export_pseudobulk

# Set-up
warnings.simplefilter(action='ignore', category=FutureWarning)
_stderr = sys.stderr
null = open(os.devnull,'wb')

# Dirs and paths
work_dir = 'mouse_adrenal'
tmp_dir = '/cellar/users/aklie/tmp/'

# Make a directory for to store the processed scATAC-seq data.
if not os.path.exists(os.path.join(work_dir, 'scATAC')):
    os.makedirs(os.path.join(work_dir, 'scATAC'))

# Load in the paths to your fragment files and turn them into a dictionary
frag_files = glob.glob("/cellar/users/aklie/data/igvf/topic_grn_links/mouse_adrenal/encode/fragments/*/*/*/*/*/*.tsv.gz")
fragments_dict = dict(zip([file.split("/")[-6] for file in frag_files], frag_files))

# Grab the metadata from the single cell anndata 
adata = sc.read_h5ad(os.path.join(work_dir, 'scRNA/adata.h5ad'))
cell_data = adata.obs
del(adata)

# For the mouse ENCODE 4 data, only a subset of the cells were from the 10x multiome kit
cell_data = cell_data[cell_data["technology"] == "10x"]
cell_data['celltype'] = cell_data['celltypes'].astype(str) # set data type of the celltype column to str, otherwise the export_pseudobulk function will complain.

# Read in some extra metadata to match cells to samples
snatac_meta = pd.read_csv("/cellar/users/aklie/data/igvf/topic_grn_links/mouse_adrenal/encode/enc4_mouse_snatac_metadata.tsv", sep="\t")
acc_mp = snatac_meta.set_index("rna_library_accession")["file_accession"]
cell_data["sample_id"] = cell_data["library_accession"].map(acc_mp).values

# Map the RNA barcodes from the anndata to the ATAC barcodes present in the fragment file
rna_bcs = pd.read_csv("/cellar/users/aklie/data/igvf/topic_grn_links/mouse_adrenal/encode/gene_exp_737K-arc-v1.txt", header=None)[0].values # read in the set of external rna barcodes
atac_bcs = pd.read_csv("/cellar/users/aklie/data/igvf/topic_grn_links/mouse_adrenal/encode/atac_737K-arc-v1.txt", header=None)[0].values # Read in the set of external atac barcodes
bcs = pd.DataFrame(data={"rna_bcs": rna_bcs, "atac_bcs": atac_bcs}) # create a dataframe with both
COMPLEMENT_DNA = {"A": "T", "C": "G", "G": "C", "T": "A"} # the fragment files contain reverse complements of the atac bcs, need to get these
bcs["atac_bcs_rc"] = ["".join(COMPLEMENT_DNA.get(base, base) for base in reversed(bc)) for bc in bcs["atac_bcs"]]
bc_map = bcs.set_index("rna_bcs")["atac_bcs_rc"] # create a map for going from rna bcs to atac bcs in fragment files

# Map the rna bcs in the cell metadata to the fragment file atac barcodes
cell_data["rna_bc"] = [row[0] for row in cell_data["cellID"].str.split(".")] # grab the RNA barcodes from the anndata metadata
cell_data["atac_bc"] = cell_data["rna_bc"].map(bc_map) # map the
cell_data["atac_bc_sample"] = cell_data["atac_bc"] + "-" + cell_data["sample_id"]
cell_data["barcode"] = cell_data["atac_bc"]
cell_data = cell_data.set_index("atac_bc")

# Stream chromsizes directly into memory using pandas
target_url='https://hgdownload.cse.ucsc.edu/goldenpath/mm10/bigZips/mm10.chrom.sizes'
chromsizes=pd.read_csv(target_url, sep='\t', header=None)
chromsizes.columns=['Chromosome', 'End']
chromsizes['Start']=[0]*chromsizes.shape[0]
chromsizes=chromsizes.loc[:,['Chromosome', 'Start', 'End']]
chromsizes=pr.PyRanges(chromsizes)

# Run without ray since these are big files. If you have a lot of memory you can probably make n_cpu larger
bw_paths, bed_paths = export_pseudobulk(
    input_data = cell_data,
    variable = 'celltype', # variable by which to generate pseubulk profiles, in this case we want pseudobulks per celltype
    sample_id_col = 'sample_id',
    chromsizes = chromsizes,
    bed_path = os.path.join(work_dir, 'scATAC/consensus_peak_calling/pseudobulk_bed_files/'),  # specify where pseudobulk_bed_files should be stored
    bigwig_path = os.path.join(work_dir, 'scATAC/consensus_peak_calling/pseudobulk_bw_files/'), # specify where pseudobulk_bw_files should be stored
    path_to_fragments = fragments_dict, # location of fragment fiels
    n_cpu = 1, # specify the number of cores to use, we use ray for multi processing
    normalize_bigwig = True,
    remove_duplicates = True,
    _temp_dir = os.path.join(tmp_dir, 'ray_spill'),
    split_pattern = '-'
)

# Export the paths
pickle.dump(
    bed_paths,
    open(os.path.join(work_dir, 'scATAC/consensus_peak_calling/pseudobulk_bed_files/bed_paths.pkl'), 'wb')
)
pickle.dump(
    bw_paths,
    open(os.path.join(work_dir, 'scATAC/consensus_peak_calling/pseudobulk_bw_files/bw_paths.pkl'), 'wb')
)
