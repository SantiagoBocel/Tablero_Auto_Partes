-- PASO 1:

USE master
go

DROP DATABASE  IF EXISTS RepuestosWebDWH
   
CREATE DATABASE RepuestosWebDWH
GO

USE RepuestosWebDWH
GO

----Definicion de los tipos de datos para el dwh
--Enteros
--llave subrrugada
create type [UDT_SK] from int
go
--llave primaria
create type [UDT_PK] from int
go 

--int
create type [UDT_INT] from int
go 

--cadenas

--cadenas largas
create type [UDT_VarcharLargo] from varchar(500)
go
--cadenas medianaas
create type [UDT_VarcharMediano] from varchar (200)
go

--cadenas cortas
create type [UDT_VarcharCorto] from varchar (100)
go

--un caracter
create type [UDT_UnCaracter] from char(1)
go

--decimales

--decimal 12,2
create type [UDT_Decimal12.2] from decimal(12,2)
go

--decimal 2,2
create type [UDT_Decimal2.2] from decimal (2,2)
go

--fechas

create type [UDT_DateTime] from datetime
go


---schemas para poder separar los obejetos y facilitar su administracion
create schema Fact
go

create schema Dimension
go

--------------------------------------------------MODELO CONCEPTUAL-------------------------------
--DEFINICION DE LAS DIMENSION Y LA TABLA DE HECHOS
--DEFINICION DE MODELO: ESTRELLA

--TABLAS DE DIMENSIONES
--Dimension partes -> union entre tabla partes, linea y categoria
create table Dimension.Partes
(
	SK_Partes [UDT_SK] primary key identity
)
go

--Dimension geografia -> union entre tabla pais, region y ciudad 
create table Dimension.Geografia
(
	SK_Geografia [UDT_SK] primary key identity
)
go

--Dimension clientes -> informacion de clientes
create table Dimension.Clientes
(
	SK_Clientes [UDT_SK] primary key identity
)
go

--Dimension StatusOrden -> informacion del estado del cliente
create table Dimension.StatusOrden
(
	SK_StatusOrden [UDT_SK] primary key identity
)
go

--Dimension Aseguradoras -> informacion del nombre de aseguradora
create table Dimension.Aseguradoras
(
	SK_Aseguradoras [UDT_SK] primary key identity
)
go

--Dimension PlantaReparacion -> informacion de la PlantaReparacion
create table Dimension.PlantaReparacion
(
	SK_PlantaReparacion [UDT_SK] primary key identity
)
go

--Dimension Vehiculo -> informacion del Vehiculo
create table Dimension.Vehiculo
(
	SK_Vehiculo [UDT_SK] primary key identity
)
go

--Dimension Descuento -> informacion del Descuento
create table Dimension.Descuento
(
	SK_Descuento [UDT_SK] primary key identity
)
go

--dimension fecha-> informacion de fechas desglasada 
create table Dimension.Fecha
(
	DateKey int primary key
)
go

--Tabla fact -> union entre orden, detalle orden, descuento y statusorden
create table Fact.Orden
(
	SK_Orden [UDT_SK] primary key identity,
	SK_Partes [UDT_SK] references Dimension.Partes(SK_Partes),
	SK_Geografia [UDT_SK] references Dimension.Geografia(SK_Geografia),
	SK_Clientes [UDT_SK] references Dimension.Clientes(SK_Clientes),
	SK_StatusOrden [UDT_SK] references Dimension.StatusOrden(SK_StatusOrden),
	SK_Aseguradoras [UDT_SK] references Dimension.Aseguradoras(SK_Aseguradoras),
	SK_PlantaReparacion [UDT_SK] references Dimension.PlantaReparacion(SK_PlantaReparacion),
	SK_Vehiculo [UDT_SK] references Dimension.Vehiculo(SK_Vehiculo),
	SK_Descuento [UDT_SK] references Dimension.Descuento(SK_Descuento),
	DateKey int references Dimension.Fecha(DateKey)
)
go

----METADA-> mejores practicas para un futuro se necesita una guia
exec sys.sp_addextendedproperty 
    @name = N'Desnormalizacion', 
    @value = N'La dimension candidato provee una vista desnormalizada de las tablas origen partes,linea y categoria uniendo todo en una única dimensión para un modelo estrella', 
    @level0type = N'SCHEMA', 
    @level0name = N'Dimension', 
    @level1type = N'TABLE', 
    @level1name = N'Partes';
go

exec sys.sp_addextendedproperty 
    @name = N'Desnormalizacion', 
    @value = N'La dimension geografia provee una vista desnormalizada de las tablas origen pais, region y ciudad  uniendo todo en una única dimensión para un modelo estrella', 
    @level0type = N'SCHEMA', 
    @level0name = N'Dimension', 
    @level1type = N'TABLE', 
    @level1name = N'Geografia';
go

exec sys.sp_addextendedproperty
	@name = N'Desnormalizacion',
	@value = N'La dimención de descuento proviene de la tabla cliente que provee toda la informacion de los clientes',
	@level0type = N'SCHEMA',
	@level0name= N'Dimension',
	@level1type = N'TABLE',
	@level1name = N'Clientes';
go

exec sys.sp_addextendedproperty 
    @name = N'Desnormalizacion', 
    @value = N'Información del status de la orden', 
    @level0type = N'SCHEMA', 
    @level0name = N'Dimension', 
    @level1type = N'TABLE', 
    @level1name = N'StatusOrden';
go

exec sys.sp_addextendedproperty 
    @name = N'Desnormalizacion', 
    @value = N'Información del vehículo del cual se cotiza o vende una parte.', 
    @level0type = N'SCHEMA', 
    @level0name = N'Dimension', 
    @level1type = N'TABLE', 
    @level1name = N'Aseguradoras';
go

exec sys.sp_addextendedproperty 
    @name = N'Desnormalizacion', 
    @value = N'Información de plantas de reparaciones que enviían cotizaciones a Auto Partes en representación de una empresa de seguros', 
    @level0type = N'SCHEMA', 
    @level0name = N'Dimension', 
    @level1type = N'TABLE', 
    @level1name = N'PlantaReparacion';
go

exec sys.sp_addextendedproperty 
    @name = N'Desnormalizacion', 
    @value = N'Información del vehículo que se cotiza o vende una parte.', 
    @level0type = N'SCHEMA', 
    @level0name = N'Dimension', 
    @level1type = N'TABLE', 
    @level1name = N'Vehiculo';
go

exec sys.sp_addextendedproperty 
    @name = N'Desnormalizacion', 
    @value = N'Posee información de descuentos promocionales que se pueden aplicar a una orden.', 
    @level0type = N'SCHEMA', 
    @level0name = N'Dimension', 
    @level1type = N'TABLE', 
    @level1name = N'Descuento';
go

exec sys.sp_addextendedproperty 
    @name = N'Desnormalizacion', 
    @value = N'La dimension fecha es generada de forma automatica y no tiene datos origen, se puede regenerar enviando un rango de fechas al stored procedure USP_FillDimDate', 
    @level0type = N'SCHEMA', 
    @level0name = N'Dimension', 
    @level1type = N'TABLE', 
    @level1name = N'Fecha';
go

exec sys.sp_addextendedproperty 
    @name = N'Desnormalizacion', 
    @value = N'La tabla de hechos es una union proveniente de las tablas de origen orden, orden detalle, descuento y status orden', 
    @level0type = N'SCHEMA', 
    @level0name = N'Fact', 
    @level1type = N'TABLE', 
    @level1name = N'Orden';
go

------------------------------------------------MODELADO LOGICO---------------------------------------------------------------------
--Transformación en modelo logico es decir que se agregan mas detalles
--complementar el diseño que se empezo a crear
-------------------------------------------------------------------------------------------------------
--Tabla Fact
alter table Fact.Orden add ID_Orden [UDT_PK]
alter table Fact.Orden add ID_DetalleOrden [UDT_PK]
alter table Fact.Orden add ID_Cotizacion [UDT_PK]
alter table Fact.Orden add NumLinea [UDT_VarcharMediano]
alter table Fact.Orden add Total_Orden [UDT_Decimal12.2]
alter table Fact.Orden add Cantidad [UDT_INT]---duda si es necesario para los ints o solo se pone int
alter table Fact.Orden add Fecha_Orden [UDT_DateTime]
alter table Fact.Orden add status_cotizacion  [UDT_VarcharMediano]
alter table Fact.Orden add TipoDocumento   [UDT_VarcharMediano]
alter table Fact.Orden add ProcesadoPor   [UDT_VarcharMediano]
alter table Fact.Orden add AseguradoraSubsidiaria   [UDT_VarcharLargo]
alter table Fact.Orden add NumeroReclamo   [UDT_VarcharMediano]
alter table Fact.Orden add OrdenRealizada   BIT
alter table Fact.Orden add CotizacionRealizada   BIT
alter table Fact.Orden add CotizacionDuplicada   BIT
alter table Fact.Orden add procurementFolderID   [UDT_VarcharMediano]
alter table Fact.Orden add DireccionEntrega1   [UDT_VarcharMediano]
alter table Fact.Orden add DireccionEntrega2   [UDT_VarcharMediano]
alter table Fact.Orden add MarcadoEntrega   BIT
alter table Fact.Orden add CodigoPostal  [UDT_VarcharCorto]
alter table Fact.Orden add LeidoPorPlantaReparacion    BIT
alter table Fact.Orden add LeidoPorPlantaReparacionFecha   [UDT_DateTime]
alter table Fact.Orden add CotizacionReabierta     BIT
alter table Fact.Orden add EsAseguradora     BIT
alter table Fact.Orden add CodigoVerificacion   [UDT_VarcharMediano]
alter table Fact.Orden add FechaCreacionRegistro   [UDT_DateTime]
alter table Fact.Orden add PartnerConfirmado     BIT
alter table Fact.Orden add WrittenBy   [UDT_VarcharMediano]
alter table Fact.Orden add SeguroValidado      BIT
alter table Fact.Orden add FechaCaptura   [UDT_DateTime]
alter table Fact.Orden add Ruta   [UDT_VarcharLargo]
alter table Fact.Orden add FechaLimiteRuta   [UDT_VarcharMediano]
alter table Fact.Orden add TelefonoEntrega [UDT_VarcharCorto]
alter table Fact.Orden add OETipoParte [UDT_VarcharCorto]
alter table Fact.Orden add AltPartNum   [UDT_VarcharMediano]
alter table Fact.Orden add AltTipoParte   [UDT_VarcharMediano]
alter table Fact.Orden add ciecaTipoParte   [UDT_VarcharMediano]
alter table Fact.Orden add partDescripcion   [UDT_VarcharLargo]
alter table Fact.Orden add PrecioListaOnRO [UDT_VarcharCorto]
alter table Fact.Orden add PrecioNetoOnRO [UDT_VarcharCorto]
alter table Fact.Orden add NecesitadoParaFecha   [UDT_DateTime]
--columnas de auditoria
alter table Fact.Orden add FechaCreacion [UDT_DateTime] not null default(getdate())
alter table Fact.Orden add UsuarioCreacion nvarchar(100) not null default(suser_name())
alter table Fact.Orden add FechaModificacion [UDT_DateTime]
alter table Fact.Orden add UsuarioModificacion nvarchar(100) null
--columnas de linaje
alter table Fact.Orden add ID_Batch uniqueidentifier null
alter table Fact.Orden add ID_SourceSystem varchar(50)
--Dimension Partes 
alter table Dimension.Partes add ID_Parte [UDT_VarcharCorto]
alter table Dimension.Partes add ID_Linea [UDT_PK]
alter table Dimension.Partes add ID_Categoria [UDT_PK]
alter table Dimension.Partes add NombreParte [UDT_VarcharCorto]
alter table Dimension.Partes add DescripcionParte [UDT_VarcharLargo]
alter table Dimension.Partes add PrecioParte [UDT_Decimal12.2]
alter table Dimension.Partes add NombreCategoria [UDT_VarcharCorto]
alter table Dimension.Partes add DescripcionCategoria [UDT_VarcharLargo]
alter table Dimension.Partes add NombreLinea [UDT_VarcharCorto]
alter table Dimension.Partes add DescripcionLinea [UDT_VarcharLargo]
--columnas scd tipo 2
alter table Dimension.Partes add FechaInicioValidez [UDT_DateTime] not null default (getdate())
alter table Dimension.Partes add FechaFinValidez [UDT_DateTime] null
--columnas de auditoria
alter table Dimension.Partes add FechaCreacion [UDT_DateTime] not null default(getdate())
alter table Dimension.Partes add UsuarioCreacion nvarchar(100) not null default(suser_name())
alter table Dimension.Partes add FechaModificacion [UDT_DateTime]
alter table Dimension.Partes add UsuarioModificacion nvarchar(100) null
--Dimension Geografia
alter table Dimension.Geografia add ID_Pais [UDT_PK]  
alter table Dimension.Geografia add ID_Region [UDT_PK]
alter table Dimension.Geografia add ID_Ciudad [UDT_PK]  
alter table Dimension.Geografia add NombrePais [UDT_VarcharCorto]
alter table Dimension.Geografia add NombreRegion [UDT_VarcharCorto]
alter table Dimension.Geografia add NombreCiudad [UDT_VarcharCorto]
alter table Dimension.Geografia add CodigoPostal  [UDT_VarcharCorto]
--columnas scd tipo 2
alter table Dimension.Geografia add FechaInicioValidez [UDT_DateTime] not null default (getdate())
alter table Dimension.Geografia add FechaFinValidez [UDT_DateTime] null
--columnas de auditoria
alter table Dimension.Geografia add FechaCreacion [UDT_DateTime] not null default(getdate())
alter table Dimension.Geografia add UsuarioCreacion nvarchar(100) not null default(suser_name())
alter table Dimension.Geografia add FechaModificacion [UDT_DateTime]
alter table Dimension.Geografia add UsuarioModificacion nvarchar(100) null
--Dimension Cliente
alter table Dimension.Clientes add ID_Cliente [UDT_PK]
alter table Dimension.Clientes add PrimerNombre [UDT_VarcharCorto]
alter table Dimension.Clientes add SegundoNombre [UDT_VarcharCorto]
alter table Dimension.Clientes add PrimerApellido [UDT_VarcharCorto]
alter table Dimension.Clientes add SegundoApellido [UDT_VarcharCorto]
alter table Dimension.Clientes add Genero [UDT_UnCaracter]
alter table Dimension.Clientes add Correo_Electronico [UDT_VarcharCorto]
alter table Dimension.Clientes add FechaNacimiento [UDT_DateTime]
--columnas scd tipo 2
alter table Dimension.Clientes add FechaInicioValidez [UDT_DateTime] not null default (getdate())
alter table Dimension.Clientes add FechaFinValidez [UDT_DateTime] null
--columnas de auditoria
alter table Dimension.Clientes add FechaCreacion [UDT_DateTime] not null default(getdate())
alter table Dimension.Clientes add UsuarioCreacion nvarchar(100) not null default(suser_name())
alter table Dimension.Clientes add FechaModificacion [UDT_DateTime]
alter table Dimension.Clientes add UsuarioModificacion nvarchar(100) null
--Dimension StatusOrden
alter table Dimension.StatusOrden add ID_StatusOrden [UDT_PK]
alter table Dimension.StatusOrden add NombreStatus [UDT_VarcharLargo]
--columnas scd tipo 2
alter table Dimension.StatusOrden add FechaInicioValidez [UDT_DateTime] not null default (getdate())
alter table Dimension.StatusOrden add FechaFinValidez [UDT_DateTime] null
--columnas de auditoria
alter table Dimension.StatusOrden add FechaCreacion [UDT_DateTime] not null default(getdate())
alter table Dimension.StatusOrden add UsuarioCreacion nvarchar(100) not null default(suser_name())
alter table Dimension.StatusOrden add FechaModificacion [UDT_DateTime]
alter table Dimension.StatusOrden add UsuarioModificacion nvarchar(100) null
--Dimension Aseguradoras
alter table Dimension.Aseguradoras add ID_Aseguradora [UDT_PK]
alter table Dimension.Aseguradoras add NombreAseguradora [UDT_VarcharLargo]
alter table Dimension.Aseguradoras add RowCreatedDate [UDT_DateTime]
alter table Dimension.Aseguradoras add Activa      BIT
--columnas scd tipo 2
alter table Dimension.Aseguradoras add FechaInicioValidez [UDT_DateTime] not null default (getdate())
alter table Dimension.Aseguradoras add FechaFinValidez [UDT_DateTime] null
--columnas de auditoria
alter table Dimension.Aseguradoras add FechaCreacion [UDT_DateTime] not null default(getdate())
alter table Dimension.Aseguradoras add UsuarioCreacion nvarchar(100) not null default(suser_name())
alter table Dimension.Aseguradoras add FechaModificacion [UDT_DateTime]
alter table Dimension.Aseguradoras add UsuarioModificacion nvarchar(100) null
--Dimension PlantaReparacion
alter table Dimension.PlantaReparacion add ID_PlantaReparacion [UDT_VarcharMediano]
alter table Dimension.PlantaReparacion add CompanyNombre   [UDT_VarcharMediano]
alter table Dimension.PlantaReparacion add Direccion   [UDT_VarcharMediano]
alter table Dimension.PlantaReparacion add Direccion2   [UDT_VarcharMediano]
alter table Dimension.PlantaReparacion add Ciudad   [UDT_VarcharMediano]
alter table Dimension.PlantaReparacion add Estado   [UDT_VarcharMediano]
alter table Dimension.PlantaReparacion add CodigoPostal   [UDT_VarcharCorto]
alter table Dimension.PlantaReparacion add Pais   [UDT_VarcharCorto]
alter table Dimension.PlantaReparacion add TelefonoAlmacen   [UDT_VarcharCorto]
alter table Dimension.PlantaReparacion add FaxAlmacen   [UDT_VarcharCorto]
alter table Dimension.PlantaReparacion add CorreoContacto   [UDT_VarcharMediano]
alter table Dimension.PlantaReparacion add NombreContacto   [UDT_VarcharLargo]
alter table Dimension.PlantaReparacion add TelefonoContacto   [UDT_VarcharCorto]
alter table Dimension.PlantaReparacion add TituloTrabajo   [UDT_VarcharMediano]
alter table Dimension.PlantaReparacion add AlmacenKeystone   [UDT_VarcharCorto]
alter table Dimension.PlantaReparacion add IDPredio   [UDT_VarcharCorto]
alter table Dimension.PlantaReparacion add LocalizadorCotizacion   [UDT_VarcharCorto]
alter table Dimension.PlantaReparacion add FechaAgregado [UDT_DateTime]
alter table Dimension.PlantaReparacion add IDEmpresa   [UDT_VarcharCorto]
alter table Dimension.PlantaReparacion add ValidacionSeguro      BIT
alter table Dimension.PlantaReparacion add Activo      BIT
alter table Dimension.PlantaReparacion add CreadoPor   [UDT_VarcharMediano]
alter table Dimension.PlantaReparacion add ActualizadoPor   [UDT_VarcharMediano]
alter table Dimension.PlantaReparacion add UltimaFechaActualizacion [UDT_DateTime]
--columnas scd tipo 2
alter table Dimension.PlantaReparacion add FechaInicioValidez [UDT_DateTime] not null default (getdate())
alter table Dimension.PlantaReparacion add FechaFinValidez [UDT_DateTime] null
--columnas de auditoria
alter table Dimension.PlantaReparacion add FechaCreacion [UDT_DateTime] not null default(getdate())
alter table Dimension.PlantaReparacion add UsuarioCreacion nvarchar(100) not null default(suser_name())
alter table Dimension.PlantaReparacion add FechaModificacion [UDT_DateTime]
alter table Dimension.PlantaReparacion add UsuarioModificacion nvarchar(100) null
--Dimension Vehiculo
alter table Dimension.Vehiculo add VehiculoID [UDT_PK]
alter table Dimension.Vehiculo add VIN_Patron [UDT_VarcharCorto]
alter table Dimension.Vehiculo add Anio SMALLINT
alter table Dimension.Vehiculo add Marca [UDT_VarcharMediano]
alter table Dimension.Vehiculo add Modelo [UDT_VarcharMediano]
alter table Dimension.Vehiculo add SubModelo [UDT_VarcharLargo]
alter table Dimension.Vehiculo add Estilo [UDT_VarcharLargo]
--columnas scd tipo 2
alter table Dimension.Vehiculo add FechaInicioValidez [UDT_DateTime] not null default (getdate())
alter table Dimension.Vehiculo add FechaFinValidez [UDT_DateTime] null
--columnas de auditoria
alter table Dimension.Vehiculo add FechaCreacion [UDT_DateTime] not null default(getdate())
alter table Dimension.Vehiculo add UsuarioCreacion nvarchar(100) not null default(suser_name())
alter table Dimension.Vehiculo add FechaModificacion [UDT_DateTime]
alter table Dimension.Vehiculo add UsuarioModificacion nvarchar(100) null
--Dimension Descuento
alter table Dimension.Descuento add ID_Descuento [UDT_PK]
alter table Dimension.Descuento add NombreDescuento [UDT_VarcharLargo]
alter table Dimension.Descuento add PorcentajeDescuento [UDT_Decimal12.2]
--columnas scd tipo 2
alter table Dimension.Descuento add FechaInicioValidez [UDT_DateTime] not null default (getdate())
alter table Dimension.Descuento add FechaFinValidez [UDT_DateTime] null
--columnas de auditoria
alter table Dimension.Descuento add FechaCreacion [UDT_DateTime] not null default(getdate())
alter table Dimension.Descuento add UsuarioCreacion nvarchar(100) not null default(suser_name())
alter table Dimension.Descuento add FechaModificacion [UDT_DateTime]
alter table Dimension.Descuento add UsuarioModificacion nvarchar(100) null
--Dimension Fecha
alter table Dimension.Fecha add [Date] DATE NOT NULL
alter table Dimension.Fecha add [Day] TINYINT NOT NULL
alter table Dimension.Fecha add [DaySuffix] CHAR(2) NOT NULL
alter table Dimension.Fecha add [Weekday] TINYINT NOT NULL
alter table Dimension.Fecha add [WeekDayName] VARCHAR(10) NOT NULL
alter table Dimension.Fecha add [WeekDayName_Short] CHAR(3) NOT NULL
alter table Dimension.Fecha add [WeekDayName_FirstLetter] CHAR(1) NOT NULL
alter table Dimension.Fecha add [DOWInMonth] TINYINT NOT NULL
alter table Dimension.Fecha add [DayOfYear] SMALLINT NOT NULL
alter table Dimension.Fecha add [WeekOfMonth] TINYINT NOT NULL
alter table Dimension.Fecha add [WeekOfYear] TINYINT NOT NULL
alter table Dimension.Fecha add [Month] TINYINT NOT NULL
alter table Dimension.Fecha add [MonthName] VARCHAR(10) NOT NULL
alter table Dimension.Fecha add [MonthName_Short] CHAR(3) NOT NULL
alter table Dimension.Fecha add [MonthName_FirstLetter] CHAR(1) NOT NULL
alter table Dimension.Fecha add [Quarter] TINYINT NOT NULL
alter table Dimension.Fecha add [QuarterName] VARCHAR(6) NOT NULL
alter table Dimension.Fecha add [Year] INT NOT NULL
alter table Dimension.Fecha add [MMYYYY] CHAR(6) NOT NULL
alter table Dimension.Fecha add [MonthYear] CHAR(7) NOT NULL
alter table Dimension.Fecha add IsWeekend BIT NOT NULL
--Indices Columnares
--indices columnares hacen mas eficientes las funciones de agregacion
--este indice va ayudar para poder hacer el cubo posteriormente ya que el cubo hace un presosamiento de la informacion
CREATE NONCLUSTERED COLUMNSTORE INDEX [NCCS-Total] ON [Fact].[Orden]
(
	[Total_Orden],
	[Cantidad]
)WITH (DROP_EXISTING = OFF, COMPRESSION_DELAY = 0)
GO