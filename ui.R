#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.


library(shiny)
library(ggplot2)
library(dplyr)

# Define UI for application 
fluidPage(

    # Application title
    titlePanel("2020 Canadian employment income by group"),

    # Sidebar
    sidebarLayout(
        sidebarPanel(
                numericInput("select_salary", 
                             label = "Income reference line (thousands)", 
                             value = 50, 
                             min=0,
                             max=1000,
                             width = "70%"),
                
                p("Appears on the graph as a dotted line with corresponding percentile for each group (max. value is 1M).", 
                  style="color: gray; font-size:0.9em; font-style:italic; margin-bottom:2em"),
                
                radioButtons("variable",
                             label = "Grouping variable",
                             choiceNames = c("Citizenship", "Gender", "Home ownership", "First official language spoken"),
                             choiceValues = c("Citizen", "Gender", "TENUR", "FOL"),
                             inline = FALSE),
        

                p("Boxplots are based on all data but income above 200K is hidden by default. 
                  You may change the display threshold below.",
                        style="margin-top: 3em; color:gray; font-size:0.9em; font-style:italic;"),
        
                numericInput("cutoff",
                             label = "Max. income displayed (thousands)",
                             value = 200,
                             min = 0,
                             max = 1000,
                             width = "70%")
        ,width=3),
        
        # Show a plot of the generated distribution
        mainPanel(
            plotOutput("plot1")
        )
    )
)
