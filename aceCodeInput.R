library(htmltools)

`%AND%` <- shiny:::`%AND%`

aceCodeInput <- function(inputId, label, code = NULL, hint = c("autocomplete", "anyword")) {
  hint <- match.arg(hint)
  
  attachDependencies(
    tagList(singleton(tags$script(src = "acecode.js")),
            singleton(tags$link(href = "acecode.css", rel = "stylesheet")),
            label %AND% tags$label(label, `for` = inputId),
            tags$div(id = inputId, class = "shiny-aceCodeInput", code)
    ), 
    htmlDependency("ace", "1.1.7", c(href = "//cdn.jsdelivr.net/ace/1.1.7/min"),
                   script = c("ace.js", "mode-r.js", "ext-language_tools.js"))
  )
}

aceCodeCompletion <- function(inputId, fromList = NULL, session = shiny::getDefaultReactiveDomain()) {
  shiny::observe({
    value <- session$input[[paste0("aceCode_", inputId, "_hint")]]
    if(is.null(value)) return(NULL)
    
    hints <- list(inputId = inputId,
                  comps = utils:::.win32consoleCompletion(value$linebuffer, value$cursorPosition)$comps)
    
    fromList2 <- if(is.reactive(fromList)) fromList() else fromList
    if(!is.null(fromList2)) {
      hints$fromList <- fromList2
    }
    
    session$sendCustomMessage('aceCode', hints)
  })
}

updateAceCodeInput <- function(session, inputId, label = NULL, code = NULL, hint = NULL) {
  message <- shiny:::dropNulls(list(label = label, code = code, hint = hint))
  session$sendInputMessage(inputId, message)
}

