USE GD2C_2026;
GO

CREATE SCHEMA [JOINT_BASADOS] AUTHORIZATION dbo;
GO

CREATE TABLE [JOINT_BASADOS].[Marcas] (
    id INT IDENTITY (1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);
GO

CREATE TABLE [JOINT_BASADOS].[Categorias_Bicicletas] (
    id INT IDENTITY (1,1) PRIMARY KEY,
    categoria VARCHAR(50) NOT NULL
);
GO

CREATE TABLE [JOINT_BASADOS].[Modelos_Bicicletas] (
    id INT IDENTITY (1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    nro_rodado INT NOT NULL,
    talle_cuadro VARCHAR(1) NOT NULL,
    color VARCHAR(10) NOT NULL,
    categoria_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Categorias_Bicicletas](id),
    marca_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Marcas](id)
);
GO

CREATE TABLE [JOINT_BASADOS].[Categorias_Accesorios] (
    id INT IDENTITY (1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL
);
GO

CREATE TABLE [JOINT_BASADOS].[Accesorios] (
    id INT IDENTITY (1,1) PRIMARY KEY,
    talle VARCHAR(1),
    color VARCHAR(10),
    categoria_accesorio_id INT REFERENCES [JOINT_BASADOS].[Categorias_Accesorios](id),
    marca_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Marcas](id)
);
GO

CREATE TABLE [JOINT_BASADOS].[Bicicletas_Ventas] (
    nro_serie INT PRIMARY KEY,
    modelo_id INT REFERENCES [JOINT_BASADOS].[Modelos_Bicicletas](id),
    garantia_meses INT
);
GO

CREATE TABLE [JOINT_BASADOS].[Estados_Bicicletas_Alquileres] (
    id INT IDENTITY (1,1) PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL
);
GO

CREATE TABLE [JOINT_BASADOS].[Bicicletas_Alquileres] (
    nro_serie INT PRIMARY KEY,
    modelo_id INT REFERENCES [JOINT_BASADOS].[Modelos_Bicicletas](id),
    precio_hora DECIMAL(10,2),
    precio_dia DECIMAL(10,2),
    estado_id INT REFERENCES [JOINT_BASADOS].[Estados_Bicicletas_Alquileres](id)
);
GO

CREATE TABLE [JOINT_BASADOS].[Provincias] (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);
GO

CREATE TABLE [JOINT_BASADOS].[Localidades] (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    provincia_id INT REFERENCES [JOINT_BASADOS].[Provincias](id)
);
GO

CREATE TABLE [JOINT_BASADOS].[Clientes] (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    apellido VARCHAR(255) NOT NULL,
    dni INT NOT NULL,
    telefono VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    activo BIT,
    localidad_id INT REFERENCES [JOINT_BASADOS].[Localidades](id)
);
GO

CREATE TABLE [JOINT_BASADOS].[Empleados] (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    descripcion_estado VARCHAR(255) NOT NULL
);
GO

CREATE TABLE [JOINT_BASADOS].[Formas_De_Pago] (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    descripcion VARCHAR(255) NOT NULL
);
GO

CREATE TABLE [JOINT_BASADOS].[Estados_Alquileres] (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    descripcion VARCHAR(255) NOT NULL
);
GO

CREATE TABLE [JOINT_BASADOS].[Estados_Reparaciones] (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    descripcion VARCHAR(255) NOT NULL
);
GO

CREATE TABLE [JOINT_BASADOS].[Categorias_Repuestos] (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    categoria VARCHAR(255) NOT NULL
);
GO

CREATE TABLE [JOINT_BASADOS].[Repuestos] (
    cod_repuesto INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    descripcion VARCHAR(MAX) NOT NULL,
    compatibilidad VARCHAR(MAX) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    categoria_id INT REFERENCES [JOINT_BASADOS].[Categorias_Repuestos](id)
);
GO

CREATE TABLE [JOINT_BASADOS].[Alquileres] (
    nro_alquiler INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    fecha_inicio DATE NOT NULL,
    fecha_fin_pactada DATE NOT NULL,
    fecha_devolucion_real DATE,
    importe_total DECIMAL(10,2) NOT NULL,
    nro_serie_bicicleta INT REFERENCES [JOINT_BASADOS].[Bicicletas_Alquileres](nro_serie),
    estado_alquiler_id INT REFERENCES [JOINT_BASADOS].[Estados_Alquileres](id),
    cliente_id INT REFERENCES [JOINT_BASADOS].[Clientes](id),
    empleado_id INT REFERENCES [JOINT_BASADOS].[Empleados](id),
    forma_pago_id INT REFERENCES [JOINT_BASADOS].[Formas_De_Pago](id)
);
GO

CREATE TABLE [JOINT_BASADOS].[Reparaciones] (
    nro_reparacion INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    modelo_id INT REFERENCES [JOINT_BASADOS].[Modelos_Bicicletas](id),
    cliente_id INT REFERENCES [JOINT_BASADOS].[Clientes](id),
    empleado_id INT REFERENCES [JOINT_BASADOS].[Empleados](id),
    estado_reparacion_id INT REFERENCES [JOINT_BASADOS].[Estados_Reparaciones](id),
    fecha_ingreso DATE NOT NULL,
    fecha_entrega_estimada DATE NOT NULL,
    fecha_entrega_real DATE,
    diagnostico VARCHAR(MAX),
    precio_mano_obra DECIMAL(10,2),
    precio_repuestos DECIMAL(10,2),
    precio_total DECIMAL(10,2)
);
GO

CREATE TABLE [JOINT_BASADOS].[Detalles_Reparaciones] (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    cod_repuesto INT REFERENCES [JOINT_BASADOS].[Repuestos](cod_repuesto),
    reparacion_id INT REFERENCES [JOINT_BASADOS].[Reparaciones](nro_reparacion)
);
GO

CREATE TABLE [JOINT_BASADOS].[Proveedores] (
    id INT IDENTITY (1,1) PRIMARY KEY,
    razon_social VARCHAR(50) NOT NULL,
    cuit VARCHAR(11) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    localidad_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Localidades](id)
);
GO

CREATE TABLE [JOINT_BASADOS].[Locales] (
    id INT IDENTITY (1,1) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    email VARCHAR(50) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    localidad_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Localidades](id)
);
GO

CREATE TABLE [JOINT_BASADOS].[Compras] (
    nro_compra INT PRIMARY KEY,
    fecha DATE NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    proveedor_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Proveedores](id),
    empleado_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Empleados](id)
);
GO

CREATE TABLE [JOINT_BASADOS].[Tipos_De_Productos] (
    id INT IDENTITY (1,1) PRIMARY KEY,
    tipo VARCHAR(50),
    activo BIT
);
GO

CREATE TABLE [JOINT_BASADOS].[Productos] (
    cod_producto VARCHAR(50) PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    descripcion VARCHAR(50),
    precio_unitario DECIMAL(10,2) NOT NULL,
    precio_venta DECIMAL(10,2),
    activo BIT NOT NULL DEFAULT 1,
    tipo_producto_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Tipos_De_Productos](id),
    accesorio_id INT REFERENCES [JOINT_BASADOS].[Accesorios](id),
    nro_serie_bicicleta INT REFERENCES [JOINT_BASADOS].[Bicicletas_Ventas](nro_serie)
);
GO

CREATE TABLE [JOINT_BASADOS].[Detalles_Compras] (
    id INT IDENTITY (1,1) PRIMARY KEY,
    nro_compra INT NOT NULL REFERENCES [JOINT_BASADOS].[Compras](nro_compra),
    cod_producto VARCHAR(50) NOT NULL REFERENCES [JOINT_BASADOS].[Productos](cod_producto),
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2)
);
GO 

CREATE TABLE [JOINT_BASADOS].[Ventas] (
    nro_venta INT PRIMARY KEY,
    fecha_hora DATETIME NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    forma_pago_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Formas_De_Pago](id),
    local_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Locales](id),
    cliente_id INT REFERENCES [JOINT_BASADOS].[Clientes](id),
    empleado_id INT REFERENCES [JOINT_BASADOS].[Empleados](id)
);
GO

CREATE TABLE [JOINT_BASADOS].[Detalles_Ventas] (
    id INT IDENTITY (1,1) PRIMARY KEY,
    nro_venta INT NOT NULL REFERENCES [JOINT_BASADOS].[Ventas](nro_venta),
    cod_producto VARCHAR(50) NOT NULL REFERENCES [JOINT_BASADOS].[Productos](cod_producto),
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL
);
GO