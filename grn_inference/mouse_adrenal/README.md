## Environments

I mainly use two general conda environments for developing these pipelines. The commands to set-up those environments can be found below. Some tools are hefty enough to require their own enviroments (e.g. SCENIC+, dictys).  Documentation for setting up those can be found in their respective directories.

1. `scverse-py38` - A Python based environment for handling, you guessed it, Python tools. To reproduce, run:
```bash
# Create the base Python environment
conda create -n scverse-py38 python=3.8 -y
conda activate scverse-py38

# Conda installs
conda install scvi-tools scikit-misc cudatoolkit=10.2 pytorch scanpy python-igraph leidenalg louvain -c conda-forge
conda install -c bioconda pybiomart scrublet harmonypy macs2

# PyPi installs
pip install mudata muon squidpy pysam mudatasets[muon] pyscenic decoupler PyWGCNA dynamo-release KDEpy inferelator normalisr

# GitHub installs
git clone https://github.com/aristoteleo/Scribe-py.git
cd Scribe-py/
python setup.py install

# R packages
conda install -c r rpy2 # See note below

# Seurat interoperatbility
conda install -c conda-forge r-seurat
conda install -c bioconda anndata2ri r-signac bioconductor-singlecellexperiment

# Kernalize
python -m ipykernel install --user --name scverse-py38 --display-name "Python 3.8 scverse"
```

2. `scverse-R413` - An R based environment for handling R packages. To reproduce, run:

|:exclamation: **Note:** Replace the path to your R library in the commands below. This seems to resolve any R and conda dependecy issues. You may run into dependency issues if you do not provide the path you your environment's R library when installing in R   |
|-----------------------------------------|

```bash
# Create the environment
conda create -n scverse-R413 r-essentials r-base -y
conda activate scverse-R413

# Kernalize
R # Once in R
IRkernel::installspec(name = "scverse-r413", displayname = "R 4.1.3 scverse")

# Core conda installs
conda install -c conda-forge r-reticulate r-biocmanager r-future r-remotes r-hdf5r r-seurat r-ggpubr leidenalg pandas
conda install -c bioconda r-signac r-harmony r-pheatmap r-loom bioconductor-limma
conda install -c r r-devtools

# SeuratData (https://github.com/satijalab/seurat-data)
R
library(devtools)
withr::with_libpaths(new = "/mnt/beegfs/users/aklie/opt/miniconda3/envs/scverse-R413/lib/R/library", install_github('satijalab/seurat-data'))

# SeuratWrappers (https://github.com/satijalab/seurat-wrappers)
conda install -c conda-forge r-r.utils #needed dependency
R
library(remotes)
withr::with_libpaths(new = "/mnt/beegfs/users/aklie/opt/miniconda3/envs/scverse-R413/lib/R/library", install_github("satijalab/seurat-wrappers"))

# SeuratDisk (https://github.com/mojaveazure/seurat-disk)
R
withr::with_libpaths(new = "/mnt/beegfs/users/aklie/opt/miniconda3/envs/scverse-R413/lib/R/library", install_github("mojaveazure/seurat-disk"))

# ArchR
conda install -c conda-forge r-rpresto r-shinythemes r-cairo r-rhandsontable  # ArchR dependencies
conda install -c bioconda bioconductor-rhdf5
R
library(devtools)
withr::with_libpaths(new = "/mnt/beegfs/users/aklie/opt/miniconda3/envs/scverse-R413/lib/R/library", install_github("GreenleafLab/ArchR", ref="master", repos = BiocManager::repositories()))

# hdWGCNA
conda install -c bioconda r-wgcna r-enrichr bioconductor-geneoverlap bioconductor-ensdb.hsapiens.v86 bioconductor-jaspar2020 bioconductor-bsgenome.hsapiens.ucsc.hg38 bioconductor-tfbstools bioconductor-rtracklayer
R
library(devtools)
withr::with_libpaths(new = '/mnt/beegfs/users/aklie/opt/miniconda3/envs/scverse-R413/lib/R/library', install_github('smorabit/hdWGCNA', ref='dev'))

# cisTopic
conda install -c bioconda bioconductor-rcistarget
R
library(devtools)
withr::with_libpaths(new = "/mnt/beegfs/users/aklie/opt/miniconda3/envs/scverse-R413/lib/R/library", install_github("aertslab/cisTopic"))

# PISCES
R
withr::with_libpaths(new = "/mnt/beegfs/users/aklie/opt/miniconda3/envs/scverse-R413/lib/R/library", install_github("califano-lab/PISCES"))
# PISCES

# Cicero
R
BiocManager::install("cicero", lib="/mnt/beegfs/users/aklie/opt/miniconda3/envs/scverse-R413/lib/R/library")
# Cicero

# DIRECT-NET
conda install -c bioconda bioconductor-jaspar2016
R
withr::with_libpaths(new = "/mnt/beegfs/users/aklie/opt/miniconda3/envs/scverse-R413/lib/R/library", install_github("zhanglhbioinfor/DIRECT-NET"))
withr::with_libpaths(new = "/cellar/users/aklie/opt/miniconda3/envs/scverse-R413/lib/R/library", install_github('immunogenomics/presto'))

# chromVAR
conda install -c bioconda bioconductor-chromvar

# FigR
R
withr::with_libpaths(new = "/mnt/beegfs/users/aklie/opt/miniconda3/envs/scverse-R413/lib/R/library", install_github("caleblareau/BuenColors"))
withr::with_libpaths(new = "/mnt/beegfs/users/aklie/opt/miniconda3/envs/scverse-R413/lib/R/library", install_github("buenrostrolab/FigR"))

## MACS2
#conda install -c bioconda macs2
## MACS2

## VIPER
R
BiocManager::install("viper", lib="/mnt/beegfs/users/aklie/opt/miniconda3/envs/scverse-R413/lib/R/library")
```
