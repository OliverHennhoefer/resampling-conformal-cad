library(ggplot2)
library(extrafont)

font_import(pattern = "Latin Modern Roman 5") 

setwd(dir = 'C:/Users/olive/OneDrive/Desktop/conformal_anomaly_benchmark/cad_benchmark/utils')
source('ggplot_layout_2.R', verbose=FALSE)

file_path <- "C:/Users/olive/OneDrive/Desktop/conformal_anomaly_benchmark/cad_benchmark/resources/output/bootstrap_power.csv"
df <- read.csv(file=file_path)
#df <- subset(df, (df$model == "PCA" & (df$dataset == "wbc" | df$dataset == "ionosphere")))
df <- subset(df, df$calib_size<=1000)
df$raw <- NULL
df$cov <- (100 * df$std) / df$mean
df$group <- paste0(df$method)
df$method <- ifelse(df$method == "JaB", "Jackknife-after-Bootstrap", "Jackknife+-after-Bootstrap")

df[df$dataset == "ionosphere",]$dataset <- "Ionosphere"
df[df$dataset == "wbc",]$dataset <- "White Blood Cells"
df[df$dataset == "pima",]$dataset <- "Pima"
df[df$dataset == "breastw",]$dataset <- "Breast"
df[df$dataset == "wine",]$dataset <- "Wine"

ratio <- 500

ggplot(data = df) +
  geom_line(aes(x = calib_size, y = mean, group = method, color = method, linetype = method, size = "line"), show.legend = FALSE) +
  geom_line(aes(x = calib_size, y = cov / ratio, group = method, color = "cov", linetype = method, size = "line")) +
  geom_point(aes(x = calib_size, y = mean, group = method, color = method, size = "point")) +
  scale_color_manual(values = c("Jackknife-after-Bootstrap" = alpha("#EB575B", 1), "Jackknife+-after-Bootstrap" = alpha("#4BA1AF", 1)),
                     limits = c("Jackknife-after-Bootstrap", "Jackknife+-after-Bootstrap")) +
  scale_linetype_manual(values = c("Jackknife-after-Bootstrap" = "solid", "Jackknife+-after-Bootstrap" = "solid")) +
  scale_size_manual(values = c("line" = 1, "point" = 2), guide = "none") +
  ylim(0, 1.0) +
  xlim(0, 10000) +
  scale_x_continuous(expand = c(0, 0), breaks=c(200, 400, 600, 800), labels = c(200, 400, 600, 800)) +
  scale_y_continuous(position = "right", breaks = c(0.125, 0.25, 0.5, 0.75),
                     sec.axis = sec_axis(~.*ratio, name="Coefficient of Variation", breaks = c(100, 200, 300))) +
  labs(x = "Calibration Set Size", y = "Statistical Power",
       title = "Influence of Calibration Set Size: Statistical Power",
       subtitle = "Principal Component Analysis (n_component=3)",
       caption = "Resampling Ratio: 0.95") +
  layout +
  facet_grid(. ~ dataset)

ggsave("C:/Users/olive/OneDrive/Desktop/conformal_anomaly_benchmark/cad_benchmark/resources/wbc_bootstrap_power.png", bg = 'white', width=27, height=9, dpi=350)

#_______________________________________________________________________________

file_path <- "C:/Users/olive/OneDrive/Desktop/conformal_anomaly_benchmark/cad_benchmark/resources/output/bootstrap_fdr.csv"
df <- read.csv(file=file_path)
df <- subset(df, (df$model == "PCA" & df$dataset == "wbc"))
df$raw <- NULL
df$cov <- (100 * df$std) / df$mean

ggplot() +
  geom_rect(aes(xmin=0, xmax=10000, ymin=0, ymax=0.2), fill="#d9ed92", col="transparent", alpha=0.4, linewidth=1) +
  geom_line(data = df, aes(x = calib_size, y = mean, group = method)) +
  geom_line(data = df, aes(x = calib_size, y = q90, group = method)) +
  geom_vline(xintercept = 223, color = "black", linetype = "dotdash", size = 0.5) + 
  ylim(0, 0.5) +
  xlim(0, 10000) +
  scale_color_manual(values = c("JaB" = "#EB575B", "J+aB" = "#4BA1AF")) +
  scale_linetype_manual(values = c("JaB" = "solid", "J+aB" = "longdash")) +
  scale_size_manual(values = c("JaB" = 1.5, "J+aB" = 1.5)) +
  scale_x_continuous(breaks=seq(1000, 10000, 1000),
                     minor_breaks = seq(100, 900, 100)) +
  theme_minimal() +
  theme(panel.grid.major.x = element_line(color = "grey", size = 0.5))


+
  theme_minimal() +
  labs(title = "Jackknife+-after-Bootstrap",
       subtitle = "Influence of the calibration set size on statistical power") +
  xlab("Calibration Set Size") +
  ylab("Statistical Power") +
  ylim(c(0, 1.0))

ggplot(data = df, aes(x = calib_size, y=fdr)) +
  geom_line() +
  geom_ribbon(aes(xmin=0, xmax=10000, ymin=0, ymax=0.2), fill="#d9ed92", col="transparent", alpha=0.4, linewidth=1) +
  theme_minimal() +
  labs(title = "Jackknife+-after-Bootstrap",
       subtitle = "Influence of the calibration set size on the false discovery rate") +
  xlab("Calibration Set Size") +
  ylab("False Discovery Rate") +
  ylim(c(0, 0.5)) +
  xlim(c(0, 10000)) +
  scale_x_continuous(expand=c(0,0))
