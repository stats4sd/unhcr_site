
library("xlsx")
source("data.R")

write.xlsx(indicators, file = 'indicators.xlsx', sheetName ="indicators", 
           col.names = TRUE, row.names = TRUE, append= FALSE)
