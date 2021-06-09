options(shiny.maxRequestSize=50*1024^2)
#observe_helpers(help_dir = "helper", withMathJax = TRUE)


shinyServer(function(input, output,session) {
  
#-----Data upload----#
  df_data <- reactive({
    req(input$file)
    df = fread(input$file$datapath,header = TRUE)
    
  })
  
#--------------------------1.Data Summary Tab------------------------------------#

  #1.Side bar Panel UI O/P
  cols <- reactive({colnames(df_data())})
  
  output$cid_ui <- renderUI({
    req(input$file)
      selectizeInput("cid","Select Customer ID",choices = cols(),multiple = FALSE)
  })
  
  output$tx_id_ui <- renderUI({
    req(input$file)
    remove <- c(input$cid)
    tx_id_cols <- cols()[!cols() %in% remove]
    selectInput("tx_id","Select Transaction ID",choices = tx_id_cols,multiple = FALSE)
  })
  
  output$tx_dt_ui <- renderUI({
    req(input$file)
    remove <- c(input$cid,input$tx_id)
    tx_dt_cols <- cols()[!cols() %in% remove]
    selectInput("tx_dt","Select Transaction Date",choices = tx_dt_cols,multiple = FALSE)
  })
  
  output$tx_dt_fmt_ui <- renderUI({
    req(input$file)
    textInput("dt_fmt",label = "Enter date format")
  })
 
  output$tx_amt_ui_1 <- renderUI({
    req(input$file)
    remove <- c(input$cid,input$tx_id,input$tx_dt)
    tx_amt_cols <- cols()[!cols() %in% remove]
    selectInput("tx_amt","Select Transaction Amount",choices = tx_amt_cols,multiple = FALSE)
  })

  
  #--1.Main Panel O/P
  # 1. dimension
  output$dim <- renderPrint({
    cat("Uploaded dataset has ",dim(df_data())[1],"rows and ",dim(df_data())[2]," columns")
  })
  
  # 2. sample data
  output$samp_data <- renderDataTable({
    head(df_data(),5)
  })
  
  # 3. missing plot
  # output$miss_plot <- renderPlot({
  #   req(input$file)
  #   Amelia::missmap(df_data())
  # })

#--------------------------2.RFM Tab------------------------------------#
  # output$data_helper <- renderUI({
  #   
  #   helper(shiny_tag = "",
  #          icon = "question",
  #          colour = "green",
  #          type = "markdown",
  #          content = "diabetes"
  #   )
  # })
  # 
  rfm_df <- eventReactive(input$cal_rfm,{
    progress <- Progress$new(session, min=1, max=10)
    progress$set(value=3,"Preparing data")
    Sys.sleep(3)
    ## UI inputs for RFM
    df_data1 <- as.data.frame(df_data())
    fac_cols <- c(input$cid,input$tx_id)
    df_data1[fac_cols] <- lapply(df_data1[fac_cols], factor)
    custID_ui =  df_data1[,input$cid]  # from UI, make `as.factor()`
    txnID_ui = df_data1[,input$tx_id]  # from UI, make `as.factor()`
    txn_amount_ui = as.numeric(df_data1[,input$tx_amt])  # from UI, make `as.numeric()`
   # date_format = "%m/%d/%Y %H:%M" # from UI. Tough but will ask folks do this. 
    date_format <- input$dt_fmt
    print(date_format)
    txn_date_ui = as.Date(df_data1[,input$tx_dt], date_format)
    
    rfm_bins_num = input$rfm_bin # from UI. Drop-down from 3 to 8
    progress$set(value=5,"Please wait.. calculating RFM scores")
    df0_rfm = get_rfm_df(custID_ui=custID_ui, 
                         txnID_ui = txnID_ui,
                         txn_amount=txn_amount_ui, 
                         txn_date_ui = txn_date_ui,
                         rfm_bins_num=rfm_bins_num)
    progress$set(value=10,"Scores calculated")
    on.exit(progress$close())
    df0_rfm
  })
  
  output$rfm_df <- renderDataTable({
    req(input$file)
    rfm_df()$rfm
  })
  
  output$rfm_dim <- renderText({
    req(input$file)
    size <- dim(rfm_df()$rfm)  
    paste0("Dimensions of RFM Scores table are ",size[1]," (rows) "," X ",size[2]," (columns)")
  
  })
  
  output$rfm_dwnld <- downloadHandler(
    filename = function() { paste(str_split(input$file$name,"\\.")[[1]][1],"_rfm_score.csv",collapse = " ") },
    content = function(file) {
      write.csv(rfm_df()$rfm, file,row.names=FALSE)
    }
  )
  
  #-- Plots tab---#
  output$clv_sum <- renderPrint({
    summary(clv_df()$CLV)
  })
  output$fac_plot_ui <- renderUI({
    if(input$fac){
      selectInput('fac_ip',"Select Group By Variable",
                  choices = list("R_Score" = "R_Score",
                                 "F_Score" = "F_Score",
                                 "M_Score" = "M_Score"),selected = "R_Score")
    }else{
      NULL
    }
  })
  
  output$clv_plot <- renderPlot({
    req(input$file)
    df1 <- clv_df()
    if(input$fac){
        df1[,input$fac_ip] <- as.factor(df1[,input$fac_ip])
        ggplot(df1, aes(x = CLV)) +
        geom_histogram(fill = "darkblue", colour = "darkblue",bins = input$d_bin) +
        facet_grid(~get(input$fac_ip) ~ ., scales = "free")+ggtitle(paste0("Distribution of CLV grouped by ", input$fac_ip))
    }else{
      ggplot(df1, aes(x = CLV)) +
        geom_histogram(fill = "darkblue", colour = "darkblue",bins = input$d_bin) +
        ggtitle("")
    }
  })
  
  
  output$rfm_plot <- renderPlot({
    req(input$file)
    rfm_result <- rfm_df()
    
    if(input$pl_sel == "hs"){
      rfm_histograms(rfm_result) 
    }
    if(input$pl_sel == "rm"){
      rfm_rm_plot(rfm_result) 
    }
    if(input$pl_sel == "fm"){
      rfm_fm_plot(rfm_result) 
    }
    if(input$pl_sel == "hm"){
      rfm_heatmap(rfm_result) 
    }
    if(input$pl_sel == "bp"){
      rfm_bar_chart(rfm_result) 
    }
    
    
  })
  
  output$sum_ht <- renderText({
    summary(rfm_df()$rfm) %>% 
           kable() %>% 
           kable_minimal()
  })
  #---CLV Tab---#
  
  clv_df <- eventReactive(input$cal_clv,{
    
    df0_rfm <- rfm_df()$rfm
    clv_df <- calc_clv(df0_rfm,
                       churn_thresh_ui = input$churn_thresh, 
                       discount_rate_ui = input$dis_rate, 
                       profit_margin_ui = input$pro_mar
                       )
    
    clv_df
  })
  
  output$clv_df <- renderDataTable({
    req(input$file)
    clv_df()
  })
  
  output$clv_dim <- renderText({
    req(input$file)
    size <- dim(clv_df())  
    paste0("Dimensions of CLV Scores table are ",size[1]," (rows) "," X ",size[2]," (columns)")
    
  })
  
  output$clv_dwnld <- downloadHandler(
    filename = function() { paste(str_split(input$file$name,"\\.")[[1]][1],"_clv_score.csv",collapse = " ") },
    content = function(file) {
      write.csv(clv_df(), file,row.names=FALSE)
    }
  )
  
  
})