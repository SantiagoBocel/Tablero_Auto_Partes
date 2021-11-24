Use RepuestosWeb

--Total de partes vendidas
select cat.Nombre as Nombre_Categoria, sum(Do.cantidad) as Cantidad
from Orden O INNER JOIN Detalle_orden DO on(DO.ID_Orden=O.ID_Orden)
INNER JOIN Partes P on (P.ID_Parte=DO.ID_Parte)
INNER JOIN Categoria Cat on (p.ID_Categoria = cat.ID_Categoria)
group by Cat.Nombre
GO

--Cantidad de descuentos aplicados
select cat.Nombre as Nombre_Categoria, 
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
from Orden O INNER JOIN
Detalle_orden DO on DO.ID_Orden = O.ID_Orden left join
Descuento De on DO. ID_Descuento= De.ID_Descuento join
Partes P on P.ID_Parte = DO.ID_Parte INNER JOIN
Categoria cat on Cat.ID_Categoria = p.ID_Categoria
group by cat.Nombre
GO

--Categoria CON CANDIDAD DE STATUS POR COTIZACION
select cat.Nombre as Nombre_Categoria, 
SUM(CASE WHEN co.status = 'Quote' THEN 1 ELSE 0 END) as Quote,
SUM(CASE WHEN co.status = 'Order' THEN 1 ELSE 0 END) as 'Order'
from Cotizacion co INNER JOIN
CotizacionDetalle cod on cod.IDCotizacion = co.IDCotizacion INNER JOIN
Partes P on P.ID_Parte = cod.ID_Parte INNER JOIN
Categoria cat on Cat.ID_Categoria = p.ID_Categoria
group by cat.Nombre
GO

--Cantidad de cotizaciones
select cat.Nombre as Nombre_Categoria, 
SUM(CASE WHEN co.ProcesadoPor = 'Servicio de Integracion' THEN 1 ELSE 0 END) as ServiciodeIntegracion,
SUM(CASE WHEN co.ProcesadoPor = 'Aseguradora' THEN 1 ELSE 0 END) as Aseguradora,
SUM(CASE WHEN co.ProcesadoPor = 'Planta de Reparacion' THEN 1 ELSE 0 END) as PlantadeReparacion,
SUM(CASE WHEN co.ProcesadoPor = 'Call center' THEN 1 ELSE 0 END) as CallCenter,
SUM(CASE WHEN co.ProcesadoPor = null THEN 1 ELSE 0 END) as SinProcesar
from Cotizacion co INNER JOIN
CotizacionDetalle cod on cod.IDCotizacion = co.IDCotizacion INNER JOIN
Partes P on P.ID_Parte = cod.ID_Parte INNER JOIN
Categoria cat on Cat.ID_Categoria = p.ID_Categoria
group by cat.Nombre
GO

--Cantidad de ordenes hechas por cotizacion
select cat.Nombre as Nombre_Categoria, 
SUM(CASE WHEN co.OrdenRealizada = 0 THEN 1 ELSE 0 END) as OrdenNoRealizada,
SUM(CASE WHEN co.OrdenRealizada = 1 THEN 1 ELSE 0 END) as OrdenRealizada
from Cotizacion co INNER JOIN
CotizacionDetalle cod on cod.IDCotizacion = co.IDCotizacion INNER JOIN
Partes P on P.ID_Parte = cod.ID_Parte INNER JOIN
Categoria cat on Cat.ID_Categoria = p.ID_Categoria
group by cat.Nombre
GO

--Cantidad de partes consultadas por cotizacion
select cat.Nombre as Nombre_Categoria, SUM(cod.Cantidad) as Cantidad
from Cotizacion co INNER JOIN
CotizacionDetalle cod on cod.IDCotizacion = co.IDCotizacion INNER JOIN
Partes P on P.ID_Parte = cod.ID_Parte INNER JOIN
Categoria cat on Cat.ID_Categoria = p.ID_Categoria
group by cat.Nombre
GO