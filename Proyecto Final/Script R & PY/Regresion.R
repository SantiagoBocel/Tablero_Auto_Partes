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

df_OrdenGeografia <- dbGetQuery(conn = Repuestosweb,"select O.Total_Orden, c.Nombre as Ciudad, R.Nombre as Region, P.Nombre as Pais
                                        from Orden O inner join Ciudad C on O.ID_Ciudad=C.ID_Ciudad
                                				inner join Region R on C.ID_Region=r.ID_Region
                                				inner join Pais P on R.ID_Pais = p.ID_Pais")
names(df_OrdenGeografia)
df_OrdenPartes <- dbGetQuery(conn = Repuestosweb,"select O.Total_Orden, P.Nombre as Parte, C.Nombre as Categoria, L.Nombre as Linea
                                              from Orden O inner join Detalle_orden De on O.ID_Orden = De.ID_Orden
                                      				inner join Partes P on De.ID_Parte = P.ID_Parte
                                      				inner join Categoria C on P.ID_Categoria = C.ID_Categoria
                                      				inner join Linea L on C.ID_Linea = L.ID_Linea")

names(df_OrdenPartes)

df_OrdenGeografia <- na.omit(df_OrdenGeografia)
df_OrdenGeografia<- transform(df_OrdenGeografia,Region=as.numeric(as.factor(Region)))
df_OrdenGeografia<- transform(df_OrdenGeografia,Ciudad=as.numeric(as.factor(Ciudad)))
df_OrdenGeografia<- transform(df_OrdenGeografia,Pais=as.numeric(as.factor(Pais)))

df_OrdenPartes<- transform(df_OrdenPartes,Parte=as.numeric(as.factor(Parte)))
df_OrdenPartes<- transform(df_OrdenPartes,Categoria=as.numeric(as.factor(Categoria)))
df_OrdenPartes<- transform(df_OrdenPartes,Linea=as.numeric(as.factor(Linea)))

set.seed(220)

Row <- sample(1:nrow(df_OrdenGeografia), 0.8*nrow(df_OrdenGeografia))  
trainingDataTotalOrdenGeografia <- df_OrdenGeografia[Row, ]  
Row <- sample(1:nrow(df_OrdenPartes), 0.8*nrow(df_OrdenPartes))  
trainingDataTotalOrdenPartes <-  df_OrdenPartes[Row, ]
lmTotalOrdenParte <- lm(Total_Orden ~ Parte+Categoria+Linea, data=trainingDataTotalOrdenPartes)
lmTotalOrdenGeografia <- lm(Total_Orden ~ Ciudad+Region+Pais, data=trainingDataTotalOrdenGeografia)  
summary (lmTotalOrdenGeografia) 
summary (lmTotalOrdenParte)

cor(df_OrdenGeografia$Total_Orden, df_OrdenGeografia$Ciudad)
cor(df_OrdenGeografia$Total_Orden, df_OrdenGeografia$Region)
cor(df_OrdenGeografia$Total_Orden, df_OrdenGeografia$Pais)
cor(df_OrdenGeografia$Total_Orden, df_OrdenGeografia$Pais+df_OrdenGeografia$Region+df_OrdenGeografia$Pais)

cor(df_OrdenPartes$Total_Orden, df_OrdenPartes$Parte)
cor(df_OrdenPartes$Total_Orden, df_OrdenPartes$Categoria)
cor(df_OrdenPartes$Total_Orden, df_OrdenPartes$Linea)
cor(df_OrdenPartes$Total_Orden, df_OrdenPartes$Parte+df_OrdenPartes$Categoria+df_OrdenPartes$Linea)

df_OrdenGeografia<-head(df_OrdenGeografia,250)
scatter.smooth(x=df_OrdenGeografia$Total_Orden, y=df_OrdenGeografia$Ciudad+df_OrdenGeografia$Region+df_OrdenGeografia$Pais)

df_OrdenPartes<-head(df_OrdenPartes,250)
scatter.smooth(x=df_OrdenPartes$Total_Orden, y=df_OrdenPartes$Parte+df_OrdenPartes$Categoria+df_OrdenPartes$Linea)

