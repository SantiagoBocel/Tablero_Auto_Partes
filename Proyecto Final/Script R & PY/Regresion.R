install.packages("ggplot2")
install.packages("dplyr")
install.packages("DBI")
install.packages("factoextra") 
install.packages("caret")
library(caret)
library(ggplot2)
library(factoextra)
library(gridExtra)
library(dplyr)
library(DBI)
library(odbc)

Repuestosweb <- dbConnect(odbc(), Driver = "SQL Server", Server ="LAPTOP-5N5FACOT", Database ="RepuestosWeb", timeout = 8000)

data <- dbGetQuery(conn = Repuestosweb,"Select DATEDIFF(YEAR,C.FechaNacimiento,GETDATE()) as Edad,
                                    		DO.Cantidad
                                        from Clientes C inner join Orden O on (C.ID_Cliente = O.ID_Cliente)
                                        inner join Detalle_orden DO on (O.ID_Orden = DO.ID_Orden)")

names(data)
set.seed(2020)
plot(data$Edad~data$Cantidad)