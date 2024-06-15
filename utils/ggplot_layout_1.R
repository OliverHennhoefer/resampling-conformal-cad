library(extrafont)
library(showtext)
library(ggplot2)
library(ggtext)

layout <- theme_minimal() +
  theme(legend.position="bottom",
        legend.title=element_blank(),
        axis.text = element_text(size=16),
        axis.text.x = element_text(size=16),
        axis.text.y = element_text(size=16),
        axis.title.x = element_text(size=16, colour = alpha("black", 0.45)),
        axis.title.y = element_text(size=16, colour = alpha("black", 0.45)),
        plot.title = element_text(size=30, face="bold"),
        panel.grid.major = element_line(colour=alpha("black", 0.35), size=0.5),
        panel.grid.minor = element_line(colour=alpha("black", 0.35), size=0.5),
        plot.margin = unit(c(2, 3, 2, 3), "cm"),
        panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        panel.border = element_blank(),
        axis.line.x = element_line(color = "black"),
        panel.grid.major.y = element_line(size = 0.75, color = "lightgray", linetype = 1),
        panel.grid.minor.y = element_blank(),
        plot.caption = element_text(hjust = 0, size = 14),
        plot.subtitle = element_markdown(size=18, face="bold")
        )
