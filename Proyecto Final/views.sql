USE RepuestosWeb
--Cantidad Cotizacion
	CREATE VIEW VW_CantidadCotizacionEncimaPromedio as
	select pa.ID_Categoria, pa.ID_Parte, pr.Ciudad, TotalEncimaPromedio = CASE WHEN (cod.Cantidad/
	(SELECT AVG(cod2.Cantidad)
	FROM dbo.CotizacionDetalle cod2)) > 1
	THEN 1 ELSE 0 end
	from Cotizacion co
	inner join PlantaReparacion pr on pr.IDPlantaReparacion = co.IDPlantaReparacion
	inner join CotizacionDetalle cod on cod.IDCotizacion = co.IDCotizacion
	inner join Partes pa on pa.ID_Parte = cod.ID_Parte
--Cantidad Partes
	CREATE VIEW VW_CantidadPartesEncimaPromedio as
	SELECT ci.Nombre AS NombreCiudad,
	c.Genero,
	p.ID_Parte,
	p.ID_Categoria,
	TotalCantidadEncimaPromedio = CASE WHEN (do.Cantidad/
	(SELECT AVG(do2.Cantidad)
	FROM dbo.Detalle_orden do2)) > 1
	THEN 1 ELSE 0 end
	FROM dbo.Clientes c
	INNER JOIN dbo.Orden o
	ON o.ID_Cliente = c.ID_Cliente
	INNER JOIN dbo.Detalle_orden do
	ON do.ID_Orden = o.ID_Orden
	INNER JOIN dbo.Partes p
	ON p.ID_Parte = do.ID_Parte
	INNER JOIN dbo.Ciudad ci
	ON ci.ID_Ciudad = o.ID_Ciudad
	INNER JOIN dbo.Categoria cat
	ON cat.ID_Categoria = p.ID_Categoria
--Porcentaje Descuento
	CREATE VIEW VW_PorcentajeDescuentoEncimaPromedio as
	select pt.ID_Parte, pt.ID_Categoria, ci.Nombre, 
	TotalEncimaPromedio = CASE WHEN (dc.PorcentajeDescuento/
	(SELECT AVG(dc2.PorcentajeDescuento)
	FROM dbo.Descuento dc2)) > 1
	THEN 1 ELSE 0 end 
	from Orden o
	inner join Detalle_orden do on do.ID_Orden = o.ID_Orden
	inner join Partes pt on pt.ID_Parte = do.ID_Parte
	inner join Categoria cg on cg.ID_Categoria = pt.ID_Categoria
	inner join Descuento dc on dc.ID_Descuento = do.ID_Descuento
	inner join Ciudad ci on ci.ID_Ciudad = o.ID_Ciudad
--Total Ordenes
	CREATE VIEW VW_TotalOrdenesEncimaPromedio as
	SELECT ci.Nombre AS NombreCiudad,
	c.Genero,
	p.ID_Parte,
	p.ID_Categoria,
	TotalEncimaPromedio = CASE WHEN (o.Total_Orden/
	(SELECT AVG(o2.Total_Orden)
	FROM dbo.Orden o2)) > 1
	THEN 1 ELSE 0 end
	FROM dbo.Clientes c
	INNER JOIN dbo.Orden o
	ON o.ID_Cliente = c.ID_Cliente
	INNER JOIN dbo.Detalle_orden do
	ON do.ID_Orden = o.ID_Orden
	INNER JOIN dbo.Partes p
	ON p.ID_Parte = do.ID_Parte
	INNER JOIN dbo.Ciudad ci
	ON ci.ID_Ciudad = o.ID_Ciudad
	INNER JOIN dbo.Categoria cat
	ON cat.ID_Categoria = p.ID_Categoria
--Orden Realizada
	CREATE VIEW VW_OrdenRealizadaCotizacion as
	select C.ID_Categoria, p.ID_Parte, co.ProcesadoPor, co.IDAseguradora, Co.OrdenRealizada
	from Cotizacion Co 
	inner join CotizacionDetalle CD on Co.IDCotizacion = CD.IDCotizacion
	inner join Partes P on CD.ID_Parte=P.ID_Parte
	inner join Categoria C on C.ID_Categoria=P.ID_Categoria
--Porcentaje Bajo
	CREATE VIEW VW_PorcentajeBajo as
	select pt.ID_Parte, pt.ID_Categoria, ci.Nombre, 
	PorcentajeBajo = CASE WHEN dc.PorcentajeDescuento < 0.30 THEN 1 ELSE 0 end 
	from Orden o
	inner join Detalle_orden do on do.ID_Orden = o.ID_Orden
	inner join Partes pt on pt.ID_Parte = do.ID_Parte
	inner join Categoria cg on cg.ID_Categoria = pt.ID_Categoria
	inner join Descuento dc on dc.ID_Descuento = do.ID_Descuento
	inner join Ciudad ci on ci.ID_Ciudad = o.ID_Ciudad
--Vehiculo Moderno
	CREATE or alter VIEW VW_VehiculoModerno as
	select pt.ID_Parte, cg.ID_Categoria, v.Marca, VehiculoModerno = CASE WHEN v.Anio > 2000 then 1 else 0 end
	from Detalle_orden do
	inner join Partes pt on pt.ID_Parte = do.ID_Parte
	inner join Categoria cg on cg.ID_Categoria = pt.ID_Categoria
	inner join Vehiculo v on v.VehiculoID = do.VehiculoID