import pandas as pd
import numpy as np

def read_aracne_out(filename):
    return pd.read_csv(filename, sep='\t')

def read_genie3_out(filename):
    return pd.read_csv(filename, sep='\t')

def read_scenic_out(filename):
    return pd.read_csv(filename, skiprows=3, header=None)

def aracne_out_to_co(
    df,
    copy=False,
):
    """Converts the output of ARACNE to a CellOracle compatible format."""
    if copy:
        df = df.copy()
    df.rename(columns={"Regulator": "source", "Target": "target", "MI": "weight", "pvalue": "p"}, inplace=True)
    df["coef_abs"] = df["weight"].abs()
    return df if copy else None

def genie3_out_to_co(
    df,
    copy=False,
):
    """Converts the output of GENIE3 to a CellOracle compatible format."""
    if copy:
        df = df.copy()
    df.rename(columns={"TF": "source", "importance": "weight"}, inplace=True)
    df["p"] = np.nan
    df["coef_abs"] = df["weight"].abs()
    return df if copy else None

def scenic_out_to_co(
    df
):
    """Co"""
    rows = []
    for i, row in df.iterrows():
        tf = row[0]
        target_string = row[8]
        target_list = target_string.rstrip("]").lstrip("[").split("),")
        for target in target_list:
            target = target.replace("(", "").replace("'", "")
            target_split = target.split(",")
            targ = target_split[0].strip()
            weight = float(target_split[1].strip().strip(")"))
            rows.append([tf, targ, weight])
    return_df = pd.DataFrame(rows, columns=["source", "target", "weight"])
    return_df["p"] = np.nan
    return_df["coef_abs"] = return_df["weight"].abs()
    return return_df

def wgcna_out_to_co(
    df,
    tf_list="/cellar/users/aklie/data/scenic/tf_lists/allTFs_mm.txt",
    copy=False
):
    """Converts the output of WGCNA to a CellOracle compatible format."""
    if copy:
        df = df.copy()
    tfs = pd.read_csv(tf_list, header=None)[0].values
    df = df[df["regulatoryGene"].isin(tfs)]
    df['minGene'] = df[['regulatoryGene', 'targetGene']].min(axis=1)
    df['maxGene'] = df[['regulatoryGene', 'targetGene']].max(axis=1)
    df = df.drop_duplicates(subset=['minGene', 'maxGene'])
    df = df.drop(columns=['minGene', 'maxGene'])
    df.rename(columns={"regulatoryGene": "source", "targetGene": "target"}, inplace=True)
    df["p"] = np.nan
    df["coef_abs"] = df["weight"].abs()
    return df if copy else None