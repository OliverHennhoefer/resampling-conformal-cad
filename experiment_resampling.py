from pathlib import Path
import random
from sys import float_info

import numpy
import warnings
import functools
import multiprocessing

import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
from pyod.models.gmm import GMM
from pyod.models.pca import PCA
from tqdm import tqdm
from fastdist import fastdist

from pyod.models.iforest import IForest
from pyod.models.lof import LOF
from pyod.models.abod import ABOD
from pyod.models.ocsvm import OCSVM

from data.dataset import Dataset
from data.data_loader import DataLoader

from unquad.enums.method import Method
from unquad.enums.adjustment import Adjustment
from unquad.estimator.conformal import ConformalEstimator
from unquad.estimator.split_config.bootstrap_config import BootstrapConfiguration

from experiment.experiment import Experiment
from experiment.setup import Setup

warnings.filterwarnings(
    "ignore",
    message="Loky-backed parallel loops cannot be called in a multiprocessing, setting n_jobs=1",
    category=UserWarning,
)

if __name__ == "__main__":

    FDR_FILE_PATH = Path("resources/output/fdr.csv")
    POWER_FILE_PATH = Path("resources/output/power.csv")

    datasets = [
        #Dataset.WINE,
        #Dataset.WBC,
        #Dataset.IONOSPHERE,
        #Dataset.BREASTW,
        #Dataset.MUSK,
        #Dataset.PIMA,
        #Dataset.ANNTHYROID,
        #Dataset.MAMMOGRAPHY,
        #Dataset.SHUTTLE,
        Dataset.FRAUD
    ]

    methods = [
        Method.SPLIT_CONFORMAL,
        #Method.JACKKNIFE,
        #Method.JACKKNIFE_PLUS,
        Method.CV,
        Method.CV_PLUS,
    ]

    models = [
        IForest(behaviour="new", contamination=float_info.min),
        #LOF(contamination=float_info.min),
        PCA(n_components=3, contamination=float_info.min),
    ]

    L, J = 100, 100
    fdr_list, power_list = [], []

    for dataset in datasets:

        dl = DataLoader(dataset=dataset)
        df = dl.df

        for method in methods:

            if method in [Method.JACKKNIFE, Method.JACKKNIFE_PLUS] and dl.num_rows > 1_000:
                print(f"Skipping 'Jackknife' for {dataset.value} due to row count.")
                continue

            inliers = df.loc[df.Class == 0]
            outliers = df.loc[df.Class == 1]

            n_inlier = len(inliers)
            n_train_cal = n_inlier // 2
            n_cal = min(2000, n_train_cal // 2)
            n_test = min(1000, n_train_cal // 3)
            n_test_outlier = n_test // 10
            n_test_inlier = n_test - n_test_outlier

            for model in models:

                print(f"{dataset.value} | {method.value} | {model.__class__.__name__}")

                setup = Setup(
                    model=model,
                    method=method,
                    n=dl.num_rows,
                    inliers=inliers,
                    outliers=outliers,
                    n_test_inlier=n_test_inlier,
                    n_test_outlier=n_test_outlier,
                    n_train_cal=n_train_cal,
                    n_cal=10 if method in [Method.CV, Method.CV_PLUS] else n_cal,
                    L=L,
                )

                j = range(J)
                experiment = Experiment(setup=setup, debug=False)
                func = functools.partial(experiment.start)
                with multiprocessing.Pool(10) as pool:
                    result = list(tqdm(pool.imap_unordered(func, j), total=J))

                fdr = [tuple[0] for tuple in result]
                power = [tuple[1] for tuple in result]

                # False Discovery Rate
                fdr_df = {
                    "dataset": [dataset.value],
                    "method": [method.value],
                    "model": [model.__class__.__name__],
                    "mean": [np.round(np.mean(fdr), 3)],
                    "q90": [np.round(np.quantile(fdr, 0.9), 3)],
                    "std": [np.round(np.std(fdr), 3)],
                    "raw": [fdr]
                }
                fdr_df = pd.DataFrame(data=fdr_df)

                if FDR_FILE_PATH.is_file():
                    existing_df = pd.read_csv(FDR_FILE_PATH)
                    fdr_df = pd.concat([existing_df, fdr_df], axis=0)
                fdr_df.to_csv(FDR_FILE_PATH, index=False)

                # Statistical Power
                power_df = {
                    "dataset": [dataset.value],
                    "method": [method.value],
                    "model": [model.__class__.__name__],
                    "mean": [np.round(np.mean(power), 3)],
                    "q90": [np.round(np.quantile(power, 0.9), 3)],
                    "std": [np.round(np.std(power), 3)],
                    "raw": [power]
                }
                power_df = pd.DataFrame(data=power_df)

                if POWER_FILE_PATH.is_file():
                    existing_df = pd.read_csv(POWER_FILE_PATH)
                    power_df = pd.concat([existing_df, power_df], axis=0)
                power_df.to_csv(POWER_FILE_PATH, index=False)
