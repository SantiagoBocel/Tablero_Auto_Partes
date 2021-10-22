--PASO 3:

use RepuestosWebDWH
go

drop table if exists Factlog
go

---creacion de tabla para los logs de los batches del fact
create table Factlog
(
	ID_Batch uniqueidentifier default(newid()),
	FechaEjecucion datetime default(getdate()),
	RegistrosNuevos int,
	constraint PK_Faclog primary key (ID_Batch)
)
go

--agregamos fk al fact
alter table Fact.Orden add constraint FK_IDBatch foreign key (ID_Batch) references Factlog(ID_Batch)
go

---creacion de staging
create schema staging
go

drop table if exists staging.Orden
go

Create table staging.Orden
(
	ID_Orden int not null,
	ID_DetalleOrden int null,
	ID_Cotizacion int null,
	NumLinea varchar(50) null,
	ID_Cliente int null,
	ID_Ciudad int null,
	ID_Parte varchar(50) not null,
	ID_StatusOrden int null,
	ID_Aseguradora int null,
	ID_PlantaReparacion varchar(50) null,
	VehiculoID int null,
	ID_Descuento int null,
	Total_Orden int null,
	Cantidad int null,
	Fecha_Orden datetime null,
	status_cotizacion varchar(200) null ,
	TipoDocumento  varchar(200) null ,
	ProcesadoPor   varchar(200) null,
	AseguradoraSubsidiaria  varchar(500) null,
	NumeroReclamo   varchar(200) null ,
	OrdenRealizada   bit null ,
	CotizacionRealizada  bit null ,
	CotizacionDuplicada  bit null ,
	procurementFolderID  varchar(200) null ,
	DireccionEntrega1  varchar(200) null ,
	DireccionEntrega2  varchar(200) null ,
	MarcadoEntrega   bit null,
	CodigoPostal  varchar(100) null ,
	LeidoPorPlantaReparacion   bit null ,
	LeidoPorPlantaReparacionFecha  datetime null ,
	CotizacionReabierta   bit null  ,
	EsAseguradora    bit null ,
	CodigoVerificacion  varchar(200) ,
	FechaCreacionRegistro  datetime null ,
	PartnerConfirmado   bit null  ,
	WrittenBy  varchar(200) null ,
	SeguroValidado    bit null  ,
	FechaCaptura  datetime null ,
	Ruta  varchar(500) null,
	FechaLimiteRuta   varchar(200) null,
	TelefonoEntrega varchar(100) null,
	OETipoParte varchar(100) null,
	AltPartNum  varchar(200) null ,
	AltTipoParte   varchar(200) null,
	ciecaTipoParte   varchar(200) null,
	partDescripcion  varchar(500) null ,
	PrecioListaOnRO varchar(100) null ,
	PrecioNetoOnRO varchar(100) null,
	NecesitadoParaFecha  datetime null,
)on [PRIMARY]
go