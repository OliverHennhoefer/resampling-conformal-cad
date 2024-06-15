import pandas as pd


def get_box_plot_data(labels, bp):
    rows_list = []

    for i in range(len(labels)):
        dict1 = {}
        dict1["label"] = labels[i]
        dict1["lower_whisker"] = bp["whiskers"][i * 2].get_ydata()[1]
        dict1["lower_quartile"] = bp["boxes"][i].get_ydata()[1]
        dict1["median"] = bp["medians"][i].get_ydata()[1]
        dict1["upper_quartile"] = bp["boxes"][i].get_ydata()[2]
        dict1["upper_whisker"] = bp["whiskers"][(i * 2) + 1].get_ydata()[1]
        rows_list.append(dict1)

    return pd.DataFrame(rows_list)
