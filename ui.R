
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(ggvis)
source("codeMirror.R")

shinyUI(fluidPage(

  # Application title
  titlePanel("Motor Trend Car Road Tests Data"),

  # Sidebar with a slider input for number of bins
  sidebarLayout(
    sidebarPanel(
      codeMirrorInput("mutate", tags$pre("mtcars %>%"), "select(x = wt, y = mpg) \n"),
      codeMirrorInput("ggvis", tags$pre("%>% ggvis() %>%"), "add_props(~x, ~y) %>% \n\tlayer_guess() \n"),
      actionButton("go", "Go", class = "pull-right"),
      br(), #pad the above pull-right
      textOutput("error")
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      ggvisOutput("plot"),
      uiOutput("plot_ui"),
      dataTableOutput("table")
    )
  )
))
