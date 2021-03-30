library(shiny)
library(leaflet)
library(ggplot2)



server <- function(input, output){
  

  
  
  load("data/mmp_data.RData")

  #------------------------ Loading modal to keep user out of trouble while map draws ---------------------------------#
  
  # 
  showModal(modalDialog(title = "MAP LOADING - PLEASE WAIT...","Please wait for map to draw. Then click outside this area.",
                        size = "l", footer = NULL, easyClose = TRUE))
  
  
  
  
  #------------------------------------- Producing the Map -----------------------------------------#
  
  output$map <- renderLeaflet({
    leaflet()  %>% addTiles() %>% 
      setView(lng = 148, lat = -20, zoom = 6) %>% 
      addPolygons(data = shapeData_NRM, weight = 2, col = 'green') %>% 
      addPolygons(data = shapeData_NRMB, weight = 2, col = 'green') %>% 
      addPolygons(data = shapeData_GBRMPB, weight = 2, col = 'blue') %>% 
      addCircleMarkers(data = nrm_df, lng = ~long, lat = ~lat,radius = 5, 
                       color = "orange", fillOpacity = 1, label = ~region, 
                       layerId = ~region) 
    
  })
  
  # adding to it after selection
  observeEvent(input$NRM_region2, {
    
    id <- match(input$NRM_region2, nrm_df$region)
    loc_on <- nrm_df[id,]
    loc_off <- nrm_df[-id,]
    

    leafletProxy("map") %>%
      addCircleMarkers(data = loc_on, lng = ~long, lat = ~lat,radius = 5, 
                       color = "red", fillOpacity = 1, label = ~region, 
                       layerId = ~region) %>%
      addCircleMarkers(data = loc_off, lng = ~long, lat = ~lat,radius = 5, 
                     color = "orange", fillOpacity = 1, label = ~region, 
                     layerId = ~region) 
    
  })
  
  # adding to it after selection
  observeEvent(input$map_marker_click, {
    

    
    loc_on <- data.frame(lat = input$map_marker_click$lat,
                      long = input$map_marker_click$lng,
                      region = input$map_marker_click$id)
    id <- match(loc_on$region, nrm_df$region)
    loc_off <- nrm_df[-id,]
 
    
    leafletProxy("map") %>%
      addCircleMarkers(data = loc_on, lng = ~long, lat = ~lat,radius = 5, 
                       color = "red", fillOpacity = 1, label = ~region, 
                       layerId = ~region) %>%
      addCircleMarkers(data = loc_off, lng = ~long, lat = ~lat,radius = 5, 
                     color = "orange", fillOpacity = 1, label = ~region, 
                     layerId = ~region) 
    
    
  })
  
  
  #------------------------ Reactive call that only renders images for selected checkboxes ----------------------------------#
 
  
  # checkbox - constituent (tab 2)
  cb_const_tab2 <- eventReactive(input$constituent, {
    
    c_check <- list(input$constituent)
    if (is.null(c_check)){return()}
    
    
    
  })
  
  # checkbox - constituent (tab 3)
  cb_const_tab3 <- eventReactive(input$constituent2, {
    
    c_check <- list(input$constituent2)
    if (is.null(c_check)){return()}
    
    
    
  })
  
  # checkbox - NRM region
  cb_nrm_tab3 <- eventReactive(input$NRM_region2, {
    
    c_check <- list(input$NRM_region2)
    if (is.null(c_check)){return()}
    
    
    
  })
  
  
  # observe the click on a map
  xxchange <- eventReactive(input$map_marker_click, {
    
    site_click <- input$map_marker_click
    if (is.null(site_click)){return()}
    siteid <- site_click$id
    siteid
    
  })
  
  #------------------------------- First Tab: Single figures  ---------------------------------#
  
  
  output$wqImage <- renderUI({
    
    xxchange()
    
    if(input$ind_const == "Chl-a" & input$ind_plot_type1 == "Power Curves")
      fig_nm <- paste0("crayon_all_pre_post_", input$map_marker_click$id, "_Chl-a.png")
    else
      if(input$ind_const == "Chl-a" & input$ind_plot_type1 == "Comparison (Pre/Post)")
        fig_nm <- paste0("all_regions_global_power_at_pt1_pre_vs_post_two_way_",
                         input$map_marker_click$id, "_Chl-a.png")
      else
        if(input$ind_const == "Chl-a" & input$ind_plot_type1 == "Comparison (Sites/Samples)")
          fig_nm <- paste0("all_regions_global_power_at_pt1_sites_vs_samples_",
                           input$map_marker_click$id, "_Chl-a.png")
        else
          if(input$ind_const == "Chl-a" & input$ind_plot_type1 == "Monitoring Data")
            fig_nm <- paste0(input$map_marker_click$id, 
                             "_CHL_QAQC_averaged_rep_depth.png")
          else
            if(input$ind_const == "Chl-a" & input$ind_plot_type1 == "Time to Exceedance")
              fig_nm <- paste0(input$map_marker_click$id, 
                               "_CHL_QAQC_power_to_guidelines.png")
        else
          if(input$ind_const == "NOx" & input$ind_plot_type1 == "Power Curves")
            fig_nm <- paste0("crayon_all_pre_post_", input$map_marker_click$id, "_NOx.png")
          else
            if(input$ind_const == "NOx" & input$ind_plot_type1 == "Comparison (Pre/Post)")
              fig_nm <- paste0("all_regions_global_power_at_pt1_pre_vs_post_two_way_",
                               input$map_marker_click$id, "_NOx.png")
            else
              if(input$ind_const == "NOx" & input$ind_plot_type1 == "Comparison (Sites/Samples)")
                fig_nm <- paste0("all_regions_global_power_at_pt1_sites_vs_samples_",
                                 input$map_marker_click$id, "_NOx.png")
              else
                if(input$ind_const == "NOx" & input$ind_plot_type1 == "Monitoring Data")
                  fig_nm <- paste0(input$map_marker_click$id, 
                                   "_NOX_QAQC_averaged_rep_depth.png")
                else
                  if(input$ind_const == "NOx" & input$ind_plot_type1 == "Time to Exceedance")
                    fig_nm <- paste0(input$map_marker_click$id, 
                                     "_NOX_QAQC_power_to_guidelines.png")
              else
                if(input$ind_const == "PN" & input$ind_plot_type1 == "Power Curves")
                  fig_nm <- paste0("crayon_all_pre_post_", input$map_marker_click$id, "_PN.png")
                else
                  if(input$ind_const == "PN" & input$ind_plot_type1 == "Comparison (Pre/Post)")
                    fig_nm <- paste0("all_regions_global_power_at_pt1_pre_vs_post_two_way_",
                                     input$map_marker_click$id, "_PN.png")
                  else
                    if(input$ind_const == "PN" & input$ind_plot_type1 == "Comparison (Sites/Samples)")
                      fig_nm <- paste0("all_regions_global_power_at_pt1_sites_vs_samples_",
                                       input$map_marker_click$id, "_PN.png")
                    else
                      if(input$ind_const == "PN" & input$ind_plot_type1 == "Monitoring Data")
                        fig_nm <- paste0(input$map_marker_click$id, 
                                         "_PN_SHIM_QAQC_averaged_rep_depth.png")
                      else
                        if(input$ind_const == "PN" & input$ind_plot_type1 == "Time to Exceedance")
                          fig_nm <- paste0(input$map_marker_click$id, 
                                           "_PN_SHIM_QAQC_power_to_guidelines.png")
                      
                    else
                      if(input$ind_const == "PP" & input$ind_plot_type1 == "Power Curves")
                        fig_nm <- paste0("crayon_all_pre_post_", input$map_marker_click$id, "_PP.png")
                      else
                        if(input$ind_const == "PP" & input$ind_plot_type1 == "Comparison (Pre/Post)")
                          fig_nm <- paste0("all_regions_global_power_at_pt1_pre_vs_post_two_way_",
                                           input$map_marker_click$id, "_PP.png")
                        else
                          if(input$ind_const == "PP" & input$ind_plot_type1 == "Comparison (Sites/Samples)")
                            fig_nm <- paste0("all_regions_global_power_at_pt1_sites_vs_samples_",
                                             input$map_marker_click$id, "_PP.png")
                          else
                            if(input$ind_const == "PP" & input$ind_plot_type1 == "Monitoring Data")
                              fig_nm <- paste0(input$map_marker_click$id, 
                                               "_PP_QAQC_averaged_rep_depth.png")
                            else
                              if(input$ind_const == "PP" & input$ind_plot_type1 == "Time to Exceedance")
                                fig_nm <- paste0(input$map_marker_click$id, 
                                                 "_PP_QAQC_power_to_guidelines.png")
                          else
                            if(input$ind_const == "Secchi" & input$ind_plot_type1 == "Power Curves")
                              fig_nm <- paste0("crayon_all_pre_post_", input$map_marker_click$id, "_Secchi.png")
                            else
                              if(input$ind_const == "Secchi" & input$ind_plot_type1 == "Comparison (Pre/Post)")
                                fig_nm <- paste0("all_regions_global_power_at_pt1_pre_vs_post_two_way_",
                                                 input$map_marker_click$id, "_Secchi.png")
                              else
                                if(input$ind_const == "Secchi" & input$ind_plot_type1 == "Comparison (Sites/Samples)")
                                  fig_nm <- paste0("all_regions_global_power_at_pt1_sites_vs_samples_",
                                                   input$map_marker_click$id, "_Secchi.png")
                                else
                                  if(input$ind_const == "Secchi" & input$ind_plot_type1 == "Monitoring Data")
                                    fig_nm <- paste0(input$map_marker_click$id, 
                                                     "_Secchi_DEPTH_averaged_rep_depth.png")
                                  else
                                    if(input$ind_const == "Secchi" & input$ind_plot_type1 == "Time to Exceedance")
                                      fig_nm <- paste0(input$map_marker_click$id, 
                                                       "_SECCHI_DEPTH_power_to_guidelines.png")  
                                else
                                  if(input$ind_const == "TSS" & input$ind_plot_type1 == "Power Curves")
                                    fig_nm <- paste0("crayon_all_pre_post_", input$map_marker_click$id, "_TSS.png")
                                  else
                                    if(input$ind_const == "TSS" & input$ind_plot_type1 == "Comparison (Pre/Post)")
                                      fig_nm <- paste0("all_regions_global_power_at_pt1_pre_vs_post_two_way_",
                                                       input$map_marker_click$id, "_TSS.png")
                                    else
                                      if(input$ind_const == "TSS" & input$ind_plot_type1 == "Comparison (Sites/Samples)")
                                        fig_nm <- paste0("all_regions_global_power_at_pt1_sites_vs_samples_",
                                                         input$map_marker_click$id, "_TSS.png")
                                      else
                                        if(input$ind_const == "TSS" & input$ind_plot_type1 == "Monitoring Data")
                                          fig_nm <- paste0(input$map_marker_click$id, 
                                                           "_TSS_QAQC_averaged_rep_depth.png")
                                        
                                        else
                                          if(input$ind_const == "TSS" & input$ind_plot_type1 == "Time to Exceedance")
                                            fig_nm <- paste0(input$map_marker_click$id, 
                                                             "_TSS_QAQC_power_to_guidelines.png")
                                      else
                                        fig_nm <- ""
                                      
                                  
                                      if(input$ind_plot_type1 == "Time to Exceedance"){
                                        tags$div(
                                          tags$img(src=fig_nm, contentType = 'image/png', height = 600),
                                          tags$script(src="titlescript.js")
                                        )
                                      }
                                      else if(input$ind_plot_type1 == "Monitoring Data"){
                                        tags$div(
                                          tags$img(src=fig_nm, contentType = 'image/png', height = 500),
                                          tags$script(src="titlescript.js")
                                        )
                                      }
                                      else{
                                        tags$div(
                                          tags$img(src=fig_nm, contentType = 'image/png', height = 400),
                                          tags$script(src="titlescript.js")
                                        )
                                      }
  })
  
  
  #------------------------------- Second Tab: Constituent Comparison (by Region) ---------------------------------#
  
    # 
    output$table1 <- DT::renderDataTable({
  

    xxchange()
    cb_const_tab2()
    imgfr <- sapply(input$constituent, function(x){

      if(x == "chla") 
        chunk <- "_Chl-a.png"
      else
        if(x == "nox")
          chunk <- "_NOx.png"
      else
        if(x == "pn")
          chunk <- "_PN.png"
      else
        if(x == "pp")
          chunk <- "_PP.png"
      else
        if(x == "secchi")
          chunk <- "_Secchi.png"
      else
        if(x == "tss")
          chunk <- "_TSS.png"
        
      if(input$ind_plot_type2 == "Comparison (Pre/Post)")
        prefix <- "all_regions_global_power_at_pt1_pre_vs_post_two_way_"
      else if(input$ind_plot_type2 == "Power Curves")
        prefix <- "crayon_all_pre_post_"
      else if(input$ind_plot_type2 == "Comparison (Sites/Samples)")
        prefix <- "all_regions_global_power_at_pt1_sites_vs_samples_"
 
        
      file_nm <- paste0(prefix, input$map_marker_click$id, chunk)
   
   file_nm
    })

    len <- length(imgfr)
    if(((len/2) %% 1) != 0)
        dat <- data.frame(matrix(c(imgfr, ""), byrow = TRUE, ncol = 2, nrow = ceiling(length(imgfr)/2)))
    else
       dat <- data.frame(matrix(imgfr, byrow = TRUE, ncol = 2, nrow = ceiling(length(imgfr)/2)))
  
    dat_img <- apply(dat, 1, function(x){
      sapply(x, function(y){
          if(y != ""){
              paste0("<img src='", y, "', contentType = 'image/png', height = 400 ></img>")
          }
          else
            paste("")
        }
    )
    })

    dat_img <- t(dat_img)
    names(dat_img) <- ""
  
     DT::datatable(dat_img, escape = FALSE, rownames = NULL, colnames = '')
  
  })

    #-------------------------------Third Tab: Constituent Comparison (across Regions) ---------------------------------#
    
    output$table2 <- DT::renderDataTable({
      
      
      cb_const_tab3()
      cb_nrm_tab3()
      
      imgfr1 <- sapply(input$constituent2, function(x){
        
        if(x == "chla") 
          chunk <- "_Chl-a.png"
        else
          if(x == "nox")
            chunk <- "_NOx.png"
          else
            if(x == "pn")
              chunk <- "_PN.png"
            else
              if(x == "pp")
                chunk <- "_PP.png"
              else
                if(x == "secchi")
                  chunk <- "_Secchi.png"
                else
                  if(x == "tss")
                    chunk <- "_TSS.png"
                  
                  browser()
                 chunk
      })
      imgfr2 <- sapply(input$NRM_region2, function(x, chunk){
        
        if(input$ind_plot_type3 == "Comparison (Pre/Post)")
                    prefix <- "all_regions_global_power_at_pt1_pre_vs_post_two_way_"
                  else if(input$ind_plot_type3 == "Power Curves")
                    prefix <- "crayon_all_pre_post_"
                  else if(input$ind_plot_type3 == "Comparison (Sites/Samples)")
                    prefix <- "all_regions_global_power_at_pt1_sites_vs_samples_"
                  
                  
                  file_nm <- paste0(prefix, x, chunk)
                  file_nm
      }, imgfr1)
      
      len <- length(imgfr2)
      
      if(((len/2) %% 1) != 0)
        dat <- data.frame(matrix(c(imgfr2, ""), byrow = TRUE, ncol = 2, nrow = ceiling(length(imgfr2)/2)))
      else
        dat <- data.frame(matrix(imgfr2, byrow = TRUE, ncol = 2, nrow = ceiling(length(imgfr2)/2)))
      dat_img <- apply(dat, 1, function(x){
        sapply(x, function(y){
          if(y != "")
            paste0("<img src='", y, "', contentType = 'image/png', height = 400 ></img>")
          else
            paste("")
        }
        
        )
      }
      )

      dat_img <- t(dat_img)
      names(dat_img) <- ""
      
      DT::datatable(dat_img, escape = FALSE, rownames = NULL, colnames = '')
    })
    
    
  
  #--------------------- Documentation ----------------------------------------#
    
    output$userguide <- renderUI({
      inclRmd("./docs/userguide.Rmd")
    })

    output$ack <- renderUI({
      inclRmd("./docs/ack.Rmd")
    })
    
    output$wqparms <- renderUI({
      inclRmd("./docs/WQdesc.Rmd")
    })
    
    output$figdesc <- renderUI({
      inclRmd("./docs/FigureDesc.Rmd")
    })
    

  
} 