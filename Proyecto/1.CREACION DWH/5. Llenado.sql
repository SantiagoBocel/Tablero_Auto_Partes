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
	L.Descripcion as DescripcionLinea,
	GETDATE() AS FechaCreacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioCreacion,
	GETDATE() AS FechaModificacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioModificacion
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
	C.CodigoPostal,
	GETDATE() AS FechaCreacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioCreacion,
	GETDATE() AS FechaModificacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioModificacion
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
	C.FechaNacimiento,
	GETDATE() AS FechaCreacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioCreacion,
	GETDATE() AS FechaModificacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioModificacion
from dbo.Clientes C
-----------query para llenar la dimension StatusOrden
select 
	SO.ID_StatusOrden,
	SO.NombreStatus,
	GETDATE() AS FechaCreacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioCreacion,
	GETDATE() AS FechaModificacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioModificacion
from dbo.[StatusOrden] SO
-----------query para llenar la dimension Aseguradoras
select 
	A.[IDAseguradora],
	A.[NombreAseguradora],
	A.[RowCreatedDate],
	A.[Activa],
	GETDATE() AS FechaCreacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioCreacion,
	GETDATE() AS FechaModificacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioModificacion
from dbo.[Aseguradoras] A
-----------query para llenar la dimension PlantaReparacion
select 
	PR.[IDPlantaReparacion],
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
	PR.[UltimaFechaActualizacion],
	GETDATE() AS FechaCreacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioCreacion,
	GETDATE() AS FechaModificacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioModificacion
from dbo.[PlantaReparacion] PR
-----------query para llenar la dimension Vehiculo
select 
	V.[VehiculoID],
	V.[VIN_Patron],
	V.[Anio],
	V.[Marca],
	V.[Modelo],
	V.[SubModelo],
	V.[Estilo],
	GETDATE() AS FechaCreacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioCreacion,
	GETDATE() AS FechaModificacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioModificacion
from dbo.Vehiculo V
-----------query para llenar la dimension Descuento
select 
	D.[ID_Descuento],
	D.[NombreDescuento],
	[PorcentajeDescuento],
	GETDATE() AS FechaCreacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioCreacion,
	GETDATE() AS FechaModificacion,
	CAST(SUSER_NAME() AS nvarchar(100)) AS UsuarioModificacion
from dbo.Descuento D
-----------query para llenar staging
use RepuestosWeb
go
select 
	O.ID_Orden, 
	DO.ID_DetalleOrden,
	Co.IDCotizacion As ID_Cotizacion,
	Cod.NumLinea,
	O.ID_Cliente,
	O.ID_Ciudad,
	DO.ID_Parte,
	S.ID_StatusOrden,
	A.IDAseguradora As ID_Aseguradora,
	PR.IDPlantaReparacion As ID_PlantaReparacion,
	V.VehiculoID,
	D.ID_Descuento,
	O.Total_Orden ,
	DO.Cantidad ,
	O.Fecha_Orden ,
	Co.FechaModificacion,
	Co.[status] As status_cotizacion,
	Co.TipoDocumento,
	Co.FechaCreacion,
	Co.ProcesadoPor,
	Co.AseguradoraSubsidiaria,
	Co.NumeroReclamo,
	Co.OrdenRealizada,
	Co.CotizacionRealizada,
	Co.CotizacionDuplicada,
	Co.procurementFolderID,
	Co.DireccionEntrega1,
	Co.DireccionEntrega2,
	Co.MarcadoEntrega,
	Co.CodigoPostal,
	Co.LeidoPorPlantaReparacion,
	Co.LeidoPorPlantaReparacionFecha,
	Co.CotizacionReabierta,
	Co.EsAseguradora,
	Co.CodigoVerificacion,
	Co.FechaCreacionRegistro,
	Co.PartnerConfirmado     ,
	Co.WrittenBy   ,
	Co.SeguroValidado      ,
	Co.FechaCaptura   ,
	Co.Ruta  ,
	Co.FechaLimiteRuta   ,
	Co.TelefonoEntrega ,
	Cod.OETipoParte ,
	Cod.AltPartNum   ,
	Cod.AltTipoParte   ,
	Cod.ciecaTipoParte   ,
	Cod.partDescripcion  ,
	Cod.PrecioListaOnRO ,
	Cod.PrecioNetoOnRO ,
	Cod.NecesitadoParaFecha
from dbo.Orden O
inner join dbo.Detalle_orden DO on (O.ID_Orden=DO.ID_Orden)
inner join dbo.Cotizacion Co on (O.ID_Orden = Co.IDOrden )
inner join dbo.CotizacionDetalle Cod on (Co.IDCotizacion = Cod.IDCotizacion)
inner join dbo.Aseguradoras A on (Co.IDAseguradora = A.IDAseguradora)
inner join dbo.PlantaReparacion PR on (Co.IDPlantaReparacion = PR.IDPlantaReparacion)
inner join dbo.Vehiculo V on(Cod.VehiculoID = V.VehiculoID)
inner join dbo.Descuento D on (DO.ID_Descuento=D.ID_Descuento)
inner join dbo.StatusOrden S on (O.ID_StatusOrden=S.ID_StatusOrden)
--inner join dbo.Clientes C on (O.ID_Cliente = C.ID_Cliente)
where ((Fecha_Orden>?) or (FechaModificacion>?))
--query para determinar la fecha maxima
SELECT ISNULL(MAX(FechaEjecucion),'1900-01-01') AS UltimaFecha
FROM FactLog
--select O.ID_Orden, 
--		O.ID_Cliente
--from dbo.Orden O inner join dbo.Clientes C on (O.ID_Cliente = C.ID_Cliente)
---query para el procedimiento
use RepuestosWebDWH
go
select
				SK_Partes,
				SK_Geografia,
				SK_Clientes,
				SK_StatusOrden,
				SK_Aseguradoras,
				SK_PlantaReparacion,
				SK_Vehiculo,
				SK_Descuento,
				DateKey,
				O.ID_Orden,
				O.ID_DetalleOrden ,
				O.ID_Cotizacion ,
				O.NumLinea ,
				O.Total_Orden ,
				O.Cantidad ,
				O.Fecha_Orden ,
				O.status_cotizacion  ,
				O.TipoDocumento   ,
				O.ProcesadoPor   ,
				O.AseguradoraSubsidiaria  ,
				O.NumeroReclamo   ,
				O.OrdenRealizada   ,
				O.CotizacionRealizada   ,
				O.CotizacionDuplicada   ,
				O.procurementFolderID   ,
				O.DireccionEntrega1   ,
				O.DireccionEntrega2   ,
				O.MarcadoEntrega   ,
				O.CodigoPostal  ,
				O.LeidoPorPlantaReparacion    ,
				O.LeidoPorPlantaReparacionFecha   ,
				O.CotizacionReabierta     ,
				O.EsAseguradora     ,
				O.CodigoVerificacion   ,
				O.FechaCreacionRegistro   ,
				O.PartnerConfirmado     ,
				O.WrittenBy   ,
				O.SeguroValidado      ,
				O.FechaCaptura   ,
				O.Ruta  ,
				O.FechaLimiteRuta   ,
				O.TelefonoEntrega ,
				O.OETipoParte ,
				O.AltPartNum   ,
				O.AltTipoParte   ,
				O.ciecaTipoParte   ,
				O.partDescripcion  ,
				O.PrecioListaOnRO ,
				O.PrecioNetoOnRO ,
				O.NecesitadoParaFecha   ,
				O.FechaCreacion,
				O.FechaModificacion
from staging.Orden O
inner join Dimension.Clientes C on (O.ID_Cliente=C.ID_Cliente)
inner join Dimension.Partes P on (O.ID_Parte=P.ID_Parte)
inner join Dimension.Geografia G on (O.ID_Ciudad=G.ID_Ciudad)
inner join Dimension.StatusOrden SO on (O.ID_StatusOrden = SO.ID_StatusOrden)
inner join Dimension.Aseguradoras A on (O.ID_Aseguradora = A.ID_Aseguradora)
inner join Dimension.PlantaReparacion PR on (O.ID_PlantaReparacion = PR.ID_PlantaReparacion)
inner join Dimension.Vehiculo V on (O.VehiculoID = V.VehiculoID)
inner join Dimension.Descuento D on(O.ID_Descuento = D.ID_Descuento) 
inner join Dimension.Fecha F on (CAST( (CAST(YEAR(O.Fecha_Orden) AS VARCHAR(4)))+left('0'+CAST(MONTH(O.Fecha_Orden) AS VARCHAR(4)),2)+left('0'+(CAST(DAY(O.Fecha_Orden) AS VARCHAR(4))),2) AS INT)  = F.DateKey)
----------- llenado fecha
DECLARE @FechaMaxima DATETIME=DATEADD(YEAR,2,GETDATE())
--Fecha
IF ISNULL((SELECT MAX(Date) FROM Dimension.Fecha),'1900-01-01')<@FechaMaxima
begin
	EXEC USP_FillDimDate @CurrentDate = '2016-01-01', 
							@EndDate     = @FechaMaxima
end
