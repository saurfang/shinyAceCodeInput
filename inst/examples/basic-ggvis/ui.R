
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggvis)
library(shinyAceCodeInput)

shinyUI(fluidPage(

  # Application title
  titlePanel("Motor Trend Car Road Tests Data"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      helpText("Modify the code chunks below and click Go to see the plot update. 
               Use Tab or Ctrl+Space for code completion."),
      aceCodeInput("mutate", tags$pre("mtcars %>%"), "select(x = wt, y = mpg) \n"),
      aceCodeInput("ggvis", tags$pre("%>% ggvis() %>%"), "add_props(~x, ~y) %>% \n\tlayer_guess() \n"),
      actionButton("go", "Go", class = "pull-right"),
      br(), #pad the above pull-right
      textOutput("error"),
      helpText("Things you can try:"),
      actionButton("groupedPoints", "Grouped Points"),
      actionButton("modelFits", "Model Fits")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      ggvisOutput("plot"),
      uiOutput("plot_ui"),
      dataTableOutput("table")
    )
  )
))
