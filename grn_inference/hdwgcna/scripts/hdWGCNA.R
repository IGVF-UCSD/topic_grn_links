# Conversion libraries and Seurat
library(SeuratDisk)
library(SeuratData)
library(Seurat)
library(Signac)

# plotting and data science packages
library(tidyverse)
library(cowplot)
library(patchwork)

# co-expression network analysis packages:
library(WGCNA)
library(hdWGCNA)

# using the cowplot theme for ggplot
theme_set(theme_cowplot())

# set random seed for reproducibility
set.seed(12345)

# Parameters
ASSAY <- "RNA"  # assay to use
NN <- 75  # number of nearest neighbors for meta cell construction
TARGET_CELLS = 1000000  # max cells to include for one group
GROUPS <- c("Gene") # grouping for metacells

# Get arguments from command line
args = commandArgs(trailingOnly=TRUE)
RDS <- args[1] # "../../../data/mouse_adrenal/preprocessed/snrna/adrenal_Parse_10x_integrated_RNA_subset.rds"
NAME <- args[2]  # "adrenal_Parse_10x_integrated_RNA_subset"
OUT <- args[3] # "/cellar/users/aklie/projects/igvf/topic_grn_links/grn_inference/mouse_adrenal/hdwgcna/result/pipeline_subset"

# Read in the R object
print(paste0("Loading ", RDS, " ..."))
seurat_obj <- readRDS(RDS)
DefaultAssay(seurat_obj) <- "RNA"

# Set-up a Seurat object for WGCNA
print(paste0("Setting up for WGCNA"))
seurat_obj <- SetupForWGCNA(
    seurat_obj,
    gene_select = "fraction", # the gene selection approach
    fraction = 0.05, # fraction of cells that a gene needs to be expressed in order to be included
    wgcna_name = NAME # the name of the hdWGCNA experiment
)

# construct metacells n each group
print(paste0("Creating metacells with ", NN, " ..."))
Idents(seurat_obj) <- "celltypes"
seurat_obj <- MetacellsByGroups(
  seurat_obj=seurat_obj,
  group.by=GROUPS, # specify the columns in adata@meta.data to group by
  ident.group = "orig.ident",
  k=NN, # nearest-neighbors parameter
  max_shared=10, # maximum number of shared cells between two metacells
  ident.group='celltypes', # set the Idents of the metacell seurat object
  assay=ASSAY,
  slot="counts",
  target_metacells=TARGET_CELLS,
)

# transpose the matrix
print(paste0("Setting up expression data..."))
seurat_obj <- SetDatExpr(
    seurat_obj, 
    assay="RNA", 
    use_metacells=TRUE, 
    wgcna_name=NAME, 
    slot="data"
)

# Test different soft powers
print(paste0("Testing soft powers..."))
seurat_obj <- TestSoftPowers(
  seurat_obj,
  use_metacells=TRUE,  # this is the default, I'm just being explicit
  setDatExpr=FALSE  # set this to FALSE since we did this above
)

# get the power table, can also access with head(get(NAME, seurat_obj@misc)$wgcna_powerTable)
power_table <- GetPowerTable(seurat_obj)
power <- power_table$Power[which(power_table$SFT.R.sq > 0.80)[1]]

# construct co-expression network:
print(paste0("Constructing networks..."))
seurat_obj <- ConstructNetwork(
  seurat_obj, 
  soft_power=power,
  use_metacells=TRUE,
  setDatExpr=FALSE,
  tom_out_dir=OUT,
  tom_name=NAME # name of the topoligical overlap matrix written to disk
)

# compute all MEs in the full single-cell dataset
print(paste0("Calculating MEs..."))
seurat_obj <- ModuleEigengenes(seurat_obj, assay=ASSAY, verbose=FALSE)

# compute eigengene-based connectivity (kME):
print(paste0("Calculating kME..."))
seurat_obj <- ModuleConnectivity(
    seurat_obj,
    assay=ASSAY,
    slot="data",
    harmonized=FALSE
)

# Save the fully processed Seurat object to be used in all the other notebooks
print(paste0("Saving to ", file.path(OUT, paste0(NAME, "_hdWGCNA.rds"))))
saveRDS(seurat_obj, file=file.path(OUT, paste0(NAME, "_hdWGCNA.rds")))
