

require(data.table)

data <- fread("/Users/amc/Documents/safer/Analysis - Sheet1.csv")

questions <- c(names(data))
setnames(data, questions, c("timestamp", paste0("q", 1:7), "city", "country", "age", "profession", "occupation", "email"))
data
questions <- questions[2:8]

data[, timestamp:=NULL]
data <- unique(data)

prop.table(table(data$q1, data$occupation), 2)
prop.table(table(data$q2, data$occupation), 2)
prop.table(table(data$q3, data$occupation), 2)
prop.table(table(data$q4, data$occupation), 2)
prop.table(table(data$q5, data$occupation), 2)
prop.table(table(data$q6, data$occupation), 2)
prop.table(table(data$q7, data$occupation), 2)

prop.table(table(data$q1, data$age), 2)
prop.table(table(data$q2, data$age), 2)
prop.table(table(data$q3, data$age), 2)
prop.table(table(data$q4, data$age), 2)
prop.table(table(data$q5, data$age), 2)
prop.table(table(data$q6, data$age), 2)
prop.table(table(data$q7, data$age), 2)

prop.table(table(data$q1, data$country), 2)
prop.table(table(data$q2, data$country), 2)
prop.table(table(data$q3, data$country), 2)
prop.table(table(data$q4, data$country), 2)
prop.table(table(data$q5, data$country), 2)
prop.table(table(data$q6, data$country), 2)
prop.table(table(data$q7, data$country), 2)

library(ggplot2)
ggplot(data, aes(age, ..count../sum(..count..))) + geom_bar(aes(fill = q1), binwidth=.5)
library(reshape2)
library(plyr)
data <- as.data.frame(data)
pdf("/Users/amc/Documents/safer/furtherAnalysis.pdf", onefile = TRUE, paper="a4r", width = 14)
for(j in c("age", "occupation", "country")){
  for(i in 1:7){
    dt <- melt(prop.table(table(data[, paste0("q", i)], data[, j]), 2))
    dt$value <- round(dt$value*100, 0)
    dt <- ddply(dt, .(Var2), transform, pos = (cumsum(value) - 0.5 * value))
    dt$label <- paste0(sprintf("%.0f", dt$value), "%")
    
    #Plot
    print(
      ggplot(dt, aes(x = Var2, y = value, fill = Var1)) +
        geom_bar(stat = "identity", width = .7) +
        geom_text(aes(y = pos, label = label), size = 3) +
        coord_flip() +
        guides(fill=guide_legend(title=NULL)) +
        ggtitle(questions[i]) +
        ylab("Percentage of respondents") +
        xlab(j)
    )
    
  }
}
dev.off()

