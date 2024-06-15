from pandas import DataFrame, read_parquet

from data.dataset import Dataset
from utils.optimization import reduce_mem_usage


class DataLoader:
    def __init__(self, dataset: Dataset):
        self._df: DataFrame = self.load_data(dataset)
        self._num_rows = self._df.shape[0]
        self._num_cols = self._df.shape[1]

    @staticmethod
    def load_data(dataset: Dataset) -> DataFrame:
        dataset = dataset.value
        df = read_parquet(f"resources/input/{dataset}/{dataset}.parquet")
        return reduce_mem_usage(df)

    @property
    def df(self):
        return self._df

    @property
    def num_rows(self):
        return self._num_rows

    @property
    def num_cols(self):
        return self._num_cols
