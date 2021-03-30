
<!-- README.md is generated from README.Rmd. Please edit that file -->

# MMPdesignE

## Marine Monitoring Program Design Evaluation

This application provides interactive supplementary material to the
paper by Lloyd-Jones et al. (2021).

## Installation

You can pull this repo and run the app by typing in the following at the
command line within R:

    library(shiny)

    source("includeRmd.r")
    source("ui.r")
    source("server.r")

    app <- shinyApp(ui = ui, server = server)
    runApp(app)

## Contact

For all enquires regarding this Shiny App, please contact: Petra Kuhnert
(<Petra.Kuhnert@data61.csiro.au>)

Contributions to the app and manuscript include:

#### CSIRO

-   Luke Lloyd-Jones: <Luke.Lloyd-Jones@data61.csiro.au>
-   Petra M. Kuhnert: <Petra.Kuhnert@data61.csiro.au>
-   Emma Lawrence: <Emma.Lawrence@data61.csiro.au>

#### Australian Institute of Marine Science (AIMS)

-   Frederieke Kroon: <F.Kroon@aims.gov.au>
-   Renee Gruber: <r.gruber@aims.gov.au>

#### James Cook University (JCU)

-   Stephen Lewis: <stephen.lewis@jcu.edu.au>
-   Jane Waterhouse: <jane.waterhouse@jcu.edu.au>

## References

Lloyd-Jones, L., Kuhnert, P., Lawrence, E., Lewis, S., Waterhouse, J.,
Gruber, R. and Kroon, F.(2021) [Influence of monitoring program design
on power to detect change in marine water quality](https://linktopaper).
