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
                 # uiOutput("data_helper"),
                  uiOutput('tx_dt_fmt_ui'),
                  uiOutput('tx_amt_ui_1'),
                  sliderInput("rfm_bin","RFM bin",min = 3,max = 8,value = 4,step = 1),
                  actionButton("cal_rfm","Calculate RFM")
        ),
        conditionalPanel(condition = "input.tabselected==4",
                         h5("Select CLV plot parameters"),
                         numericInput("d_bin",
                                      label = "No of bins",
                                      min = 20,
                                      max=300,
                                      value=50),
                         checkboxInput('fac',"Show Group By Plots"),
                         uiOutput("fac_plot_ui"),
                         hr(),
                         selectInput("pl_sel","RFM Plots",choices = list("Recency, Frequency and Monetary (Histogram)"="hs",
                                                                    "Recencey vs Monetary (Scatter)" = "rm",
                                                                    "Frequency vs Monetary (Scatter)" = "fm",
                                                                    "Recency vs Freq vs Monetary (Heat Map)" = "hm",
                                                                    "Recency vs Freq vs Monetary (Bar Plot)" = "bp"))
                         ),
        conditionalPanel(condition = "input.tabselected==3",
                   sliderInput("churn_thresh","Churn Threshold (ret_rate_it)",min = 0.5,max = 0.99,value = 0.75,step = 0.01),
                   sliderInput("dis_rate","Discount Rate (discount_rate in formula)",min=0.01,max=0.20,value = 0.1,step=0.01),
                   numericInput("pro_mar","Profit Margin ((gross_margin in formula)",min = 0,max=1,value = 0.1,step = 0.01),
                   actionButton("cal_clv","Calculate CLV")
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
                   # h4("Missingness Map"),
                   # plotOutput("miss_plot")
                    
            ),
            tabPanel("RFM", value=2,
                     h4("Dimensions"),
                     verbatimTextOutput("rfm_dim"),
                     hr(),
                     h4("Download Scores"),
                     downloadButton("rfm_dwnld","Download"),
                     hr(),
                     h4("RFM DF"),
                     dataTableOutput("rfm_df"),
                     hr()
                    
                     
                     
            ),
            tabPanel("CLV",value=3,
                     h4("CLV Formula"),
                     img(src = "clv1.png"),
                     hr(),
                     h4("Dimensions"),
                     verbatimTextOutput("clv_dim"),
                     h4("Download Scores"),
                     downloadButton("clv_dwnld","Download"),
                     hr(),
                     h4("CLV DF"),
                     dataTableOutput("clv_df"),
                     hr()
            ),
            tabPanel("Plots",value=4,
                     h4("CLV summary stats"),
                     verbatimTextOutput("clv_sum"),
                     h4("Distribution of CLV"),
                     plotOutput("clv_plot"),
                     hr(),
                     h4("Exploratory Data Analysis of RFM Table"),
                     plotOutput("rfm_plot")
        
                     
            ),
            id = "tabselected"
        )
    )
))

