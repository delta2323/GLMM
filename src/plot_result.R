data = read.csv("predict.csv")
jpeg(file="predict.jpg")
plot(data$x, data$y)
