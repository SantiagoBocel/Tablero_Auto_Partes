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
    @level1name = N'Aseguradora';
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
alter table Fact.Orden add ID_Descuento [UDT_PK]
alter table Fact.Orden add ID_DetalleOrden [UDT_PK]
alter table Fact.Orden add ID_Aseguradora [UDT_PK]
alter table Fact.Orden add ID_PlantaReparacion [UDT_PK]
alter table Fact.Orden add ID_Partner [UDT_PK]
alter table Fact.Orden add ID_ClientePlantaReparacion [UDT_PK]
alter table Fact.Orden add ID_Recotizacion [UDT_PK]
alter table Fact.Orden add ID_Parte [UDT_PK]
alter table Fact.Orden add NumLinea [UDT_PK]
alter table Fact.Orden add NombreDescuento [UDT_VarcharMediano]
alter table Fact.Orden add PorcentajeDescuento  [UDT_Decimal2.2]
alter table Fact.Orden add Total_Orden [UDT_Decimal12.2]
alter table Fact.Orden add Cantidad [UDT_INT]---duda si es necesario para los ints o solo se pone int
alter table Fact.Orden add NombreStatus [UDT_VarcharCorto]
alter table Fact.Orden add Fecha_Orden [UDT_DateTime]
alter table Fact.Orden add Fecha_Modificacion [UDT_DateTime]
alter table Fact.Orden add status_cotizacion  [UDT_VarcherMediano]
alter table Fact.Orden add TipoDocumento   [UDT_VarcherMediano]
alter table Fact.Orden add FechaCreacion  [UDT_DateTime]
alter table Fact.Orden add FechaModificacion  [UDT_DateTime]
alter table Fact.Orden add ProcesadoPor   [UDT_VarcherMediano]
alter table Fact.Orden add AseguradoraSubsidiaria   [UDT_VarcharLargo]
alter table Fact.Orden add NumeroReclamo   [UDT_VarcherMediano]
alter table Fact.Orden add OrdenRealizada   BIT
alter table Fact.Orden add CotizacionRealizada   BIT
alter table Fact.Orden add CotizacionDuplicada   BIT
alter table Fact.Orden add procurementFolderID   [UDT_VarcherMediano]
alter table Fact.Orden add DireccionEntrega1   [UDT_VarcherMediano]
alter table Fact.Orden add DireccionEntrega2   [UDT_VarcherMediano]
alter table Fact.Orden add MarcadoEntrega   BIT
alter table Fact.Orden add CodigoPostal  [UDT_VarcharCorto]
alter table Fact.Orden add LeidoPorPlantaReparacion    BIT
alter table Fact.Orden add LeidoPorPlantaReparacionFecha   [UDT_DateTime]
alter table Fact.Orden add CotizacionReabierta     BIT
alter table Fact.Orden add EsAseguradora     BIT
alter table Fact.Orden add CodigoVerificacion   [UDT_VarcherMediano]
alter table Fact.Orden add FechaCreacionRegistro   [UDT_DateTime]
alter table Fact.Orden add PartnerConfirmado     BIT
alter table Fact.Orden add WrittenBy   [UDT_VarcherMediano]
alter table Fact.Orden add SeguroValidado      BIT
alter table Fact.Orden add FechaCaptura   [UDT_DateTime]
alter table Fact.Orden add Ruta   [UDT_VarcharLargo]
alter table Fact.Orden add FechaLimiteRuta   [UDT_VarcherMediano]
alter table Fact.Orden add TelefonoEntrega [UDT_VarcharCorto]
alter table Fact.Orden add OETipoParte [UDT_VarcharCorto]
alter table Fact.Orden add AltPartNum   [UDT_VarcherMediano]
alter table Fact.Orden add AltTipoParte   [UDT_VarcherMediano]
alter table Fact.Orden add ciecaTipoParte   [UDT_VarcherMediano]
alter table Fact.Orden add partDescripcion   [UDT_VarcharLargo]
alter table Fact.Orden add PrecioListaOnRO [UDT_VarcharCorto]
alter table Fact.Orden add PrecioNetoOnRO [UDT_VarcharCorto]
alter table Fact.Orden add NecesitadoParaFecha   [UDT_DateTime]