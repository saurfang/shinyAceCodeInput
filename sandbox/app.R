library(ggvis)

server <- function(input, output, session) {
  
  all_values <- function(x) {
    if(is.null(x)) return(NULL)
    paste0(names(x), ": ", format(x), collapse = "<br />")
  }
  
  dat <- reactive({ mtcars[1:input$obs, ] })
  
  observe({
    input$populate
    
    updateTextInput(session, "input1", value = "select(wt, mpg, cyl)")
    updateTextInput(session, "input2", value = "add_props(~wt, ~mpg, fill = ~as.factor(cyl)) %>% layer_guess()")
  })
  
  observe({
    input$tooltip
    
    updateTextInput(session, "input2", value = paste(isolate(input$input2), "%>% add_tooltip(all_values)"))
  })
  
  vis <- reactive({
    input$go1
    
    tryCatch({
      #clear error
      output$error <- renderPrint(NULL)
      
      eval(parse(text = paste("dat %>%", isolate(input$input1))))
    }, error = function(x) {
      output$error <- renderPrint(x)
      
      data
    })
  }) %>% ggvis
  
  reactive({
    input$go1
    
    tryCatch({
      #clear error
      output$error <- renderPrint(NULL)
      message(str(vis))
      eval(parse(text = paste("vis %>%", isolate(input$input2))))
    }, error = function(x) {
      output$error <- renderPrint(x)
      
      ggvis(data.frame(x = numeric(0)), ~x)
    })
  }) %>% bind_shiny("plot1")
  
  
  reactive({
    input$go2
    
    tryCatch({
      #clear error
      output$error <- renderPrint(NULL)
      
      isolate(eval(parse(text = paste("dat %>%", input$input1, "%>% ggvis %>%", input$input2))))
    }, error = function(x) {
      output$error <- renderPrint(x)
      
      ggvis(data.frame(x = numeric(0)), ~x)
    })
  }) %>% bind_shiny("plot2")
}

ui <- shinyUI(fluidPage(
  sidebarLayout(
    sidebarPanel(
      sliderInput("obs", "obs", min = 1, max = nrow(mtcars), value = nrow(mtcars)),
      textInput("input1", "mtcars %>%", "select(wt, mpg)"),
      textInput("input2", "%>% ggvis %>%", "add_props(~wt, ~mpg) %>% layer_guess()"),
      br(),
      helpText("The following will break in go1 but works in go2"),
      actionButton("populate", "populate"),
      helpText("The following will work in go1 but fails in go2"),
      actionButton("tooltip", "tooltip"),
      hr(),
      actionButton("go1", "go1"),
      actionButton("go2", "go2"),
      textOutput("error")
    ),
    mainPanel(
      ggvisOutput("plot1"),
      ggvisOutput("plot2")
    ))
))

shinyApp(ui = ui, server = server)
