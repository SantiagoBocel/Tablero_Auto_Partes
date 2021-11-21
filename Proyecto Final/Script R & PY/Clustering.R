library(ggplot2)
library(factoextra)
library(gridExtra)
library(dplyr)
library(DBI)
library(odbc)

#Conexion a base de datos
con <- dbConnect(odbc(),
                 Driver = "SQL Server",
                 Server = "LAPTOP-0I4EFM0E",
                 Database = "RepuestosWeb",
                 timeout = 8000)

#Semilla
set.seed(1234)

#Total de partes vendidas
Total_Ventas<- dbGetQuery(con = con,
                       "select cat.Nombre as NombreCategoria,
sum(Do.cantidad) as Cantidad, sum(p.Precio*Do.Cantidad) as TotalVentas
from Orden O inner join Detalle_orden DO on(DO.ID_Orden=O.ID_Orden)
inner join Partes P on (P.ID_Parte=DO.ID_Parte)
inner join Categoria Cat on (p.ID_Categoria = cat.ID_Categoria)
group by Cat.Nombre"
)

rownames(Total_Ventas) <- Total_Ventas$NombreCategoria
Total_Ventas$NombreCategoria <- NULL
######################################################
Ventas <- scale(Total_Ventas)
Ventas <- na.omit(Ventas)

clusterk2ventas <- kmeans(Ventas, 2, nstart = 25)
clusterk3ventas <- kmeans(Ventas, 3, nstart = 25)
clusterk4ventas <- kmeans(Ventas, 4, nstart = 25)
clusterk5ventas <- kmeans(Ventas, 5, nstart = 25)
clusterk6ventas <- kmeans(Ventas, 6, nstart = 25)
clusterk7ventas <- kmeans(Ventas, 7, nstart = 25)

grafica1ventas <- fviz_cluster(clusterk2ventas, geom = "point", data = Ventas) + ggtitle("k2")
grafica2ventas <- fviz_cluster(clusterk3ventas, geom = "point", data = Ventas) + ggtitle("k3")
grafica3ventas <- fviz_cluster(clusterk4ventas, geom = "point", data = Ventas) + ggtitle("k4")
grafica4ventas <- fviz_cluster(clusterk5ventas, geom = "point", data = Ventas) + ggtitle("k5")
grafica5ventas <- fviz_cluster(clusterk6ventas, geom = "point", data = Ventas) + ggtitle("k6")
grafica6ventas <- fviz_cluster(clusterk7ventas, geom = "point", data = Ventas) + ggtitle("k7")


grid.arrange(grafica1ventas,
             grafica2ventas,
             grafica3ventas,
             grafica4ventas,
             grafica5ventas,
             grafica6ventas, nrow = 2)

fviz_nbclust(Ventas, kmeans, method = "wss") +
  geom_vline(xintercept = 6, linetype = 2)

VentasCluster <- as.data.frame(clusterk6ventas$cluster)
VentasRaw <- Total_Ventas

VStats <- merge(VentasCluster, VentasRaw, by=0, all=TRUE)

names(VStats)[2]<-"clustno"
VStats <- subset(VStats, select =-c(Row.names))

VStats <- aggregate(VStats, by=list(VStats$clustno), FUN = mean)

fviz_cluster(clusterk6ventas, data = Ventas, labelsize = 0, pointsize = 0)

ggplot(VStats, aes(x="",y=Cantidad, fill=clustno)) +
  geom_histogram(stat="identity", width = 1)+
  coord_polar("y", start = 0)

ggplot(VStats, aes(x="",y=TotalVentas, fill=clustno)) +
  geom_histogram(stat="identity", width = 1)+
  coord_polar("y", start = 0)

#Cantidad de descuentos aplicados
Descuento_Aplicado <- dbGetQuery(con = con,
                          "select cat.Nombre as NombreCategoria, 
SUM(CASE WHEN De.ID_Descuento = 1 THEN 1 ELSE 0 END) as PromocionTrupebistor,
SUM(CASE WHEN De.ID_Descuento = 2 THEN 1 ELSE 0 END) as PromocionQwicador,
SUM(CASE WHEN De.ID_Descuento = 3 THEN 1 ELSE 0 END) as PromocionThrunipaquar,
SUM(CASE WHEN De.ID_Descuento = 4 THEN 1 ELSE 0 END) as PromocionInzapefax,
SUM(CASE WHEN De.ID_Descuento = 5 THEN 1 ELSE 0 END) as PromocionUperollan,
SUM(CASE WHEN De.ID_Descuento = 6 THEN 1 ELSE 0 END) as PromocionMonvenplin,
SUM(CASE WHEN De.ID_Descuento = 7 THEN 1 ELSE 0 END) as PromocionEndwerpower,
SUM(CASE WHEN De.ID_Descuento = 8 THEN 1 ELSE 0 END) as PromocionRebanazz,
SUM(CASE WHEN De.ID_Descuento = 9 THEN 1 ELSE 0 END) as PromocionLomrobover,
SUM(CASE WHEN De.ID_Descuento = 10 THEN 1 ELSE 0 END) as PromocionQwinipilor,
SUM(CASE WHEN De.ID_Descuento = 11 THEN 1 ELSE 0 END) as PromocionRetuman,
SUM(CASE WHEN De.ID_Descuento = 12 THEN 1 ELSE 0 END) as PromocionEmmunazz,
SUM(CASE WHEN De.ID_Descuento = 13 THEN 1 ELSE 0 END) as PromocionLompebinar,
SUM(CASE WHEN De.ID_Descuento = 14 THEN 1 ELSE 0 END) as PromocionMonquestilin,
SUM(CASE WHEN De.ID_Descuento = 15 THEN 1 ELSE 0 END) as PromocionIntinaquor,
SUM(CASE WHEN De.ID_Descuento = 16 THEN 1 ELSE 0 END) as PromocionLomcadazz,
SUM(CASE WHEN De.ID_Descuento = 17 THEN 1 ELSE 0 END) as PromocionRapcadantor,
SUM(CASE WHEN De.ID_Descuento = 18 THEN 1 ELSE 0 END) as PromocionGrohupanar,
SUM(CASE WHEN De.ID_Descuento = 19 THEN 1 ELSE 0 END) as PromocionFrokilistor,
SUM(CASE WHEN De.ID_Descuento = 20 THEN 1 ELSE 0 END) as PromocionWinwerpegax,
SUM(CASE WHEN De.ID_Descuento = 21 THEN 1 ELSE 0 END) as PromocionTupkililin,
SUM(CASE WHEN De.ID_Descuento = 22 THEN 1 ELSE 0 END) as PromocionMonsipadin,
SUM(CASE WHEN De.ID_Descuento = 23 THEN 1 ELSE 0 END) as PromocionFrosipamin,
SUM(CASE WHEN De.ID_Descuento = 24 THEN 1 ELSE 0 END) as PromocionGrocadazz,
SUM(CASE WHEN De.ID_Descuento = 25 THEN 1 ELSE 0 END) as PromocionUnwerpin
from Orden O inner join
Detalle_orden DO on DO.ID_Orden = O.ID_Orden left join
Descuento De on DO. ID_Descuento= De.ID_Descuento join
Partes P on P.ID_Parte = DO.ID_Parte INNER JOIN
Categoria cat on Cat.ID_Categoria = p.ID_Categoria
group by cat.Nombre"
)

rownames(Descuento_Aplicado) <- Descuento_Aplicado$NombreCategoria
Descuento_Aplicado$NombreCategoria <- NULL
##################################################################
Descuento <- scale(Descuento_Aplicado)
Descuento <- na.omit(Descuento)

clusterk2descuento <- kmeans(Descuento, 2, nstart = 25)
clusterk3descuento <- kmeans(Descuento, 3, nstart = 25)
clusterk4descuento <- kmeans(Descuento, 4, nstart = 25)
clusterk5descuento <- kmeans(Descuento, 5, nstart = 25)

grafica1descuento <- fviz_cluster(clusterk2descuento, geom = "point", data = Descuento) + ggtitle("k2")
grafica2descuento <- fviz_cluster(clusterk3descuento, geom = "point", data = Descuento) + ggtitle("k3")
grafica3descuento <- fviz_cluster(clusterk4descuento, geom = "point", data = Descuento) + ggtitle("k4")
grafica4descuento <- fviz_cluster(clusterk5descuento, geom = "point", data = Descuento) + ggtitle("k5")

grid.arrange(grafica1descuento,
             grafica2descuento,
             grafica3descuento,
             grafica4descuento, nrow = 2)

fviz_nbclust(Descuento, kmeans, method = "wss") +
  geom_vline(xintercept = 4, linetype = 2)

DescuentoCluster <- as.data.frame(clusterk4descuento$cluster)
DescuentoRaw <- Descuento_Aplicado

DStats <- merge(DescuentoCluster, DescuentoRaw, by=0, all=TRUE)

N(DStats)[2]<-"clustno"
DStats <- subset(DStats, select =-c(Row.N))

DStats <- aggregate(DStats, by=list(DStats$clustno), FUN = mean)

fviz_cluster(clusterk4descuento, data = Descuento, labelsize = 0, pointsize = 0)

#Cantidad de genero
Genero <- dbGetQuery(con = con,
                       "select cat.Nombre as NombreCategoria, 
SUM(CASE WHEN Cli.Genero = 'M' THEN 1 ELSE 0 END) as M,
SUM(CASE WHEN Cli.Genero = 'F' THEN 1 ELSE 0 END) as F
from Orden O inner join
Detalle_orden DO on DO.ID_Orden = O.ID_Orden inner join
Partes P on P.ID_Parte = DO.ID_Parte INNER JOIN
Categoria cat on Cat.ID_Categoria = p.ID_Categoria inner join
Clientes Cli on O.ID_Cliente = Cli.ID_Cliente
group by cat.Nombre"
)

rownames(Genero) <- Genero$NombreCategoria
Genero$NombreCategoria <- NULL
##########################################
genero <- scale(Genero)
genero <- na.omit(genero)

clusterk2genero <- kmeans(genero, 2, nstart = 25)
clusterk3genero <- kmeans(genero, 3, nstart = 25)
clusterk4genero <- kmeans(genero, 4, nstart = 25)
clusterk5genero <- kmeans(genero, 5, nstart = 25)
clusterk6genero <- kmeans(genero, 6, nstart = 25)
clusterk7genero <- kmeans(genero, 7, nstart = 25)

grafica1genero <- fviz_cluster(clusterk2genero, geom = "point", data = genero) + ggtitle("k2")
grafica2genero <- fviz_cluster(clusterk3genero, geom = "point", data = genero) + ggtitle("k3")
grafica3genero <- fviz_cluster(clusterk4genero, geom = "point", data = genero) + ggtitle("k4")
grafica4genero <- fviz_cluster(clusterk5genero, geom = "point", data = genero) + ggtitle("k5")
grafica5genero <- fviz_cluster(clusterk6genero, geom = "point", data = genero) + ggtitle("k6")
grafica6genero <- fviz_cluster(clusterk7genero, geom = "point", data = genero) + ggtitle("k7")

grid.arrange(grafica1genero,
             grafica2genero,
             grafica3genero,
             grafica4genero,
             grafica5genero,
             grafica6genero, nrow = 2)

fviz_nbclust(genero, kmeans, method = "wss") +
  geom_vline(xintercept = 3, linetype = 2)

GeneroCluster <- as.data.frame(clusterk3genero$cluster)
GeneroRaw <- Genero

GStats <- merge(GeneroCluster, GeneroRaw, by=0, all=TRUE)

names(GStats)[2]<-"clustno"
GStats <- subset(GStats, select =-c(Row.names))

GStats <- aggregate(GStats, by=list(GStats$clustno), FUN = mean)

fviz_cluster(clusterk3genero, data = genero, labelsize = 0, pointsize = 0)

ggplot(GStats, aes(x="",y=M, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)

ggplot(GStats, aes(x="",y=F, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)
 
#Cantidad de cotizaciones
Cotizaciones <- dbGetQuery(con = con,
                                       "select cat.Nombre as NombreCategoria, 
SUM(CASE WHEN co.ProcesadoPor = 'Servicio de Integracion' THEN 1 ELSE 0 END) as ServiciodeIntegracion,
SUM(CASE WHEN co.ProcesadoPor = 'Aseguradora' THEN 1 ELSE 0 END) as Aseguradora,
SUM(CASE WHEN co.ProcesadoPor = 'Planta de Reparacion' THEN 1 ELSE 0 END) as PlantadeReparacion,
SUM(CASE WHEN co.ProcesadoPor = 'Call center' THEN 1 ELSE 0 END) as CallCenter
from Cotizacion co inner join
CotizacionDetalle cod on cod.IDCotizacion = co.IDCotizacion inner join
Partes P on P.ID_Parte = cod.ID_Parte INNER JOIN
Categoria cat on Cat.ID_Categoria = p.ID_Categoria
group by cat.Nombre"
)

rownames(Cotizaciones) <- Cotizaciones$NombreCategoria
Cotizaciones$NombreCategoria <- NULL
######################################################
cotizaciones <- scale(Cotizaciones)
cotizaciones <- na.omit(cotizaciones)

clusterk2cotizaciones <- kmeans(cotizaciones, 2, nstart = 25)
clusterk3cotizaciones <- kmeans(cotizaciones, 3, nstart = 25)
clusterk4cotizaciones <- kmeans(cotizaciones, 4, nstart = 25)
clusterk5cotizaciones <- kmeans(cotizaciones, 5, nstart = 25)

grafica1cotizaciones <- fviz_cluster(clusterk2cotizaciones, geom = "point", data = cotizaciones) + ggtitle("k2")
grafica2cotizaciones <- fviz_cluster(clusterk3cotizaciones, geom = "point", data = cotizaciones) + ggtitle("k3")
grafica3cotizaciones <- fviz_cluster(clusterk4cotizaciones, geom = "point", data = cotizaciones) + ggtitle("k4")
grafica4cotizaciones <- fviz_cluster(clusterk5cotizaciones, geom = "point", data = cotizaciones) + ggtitle("k5")

grid.arrange(grafica1cotizaciones,
             grafica2cotizaciones,
             grafica3cotizaciones,
             grafica4cotizaciones, nrow = 2)

fviz_nbclust(cotizaciones, kmeans, method = "wss") +
  geom_vline(xintercept = 5, linetype = 2)

CotizacionesCluster <- as.data.frame(clusterk5cotizaciones$cluster)
cotizacionesRaw <- Cotizaciones

CStats <- merge(CotizacionesCluster, cotizacionesRaw, by=0, all=TRUE)

names(CStats)[2]<-"clustno"
CStats <- subset(CStats, select =-c(Row.names))

CStats <- aggregate(CStats, by=list(CStats$clustno), FUN = mean)

fviz_cluster(clusterk5cotizaciones, data = cotizaciones, labelsize = 0, pointsize = 0)

ggplot(CStats, aes(x="",y=Aseguradora, fill=clustno)) +
  geom_histogram(stat="identity", width = 1)+
  coord_polar("y", start = 0)

ggplot(CStats, aes(x="",y=CallCenter, fill=clustno)) +
  geom_histogram(stat="identity", width = 1)+
  coord_polar("y", start = 0)

#Cantidad de ordenes hechas por cotizacion
Orden_Cotizacion <- dbGetQuery(con = con,
                                         "select cat.Nombre as NombreCategoria, 
SUM(CASE WHEN co.OrdenRealizada = 0 THEN 1 ELSE 0 END) as OrdenNoRealizada,
SUM(CASE WHEN co.OrdenRealizada = 1 THEN 1 ELSE 0 END) as OrdenRealizada
from Cotizacion co inner join
CotizacionDetalle cod on cod.IDCotizacion = co.IDCotizacion inner join
Partes P on P.ID_Parte = cod.ID_Parte INNER JOIN
Categoria cat on Cat.ID_Categoria = p.ID_Categoria
group by cat.Nombre"
)

rownames(Orden_Cotizacion) <- Orden_Cotizacion$NombreCategoria
Orden_Cotizacion$NombreCategoria <- NULL
##################################################################################
orden_cotizacion <- scale(Orden_Cotizacion)
orden_cotizacion <- na.omit(orden_cotizacion)

clusterk2orden_cotizacion <- kmeans(orden_cotizacion, 2, nstart = 25)
clusterk3orden_cotizacion <- kmeans(orden_cotizacion, 3, nstart = 25)
clusterk4orden_cotizacion <- kmeans(orden_cotizacion, 4, nstart = 25)
clusterk5orden_cotizacion <- kmeans(orden_cotizacion, 5, nstart = 25)
clusterk6orden_cotizacion <- kmeans(orden_cotizacion, 6, nstart = 25)
clusterk7orden_cotizacion <- kmeans(orden_cotizacion, 7, nstart = 25)


grafica1orden_cotizacion <- fviz_cluster(clusterk2orden_cotizacion, geom = "point", data = orden_cotizacion) + ggtitle("k2")
grafica2orden_cotizacion <- fviz_cluster(clusterk3orden_cotizacion, geom = "point", data = orden_cotizacion) + ggtitle("k3")
grafica3orden_cotizacion <- fviz_cluster(clusterk4orden_cotizacion, geom = "point", data = orden_cotizacion) + ggtitle("k4")
grafica4orden_cotizacion <- fviz_cluster(clusterk5orden_cotizacion, geom = "point", data = orden_cotizacion) + ggtitle("k5")
grafica5orden_cotizacion <- fviz_cluster(clusterk6orden_cotizacion, geom = "point", data = orden_cotizacion) + ggtitle("k6")
grafica6orden_cotizacion <- fviz_cluster(clusterk7orden_cotizacion, geom = "point", data = orden_cotizacion) + ggtitle("k7")

grid.arrange(grafica1orden_cotizacion,
             grafica2orden_cotizacion,
             grafica3orden_cotizacion,
             grafica4orden_cotizacion,
             grafica5orden_cotizacion,
             grafica6orden_cotizacion, nrow = 2)

fviz_nbclust(orden_cotizacion, kmeans, method = "wss") +
  geom_vline(xintercept = 5, linetype = 2)

Orden_cotizacionCluster <- as.data.frame(clusterk5orden_cotizacion$cluster)
Orden_cotizacionRaw <- Orden_Cotizacion

OCStats <- merge(Orden_cotizacionCluster, Orden_cotizacionRaw, by=0, all=TRUE)

names(OCStats)[2]<-"clustno"
OCStats <- subset(OCStats, select =-c(Row.names))

OCStats <- aggregate(OCStats, by=list(OCStats$clustno), FUN = mean)

fviz_cluster(clusterk5orden_cotizacion, data = orden_cotizacion, labelsize = 0, pointsize = 0)

ggplot(OCStats, aes(x="",y=OrdenRealizada, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)

ggplot(OCStats, aes(x="",y=OrdenNoRealizada, fill=clustno)) +
  geom_bar(stat="identity", width = 1)+
  coord_polar("y", start = 0)

#Cantidad de partes consultadas por cotizacion
PartesCotizadas <- dbGetQuery(con = con,
                                "select cat.Nombre as NombreCategoria,
SUM(cod.Cantidad) as Cantidad,
sum(p.Precio*cod.Cantidad) as TotalPorParte
from Cotizacion co inner join
CotizacionDetalle cod on cod.IDCotizacion = co.IDCotizacion inner join
Partes P on P.ID_Parte = cod.ID_Parte INNER JOIN
Categoria cat on Cat.ID_Categoria = p.ID_Categoria
group by cat.Nombre"
)

rownames(PartesCotizadas) <- PartesCotizadas$NombreCategoria
PartesCotizadas$NombreCategoria <- NULL
################################################################
parteCotizada <- scale(PartesCotizadas)
parteCotizada <- na.omit(parteCotizada)

clusterk2parteCotizada <- kmeans(parteCotizada, 2, nstart = 25)
clusterk3parteCotizada <- kmeans(parteCotizada, 3, nstart = 25)
clusterk4parteCotizada <- kmeans(parteCotizada, 4, nstart = 25)
clusterk5parteCotizada <- kmeans(parteCotizada, 5, nstart = 25)

grafica1parteCotizada <- fviz_cluster(clusterk2parteCotizada, geom = "point", data = parteCotizada) + ggtitle("k2")
grafica2parteCotizada <- fviz_cluster(clusterk3parteCotizada, geom = "point", data = parteCotizada) + ggtitle("k3")
grafica3parteCotizada <- fviz_cluster(clusterk4parteCotizada, geom = "point", data = parteCotizada) + ggtitle("k4")
grafica4parteCotizada <- fviz_cluster(clusterk5parteCotizada, geom = "point", data = parteCotizada) + ggtitle("k5")

grid.arrange(grafica1parteCotizada,
             grafica2parteCotizada,
             grafica3parteCotizada,
             grafica4parteCotizada, nrow = 2)

fviz_nbclust(parteCotizada, kmeans, method = "wss") +
  geom_vline(xintercept = 4, linetype = 2)

ParteCluster <- as.data.frame(clusterk4parteCotizada$cluster)
ParteRaw <- PartesCotizadas

PStats <- merge(ParteCluster, ParteRaw, by=0, all=TRUE)

names(PStats)[2]<-"clustno"
PStats <- subset(PStats, select =-c(Row.names))

PStats <- aggregate(PStats, by=list(PStats$clustno), FUN = mean)

fviz_cluster(clusterk4parteCotizada, data = parteCotizada, labelsize = 0, pointsize = 0)

ggplot(PStats, aes(x="Total",y=Cantidad, fill=clustno)) +
  geom_histogram(stat="identity", width = 1)+
  coord_polar("y", start = 0)

ggplot(PStats, aes(x="Precio",y=TotalPorParte, fill=clustno)) +
  geom_histogram(stat="identity", width = 1)+
  coord_polar("y", start = 0)