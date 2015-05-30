#ui.R
library(shiny)
library(shinydashboard)

header <- dashboardHeader(
  title = 'Safer!'
)


body <- dashboardBody(
  fluidPage(
  titlePanel("Changing the values of inputs from the server"),
  fluidRow(
    column(3, tabPanel(
      h4("Tell us know more about you"),
      textInput("in_txt_PC",
                "Please type your post code:",
                "Home Post code"),
      numericInput("control_num",
                  "How many floors does your home have?",
                  min = 1, max = 20, value = 1),
      checkboxInput('nest_check','Do you have a Nest product?',value=FALSE)
    )),
    
    column(5, tabPanel(
      h4("These are the house risks you face"),
      infoBoxOutput("risk1",width=NULL),
      infoBoxOutput("risk2",width=NULL),
      infoBoxOutput("risk3",width=NULL)
    )),
    
    column(4,
           tabPanel(
             h4("These are  the types of cover you should choose"),
             infoBoxOutput('quote1',width=NULL)
           )
        )
    )
  )
)

dashboardPage(
  header,
  dashboardSidebar(disable=TRUE
#     conditionalPanel(
#       condition = "input.tabvals == 1",
#       sliderInput('slider1','Slider for tab1:',min=1,max=3000,value=30),
#       sliderInput('slider2','2nd Slider for tab1:',min=1,max=3000,value=300)
#     ),
#     conditionalPanel(
#       condition = "input.tabvals == 2",
#       sliderInput('slider3','Slider for tab2:',min=1,max=1000,value=10), 
#       sliderInput('slider4','2nd Slider for tab2:',min=1,max=1000,value=500)
#     ),
#     conditionalPanel(
#       condition = "input.tabvals == 3",
#       sliderInput('slider5','Slider for tab3:',min=1,max=3000,value=30),
#       sliderInput('slider6','2nd Slider for tab3:',min=1,max=3000,value=30)
#     )
  ),
  body
)

