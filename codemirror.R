library(htmltools)

`%AND%` <- shiny:::`%AND%`

codeMirrorInput <- function(inputId, label, code = NULL, hint = c("autocomplete", "anyword")) {
  hint <- match.arg(hint)
  
  attachDependencies(
    tagList(singleton(tags$script(src = "codemirror.js")),
            singleton(tags$link(href = "codemirror.css", rel = "stylesheet")),
            label %AND% tags$label(label, `for` = inputId),
            tags$textarea(id = inputId, name = inputId, class = "shiny-codeMirrorInput", code)
    ), 
    htmlDependency("codemirror", "4.6", c(href = "//cdnjs.cloudflare.com/ajax/libs/codemirror/4.6.0"),
                   script = c("codemirror.min.js", "mode/r/r.min.js", 
                              "addon/edit/matchbrackets.min.js", "addon/edit/closebrackets.min.js", 
                              "addon/hint/show-hint.min.js", "addon/hint/anyword-hint.min.js"), 
                   stylesheet = c("codemirror.min.css", "addon/hint/show-hint.min.css"))
  )
}

codeMirrorHint <- function(inputId, fromList = NULL, session = shiny::getDefaultReactiveDomain()) {
  shiny::observe({
    value <- session$input[[paste0("CodeMirror_", inputId, "_hint")]]
    if(is.null(value)) return(NULL)
    
    hints <- list(inputId = inputId,
                  comps = utils:::.win32consoleCompletion(value$linebuffer, value$cursorPosition)$comps)
    
    fromList2 <- if(is.reactive(fromList)) fromList() else fromList
    if(!is.null(fromList2)) {
      hints$comps <- paste(hints$comps, paste(fromList2, collapse = " "))
    }
    
    session$sendCustomMessage('codemirror', hints)
  })
}

updateCodeMirrorInput <- function(session, inputId, label = NULL, code = NULL, hint = NULL) {
  message <- shiny:::dropNulls(list(label = label, code = code, hint = hint))
  session$sendInputMessage(inputId, message)
}

