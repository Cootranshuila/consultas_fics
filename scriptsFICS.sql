-- Scripts Database: FICS.HUIL -SQLServer

-- Estructura basica de un select: SELECT TOP (1000) campos separados por comas o * selecciona todo FROM Tabla

-- ---------------------------------------------------------------------------------------------------------------
-- TABLAS DE INTERES
-- Boleterias: es la tabla de las agencias, contiene la configuración de cada agencia
-- Coches: es la tabla de los vehiculos
-- Viajes: es la tabla de los despachos
-- ViajesTripulantes: es la relacion entre el despacho y el pasajero
-- Usuarios: es la tabla de usuarios del sistema
-- Perfiles: es la tabla de categoria de usuarios (taquillero, jefe de taquilla, administrador...)
-- UsuariosPerfiles: es la relacion del perfil o perfiles de un usuario
-- Personas: es la tabla de clientes
-- Tripulantes: es la tabla de clientes
-- TFC_ViajesDespachos: es la tabla de despachos
-- TFC_ViajesDespachos_Cancelados: es la tabla de los despachos cancelados
-- Terminales: es la tabla con la informacion de los terminales
-- Socios: es la tabla de socios
-- SociosCoches: es la relacion de los carros de los socios
-- Reservas: es la tabla de reservas
-- Pasajes: es la tabla de tiquetes
-- PasajesTipos: es la tabla del tipo de venta
-- MediosPago: es la tabla de los medios de pago
-- PasajesTiposMediosPago: es la relacion del metodo de pago del tiquete
-- CategoriasServicios: es la tabla de la modalidad del vehiculo (VIP, DOBLE YO ...)

-- Consulta de cajas abiertas
SELECT TOP 100 Usuarios.Nombre, FechaHoraApertura, FechaHoraCierre, SaldoCierre, Boleterias.Nombre AS Agencia 
FROM CajasUsuarios, Usuarios, Boleterias
WHERE CajasUsuarios.Usuario = Usuarios.Id AND Boleterias.Id = CajasUsuarios.Boleteria


-- Consulta de venta de tiquetes
SELECT TOP (1000) Numero,ImporteFinal,Pasajes.Estado,ViajeFechaTope,Persona,Viajo, PasajesTipos.Nombre AS Tipo_venta, CONCAT(Personas.Nombres,' ',Personas.Apellido) AS Pasajero
FROM Pasajes, PasajesTipos, Personas
WHERE Pasajes.TipoPasaje = PasajesTipos.Id AND Personas.Id = Pasajes.Persona


-- consulta de taquilleros con mayor numero de ventas generadas dependiendo del descuento
select u.nombre, b.nombre, YEAR(po.fechaoperacion) as AñoOperacion,month(po.fechaoperacion) as Mesoperacion, sum(p.importebase) as TarifaPlena ,sum(p.importedescuentos) as DescuentosAplicados,
sum(p.importefinal) as ImporteFinal, CONCAT(cast((sum(p.importedescuentos) * 100.0)/sum(p.importebase) as decimal(16,2)), '%') as Porcentaje, count(p.id) as CantidadTickets 
from pasajesoperaciones po 
inner join pasajes p on po.pasaje=p.id
inner join boleterias b on po.boleteria=b.id inner join usuarios u on po.usuario=u.id
inner join g_Localidades lo on p.localidadorigen=lo.localidadid
inner join g_localidades ld on p.localidaddestino=ld.localidadid
inner join PasajesTipos pt on p.TipoPasaje=pt.id
Where p.estado=0 and po.operacion=0  and po.FechaOperacion between '2021-07-01' and '2021-07-31 23:59'
and p.tipopasaje not in (4,5,8,3)
group by u.nombre,b.nombre, YEAR(po.fechaoperacion),month(po.fechaoperacion) order by u.nombre asc


-- consulta Ventas online por cada canal.
SELECT u.nombre, YEAR(po.fechaoperacion) as AñoOperacion,month(po.fechaoperacion) as MesOperacion, sum(p.importebase) as TarifaPlena ,sum(p.importedescuentos) as DescuentosAplicados,
sum(p.importefinal) as ImporteFinal, CONCAT(cast((sum(p.importedescuentos) * 100.0)/sum(p.importebase) as decimal(16,2)), '%') as Porcentaje, count(p.id) as CantidadTickets
from pasajesoperaciones po
inner join pasajes p on po.pasaje=p.id
inner join boleterias b on po.boleteria=b.id inner join usuarios u on po.usuario=u.id
inner join g_Localidades lo on p.localidadorigen=lo.localidadid
inner join g_localidades ld on p.localidaddestino=ld.localidadid
inner join PasajesTipos pt on p.TipoPasaje=pt.id
Where p.estado=0 and po.operacion=0  and po.FechaOperacion between '2021-09-01' and '2021-09-30 23:59'
and po.boleteria in (11,58,61)
group by b.nombre,u.nombre, YEAR(po.fechaoperacion),month(po.fechaoperacion) order by sum(p.importefinal) desc


-- consulta Ventas totales distribuidos por agencias.
SELECT b.nombre, YEAR(po.fechaoperacion) as AñoOperacion,month(po.fechaoperacion) as MesOperacion, sum(p.importebase) as TarifaPlena ,sum(p.importedescuentos) as DescuentosAplicados,
sum(p.importefinal) as ImporteFinal, count(p.id) as CantidadTickets
from pasajesoperaciones po
inner join pasajes p on po.pasaje=p.id
inner join boleterias b on po.boleteria=b.id
inner join g_Localidades lo on p.localidadorigen=lo.localidadid
inner join g_localidades ld on p.localidaddestino=ld.localidadid
inner join PasajesTipos pt on p.TipoPasaje=pt.id
Where (p.estado = 0 OR p.estado = 3) and po.operacion = 0 and p.tipopasaje not in (4,5,8,3) and b.id = 46 
and po.FechaOperacion between '2022-04-01' and '2022-04-30 23:59'
group by b.nombre, YEAR(po.fechaoperacion),month(po.fechaoperacion) order by sum(p.importefinal) desc










-- Consulta Cantidad de ventas con descuento por cada taquillero
select u.nombre,b.nombre, lo.nombre as Origen,ld.nombre as destino,YEAR(po.fechaoperacion) as AñoOperacion,month(po.fechaoperacion) as Mesoperacion, sum(p.importebase) as TarifaPlena
,sum(p.importedescuentos) as DescuentosAplicados,
sum(p.importefinal) as ImporteFinal, count(p.id) as CantidadTickets from pasajesoperaciones po inner join pasajes p on po.pasaje=p.id
inner join boleterias b on po.boleteria=b.id inner join usuarios u on po.usuario=u.id
inner join g_Localidades lo on p.localidadorigen=lo.localidadid
inner join g_localidades ld on p.localidaddestino=ld.localidadid
Where p.estado=0 and po.operacion=0  and po.FechaOperacion between '2021-06-01' and '2021-06-30 23:59'
and p.tipopasaje not in (4,5,8,3)

group by b.nombre,u.nombre,lo.nombre,ld.nombre, YEAR(po.fechaoperacion),month(po.fechaoperacion) order by sum(p.importefinal) desc


-- consulta
select u.nombre AS Usuario ,b.nombre as Agencia,pt.Nombre AS TipoTicket,P.numero, lo.nombre as Origen,ld.nombre as Destino,YEAR(po.fechaoperacion) as AñoOperacion,month(po.fechaoperacion) as Mesoperacion,
p.importebase as TarifaPlena
,p.importedescuentos as DescuentosAplicados,
p.importefinal as ImporteFinal FROM pasajesoperaciones po inner join pasajes p on po.pasaje=p.id
inner join boleterias b on po.boleteria=b.id inner join usuarios u on po.usuario=u.id
inner join g_Localidades lo on p.localidadorigen=lo.localidadid
inner join g_localidades ld on p.localidaddestino=ld.localidadid
inner join PasajesTipos pt on p.TipoPasaje=pt.id
Where p.estado=0 and po.operacion=0  and po.FechaOperacion between '2021-07-01' and '2021-07-31 23:59'
and p.tipopasaje not in (4,5,8,3)

-- consulta ventas
select u.nombre,YEAR(po.fechaoperacion) as AñoOperacion,month(po.fechaoperacion) as Mesoperacion, sum(p.importebase) as TarifaPlena ,sum(p.importedescuentos) as DescuentosAplicados,
sum(p.importefinal) as ImporteFinal, CONCAT(cast((sum(p.importedescuentos) * 100.0)/sum(p.importebase) as decimal(16,2)), '%') as Porcentaje, count(p.id) as CantidadTickets 
from pasajesoperaciones po 
inner join pasajes p on po.pasaje=p.id
inner join boleterias b on po.boleteria=b.id inner join usuarios u on po.usuario=u.id
inner join g_Localidades lo on p.localidadorigen=lo.localidadid
inner join g_localidades ld on p.localidaddestino=ld.localidadid
inner join PasajesTipos pt on p.TipoPasaje=pt.id
Where p.estado=0 and po.operacion=0  and po.FechaOperacion between '2021-07-01' and '2021-07-31 23:59'
and p.tipopasaje not in (4,5,8,3)
group by b.nombre,u.nombre, YEAR(po.fechaoperacion),month(po.fechaoperacion) order by sum(p.importefinal) desc

-- consulta ventas totales por categorias
select ca.Nombre, YEAR(po.fechaoperacion) as AñoOperacion, month(po.fechaoperacion) as Mesoperacion, sum(p.importebase) as TarifaPlena, sum(p.importedescuentos) as DescuentosAplicados, sum(p.importefinal) as ImporteFinal, count(p.id) as CantidadTickets 
from pasajesoperaciones po 
left join pasajes p on po.pasaje=p.id
left join viajes v on v.Id = p.Viaje
left join servicios s on s.Id = v.Servicio
left join CategoriasServicios ca on ca.id = s.Categoria
Where p.estado=0 and po.operacion=0  and po.FechaOperacion between '2021-07-01' and '2021-07-31 23:59'
and p.tipopasaje not in (4,5,8,3)
group by ca.nombre, YEAR(po.fechaoperacion),month(po.fechaoperacion) 
order by sum(p.importefinal) desc
