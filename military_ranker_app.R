library(shiny)
library(tidyverse)
library(formattable)
library(DT)
library(reshape)
library(naptime)


scr_data <- read.csv('F:\\Work\\MLprojects\\R\\R_Military_Ranker\\military_expenditure.csv', stringsAsFactors = F)

data <- scr_data %>%
  select(c(1:3,ncol(scr_data)))




all.countries <- 
  data %>%
  filter(Type == 'Country')
head(all.countries)

countries <- all.countries %>%
  filter(!is.na(X2018))

countries$rank <- rank(-countries$X2018)

# cat('See your country\'s ranking in Military Spending')
# code <- toupper(readline(prompt='Enter your country code:'))
# if (!Input$text1 %in% countries$Code){
#   cat('Sorry, Your Country did not report its Military Spending')
# } 
# rank<- countries[countries$Code == code, 5]

# cat('Your country ranking is:', rank)

# ============================== WebApp =====================================

ui <- fluidPage(
  tags$head(
    tags$style(HTML("
      body {
        background-color: #2d5bb4;
        color: white;
        margin:190px 200px;
        text-align:center;
        overflow:hidden;
      }
      #text1{
      font-weight:bold;
      text-align: center;
      }
      #subtitle{
        margin:20px 0;
        font-size:25px;
      }
      #support{
        margin: 40px 0;
        font-size:25px;
        color:#CEDAF3;
      }
      #txtout{
        font-size:30px;
        font-family: arial;
        background: none;
        border: none;
        color:white;
        overflow: hidden;
        height: 150px;
      }
      a{
       color:#2d5bb4;
       text-decoration:none;
       transition: .3s;
       background: white;
       border-radius: 5px;
       padding:3px 5px;
       shadow: 3px 3px 1px;
       
      }
      a:hover{
        color: white;
        shadow:none;
        background: #2d5bb4;
        text-decoration: none;
      }
"))),
  
  fluidRow(
    column(12, 
           align='center',
          tags$h1('Welcome to Military Expenditure Ranker'),
          tags$div('A Simple Web App Based on R', id='subtitle'),
          textInput('text1', 'Enter country alpha-3 code', ''),
          tags$div('Support Me and Upvote', tags$br(), 'Back to Kernel From', tags$a(href='www.rstudio.com', 'Here'), id='support'),
          verbatimTextOutput('txtout')  
)))

server <- function(input, output, session) {
  
  code<- reactive({toupper(input$text1)})
  
  output$txtout <- renderText({
    if (code() %in% countries$Code){
      naptime(.5)
      countries[countries$Code == code(), 5]
    } else if(code()==''){
      ''
    }else if (!code() %in% countries$Code){
      naptime(.5)
      'Sorry, Your Country did not \n report its Military Spending'
    # }else if(length(code())!=3){
    #   'It Should Be a Alpha-3 Code (3 letters)'
    }
    
  })
  
}

shinyApp(ui, server)