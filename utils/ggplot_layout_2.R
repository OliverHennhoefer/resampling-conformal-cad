library(extrafont)
library(showtext)
library(ggplot2)
library(ggtext)

layout <- theme_minimal() +
  theme(legend.position="bottom",
        theme(text  = element_text(size=18, family="LM Roman 10")), 
        legend.title=element_blank(),
        legend.text = element_text(size=28, family="LM Roman 10"),
        legend.key.size = unit(3, 'line'),
        axis.text = element_text(size=26, family="LM Roman 10"),
        axis.text.x = element_text(size=26, angle = 45, vjust=0.5),
        axis.text.y = element_text(size=26, family="LM Roman 10"),
        axis.title.x = element_blank(),#element_text(size=18, colour = alpha("black", 0.45)),
        axis.title.y = element_text(size=26, colour = alpha("black", 0.45)),
        plot.title = element_text(size=36, face="bold"),
        panel.grid.major = element_line(colour=alpha("black", 0.35), size=0.5),
        panel.grid.minor = element_line(colour=alpha("black", 0.15), size=0.5),
        plot.margin = unit(c(0.5, 0.5, 0.5, 0.5), "cm"),  # t,r,b,l
        #panel.grid.major.x = element_blank(),
        #panel.grid.minor.x = element_blank(),
        axis.line.y = element_blank(),
        axis.ticks.y = element_blank(),
        panel.border = element_blank(),
        axis.line.x = element_line(color = "black"),
        panel.grid.major.y = element_line(size = 0.75, color = "lightgray", linetype = 1),
        panel.grid.minor.y = element_blank(),
        plot.caption = element_text(hjust = 0, size = 22),
        plot.subtitle = element_markdown(size=26),
        strip.text.x = element_text(size = 26),
        panel.background = element_rect(fill = "lightgrey", colour = "lightgrey")
        )
