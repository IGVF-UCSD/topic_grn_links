import os
import sys
import warnings
import pickle
from pycisTopic.cistopic_class import *
warnings.simplefilter(action='ignore', category=FutureWarning)
_stderr = sys.stderr
null = open(os.devnull,'wb')

# Dirs and paths
work_dir = "../mouse_adrenal"
tmp_dir = '/cellar/users/aklie/tmp/'

# Load the object
print("Loading cisTopic object...")
cistopic_obj = pickle.load(open(os.path.join(work_dir, 'scATAC/cistopic_obj.pkl'), 'rb'))

# Run models
print("Running models...")
models=run_cgs_models(
    cistopic_obj,
    n_topics=[2, 5, 10, 20, 30, 40],
    n_cpu=6,
    n_iter=500,
    random_state=555,
    alpha=50,
    alpha_by_topic=True,
    eta=0.1,
    eta_by_topic=False,
    save_path=None,
    _temp_dir = os.path.join(tmp_dir + 'ray_spill')
)

# Make dir
if not os.path.exists(os.path.join(work_dir, 'scATAC/models')):
    os.makedirs(os.path.join(work_dir, 'scATAC/models'))
    
# Dump the models
print("Saving models and pycisTopic object with models...")
pickle.dump(
    models,
    open(os.path.join(work_dir, 'scATAC/models/models_500_iter_LDA.pkl'), 'wb')
)

# Add the models to the object
cistopic_obj.add_LDA_model(model)
pickle.dump(
    cistopic_obj,
    open(os.path.join(work_dir, 'scATAC/cistopic_obj_models.pkl'), 'wb')
)