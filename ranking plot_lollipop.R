.libPaths(c(.libPaths(),"c:/3.5"))
library(readxl)
library(ggplot2)
data <- read_excel("//westat.com/dfs/PIAAC2013/PIAAC 2017/Sampling/Statwork/Mendoza/Falsification/Data/kpi_group.xlsx",sheet="kpi_group",col_names=TRUE)
data$group_levels <- as.character(data$group_levels)
data$kpi_overall_sign <- as.factor(data$kpi_overall_sign)
data$kpi_chisq_min_sign <- as.factor(data$kpi_chisq_min_sign)

data$sign12 <- as.factor(data$sign12)
data$sign13 <- as.factor(data$sign13)
data$sign14 <- as.factor(data$sign14)
data$sign15 <- as.factor(data$sign15)
data$sign16 <- as.factor(data$sign16)
data$sign17 <- as.factor(data$sign17)
data$sign18 <- as.factor(data$sign18)
data$sign19 <- as.factor(data$sign19)

###################################
# ENTER DESIRED RESPONSE VAR HERE #
response <- "kpi_overall_chisq_prob"
###################################
attach(data)
data$response_var <- eval(parse(text=response))
detach(data)

# Diverging dot plot - overall
data_diverging <- data[order(data$response_var,decreasing=TRUE),] #sort
data_diverging$group_levels <- factor(data_diverging$group_levels,levels=data_diverging$group_levels) #convert to factor to retain sorted order in plot

#a <- data_diverging[data_diverging$response_var <= 0.05, "group_levels"]
#a[1,,]
#a[nrow(a),,]

#pdf(("Overall_KPI.pdf"),width=8.5, height=14) 
png("Overall_KPI.png", width=8.5,height=12, units='in', res=300)
ggplot(data=data_diverging, aes(x=response_var,y=group_levels,label=response_var)) + 
  geom_segment(aes(yend=group_levels,xend=median(response_var)), alpha=0.4)+
  geom_point(stat='identity',aes(col=kpi_overall_sign),size=2) +
  geom_vline(xintercept=0.05, linetype=2,size=0.2, color="red")+
  #geom_segment(aes(x = 0.05, y = "1249", xend = 0.05, yend ="1175"), linetype=2,size=0.2, color="red")+
  scale_color_manual(name="Sign", labels=c("-1"="Negative","1"="Positive"),values=c("1"="forestgreen","-1"="red")) +
  scale_x_continuous(breaks=c(0,0.05,0.25,0.5,0.75,1)) +
  labs(title="Overall KPI - Diverging Dot Plot") +
  xlab(gsub("_"," ",response)) +
  ylab("Interviewer ID") +
  theme_bw()+
  theme(axis.text.y = element_text(size=7))
dev.off() 
