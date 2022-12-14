# SCENIC protocol -- https://scenic.aertslab.org/

## TODO
1. single format script or notebook to generate all the files necessary for all the tools? is that too mcuh
2. in preprocess.ipynb, get the data ready for SCENIC specifically
3. in run.ipynb, illustrate how to set up script running
3. in eval.ipynb, evaluate those results for a set of criteria

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

## Workflow

### Download data from Synapse and Google Drive (coming soon)

### Run the steps in the `../format.ipynb` notebook to create inputs to preprocess

### Run the steps in the `preprocess.ipynb` notebook to create filtered loom files for SCENIC run

### Run the steps in the `run.ipynb` notebook to run different configurations of SCENIC pipleine

### Run the steps in the `eval.ipynb` notebook to run different analyses on the SCENIC output

## Useful Q&As
https://github.com/aertslab/SCENICprotocol/issues/52
