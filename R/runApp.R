#' Run shiny app
#' 
#' Function to run the shiny app
#'
#'@export
runShiny <- function() {
  runApp(system.file("shinyApp", package="MMPde"))
}