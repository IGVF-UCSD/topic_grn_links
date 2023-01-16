import os
import sys
import warnings
import pickle
from pycisTopic.pseudobulk_peak_calling import peak_calling
from pycisTopic.iterative_peak_calling import consensus_peaks

# Set-up
warnings.simplefilter(action='ignore', category=FutureWarning)
_stderr = sys.stderr
null = open(os.devnull,'wb')

# Dirs and paths
work_dir = 'mouse_adrenal'
bed_paths = pickle.load(open(os.path.join(work_dir, 'scATAC/consensus_peak_calling/pseudobulk_bed_files/bed_paths.pkl'), 'rb'))
bw_paths =  pickle.load(open(os.path.join(work_dir, 'scATAC/consensus_peak_calling/pseudobulk_bed_files/bw_paths.pkl'), 'rb'))
tmp_dir = '/cellar/users/aklie/tmp/'

# Run peak calling
macs_path = '/cellar/users/aklie/opt/miniconda3/envs/scenicplus/bin/macs2'
narrow_peaks_dict = peak_calling(
    macs_path,
    bed_paths,
    os.path.join(work_dir, 'scATAC/consensus_peak_calling/MACS/'),
    genome_size='hs',
    n_cpu=12,
    input_format='BEDPE',
    shift=73,
    ext_size=146,
    keep_dup = 'all',
    q_value = 0.05,
    _temp_dir = os.path.join(tmp_dir, 'ray_spill')
)

# Dump the return object to a pickle
pickle.dump(
    narrow_peaks_dict,
    open(os.path.join(work_dir, 'scATAC/consensus_peak_calling/MACS/narrow_peaks_dict.pkl'), 'wb')
)

# Get consensus peaks
peak_half_width = 250
path_to_blacklist= os.path.join(work_dir, 'hg38-blacklist.v2.bed')
consensus_peaks=get_consensus_peaks(
    narrow_peaks_dict, 
    peak_half_width, 
    chromsizes=chromsizes, 
    path_to_blacklist=path_to_blacklist
)

# Save to bed file
consensus_peaks.to_bed(
    path = os.path.join(work_dir, 'scATAC/consensus_peak_calling/consensus_regions.bed'),
    keep=True,
    compression='infer',
    chain=False
)