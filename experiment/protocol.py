from statistics import mean
from pandas import concat
from sklearn.model_selection import train_test_split
from unquad.evaluation.metrics import false_discovery_rate, statistical_power
from unquad.enums.adjustment import Adjustment
from unquad.estimator.conformal import ConformalEstimator

from experiment.setup import Setup


class Protocol:
    def __init__(self, setup: Setup, debug: bool = False):

        self.setup = setup
        self.debug = debug

    def start(self, random_state: int):

        train, test = train_test_split(
            self.setup.inliers,
            train_size=self.setup.n_train_cal,
            random_state=random_state,
        )

        if self.debug:
            print(f"{random_state} (train size: {len(train)} | test size: {len(test)}")

        estimator = ConformalEstimator(
            detector=self.setup.model,
            method=self.setup.method,
            adjustment=Adjustment.BENJAMINI_HOCHBERG,
            alpha=0.2,
            split=self.setup.n_cal,
            silent=True,
            random_state=random_state,
            bootstrap_config=self.setup.bootstrap if self.setup is not None else None
        )

        train.drop(["Class"], axis=1, inplace=True)

        estimator.fit(train)

        if self.debug:
            try:
                print(estimator.detector.get_params()["random_state"])
            except:
                pass

        fdr_list = []
        power_list = []
        for l in range(self.setup.L):

            test_set = concat(
                [
                    test.sample(n=self.setup.n_test_inlier, random_state=l),
                    self.setup.outliers.sample(
                        n=self.setup.n_test_outlier, random_state=l
                    ),
                ],
                ignore_index=True,
            )

            x_test = test_set.drop(["Class"], axis=1)
            y_test = test_set["Class"]

            pred = estimator.predict(x_test)
            fdr = false_discovery_rate(y=y_test, y_hat=pred)
            fdr_list.append(fdr)
            power = statistical_power(y=y_test, y_hat=pred)
            power_list.append(power)

        return mean(fdr_list), mean(power_list)
