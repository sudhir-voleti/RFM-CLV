library(dplyr)
shinyUI(fluidPage(
    
    title = "RFM-CLV",
    titlePanel(title=div(img(src="logo.png",align='right'),"RFM-CLV")),
    sidebarPanel(
        
        conditionalPanel(condition = "input.tabselected==1",
                         fileInput("file", "Upload Input file"),               
        ),
        conditionalPanel(condition="input.tabselected==2",
                  uiOutput("cid_ui"),
                  uiOutput('tx_id_ui'),
                  uiOutput('tx_dt_ui'),
                  uiOutput('tx_amt_ui')
        ),
        conditionalPanel(condition = "input.tabselected==3",
                         
        )
        
    ),
    mainPanel(

        tabsetPanel(
            tabPanel("Overview & Example Dataset", value=1, 
                     includeMarkdown("overview.md")
            ),
            tabPanel("Data Summary", value=2,
                    h4("Data Dimensions"),
                    verbatimTextOutput("dim"),
                    hr(),
                    h4("Sample Dataset"),
                    dataTableOutput("samp_data"),
                    hr(),
                    h4("Missingness Map"),
                    plotOutput("miss_plot")
                     
            ),
            tabPanel("RFM", value=3,
                     
                     
                     
            ),
            tabPanel("CLV",value=4,
                    
            ),
            id = "tabselected"
        )
    )
))

