
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(dplyr)
library(ggvis)

shinyServer(function(input, output, session) {
  
  output$table <- renderDataTable(mtcars)
  
  mutatedNames <- reactive({
    try({
      code <- gsub("\\s+$", "", isolate(input$mutate))
      eval(parse(text = isolate(paste("mtcars %>%", code)))) %>%
        colnames %>%
        paste0("~", .)
    }, silent = TRUE)
  })
  
  codeMirrorHint("mutate", colnames(mtcars))
  codeMirrorHint("ggvis", mutatedNames)
  
  reactive({ 
    input$go
    
    tryCatch({
      #clear error
      output$error <- renderPrint(invisible())
      
      code1 <- gsub("\\s+$", "", isolate(input$mutate))
      code2 <- gsub("\\s+$", "", isolate(input$ggvis))
      
      eval(parse(text = isolate(paste("mtcars %>%", code1, "%>% ggvis %>%", code2))))
    }, error = function(ex) {
      output$error <- renderPrint(ex)
      
      #error fallback
      ggvis(data.frame(x=numeric()), ~x)
    })
  }) %>%
    bind_shiny("plot", "plot_ui")

})
