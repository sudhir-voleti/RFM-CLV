options(shiny.maxRequestSize=50*1024^2)

shinyServer(function(input, output,session) {
  
#-----Data upload----#
  df_data <- reactive({
    req(input$file)
    df = fread(input$file$datapath,header = TRUE)
    
  })
  
#----1.Data Summary Tab

  #1.Side bar Panel UI O/P
  cols <- reactive({colnames(df_data())})
  
  output$cid_ui <- renderUI({
    req(input$file)
      selectInput("cid","Select Customer ID",choices = cols(),multiple = FALSE)
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
 
  output$tx_amt_ui <- renderUI({
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
  output$miss_plot <- renderPlot({
    req(input$file)
    Amelia::missmap(df_data())
  })
  
  
  
})