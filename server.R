#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)

# Define server logic required to draw a histogram
function(input, output, session) {
        
        load("census_data_2021.Rda")
        
        output$plot1 <- renderPlot({
                
                mycols <- c("EmpIn", input$variable)
                max_disp_sal <- input$cutoff
                
                display_df <- census_subset_2021 %>%
                        select(one_of(mycols)) %>%
                        rename(Group = 2) # Change second column name to 'Group'
                
                pctl <- NULL
                for (i in levels(display_df$Group)) {
                        df_filtered <- filter(display_df, Group == i)
                        pctl <- c(pctl,round(ecdf(df_filtered$EmpIn)(input$select_salary*1000),2))
                }
                
                intersects <- data.frame(Group=levels(display_df$Group)) %>%
                        mutate(input_salary=input$select_salary) %>%
                        mutate(percentile=pctl)
                
                ggplot(NULL, aes()) +
                        geom_boxplot(data=display_df, aes(x=Group, y=EmpIn/1000, color=Group)) + 
                        coord_cartesian(ylim = c(-70, max_disp_sal)) +
                        geom_hline(yintercept=input$select_salary, linetype="dashed", color="slategrey") +
                        geom_point(data=intersects, aes(x=Group, y=input_salary)) +
                        geom_text(data=intersects, aes(x=Group, y=input_salary, label=percentile), hjust=-0.3, vjust=-0.5) +
                        xlab("Group") +
                        ylab("Employment income (thousands)") +
                        labs(title="Income by selected variable, ages 18-69",
                             caption="2020 employment income from 2021 Census of Canada Public Use Microdata, 
                             freely available at https://hdl.handle.net/11272.1/AB2/1WTDOP. Consult the
                             user guide for variable definitions and details.") + 
                        theme_light(base_size=15) +
                        theme(plot.margin = unit(c(1,0,0,0), "cm"),
                              axis.title.x=element_blank(),
                              axis.text.x=element_blank(),
                              axis.ticks.x=element_blank()) +
                        scale_colour_brewer(palette = "Dark2")
              #          theme(legend.position="bottom")
                
        }, height=500)  


}
