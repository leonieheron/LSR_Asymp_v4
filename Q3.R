rm(list = ls())

#download packages
library(meta)
library(readxl)
library(tidyverse)
library(httr) # use to retrieve data from REDCap
library(kableExtra)
library(flextable)
library(dplyr)
library(RCurl)
library(tidyr)
library(ggplot2)
library(metafor)
library(extrafont)
loadfonts(device = "win")


###############################################################
# Question 2.2: results output ################################
# Proportion of transmission from asymp or pre-symp ###########
###############################################################



################################################################
#Below codes are to get data from REDCap. In order to reproduce #
#plots and analysis please use "Q3_ExtractedData.csv" file.     #
#################################################################


#use getDataREDCap.R to get data from REDCap
source("getDataREDCap.R")

#formDataQ3 is from getDataREDCap script
response3 <- httr::POST(url, body = formDataQ3, encode = "form")
asymptomaticQ3 <- httr::content(response3)

#read "Q3_ExtractedData.csv" file
asymptomaticQ3 <- read.csv("Q3_ExtractedData.csv")


asymptomaticQ3 = asymptomaticQ3 %>% filter(!(q3_pp_m=="" & is.na(q3_pa_m)))
asymptomaticQ3$q3_setting=ifelse(asymptomaticQ3$q3_setting=="",NA,asymptomaticQ3$q3_setting)

s <- strsplit(asymptomaticQ3$q3_setting, split = ";")
pp_m <- strsplit(asymptomaticQ3$q3_pp_m, split = ";")
pp_l <- strsplit(asymptomaticQ3$q3_pp_l, split = ";")
pp_u <- strsplit(asymptomaticQ3$q3_pp_u, split = ";")

dfQ3a=data.frame(label=rep(paste0("   ",asymptomaticQ3$author_1), sapply(pp_m, length)),
                 Q3set=unlist(s),
                 p = as.numeric(unlist(pp_m)), 
                 l = as.numeric(unlist(pp_l)),
                 h = as.numeric(unlist(pp_u)),
                 setting="Pre-symptomatic",stringsAsFactors = FALSE)



dfQ3a[dfQ3a==9999]<-NA
dfQ3a=dfQ3a[!is.na(dfQ3a$p),]

dfQ3b=data.frame(label=paste0("   ",asymptomaticQ3$author_1),
                 Q3set=NA,
                 p = asymptomaticQ3$q3_pa_m, 
                 l = asymptomaticQ3$q3_pa_l,
                 h = asymptomaticQ3$q3_pa_u,
                 setting="Asymptomatic",stringsAsFactors = FALSE)

dfQ3b[dfQ3b==9999]<-NA
dfQ3b=dfQ3b[!is.na(dfQ3b$p),]

dfQ3=rbind.data.frame(dfQ3b,dfQ3a, stringsAsFactors = FALSE)

dfQ3$line=1:nrow(dfQ3)
dfQ3$type=rep(2,nrow(dfQ3))


insertRow <- function(existingDF, newrow, r) {
  existingDF[seq(r+1,nrow(existingDF)+1),] <- existingDF[seq(r,nrow(existingDF)),]
  existingDF[r,] <- newrow
  existingDF
}


dfQ3=insertRow(dfQ3,c("Asymptomatic transmission",NA,NA,NA,NA,NA,1,1),1)

dfQ3=insertRow(dfQ3,c("Pre-symptomatic transmission",NA,NA,NA,NA,NA,1,1),nrow(dfQ3b)+2)
dfQ3=insertRow(dfQ3,c(rep(NA,7),1),nrow(dfQ3b)+2)
dfQ3$line=1:nrow(dfQ3)

dfQ3$p=as.numeric(dfQ3$p)
dfQ3$l=as.numeric(dfQ3$l)
dfQ3$h=as.numeric(dfQ3$h)



dataG=dfQ3

dig=2
r<-function(x){format(round(as.numeric(x),2),dig=2)}



dataG$label=ifelse(dataG$label=="   Ganyani T",
                   paste0(dataG$label, " ", ifelse(!is.na(dataG$Q3set),paste0("[",dataG$Q3set,"]"),"")),dataG$label)

dataG$label=ifelse(dataG$label=="   Peak CM",
                   paste0(dataG$label, " ", ifelse(!is.na(dataG$Q3set),paste0("[",dataG$Q3set,"]"),"")),dataG$label)
dataG$label=ifelse(dataG$label=="   Tindale LC",
                   paste0(dataG$label, " ", ifelse(!is.na(dataG$Q3set),paste0("[",dataG$Q3set,"]"),"")),dataG$label)

dataG$label=ifelse(dataG$label=="   Zhang W",
                   paste0(dataG$label, " ", ifelse(!is.na(dataG$Q3set),paste0("[",dataG$Q3set,"]"),"")),dataG$label)


dataG$fontface=ifelse(dataG$type==1, "italic","plain")

dataG$label_studyCI=ifelse(!is.na(dataG$h), paste0("[",r(dataG$l),";",r(dataG$h),"]"),NA)
dataG$label_study=ifelse(!is.na(dataG$p),r(dataG$p),NA)

p=ggplot()+ 
  geom_point(data=dataG,aes(y=dataG$line, x=dataG$p),fill="gray", shape=22, color="black",size=4)+
  geom_errorbarh(data=dataG,aes(y=dataG$line, xmin=dataG$l, xmax=dataG$h), height=0.3)+
  
  geom_text(aes(y=c(-1,-1,-1), x=c(-2,1.25,1.75), label=c("Study","Prop.","95% CI")), hjust = 0, fontface = "bold")+
  
  geom_text(data=dataG,aes(y=dataG$line, x=1.25, label=label_study), hjust = 0)+
  geom_text(data=dataG,aes(y=dataG$line, x=1.75, label=label_studyCI), hjust = 0)+
  
  
  geom_text(data=dataG,aes(y=dataG$line, x=-2, label=dataG$label), hjust = 0, fontface=dataG$fontface)+
  #geom_rect(data=dataG,aes(xmin=dataG$Pl,xmax=dataG$Ph,ymin=dataG$line-0.1,ymax=dataG$line+0.1),color="black", fill="red")+
  theme_void() + 
  scale_y_reverse()+
  geom_segment(aes(y=max(dataG$line)+1, x=0, xend=1, yend=max(dataG$line)+1))+
  geom_segment(aes(y=max(dataG$line)+1,yend=max(dataG$line)+1.3,x=0,xend=0))+
  geom_segment(aes(y=max(dataG$line)+1,yend=max(dataG$line)+1.3,x=0.25,xend=0.25))+
  geom_segment(aes(y=max(dataG$line)+1,yend=max(dataG$line)+1.3,x=0.5,xend=0.5))+
  geom_segment(aes(y=max(dataG$line)+1,yend=max(dataG$line)+1.3,x=0.75,xend=0.75))+
  geom_segment(aes(y=max(dataG$line)+1,yend=max(dataG$line)+1.3,x=1,xend=1))+
  geom_text(aes(y=rep(max(dataG$line)+2,5),x=0:4/4, label=c(0.00,0.25,0.5,0.75,1.00)))+
  #geom_segment(data=dataG,aes(x=vlineloc, xend=vlineloc, y=0, yend=max(dataG$line)+1), linetype=3)+
  
  xlim(c(-2,2.5))+
  theme(legend.position = "none")

#create image file

p

png(file="forest_Q2_2.png", res=300, height=17, width=20, units="cm")
#pdf(file="Figure4.pdf", height=12/2, width=25/3)
p
dev.off()


tiff(filename = "Q2_2.tiff",
     width = 1700, height = 1900,
     res = 300)
p
dev.off()
