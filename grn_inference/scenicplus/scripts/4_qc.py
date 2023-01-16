import os
import sys
import warnings
import pickle
import pybiomart as pbm
from pycisTopic.qc import compute_qc_stats, plot_barcode_metrics

# Set-up
warnings.simplefilter(action='ignore', category=FutureWarning)
_stderr = sys.stderr
null = open(os.devnull,'wb')

# Dirs and paths
work_dir = 'mouse_adrenal'

# Create a quality control dir
if not os.path.exists(os.path.join(work_dir, 'scATAC/quality_control')):
    os.makedirs(os.path.join(work_dir, 'scATAC/quality_control'))
    
# Get TSS annotations for mouse
dataset = pbm.Dataset(name='mmusculus_gene_ensembl',  host='http://www.ensembl.org')
annot = dataset.query(attributes=['chromosome_name', 'transcription_start_site', 'strand', 'external_gene_name', 'transcript_biotype'])
annot['Chromosome/scaffold name'] = annot['Chromosome/scaffold name'].to_numpy(dtype = str)
filter = annot['Chromosome/scaffold name'].str.contains('CHR|GL|JH|MT')
annot = annot[~filter]
annot['Chromosome/scaffold name'] = annot['Chromosome/scaffold name'].str.replace(r'(\b\S)', r'chr\1')
annot.columns=['Chromosome', 'Start', 'Strand', 'Gene', 'Transcript_type']
annot = annot[annot.Transcript_type == 'protein_coding']

# Load in the paths to your fragment files and turn them into a dictionary
frag_files = glob.glob("/cellar/users/aklie/data/igvf/topic_grn_links/mouse_adrenal/encode/fragments/*/*/*/*/*/*.tsv.gz")
fragments_dict = dict(zip([file.split("/")[-6] for file in frag_files], frag_files))

# Load the path to regions, same for all samples
path_to_regions = dict.fromkeys(fragments_dict.keys(), os.path.join(work_dir, 'scATAC/consensus_peak_calling/consensus_regions.bed'))

# Get per barcode qc
metadata_bc, profile_data_dict = compute_qc_stats(
    fragments_dict = fragments_dict,
    tss_annotation = annot,
    stats = ['barcode_rank_plot', 'duplicate_rate', 'insert_size_distribution', 'profile_tss', 'frip'],
    label_list = None,
    path_to_regions = path_to_regions,
    n_cpu = 1,
    valid_bc = None,
    n_frag = 100,
    n_bc = None,
    tss_flank_window = 1000,
    tss_window = 50,
    tss_minimum_signal_window = 100,
    tss_rolling_window = 10,
    remove_duplicates = True,
    _temp_dir = os.path.join(tmp_dir + 'ray_spill')
)

# Dump the metadata
pickle.dump(
    metadata_bc,
    open(os.path.join(work_dir, 'scATAC/quality_control/metadata_bc.pkl'), 'wb')
)
pickle.dump(
    profile_data_dict,
    open(os.path.join(work_dir, 'scATAC/quality_control/profile_data_dict.pkl'), 'wb')
)

# Set some filters (min, max)
QC_filters = {
    'Log_unique_nr_frag': [2 , None],
    'FRIP':               [0.3, None],
    'TSS_enrichment':     [1   , None],
    'Dupl_rate':          [None, None]

}

# Collect cell barcodes that pass filters from each sample
bc_passing_filters = {}
for sample in fragments_dict:
    print("Sample", sample)
    FRIP_NR_FRAG_filter = plot_barcode_metrics(
        metadata_bc[sample],
        var_x='Log_unique_nr_frag',
        var_y='FRIP',
        min_x=QC_filters['Log_unique_nr_frag'][0],
        max_x=QC_filters['Log_unique_nr_frag'][1],
        min_y=QC_filters['FRIP'][0],
        max_y=QC_filters['FRIP'][1],
        return_cells=True,
        return_fig=False,
        plot=False
    )
    TSS_NR_FRAG_filter = plot_barcode_metrics(
        metadata_bc[sample],
        var_x='Log_unique_nr_frag',
        var_y='TSS_enrichment',
        min_x=QC_filters['Log_unique_nr_frag'][0],
        max_x=QC_filters['Log_unique_nr_frag'][1],
        min_y=QC_filters['TSS_enrichment'][0],
        max_y=QC_filters['TSS_enrichment'][1],
        return_cells=True,
        return_fig=False,
        plot=False
    )
    bc_passing_filters[sample] = list((set(FRIP_NR_FRAG_filter) & set(TSS_NR_FRAG_filter)))
    
# Dump the barcodes that pass filters
pickle.dump(
    bc_passing_filters,
    open(os.path.join(work_dir, 'scATAC/quality_control/bc_passing_filters.pkl'), 'wb')
)

# Print out number of cells that pass
for sample in bc_passing_filters:
    print(f"{len(bc_passing_filters[sample])} barcodes passed QC stats for {sample}")