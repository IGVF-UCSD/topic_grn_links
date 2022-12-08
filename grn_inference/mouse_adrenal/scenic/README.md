# SCENIC protocol -- https://scenic.aertslab.org/

## Conda environment

To reproduce my conda environment run:

```bash
# Create the base Python environment
conda create -n scverse-py38 python=3.8 -y
conda activate scverse-py38

# CORE -- also installs anndata

# Conda installs
conda install scvi-tools scikit-misc cudatoolkit=10.2 pytorch scanpy python-igraph leidenalg louvain -c conda-forge

# Pip installs, don't use a screen!
pip install mudata muon squidpy pysam mudatasets[muon] pyscenic

# R packages
conda install -c r rpy2 # See note below

# Kernalize
python -m ipykernel install --user --name scverse-py38 --display-name "Python 3.8 scverse"

# Seurat interoperatbility
conda install -c conda-forge r-seurat
conda install -c bioconda anndata2ri r-signac bioconductor-singlecellexperiment
```

### Useful Q&As
https://github.com/aertslab/SCENICprotocol/issues/52
