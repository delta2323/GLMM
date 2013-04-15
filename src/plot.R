data = read.csv("data.csv")
jpeg(file="data.jpg")
plot(data$x, data$y)
