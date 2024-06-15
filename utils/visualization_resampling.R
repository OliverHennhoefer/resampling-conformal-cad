library(ggplot2)
library(tidyverse)
library(jsonlite)

setwd(dir = 'C:/Users/olive/OneDrive/Desktop/conformal_anomaly_benchmark/cad_benchmark/utils')
source('ggplot_layout_2.R', verbose=FALSE)

file_path <- "C:/Users/olive/OneDrive/Desktop/conformal_anomaly_benchmark/cad_benchmark/resources/output/power.csv"
df <- read.csv(file=file_path)

df <- subset(df, df$dataset == "wine")
df$se <- df$std / sqrt(223)
df$cov <- (100 * df$std) / df$mean

df <- df %>%
  mutate(raw = lapply(raw, fromJSON))

df_long <- df %>%
  unnest(raw)

ggplot(df_long, aes(fill = method, x = dataset, y = raw)) +
  geom_boxplot() +
  facet_wrap(~ model, scales = "free_y") +
  labs(title = "Histogram of Raw Values by Method and Model", x = "Raw Value", y = "Count")

ggplot(data = df)+
  geom_boxplot(aes(fill = method, x = dataset, y = raw)) +
  theme_minimal() +
  facet_grid(. ~ model)


ggplot(data = df)+
  geom_bar(aes(fill = method, x = dataset, y = mean), position="dodge", stat="identity") +
  #geom_errorbar(aes(x=dataset, ymin=mean-se, ymax=mean+se, group = method), width=0.4, colour="black", alpha=0.9, size=1.3, position = position_dodge(1)) +
  geom_point(aes(x = dataset, y = std, group = method), position = position_dodge(1)) +
  theme_minimal() +
  facet_grid(. ~ model)




  geom_bar(aes(fill = method, x = dataset, y = mean), position="dodge", stat="identity") +
  geom_errorbar(aes(x=dataset, ymin=mean-se, ymax=mean+se, group = method), width=0.4, colour="black", alpha=0.9, size=1.3, position = position_dodge(1)) +
  geom_point(aes(x = dataset, y = q90, group = method), position = position_dodge(1)) +
  theme_minimal() +
  facet_grid(. ~ model)
