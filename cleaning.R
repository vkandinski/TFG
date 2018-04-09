setwd('~/Desktop/TFG/')
load('rawdata.RData')

library(tidyverse)

### Convert character variables to factors
rawdata <- rawdata %>% mutate_if(is.character, as.factor)

attach(rawdata)
save(rawdata, file = 'rawdata.RData')