import dill
import scanpy as sc
import pandas as pd
import os
import warnings
import pandas
import pyranges
import sys
warnings.filterwarnings("ignore")
_stderr = sys.stderr
null = open(os.devnull,'wb')

# Dirs and paths
work_dir = "../mouse_adrenal"
tmp_dir = '/cellar/users/aklie/tmp/'

# Paths to other data
biomart_host = "http://sep2019.archive.ensembl.org/"
tf_list = "/cellar/users/aklie/opt/shared/SCENIC/tf_lists/allTFs_mm.txt"
big_bed = work_dir

# Load the object
print("Loading SCENIC+ object...")
scplus_obj = dill.load(open(os.path.join(work_dir, 'scenicplus/scplus_obj_pre.pkl'), 'rb'))

# Run it!
print("Let's run!")
from scenicplus.wrappers.run_scenicplus import run_scenicplus
try:
    run_scenicplus(
        scplus_obj = scplus_obj,
        variable = ['GEX_celltypes'],
        species = 'mmusculus',
        assembly = 'mm10',
        tf_file = tf_list,
        save_path = os.path.join(work_dir, 'scenicplus'),
        biomart_host = biomart_host,
        upstream = [1000, 150000],
        downstream = [1000, 150000],
        calculate_TF_eGRN_correlation = True,
        calculate_DEGs_DARs = True,
        export_to_loom_file = True,
        export_to_UCSC_file = True,
        path_bedToBigBed = '../mouse_adrenal',
        n_cpu = 4,
        _temp_dir = os.path.join(tmp_dir, 'ray_spill')
    )
except Exception as e:
    #in case of failure, still save the object
    dill.dump(scplus_obj, open(os.path.join(work_dir, 'scenicplus/scplus_obj.pkl'), 'wb'), protocol=-1)
    raise(e)