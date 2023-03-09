import dill
import scanpy as sc
import pandas as pd
import os
import warnings
import pandas
import pyranges
import sys
_stderr = sys.stderr
null = open(os.devnull,'wb')
warnings.filterwarnings("ignore")

# Dirs and paths
work_dir = "../mouse_adrenal"
tmp_dir = '/cellar/users/aklie/tmp/'

# Load all the data
print("Loading anndata, cistopic object and motif enrichment results...")
adata = sc.read_h5ad(os.path.join(work_dir, 'scRNA/adata.h5ad'))
cistopic_obj = dill.load(open(os.path.join(work_dir, 'scATAC/cistopic_obj_50_iter_model.pkl'), 'rb'))
menr = dill.load(open(os.path.join(work_dir, 'motifs/menr.pkl'), 'rb'))
adata.var_names_make_unique()

# For the mouse ENCODE 4 data, only a subset of the cells were from the 10x multiome kit
print("Do some barcode mapping acrobatics...")
adata = adata[adata.obs["technology"] == "10x"]
adata.obs['celltype'] = adata.obs['celltypes'].astype(str) # set data type of the celltype column to str, otherwise the export_pseudobulk function will complain.
adata.obs["celltype"].value_counts(dropna=False)

# Read in some extra metadata to match cells to samples and toconvert barcodes
snatac_meta = pd.read_csv("/cellar/users/aklie/data/igvf/topic_grn_links/mouse_adrenal/encode/enc4_mouse_snatac_metadata.tsv", sep="\t")
acc_mp = snatac_meta.set_index("rna_library_accession")["file_accession"]
adata.obs["sample_id"] = adata.obs["library_accession"].map(acc_mp).values
adata.obs["sample_id"].value_counts(dropna=False)

# Map the RNA barcodes from the anndata to the ATAC barcodes present in the fragment file
rna_bcs = pd.read_csv("/cellar/users/aklie/data/igvf/topic_grn_links/mouse_adrenal/encode/gene_exp_737K-arc-v1.txt", header=None)[0].values # read in the set of external rna barcodes
atac_bcs = pd.read_csv("/cellar/users/aklie/data/igvf/topic_grn_links/mouse_adrenal/encode/atac_737K-arc-v1.txt", header=None)[0].values # Read in the set of external atac barcodes
bcs = pd.DataFrame(data={"rna_bcs": rna_bcs, "atac_bcs": atac_bcs}) # create a dataframe with both
COMPLEMENT_DNA = {"A": "T", "C": "G", "G": "C", "T": "A"} # the fragment files contain reverse complements of the atac bcs, need to get these
bcs["atac_bcs_rc"] = ["".join(COMPLEMENT_DNA.get(base, base) for base in reversed(bc)) for bc in bcs["atac_bcs"]]
bc_map = bcs.set_index("rna_bcs")["atac_bcs_rc"] # create a map for going from rna bcs to atac bcs in fragment files

# Map the rna bcs in the cell metadata to the fragment file atac barcodes
adata.obs["rna_bc"] = [row[0] for row in adata.obs["cellID"].str.split(".")] # grab the RNA barcodes from the anndata metadata
adata.obs["atac_bc"] = adata.obs["rna_bc"].map(bc_map) # map the
adata.obs["atac_bc_sample"] = adata.obs["atac_bc"] + "-" + adata.obs["sample_id"]
adata.obs["barcode"] = adata.obs["atac_bc"]
adata.obs = adata.obs.set_index("atac_bc_sample")
print(adata.obs_names.str.replace(".", "-").isin(cistopic_obj.cell_names).sum())

# Add some metadata for genes in adata
sc.pp.filter_genes(adata, min_cells=3)
adata.var['mt'] = adata.var_names.str.startswith('mt-')  # annotate the group of mitochondrial genes as 'mt'
sc.pp.calculate_qc_metrics(adata, qc_vars=['mt'], percent_top=None, log1p=False, inplace=True)

#Create the object and save it
from scenicplus.scenicplus_class import create_SCENICPLUS_object
import numpy as np
print("Create the object and save it...")
scplus_obj = create_SCENICPLUS_object(
    GEX_anndata = adata.raw.to_adata(),
    cisTopic_obj = cistopic_obj,
    menr = menr,
)
scplus_obj.X_EXP = np.array(scplus_obj.X_EXP.todense())
if not os.path.exists(os.path.join(work_dir, 'scenicplus')):
    os.makedirs(os.path.join(work_dir, 'scenicplus'))
dill.dump(scplus_obj, open(os.path.join(work_dir, 'scenicplus/scplus_obj_pre.pkl'), 'wb'), protocol=-1)