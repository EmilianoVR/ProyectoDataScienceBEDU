library(shiny)
library(DT)
library(shinydashboard)

# Refiere a server.R para usar 'datos' en L19
source("server.R")
source("data/dict_info.R")

# Interfaz
ui <- dashboardPage(
  dashboardHeader(title = "Contaminación atmosférica en México"),  # Título del encabezado
  dashboardSidebar( # Panel lateral
    sidebarMenu( # Menú con pestañas
      menuItem("Tabla", tabName = "table", icon = icon("table")), 
      menuItem("Tab 2", tabName = "tab2", icon = icon("chart-bar")),
      menuItem("Tab 3", tabName = "tab3", icon = icon("chart-bar")),
      menuItem("Tab 4", tabName = "tab4", icon = icon("chart-bar"))
    ),
    dashboardBody(
      tags$head(
        tags$style(HTML("
        .main-header {
          background-color: red;"))
      )
    )
  ),
  dashboardBody( 
    tabItems( # Contenido de las pestañas
      tabItem(tabName = "table", #Pestaña 1
              h2("Tabla"),
              fluidRow( 
                column(2, 
                       # Inputs para seleccionar las columnas
                       checkboxGroupInput("columns", "Selecciona las columnas que quieres ver", choices = variables_interes, selected = variables_interes)
                ),
                column(10, # Columna de ancho 7
                       # Tabla filtrada
                       DT::dataTableOutput("tableData")
                )
              )
      ),
      
      
      tabItem(tabName = "tab2", #Pestaña 3
              h2("Localización de las estaciones"),
              leafletOutput("map")
      ),
      
      tabItem(tabName = "tab3", # Pestaña 3
        h2("Progreso cronológico de presencia de gases en la atmósfera"), 
        fluidPage(
          fluidRow( 
            column(4, #Parte izquierda
                   #INPUT DE VARIABLES
                   selectizeInput("gas_select", "Selecciona una variable", choices = names(dict_gas)),
                   wellPanel(
                     textOutput("gas_info_render"))
          ),
          column(8,
          verticalLayout(
            plotOutput("timePlot"),
            wellPanel(
              sliderInput("timeSlide", 
                          "Rango de tiempo", 
                          min = as.Date("2015-07-01", "%Y-%m-%d"),
                          max = as.Date("2021-12-31", "%Y-%m-%d"),
                          value = c(as.Date("2015-06-01", "%Y-%m-%d"), as.Date("2021-12-31", "%Y-%m-%d")),
                          timeFormat = "%Y-%m-%d",
                          step = 182)
              )
          )))
        )
      ),
      
      # TAB4 Heatmap Hourly
      tabItem(tabName = "tab4", # Pestaña 2
              h2("Frecuencia en la concentración de cada gas"), # Título de ejemplo
              # --------
              fluidRow( 
                column(2, 
                       #INPUT DE VARIABLES
                       selectizeInput("gas_select_2", "Selecciona una variable", choices = names(dict_gas)),
                       # Inputs para seleccionar las variables
                       sliderInput("binsHist", 
                                   "Número de Bins:", 
                                   min = 1, 
                                   max = 50, 
                                   value = 30)
                ),
                column(10, # Columna de ancho 8
                       plotOutput("histPlot")
                )
              )      # ----------
      )
    )
))