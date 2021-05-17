library(shiny)
library(leaflet)
library(ggplot2)
library(DT)

# Input widgets
ui  <- fluidPage(
  
  tags$head(includeHTML(("google-analytics.html"))),

  # Header
    headerPanel("Marine Monitoring Program - Evaluation of Design Changes"),
    mainPanel(
        h3("Overview"),
        p("This application provides interactive supplementary material to the paper by Lloyd-Jones et al. (2021). 
           Three views of the outputs from the design evaluation are available. The first tab allows you to view individual 
           consistuents by region. The second tab allows the user to compare constituents by region. The third tab
           allows a comparison of constituents across regions."),
        p("Once a region is selected on the map below (yellow dots), the user can view the data and specific outputs from 
           the analysis. Hovering over each dot will reveal the name of the region it represents.  When a comparison across regions
           is selected, regional views are highlighted on the map corresponding to selections made.")
    ),
  fluidRow(
  column(5,
         conditionalPanel(condition="input.plot_tabs!='Overview'",
                          tabsetPanel(id = "ui_tab",
                                      tabPanel("Map",
                                               column(12, h4("Marine Monitoring Locations in the GBR NRM Region"),
                                                      leafletOutput("map", height="600px"), 
                                                      verbatimTextOutput("marker")
                                               )
                                      ),
                                      tabPanel("About this App", column(12, uiOutput("userguide"))
                                      ),
                                      tabPanel("Water Quality Parameters", column(12, uiOutput("wqparms"))
                                      ),
                                      tabPanel("Figure Descriptions", column(12, uiOutput("figdesc"))
                                      ),
                                      tabPanel("Acknowledgments", column(12, uiOutput("ack"))
                                      )
                          )
         ),
         conditionalPanel(condition = "input.plot_tabs=='User guide'",
                          column(12)
         )
  ),
  column(7, tabsetPanel(id="plot_tabs",
                        
                        tabPanel("Individual Constituents",
                                 fluidRow(
                                   h4("Please select a region by clicking on a location on the Map tab."),
                                   h4("Then select a water quality (WQ) constituent and a Plot Type."),
                                   h5("(Information on plot types is located in the tabs above the map.)"),
                                   
                                   column(4, selectInput("ind_const", "WQ Constituent:", 
                                                         choices = c("Chl-a", "NOx", "PN", "PP", "Secchi", "TSS"))),
                                   column(4, selectInput("ind_plot_type1", "Plot Type:", 
                                                         choices = c("Monitoring Data", "Power Curves", "Comparison (Pre/Post)", "Comparison (Sites/Samples)",
                                                                     "Time to Exceedance")))
                                 ),
           
           fluidRow(
             column(4, uiOutput("wqImage"))
               )
           ),
           tabPanel("Constituent Comparison (by Region)",
                        fluidRow(
                          h4("Please select a region by clicking on a location on the Map tab."),
                          h4("Then select a Plot Type and one or more constituents."),
                          h5("(Information on plot types is located in the tabs above the map.)"),
                    column(4, selectInput("ind_plot_type2", "Plot Type:", 
                                          choices = c("Power Curves", "Comparison (Pre/Post)", "Comparison (Sites/Samples)"))),
                    column(4, checkboxGroupInput("constituent", "Constituents:",
                                                 c("Chl-a" = "chla",
                                                   "NOx" = "nox",
                                                   "PN" = "pn",
                                                   "PP" = "pp",
                                                   "Secchi" = "secchi",
                                                   "TSS" = "tss"))
                           )
                           
                    ),
                    mainPanel(
                      
                      DT::dataTableOutput("table1")
                    )),
           tabPanel("Constituent Comparison (across Regions)",
                    fluidRow(
                      h4("Please select a Plot Type, one or more NRM regions and WQ constituents."),
                      h5("(Information on plot types is located in the tabs above the map.)"),

                      column(4, selectInput("ind_plot_type3", "Plot Type:", 
                                            choices = c("Power Curves", "Comparison (Pre/Post)", "Comparison (Sites/Samples)"))),
                      column(4, checkboxGroupInput("NRM_region2", "NRM Region:", 
                                                   c("Burdekin", "Mackay Whitsunday",
                                                     "Wet Tropics - Russell-Mulgrave", 
                                                     "Wet Tropics - Tully" ))),
                      column(4, checkboxGroupInput("constituent2", "Constituents:",
                                                   c("Chl-a" = "chla",
                                                     "NOx" = "nox",
                                                     "PN" = "pn",
                                                     "PP" = "pp",
                                                     "Secchi" = "secchi",
                                                     "TSS" = "tss"))
                             )
                             
                      ),
                      mainPanel(
                        
                        DT::dataTableOutput("table2")
                      )
                      
                    )
                    
           )
           )
  )
  
)
