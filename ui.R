library(shiny)

shinyUI(fluidPage(
  titlePanel("Prediction of Child Health based on  parents"),
  sidebarLayout(
    sidebarPanel(
      helpText("This application predicts  Health  of child through his gender and the Health of the parents."),
      helpText("Please make a choise of parameters:"),
      sliderInput(inputId = "inFh",
                   label = "Father's Health Condichtion:",
                   value = 50,
                   min = 25,
                   max = 100,
                   step = 1),
      sliderInput(inputId = "inMh",
                   label = "Mother's Health Condition:",
                   value = 50,
                   min = 25,
                   max = 100,
                   step = 1),
      
      radioButtons(inputId = "inGen",
                   label = "Child's gender: ",
                   choices = c("Female"="female", "Male"="male"),
                   inline = TRUE)
      ),
    
    mainPanel(
      htmlOutput("parentsText"),
      htmlOutput("prediction"),
      plotOutput("barsPlot", width = "50%")
    )
    )
))