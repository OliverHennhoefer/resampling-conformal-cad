from dataclasses import dataclass
from pandas import DataFrame
from unquad.enums.method import Method
from pyod.models.base import BaseDetector
from unquad.estimator.split_config.bootstrap_config import BootstrapConfiguration


@dataclass
class Setup:

    model: BaseDetector
    method: Method

    n: int
    inliers: DataFrame
    outliers: DataFrame

    n_test_inlier: int
    n_test_outlier: int

    n_train_cal: int
    n_cal: int

    L: int

    bootstrap: BootstrapConfiguration = None
