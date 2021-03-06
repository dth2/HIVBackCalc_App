library(shiny)

shinyUI(
  navbarPage('HIV Backcalculation',
             
             tabPanel('Load Data',
             
                 sidebarLayout(
                   fluid=FALSE,
                   sidebarPanel(
                     h5('Welcome'),
                     p('This app runs the HIV back-calculation model developed by Ian Fellows et al 
                       on a dataset of your choice.'),
                     h5('Data File'),
                     p('Select either the example dataset, or upload your own.'),
                     fileInput('file1', 'Choose CSV File',
                               accept=c('text/csv', 
                                        'text/comma-separated-values,text/plain', 
                                        '.csv')),
                     tags$hr(),
                     checkboxInput('header', 'Header', TRUE),
                     radioButtons('sep', 'Separator',
                                  c(Comma=',',
                                    Semicolon=';',
                                    Tab='\t'),
                                  ','),
                     radioButtons('quote', 'Quote',
                                  c(None='',
                                    'Double Quote'='"',
                                    'Single Quote'="'"),
                                  '"')                 
                   ),
                   mainPanel(
                     h5('File Contents'),
                     p('The first 10 rows are displayed to confirm the successful selection/
                       upload of your data. Please proceed to the "Examine Data" section next.'),
                     tableOutput('data_10rows')
                   )
                 )
             ),
             tabPanel('Examine Data',
                tabsetPanel('Summary Tabs',
                tabPanel('Overview',
                   h5('Description of sample by age, race and mode of transmission'),
                   tableOutput('describe_sample')
                ),
                tabPanel('Diagnoses',
                   h5('Reported number of diagnosed cases over time'),
                   plotOutput('diagnoses_plot')
                ),
                tabPanel('Testing Histories',
                   h5('Testing history responses over time'),
                   p('When asked "Have you ever had a prior negative test?", cases could report "Yes", "No", or not answer the question'),
                   plotOutput('testinghistories_plot')
                )
                )),
             tabPanel('Calculate TID',
               h5('Time from infection to diagnosis (TID), under three scenarios:'),
               em('1. Base Case'), div('Missing testing history data are considered missing at random and are excluded from calculating the TID. The probability of infection is uniformly distributed between the time of last negative test and time of diagnosis.'),
               br(),
               em('2. Worst Case (Obs)'), div('Missing testing history data are considered missing at random and are excluded from calculating the TID. Infection is assumed to occur immediately following the date of last negative test, a worst case assumption.'),
               br(),
               em('3. Worst Case (Miss)'), div('Missing testing history data are imputed using the assumption that infection occurred either 18 years prior to diagnosis or at age 16, whichever is more recent. For cases with testing history, infection is assumed to occur immediately following the date of last negative test.'),
               br(),
               plotOutput('tid_plot')
             ),
             tabPanel('Backcalculate Infections',
               sidebarLayout(
                  fluid=FALSE,
                  sidebarPanel(
                     h5('Click to backcalculate infections'),
                     actionButton('go', label='Run backcalculation')
                  ),
                  mainPanel(
                     # This accesses the stylesheet, which just sets a 
                     # location for the progress bar. Thanks to:
                     # https://groups.google.com/forum/#!topic/shiny-discuss/VzGkfPqLWkY 
                     # and https://github.com/johndharrison/Seed
                     # tags$link(rel='stylesheet', type='text/css', href='styles.css'),
                     # Update 1/7/15: commented out in order to get withProgress() built into Shiny 0.10.2 to work
                            
                     h5('Results'),
                     em('Note: counts refer to the time period for which diagnoses
                        were reported. In the KC data, this time period is a 
                        quarter-year.'),
                     br(),
                     br(),
                     p('The plot below shows the reported diagnoses over time with
                       the estimated incidence counts for each of the three TID cases 
                       (top panel). The bottom panel shows the estimated undiagnosed
                       counts over time for each of the three TID cases.'),
                     plotOutput('results_plot'),
                     p('The table below summarizes reported diagnoses, estimated 
                       incidence for the three TID cases, and estimated undiagnosed
                       counts for the three TID cases across all time periods'),
                     tableOutput('results_table')
                  )
               )
             ),
             tabPanel('Help')
             )

)
