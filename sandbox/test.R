library(ggvis)
ui <- shinyUI(pageWithSidebar(
  div(),
  sidebarPanel(
    checkboxInput("tip", "tip", F),
    checkboxInput("size", "size", F),
    uiOutput("plot_ui")
  ),
  mainPanel(ggvisOutput("plot"))
))

server <- shinyServer(function(input, output, session) {
  all_values <- function(x) {
    if(is.null(x)) return(NULL)
    paste0(names(x), ": ", format(x), collapse = "<br />")
  }
    
  reactive({
    vis <-
      mtcars %>%
      ggvis(~wt, ~mpg) %>%
      layer_points(size := if(input$size) input_slider(100, 1000) else 100)
    if(input$tip) add_tooltip(vis, all_values) else vis
  }) %>% bind_shiny("plot", "plot_ui")
})

shinyApp(ui = ui, server = server)