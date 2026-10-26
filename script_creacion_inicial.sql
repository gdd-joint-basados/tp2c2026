USE GD2C_2026;
GO

CREATE SCHEMA [JOINT_BASADOS] AUTHORIZATION dbo;
GO

CREATE TABLE [JOINT_BASADOS].[Marcas] (
    id INT IDENTITY (1,1) PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);
GO

CREATE TABLE [JOINT_BASADOS].[Categorias_Bicicletas] (
    id INT IDENTITY (1,1) PRIMARY KEY,
    categoria VARCHAR(255) NOT NULL
);
GO

CREATE TABLE [JOINT_BASADOS].[Modelos_Bicicletas] (
    id INT IDENTITY (1,1) PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    nro_rodado VARCHAR(255) NOT NULL,
    talle_cuadro VARCHAR(255) NOT NULL,
    color VARCHAR(255) NOT NULL,
    categoria_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Categorias_Bicicletas](id),
    marca_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Marcas](id)
);
GO

CREATE TABLE [JOINT_BASADOS].[Categorias_Accesorios] (
    id INT IDENTITY (1,1) PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);
GO

CREATE TABLE [JOINT_BASADOS].[Accesorios] (
    id INT IDENTITY (1,1) PRIMARY KEY,
    talle VARCHAR(255),
    color VARCHAR(255),
    categoria_accesorio_id INT REFERENCES [JOINT_BASADOS].[Categorias_Accesorios](id),
    marca_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Marcas](id)
);
GO
-- CAMBIO "nro de seria" a "id" porque en la tabla master el nro de serie para bicis en ventas no existe, pero según el enunciado podemos crear más columnas que nos e llenen con datos inventados--
CREATE TABLE [JOINT_BASADOS].[Bicicletas_Ventas] (
    id INT IDENTITY (1,1) PRIMARY KEY,
    modelo_id INT REFERENCES [JOINT_BASADOS].[Modelos_Bicicletas](id),
    garantia_meses INT
);
GO

CREATE TABLE [JOINT_BASADOS].[Estados_Bicicletas_Alquileres] (
    id INT IDENTITY (1,1) PRIMARY KEY,
    descripcion VARCHAR(255) NOT NULL
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

CREATE TABLE [JOINT_BASADOS].[Locales] (
  id INT IDENTITY (1,1) PRIMARY KEY,
  nombre VARCHAR(255) NOT NULL,
  telefono VARCHAR(255) NOT NULL,
  email VARCHAR(255) NOT NULL,
  direccion VARCHAR(255) NOT NULL,
  localidad_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Localidades](id)
);
GO

CREATE TABLE [JOINT_BASADOS].[Bicicletas_Alquileres] (
 nro_serie VARCHAR(255) NOT NULL PRIMARY KEY,
 modelo_id INT REFERENCES [JOINT_BASADOS].[Modelos_Bicicletas](id),
 precio_hora DECIMAL(38,2),
 precio_dia DECIMAL(38,2),
 estado_id INT REFERENCES [JOINT_BASADOS].[Estados_Bicicletas_Alquileres](id),
 local_id INT REFERENCES [JOINT_BASADOS].[Locales](id)
);
GO

CREATE TABLE [JOINT_BASADOS].[Clientes] (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    apellido VARCHAR(255) NOT NULL,
    dni VARCHAR(255) NOT NULL,
    telefono VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    fecha_nacimiento DATETIME2 NOT NULL,
    localidad_id INT REFERENCES [JOINT_BASADOS].[Localidades](id)
);
GO

CREATE TABLE [JOINT_BASADOS].[Empleados] (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre VARCHAR(255)  NULL,
    apellido VARCHAR(255)  NULL,
    dni VARCHAR(255)  NULL,
    puesto VARCHAR(255)  NULL,
    fecha_ingreso DATETIME2  NULL,
    telefono VARCHAR(255) NULL,
    email  VARCHAR(255) NULL,
    domicilio VARCHAR(255) NULL,
    fecha_de_nacimiento DATETIME2 NULL,
    localidad_id INT REFERENCES [JOINT_BASADOS].[Localidades] (id),
    local_id INT REFERENCES [JOINT_BASADOS].[Locales](id)
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
    cod_repuesto VARCHAR(255) NOT NULL PRIMARY KEY,
    descripcion VARCHAR(MAX) NOT NULL,
    compatibilidad VARCHAR(MAX) NOT NULL,
    precio DECIMAL(38,2) NOT NULL,
    categoria_id INT REFERENCES [JOINT_BASADOS].[Categorias_Repuestos](id)
);
GO



CREATE TABLE [JOINT_BASADOS].[Alquileres] (
    nro_alquiler INT PRIMARY KEY,
    fecha_inicio DATETIME2  NOT NULL,
    fecha_fin_pactada DATETIME2  NOT NULL,
    fecha_devolucion_real DATETIME2   ,
    importe_total NUMERIC(38,2) NOT NULL,
    nro_serie_bicicleta VARCHAR(255)  REFERENCES [JOINT_BASADOS].[Bicicletas_Alquileres](nro_serie),
    estado_alquiler_id INT REFERENCES [JOINT_BASADOS].[Estados_Alquileres](id),
    cliente_id INT REFERENCES [JOINT_BASADOS].[Clientes](id),
    empleado_id INT REFERENCES [JOINT_BASADOS].[Empleados](id),
    forma_pago_id INT REFERENCES [JOINT_BASADOS].[Formas_De_Pago](id)
);
GO

CREATE TABLE [JOINT_BASADOS].[Reparaciones] (
    nro_reparacion INT PRIMARY KEY,
    modelo_id INT REFERENCES [JOINT_BASADOS].[Modelos_Bicicletas](id),
    cliente_id INT REFERENCES [JOINT_BASADOS].[Clientes](id),
    empleado_id INT REFERENCES [JOINT_BASADOS].[Empleados](id),
    estado_reparacion_id INT REFERENCES [JOINT_BASADOS].[Estados_Reparaciones](id),
    fecha_ingreso DATE NOT NULL,
    fecha_entrega_estimada DATE NOT NULL,
    fecha_entrega_real DATE,
    diagnostico VARCHAR(MAX),
    precio_mano_obra DECIMAL(38,2),
    precio_repuestos DECIMAL(38,2),
    precio_total DECIMAL(38,2)
);
GO

CREATE TABLE [JOINT_BASADOS].[Detalles_Reparaciones] (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    cantidad_repuesto INT NOT NULL,
    precio_unitario DECIMAL(38,2) NOT NULL,
    subtotal DECIMAL(38,2) NOT NULL,
    cod_repuesto VARCHAR(255) REFERENCES [JOINT_BASADOS].[Repuestos](cod_repuesto),
    reparacion_id INT REFERENCES [JOINT_BASADOS].[Reparaciones](nro_reparacion)
);
GO

CREATE TABLE [JOINT_BASADOS].[Proveedores] (
    id INT IDENTITY (1,1) PRIMARY KEY,
    razon_social VARCHAR(255) NOT NULL,
    cuit VARCHAR(255) NOT NULL,
    telefono VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    localidad_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Localidades](id)
);
GO



CREATE TABLE [JOINT_BASADOS].[Compras] (
    nro_compra INT PRIMARY KEY,
    fecha DATE NOT NULL,
    total DECIMAL(38,2) NOT NULL,
    proveedor_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Proveedores](id),
    empleado_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Empleados](id)
);
GO

CREATE TABLE [JOINT_BASADOS].[Tipos_De_Productos] (
    id INT IDENTITY (1,1) PRIMARY KEY,
    tipo VARCHAR(255)
);
GO

CREATE TABLE [JOINT_BASADOS].[Productos] (
    cod_producto VARCHAR(255) PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    descripcion VARCHAR(255),
    precio_venta DECIMAL(38,2),
    tipo_producto_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Tipos_De_Productos](id),
    accesorio_id INT REFERENCES [JOINT_BASADOS].[Accesorios](id),
    bicicleta_venta_id INT REFERENCES [JOINT_BASADOS].[Bicicletas_Ventas](id),
    garantia_en_meses INT
);
GO

CREATE TABLE [JOINT_BASADOS].[Detalles_Compras] (
    id INT IDENTITY (1,1) PRIMARY KEY,
    nro_compra INT NOT NULL REFERENCES [JOINT_BASADOS].[Compras](nro_compra),
    cod_producto VARCHAR(255) NOT NULL REFERENCES [JOINT_BASADOS].[Productos](cod_producto),
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(38,2) NOT NULL,
    subtotal DECIMAL(38,2)
);
GO 

CREATE TABLE [JOINT_BASADOS].[Ventas] (
    nro_venta INT PRIMARY KEY,
    fecha_hora DATETIME NOT NULL,
    total DECIMAL(38,2) NOT NULL,
    forma_pago_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Formas_De_Pago](id),
    local_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Locales](id),
    cliente_id INT REFERENCES [JOINT_BASADOS].[Clientes](id),
    empleado_id INT REFERENCES [JOINT_BASADOS].[Empleados](id)
);
GO

CREATE TABLE [JOINT_BASADOS].[Detalles_Ventas] (
    id INT IDENTITY (1,1) PRIMARY KEY,
    nro_venta INT NOT NULL REFERENCES [JOINT_BASADOS].[Ventas](nro_venta),
    cod_producto VARCHAR(255) NOT NULL REFERENCES [JOINT_BASADOS].[Productos](cod_producto),
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(38,2) NOT NULL,
    subtotal DECIMAL(38,2) NOT NULL
);
GO

CREATE PROCEDURE [JOINT_BASADOS].[Migrar_Marcas]
AS
BEGIN
    INSERT INTO [JOINT_BASADOS].[Marcas] (nombre)
    SELECT DISTINCT [Marca_Marca] 
    FROM [gd_esquema].[maestra] 
    WHERE [Marca_Marca] IS NOT NULL;
END;
GO

EXEC [JOINT_BASADOS].[Migrar_Marcas];
GO

CREATE PROCEDURE [JOINT_BASADOS].[Migrar_Categoria_Accesorios]
AS
BEGIN
    INSERT INTO [JOINT_BASADOS].[Categorias_Accesorios] (nombre)
    SELECT DISTINCT [Categoria_Accesorios_Categoria_Accesorio] 
    FROM [gd_esquema].[maestra] 
    WHERE [Categoria_Accesorios_Categoria_Accesorio] IS NOT NULL;
END;
GO

EXEC [JOINT_BASADOS].[Migrar_Categoria_Accesorios];
GO

CREATE PROCEDURE [JOINT_BASADOS].[Migrar_Categorias_Bicicletas]
AS
BEGIN
    INSERT INTO [JOINT_BASADOS].[Categorias_Bicicletas] (categoria)
    SELECT DISTINCT [Categoria_Bicicleta_Categoria_Bicicleta] 
    FROM [gd_esquema].[maestra] 
    WHERE [Categoria_Bicicleta_Categoria_Bicicleta] IS NOT NULL;
END;
GO

EXEC [JOINT_BASADOS].[Migrar_Categorias_Bicicletas];
GO

CREATE PROCEDURE [JOINT_BASADOS].[Migrar_Estado_Bicicleta_Alquiler]
AS
BEGIN
    INSERT INTO [JOINT_BASADOS].[Estados_Bicicletas_Alquileres] (descripcion)
    SELECT DISTINCT [Estado_Bici_Alquiler_Estado_Bici_Alquiler] 
    FROM [gd_esquema].[maestra] 
    WHERE [Estado_Bici_Alquiler_Estado_Bici_Alquiler] IS NOT NULL;
END;
GO

EXEC [JOINT_BASADOS].[Migrar_Estado_Bicicleta_Alquiler];
GO

CREATE PROCEDURE [JOINT_BASADOS].[Migrar_Categorias_Repuestos]
AS
BEGIN
    INSERT INTO [JOINT_BASADOS].[Categorias_Repuestos] (categoria)
    SELECT DISTINCT [Categoria_Repuestos_Categoria_Respuesto] 
    FROM [gd_esquema].[maestra] 
    WHERE [Categoria_Repuestos_Categoria_Respuesto] IS NOT NULL;
END;
GO

EXEC [JOINT_BASADOS].[Migrar_Categorias_Repuestos];
GO

CREATE PROCEDURE [JOINT_BASADOS].[Migrar_Estados_Alquiler]
AS
BEGIN
    INSERT INTO [JOINT_BASADOS].[Estados_Alquileres] (descripcion)
    SELECT DISTINCT [Estado_Alquiler_Estado_Alquiler] 
    FROM [gd_esquema].[maestra] 
    WHERE [Estado_Alquiler_Estado_Alquiler] IS NOT NULL;
END;
GO

EXEC [JOINT_BASADOS].[Migrar_Estados_Alquiler];
GO

CREATE PROCEDURE [JOINT_BASADOS].[Migrar_Estados_Reparaciones]
AS
BEGIN
    INSERT INTO [JOINT_BASADOS].[Estados_Reparaciones] (descripcion)
    SELECT DISTINCT [Estado_Reparacion_Estado_Reparacion] 
    FROM [gd_esquema].[maestra] 
    WHERE [Estado_Reparacion_Estado_Reparacion] IS NOT NULL;
END;
GO

EXEC [JOINT_BASADOS].[Migrar_Estados_Reparaciones];
GO

CREATE PROCEDURE [JOINT_BASADOS].[Migrar_Provincias]
AS
BEGIN
    INSERT INTO [JOINT_BASADOS].[Provincias] (nombre)
    SELECT [Cliente_Provincia] FROM [gd_esquema].[maestra] WHERE [Cliente_Provincia] IS NOT NULL
    UNION
    SELECT [Empleado_Provincia] FROM [gd_esquema].[maestra] WHERE [Empleado_Provincia] IS NOT NULL
    UNION
    SELECT [Local_Provincia] FROM [gd_esquema].[maestra] WHERE [Local_Provincia] IS NOT NULL
    UNION
    SELECT [Proveedor_Provincia] FROM [gd_esquema].[maestra] WHERE [Proveedor_Provincia] IS NOT NULL;
END;
GO

EXEC [JOINT_BASADOS].[Migrar_Provincias];
GO

CREATE PROCEDURE [JOINT_BASADOS].[Migrar_Formas_de_Pago]
AS
BEGIN
    INSERT INTO [JOINT_BASADOS].[Formas_De_Pago] (descripcion)
    SELECT DISTINCT [Forma_Pago_Forma_Pago] 
    FROM [gd_esquema].[maestra] 
    WHERE [Forma_Pago_Forma_Pago] IS NOT NULL;
END;
GO

EXEC [JOINT_BASADOS].[Migrar_Formas_de_Pago];
GO

CREATE PROCEDURE [JOINT_BASADOS].[Migrar_Tipos_de_Productos]
AS
BEGIN
    INSERT INTO [JOINT_BASADOS].[Tipos_De_Productos] (tipo)
    SELECT DISTINCT [Tipo_Producto_Tipo_Producto] 
    FROM [gd_esquema].[maestra] 
    WHERE [Tipo_Producto_Tipo_Producto] IS NOT NULL;
END;
GO

EXEC [JOINT_BASADOS].[Migrar_Tipos_de_Productos];
GO

SELECT * FROM [JOINT_BASADOS].[Marcas]
SELECT * FROM [JOINT_BASADOS].[Categorias_Accesorios]
SELECT * FROM [JOINT_BASADOS].[Categorias_Bicicletas]
SELECT * FROM [JOINT_BASADOS].[Estados_Bicicletas_Alquileres]
SELECT * FROM [JOINT_BASADOS].[Categorias_Repuestos]
SELECT * FROM [JOINT_BASADOS].[Estados_Alquileres]
SELECT * FROM [JOINT_BASADOS].[Estados_Reparaciones]
SELECT * FROM [JOINT_BASADOS].[Provincias]
SELECT * FROM [JOINT_BASADOS].[Formas_De_Pago]
SELECT * FROM [JOINT_BASADOS].[Tipos_De_Productos]

