#' Create an Ace code input control
#' 
#' Create an input control for entry of R code text values. This is very similar to a
#' \code{\link[shiny]{textInput}} but has additional IDE look and feel plus code
#' completion that comes with Ace code editor.
#' 
#' @param inputId Input variable to assign the control's value to
#' @param label	Display label for the control
#' @param code Initial code text
#' @param hint Types of code compeltion to enable
#' @return An Ace code input control that can be added to a UI definition
#' @importFrom htmltools attachDependencies htmlDependency
#' @import shiny
#' @export
aceCodeInput <- function(inputId, label, code = NULL, hint = c("autocomplete", "anyword")) {
  #TODO: Need to implement this
  hint <- match.arg(hint)
  
  addResourcePath("shinyAceCodeInput", system.file("www", package="shinyAceCodeInput"))
  
  attachDependencies(
    tagList(
      singleton(
        tags$head(
          tags$script(src = "shinyAceCodeInput/acecode.js"),
          tags$link(href = "shinyAceCodeInput/acecode.css", rel = "stylesheet")
        )
      ),
      shiny:::`%AND%`(label, tags$label(label, `for` = inputId)),
      tags$div(id = inputId, class = "shiny-aceCodeInput", code)
    ), 
    htmlDependency("ace", "1.1.7", c(href = "//cdn.jsdelivr.net/ace/1.1.7/min"),
                   script = c("ace.js", "mode-r.js", "ext-language_tools.js"))
  )
}

#' Enable Code Completion for an Ace Code Input
#' 
#' @param inputId The id of the input object
#' @param fromList The list of code completion words that will be categorized as \code{names}.
#' This is intended to provide a way to offer completion for functions that use NSE (non-standard
#' evaluation). This can be a static character vector/\code{list} or a \code{reactive} that returns
#' such.
#' @param session The \code{session} object passed to function given to shinyServer
#' @return An observer reference class object that is responsible for offering code completion.
#' See \code{\link[shiny]{observe}} for more details.
#' @export 
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

#' Change the value of an Ace code input on the client
#' 
#' @param session The \code{session} object passed to function given to ShinyServer
#' @param inputId The id of the input object
#' @param label The label to set for the input object
#' @param code The code text to set for the input object
#' @param hint The type of code completion to enable for the input object
#' @export
updateAceCodeInput <- function(session, inputId, label = NULL, code = NULL, hint = NULL) {
  message <- shiny:::dropNulls(list(label = label, code = code, hint = hint))
  session$sendInputMessage(inputId, message)
}

