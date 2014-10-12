
# This is the server logic for a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(dplyr)
library(ggvis)
library(shinyAceCodeInput)

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
  
  aceCodeCompletion("mutate", colnames(mtcars))
  aceCodeCompletion("ggvis", mutatedNames)
  
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

  observe({
    if(input$groupedPoints == 0) return(NULL)
    
    updateAceCodeInput(session, "mutate", code = "identity\n")
    updateAceCodeInput(session, "ggvis", code = "layer_points(~wt, ~mpg,\n\tfill = ~as.factor(cyl))\n")
  })
  
  observe({
    if(input$modelFits == 0) return(NULL)
    
    updateAceCodeInput(session, "mutate", code = "do(data.frame(
  `Fitted lm` = lm(mpg ~ ., data = .)$fitted,
  `Fitted loess` = loess(mpg ~ wt + cyl, data = .)$fitted,
  `Fitted gam` = mgcv::gam(mpg ~ s(wt, by = cyl), data = .)$fitted,
  wt = .$wt,
  Actual = .$mpg)) %>%
  reshape2::melt(c(\"wt\", \"Actual\"))")
    updateAceCodeInput(session, "ggvis", code = "layer_points(~wt, ~value, fill = ~variable) %>%
layer_points(~wt, ~Actual)")
  })
})
