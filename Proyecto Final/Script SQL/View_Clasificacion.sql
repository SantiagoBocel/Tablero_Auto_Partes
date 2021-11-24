USE RepuestosWeb
--Promedio Ordenes Ciudad
	CREATE VIEW V_PromedioOrdenesCiudad as
	SELECT ci.Nombre AS NombreCiudad, c.Genero,  p.ID_Parte, p.ID_Categoria, o.Total_Orden, TotalEncimaPromedio = CASE WHEN (o.Total_Orden/
	(SELECT AVG(o2.Total_Orden)
	FROM dbo.Orden o2)) > 1 
	THEN 1 ELSE 0 end
	FROM dbo.Clientes c
	INNER JOIN dbo.Orden o ON o.ID_Cliente = c.ID_Cliente 
	INNER JOIN dbo.Detalle_orden do ON do.ID_Orden = o.ID_Orden
	INNER JOIN dbo.Partes p  ON p.ID_Parte = do.ID_Parte
	INNER JOIN dbo.Ciudad ci ON ci.ID_Ciudad = o.ID_Ciudad
	INNER JOIN dbo.Categoria cat ON cat.ID_Categoria = p.ID_Categoria