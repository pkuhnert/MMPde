#' Run shiny app
#'
#'
#'@export
runShiny <- function() {
  library(shiny)
  
  #source(system.file("shinyApp", "server.r", package = "mmpdesigne"))
  #source(system.file("shinyApp", "ui.r", package = "mmpdesigne"))
  
  #app <- shinyApp(ui, server)
  runApp(system.file("shinyApp", package="MMPde"))
}