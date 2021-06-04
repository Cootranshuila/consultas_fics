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