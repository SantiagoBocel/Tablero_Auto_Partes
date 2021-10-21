-- PASO 4:

use RepuestosWebDWH
go

--DROP PROCEDURE USP_MergeFact
--GO  
--Script de SP para MERGE
CREATE or ALTER PROCEDURE USP_MergeFact
as
BEGIN

	SET NOCOUNT ON;
	BEGIN TRY
		BEGIN TRAN
		--generar nuevo gui para la tabla de log, y declaracion de variables de maxima fecha de ejecion con cantidad de registros afectas
		DECLARE @NuevoGUIDInsert UNIQUEIDENTIFIER = NEWID(), @MaxFechaEjecucion DATETIME, @RowsAffected INT
		--print @MaxFechaEjecucion
		--insertar en tabla de log
		INSERT INTO FactLog (ID_Batch, FechaEjecucion, RegistrosNuevos)
		VALUES (@NuevoGUIDInsert,NULL,NULL)
		--merge me ayuda integrar tablas: si vienen cosas del destino que no existen insertarlas, si existen cosas en los dos modificalas y si no esta en fuente pero si en el destino borrarla
		--aca en los hechos lo que mas se espera son inserciones nuevas
		MERGE Fact.Orden AS T
		USING (
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
				getdate() as FechaCreacion,
				NULL as FechaModificacion, 
				@NuevoGUIDINsert as ID_Batch,
				'ssis' as ID_SourceSystem
			from staging.Orden O
			inner join Dimension.Clientes C on (O.ID_Cliente=C.ID_Cliente)
			inner join Dimension.Partes P on (O.ID_Parte=P.ID_Parte)
			inner join Dimension.Geografia G on (O.ID_Ciudad=G.ID_Ciudad)
			inner join Dimension.StatusOrden SO on (O.ID_StatusOrden = SO.ID_StatusOrden)
			inner join Dimension.Aseguradoras A on (O.ID_Aseguradora = A.ID_Aseguradora)
			inner join Dimension.PlantaReparacion PR on (O.ID_PlantaReparacion = PR.ID_PlantaReparacion)
			inner join Dimension.Vehiculo V on (O.VehiculoID = V.VehiculoID)
			inner join Dimension.Descuento D on (O.ID_Descuento = D.ID_Descuento)
			inner join Dimension.Fecha F on (CAST( (CAST(YEAR(O.Fecha_Orden) AS VARCHAR(4)))+left('0'+CAST(MONTH(O.Fecha_Orden) AS VARCHAR(4)),2)+left('0'+(CAST(DAY(O.Fecha_Orden) AS VARCHAR(4))),2) AS INT)  = F.DateKey)
			--SELECT [SK_Candidato], [SK_Carrera], [DateKey], [ID_Examen], [ID_Descuento], r.Descripcion AS DescripcionDescuento, [PorcentajeDescuento], [Precio], r.Nota as NotaTotal, [NotaArea], [NombreMateria], getdate() as FechaCreacion, 'ETL' as UsuarioCreacion, NULL as FechaModificacion, NULL as UsuarioModificacion, @NuevoGUIDINsert as ID_Batch, 'ssis' as ID_SourceSystem, r.FechaPrueba, r.FechaModificacionSource
			--FROM STAGING.Examen R
			--	INNER JOIN Dimension.Candidato C ON(C.ID_Candidato = R.ID_Candidato and
			--										R.FechaPrueba BETWEEN c.FechaInicioValidez AND ISNULL(c.FechaFinValidez, '9999-12-31')) 
			--	INNER JOIN Dimension.Carrera CA ON(CA.ID_Carrera = R.ID_Carrera and
			--										R.FechaPrueba BETWEEN CA.FechaInicioValidez AND ISNULL(CA.FechaFinValidez, '9999-12-31')) 
			--	LEFT JOIN Dimension.Fecha F ON(CAST( (CAST(YEAR(R.FechaPrueba) AS VARCHAR(4)))+left('0'+CAST(MONTH(R.FechaPrueba) AS VARCHAR(4)),2)+left('0'+(CAST(DAY(R.FechaPrueba) AS VARCHAR(4))),2) AS INT)  = F.DateKey)
				) AS S ON (S.ID_Orden = T.ID_Orden)

		WHEN NOT MATCHED BY TARGET THEN --No existe en Fact
		INSERT (SK_Partes,
				SK_Geografia,
				SK_Clientes,
				SK_StatusOrden,
				SK_Aseguradoras,
				SK_PlantaReparacion,
				SK_Vehiculo,
				SK_Descuento,
				DateKey,
				ID_Orden ,
				ID_DetalleOrden ,
				ID_Cotizacion ,
				NumLinea ,
				Total_Orden ,
				Cantidad ,
				Fecha_Orden ,
				status_cotizacion  ,
				TipoDocumento   ,
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
				NecesitadoParaFecha   ,
				FechaCreacion, 
				FechaModificacion, 
				ID_Batch, 
				ID_SourceSystem)
		VALUES (	S.SK_Partes,
					S.SK_Geografia,
					S.SK_Clientes,
					S.SK_StatusOrden,
					S.SK_Aseguradoras,
					S.SK_PlantaReparacion,
					S.SK_Vehiculo,
					S.SK_Descuento,
					S.DateKey,
					S.ID_Orden ,
					S.ID_DetalleOrden ,
					S.ID_Cotizacion ,
					S.NumLinea ,
					S.Total_Orden ,
					S.Cantidad ,
					S.Fecha_Orden ,
					S.status_cotizacion  ,
					S.TipoDocumento   ,
					S.ProcesadoPor   ,
					S.AseguradoraSubsidiaria  ,
					S.NumeroReclamo   ,
					S.OrdenRealizada   ,
					S.CotizacionRealizada   ,
					S.CotizacionDuplicada   ,
					S.procurementFolderID   ,
					S.DireccionEntrega1   ,
					S.DireccionEntrega2   ,
					S.MarcadoEntrega   ,
					S.CodigoPostal  ,
					S.LeidoPorPlantaReparacion    ,
					S.LeidoPorPlantaReparacionFecha   ,
					S.CotizacionReabierta     ,
					S.EsAseguradora     ,
					S.CodigoVerificacion   ,
					S.FechaCreacionRegistro   ,
					S.PartnerConfirmado     ,
					S.WrittenBy   ,
					S.SeguroValidado      ,
					S.FechaCaptura   ,
					S.Ruta  ,
					S.FechaLimiteRuta   ,
					S.TelefonoEntrega ,
					S.OETipoParte ,
					S.AltPartNum   ,
					S.AltTipoParte   ,
					S.ciecaTipoParte   ,
					S.partDescripcion  ,
					S.PrecioListaOnRO ,
					S.PrecioNetoOnRO ,
					S.NecesitadoParaFecha, 
					S.FechaCreacion, 
					S.FechaModificacion, 
					S.ID_Batch, 
					S.ID_SourceSystem);

		SET @RowsAffected =@@ROWCOUNT

		SELECT MAX(MaxFechaEjecucion)
		FROM(
			SELECT MAX(Fecha_Orden) as MaxFechaEjecucion
			FROM FACT.Orden
			UNION
			SELECT MAX(FechaModificacion)  as MaxFechaEjecucion
			FROM FACT.Orden
		)AS A

		UPDATE FactLog
		SET RegistrosNuevos=@RowsAffected, FechaEjecucion = @MaxFechaEjecucion
		WHERE ID_Batch = @NuevoGUIDInsert

		COMMIT
	END TRY
	BEGIN CATCH
		SELECT @@ERROR,'Ocurrio el siguiente error: '+ERROR_MESSAGE()
		IF (@@TRANCOUNT>0)
			ROLLBACK;
	END CATCH

END
go
