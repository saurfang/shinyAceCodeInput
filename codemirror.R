library(htmltools)

`%AND%` <- shiny:::`%AND%`

codeMirrorInput <- function(inputId, label, code = NULL, hintWords = NULL) {
  attachDependencies(
    tagList(singleton(tags$script(src = "codemirror.js")),
            singleton(tags$link(href = "codemirror.css", rel = "stylesheet")),
            label %AND% tags$label(label, `for` = inputId),
            tags$textarea(id = inputId, name = inputId, class = "shiny-codeMirrorInput", code)
    ), 
    htmlDependency("codemirror", "4.6", c(href = "//cdnjs.cloudflare.com/ajax/libs/codemirror/4.6.0"),
                   script = c("codemirror.min.js", "mode/r/r.min.js", "addon/edit/matchbrackets.min.js", "addon/edit/closebrackets.min.js", "addon/hint/show-hint.min.js"), 
                   stylesheet = c("codemirror.min.css", "addon/hint/show-hint.min.css"))
  )
}

updateCodeMirrorInput <- function(session, inputId, label = NULL, code = NULL, hintWords = NULL) {
  message <- shiny:::dropNulls(list(label = label, code = code, hintWords = hintWords))
  session$sendInputMessage(inputId, message)
}