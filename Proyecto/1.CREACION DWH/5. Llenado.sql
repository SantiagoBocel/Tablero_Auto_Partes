use RepuestosWeb
go
-----------query para llenar la diemnsion partes
select 
	P.ID_Parte,
	L.ID_Linea,
	C.ID_Categoria,
	P.Nombre as NombreParte,
	P.Descripcion as DescripcionParte,
	P.Precio as PrecioParte,
	C.Nombre as NombreCategoria,
	C.Descripcion as DescripcionCategoria,
	L.Nombre as NombreLinea,
	L.Descripcion as DescripcionLinea
from dbo.Categoria C 
inner join dbo.Partes P on(P.ID_Categoria=C.ID_Categoria)
inner join dbo.Linea L on (L.ID_Linea=C.ID_Linea)
-----------query para llenar la dimension geografia
select 
	P.ID_Pais,
	R.ID_Region,
	C.ID_Ciudad,
	P.Nombre as NombrePais,
	R.Nombre as NombreRegion,
	C.Nombre as NombreCiudad,
	C.CodigoPostal
from dbo.Region R
inner join dbo.Pais P on (R.ID_Pais=P.ID_Pais)
inner join dbo.Ciudad C on (R.ID_Region=C.ID_Region)
-----------query para llenar la dimension clientes
select 
	C.ID_Cliente,
	C.PrimerNombre,
	C.SegundoNombre,
	C.PrimerApellidO,
	C.SegundoApellido,
	C.Genero,
	C.Correo_Electronico,
	C.FechaNacimiento
from dbo.Clientes C
-----------query para llenar la dimension StatusOrden
select 
	SO.ID_StatusOrden,
	SO.NombreStatus,
from dbo.[StatusOrden] SO
-----------query para llenar la dimension Aseguradoras
select 
	A.[SK_Aseguradoras],
	A.[ID_Aseguradora],
	A.[NombreAseguradora],
	A.[RowCreatedDate],
	A.[Activa]
from dbo.[Aseguradoras] A
-----------query para llenar la dimension PlantaReparacion
select 
	PR.[SK_PlantaReparacion],
	PR.[ID_PlantaReparacion],
	PR.[CompanyNombre],
	PR.[Direccion],
	PR.[Direccion2],
	PR.[Ciudad],
	PR.[Estado],
	PR.[CodigoPostal],
	PR.[Pais],
	PR.[TelefonoAlmacen],
	PR.[FaxAlmacen],
	PR.[CorreoContacto],
	PR.[NombreContacto],
	PR.[TelefonoContacto],
	PR.[TituloTrabajo],
	PR.[AlmacenKeystone],
	PR.[IDPredio],
	PR.[LocalizadorCotizacion],
	PR.[FechaAgregado],
	PR.[IDEmpresa],
	PR.[ValidacionSeguro],
	PR.[Activo],
	PR.[CreadoPor],
	PR.[ActualizadoPor],
	PR.[UltimaFechaActualizacion]
from dbo.[PlantaReparacion] PR
-----------query para llenar la dimension Vehiculo
select 
	V.[SK_Vehiculo],
	V.[VehiculoID],
	V.[VIN_Patron],
	V.[Anio],
	V.[Marca],
	V.[Modelo],
	V.[SubModelo],
	V.[Estilo],
	V.[FechaCreacion]
from dbo.Vehiculo V
-----------query para llenar la dimension Descuento
select 
	D.[SK_Descuento],
	D.[ID_Descuento],
	D.[NombreDescuento],
	[PorcentajeDescuento]
from dbo.Descuento D



-----------query para llenar staging
use RepuestosWeb
go
select 
	O.ID_Orden ,
	DO.ID_DetalleOrden ,
	Co.IDCotizacion As ID_Cotizacion,
	NumLinea ,
	Total_Orden ,
	Cantidad ,
	NombreStatus ,
	Fecha_Orden ,
	Fecha_Modificacion ,
	status_cotizacion  ,
	TipoDocumento   ,
	FechaCreacion  ,
	FechaModificacion  ,
	ProcesadoPor   ,
	AseguradoraSubsidiaria  ,
	NumeroReclamo   ,
	OrdenRealizada   ,
	CotizacionRealizada   ,
	CotizacionDuplicada   ,
	procurementFolderID   ,
	DireccionEntrega1   ,
	DireccionEntrega2   ,
	MarcadoEntrega   ,
	CodigoPostal  ,
	LeidoPorPlantaReparacion    ,
	LeidoPorPlantaReparacionFecha   ,
	CotizacionReabierta     ,
	EsAseguradora     ,
	CodigoVerificacion   ,
	FechaCreacionRegistro   ,
	PartnerConfirmado     ,
	WrittenBy   ,
	SeguroValidado      ,
	FechaCaptura   ,
	Ruta  ,
	FechaLimiteRuta   ,
	TelefonoEntrega ,
	OETipoParte ,
	AltPartNum   ,
	AltTipoParte   ,
	ciecaTipoParte   ,
	partDescripcion  ,
	PrecioListaOnRO ,
	PrecioNetoOnRO ,
	NecesitadoParaFecha
from dbo.Orden O
inner join dbo.Detalle_orden DO on (O.ID_Orden=DO.ID_Orden)
inner join dbo.Cotizacion Co on (O.ID_Orden = Co.IDOrden )
inner join dbo.CotizacionDetalle Cod on (Co.IDCotizacion = Cod.IDCotizacion)
inner join dbo.Aseguradoras A on (Co.IDAseguradora = A.IDAseguradora)
inner join dbo.PlantaReparacion PR on (Co.IDPlantaReparacion = PR.IDPlantaReparacion)
inner join dbo.Vehiculo V on(Cod.VehiculoID = V.VehiculoID)
inner join dbo.Descuento D on (DO.ID_Descuento=D.ID_Descuento)
inner join dbo.StatusOrden S on (O.ID_StatusOrden=S.ID_StatusOrden)
inner join dbo.Clientes C on (O.ID_Cliente = C.ID_Cliente)
where ((Fecha_Orden>?) or (Fecha_Modificacion>?))
--query para determinar la fecha maxima
SELECT ISNULL(MAX(FechaEjecucion),'1900-01-01') AS UltimaFecha
FROM FactLog

---query para el procedimiento
use RepuestosWebDWH
go
select
	SK_Partes,
	SK_Geografia,
	SK_Clientes,
	DateKey,
	O.ID_Orden,
	O.ID_Descuento,
	O.ID_DetalleOrden,
	O.NombreDescuento,
	O.PorcentajeDescuento,
	O.Total_Orden,
	O.Cantidad,
	O.NombreStatus,
	O.Fecha_Orden,
	O.Fecha_Modificacion
from staging.Orden O
inner join Dimension.Clientes C on (O.ID_Cliente=C.ID_Cliente)
inner join Dimension.Partes P on (O.ID_Partes=P.ID_Partes)
inner join Dimension.Geografia G on (O.ID_Ciudad=G.ID_Ciudad)
inner join Dimension.Fecha F on (CAST( (CAST(YEAR(O.Fecha_Orden) AS VARCHAR(4)))+left('0'+CAST(MONTH(O.Fecha_Orden) AS VARCHAR(4)),2)+left('0'+(CAST(DAY(O.Fecha_Orden) AS VARCHAR(4))),2) AS INT)  = F.DateKey)
----------- llenado fecha
DECLARE @FechaMaxima DATETIME=DATEADD(YEAR,2,GETDATE())
--Fecha
IF ISNULL((SELECT MAX(Date) FROM Dimension.Fecha),'1900-01-01')<@FechaMaxima
begin
	EXEC USP_FillDimDate @CurrentDate = '2016-01-01', 
							@EndDate     = @FechaMaxima
end

truncate table Dimension.Fecha