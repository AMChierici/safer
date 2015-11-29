#### Example of insurance convenience #####

# source('Documents/safer/InsureTheDice.R')
# ExpSev <- InsureTheDice(3, S=600)
# ExpSev[, SelfInsuredPRM:=600*1/6]
# ExpSev[, PRM:=RiskCost/N]
# ExpSev[, EP.Y1:=1*RiskCost]
# ExpSev[, EP.Y2:=2*RiskCost]
# ExpSev[, EP.Y3:=3*RiskCost]
# ExpSev[, EP.Y4:=4*RiskCost]
# ExpSev[, EP.Y5:=5*RiskCost]
# ExpSev[, EP.Y6:=6*RiskCost]
# ExpSev[, EP.Y7:=7*RiskCost]
# ExpSev[, EP.Y8:=8*RiskCost]
# ExpSev[, EP.Y9:=9*RiskCost]
# ExpSev[, EP.Y10:=10*RiskCost]


library(shiny)
library(shinydashboard)

# Define a server for the Shiny app
server <- function(input, output) {
  
  # Fill in the spot we created for a plot
  output$IndPrmPlot <- renderPlot({
    
    source('InsureTheDice.R')
    ExpSev <- InsureTheDice(input$n, input$p, input$S)
#     ExpSev[, SelfInsuredPRM:=600*1/6]
    ExpSev[, PRM:=RiskCost/N]
    
    # Render a barplot
    barplot(ExpSev[, PRM], 
            main="Individual PRM by No. of insured",
            ylab="PRM (£)",
            xlab="No. of insured",
            ylim=c(0, input$S*input$p*1.2))
    axis(1, at = 1:input$n, labels = 1:input$n, tick = FALSE)
    abline(h=input$p*input$S, col='red')
  })
}

ui <- fluidPage(    
      
      # Give the page a title
      titlePanel("How insurance works"),
      
      # Generate a row with a sidebar
      sidebarLayout(      
        
        # Define the sidebar with one input
        sidebarPanel(
          numericInput("p", "Prob. of event occurring", 1/6),
          numericInput("n", "No. of insured", 10),
          numericInput('S', 'Insured sum', 600),
          helpText("The red line would be the individual PRM if people self-insured themselves")
      ),

        # Create a spot for the barplot
        mainPanel(
          plotOutput("IndPrmPlot")  
        )
        
      )
)

shinyApp(ui, server)


