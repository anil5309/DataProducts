library(shiny)
library(HistData)
data(GaltonFamilies)
library(dplyr)
library(ggplot2)

# converting in centimeters
gf <- GaltonFamilies
gf <- gf %>% mutate(father=father*.9,
                    mother=mother*.9,
                    childHeight=childHeight*1)

# linear model
regmod <- lm(childHeight ~ father + mother + gender, data=gf)

shinyServer(function(input, output) {
  output$parentsText <- renderText({
    paste("When the father's Health Condition is",
          strong(round(input$inFh, 1)),
          ", and mother's is",
          strong(round(input$inMh, 1)),
          ", then:")
  })
  output$prediction <- renderText({
    df <- data.frame(father=input$inFh,
                     mother=input$inMh,
                     gender=factor(input$inGen, levels=levels(gf$gender)))
    ch <- predict(regmod, newdata=df)
    sord <- ifelse(
      input$inGen=="female",
      "Daugther",
      "Son"
    )
    paste0(em(strong(sord)),
           "'s predicted Health Condition would be approximately ",
           em(strong(round(ch))),
           ""
    )
  })
  output$barsPlot <- renderPlot({
    sord <- ifelse(
      input$inGen=="female",
      "Daugther",
      "Son"
    )
    df <- data.frame(father=input$inFh,
                     mother=input$inMh,
                     gender=factor(input$inGen, levels=levels(gf$gender)))
    ch <- predict(regmod, newdata=df)
    yvals <- c("Father", sord, "Mother")
    df <- data.frame(
      x = factor(yvals, levels = yvals, ordered = TRUE),
      y = c(input$inFh, ch, input$inMh),
      colors = c("green", "black", "blue")
    )
    ggplot(df, aes(x=x, y=y, color=colors, fill=colors)) +
      geom_bar(stat="identity", width=0.5) +
      xlab("") +
      ylab("Health Condition  ") +
      theme_minimal() +
      theme(legend.position="none")
  })
})