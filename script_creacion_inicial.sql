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
    nro_rodado VARCHAR(255)  NOT NULL,
    talle_cuadro VARCHAR(255) NOT NULL,
    color VARCHAR(255)  NOT NULL,
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
    talle VARCHAR(255) NOT NULL,
    color VARCHAR(255) NOT NULL,
    categoria_accesorio_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Categorias_Accesorios](id),
    marca_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Marcas](id)
);
GO
-- CAMBIO "nro de seria" a "id" porque en la tabla master el nro de serie para bicis en ventas no existe, pero según el enunciado podemos crear más columnas que nos e llenen con datos inventados--
CREATE TABLE [JOINT_BASADOS].[Bicicletas_Ventas] (
    id INT IDENTITY (1,1) PRIMARY KEY,
    cod_producto VARCHAR(255) NOT NULL UNIQUE, -- lo agrego para que después al migrar Productos se pueda reconocer que a Bici Venta referencia
    modelo_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Modelos_Bicicletas](id)
);
GO

CREATE TABLE [JOINT_BASADOS].[Estados_Bicicletas_Alquileres] (
    id INT IDENTITY (1,1) PRIMARY KEY,
    descripcion VARCHAR(255)  NOT NULL
);
GO

CREATE TABLE [JOINT_BASADOS].[Provincias] (
    id INT IDENTITY(1,1)  PRIMARY KEY,
    nombre VARCHAR(255)  NOT NULL
);
GO

CREATE TABLE [JOINT_BASADOS].[Localidades] (
    id INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(255)  NOT NULL,
    provincia_id INT  NOT NULL REFERENCES [JOINT_BASADOS].[Provincias](id)
);
GO

CREATE TABLE [JOINT_BASADOS].[Locales] (
  id INT IDENTITY (1,1) PRIMARY KEY,
  nombre VARCHAR(255)  NOT NULL,
  telefono VARCHAR(255)  NOT NULL,
  email VARCHAR(255)  NOT NULL,
  direccion VARCHAR(255)  NOT NULL,
  localidad_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Localidades](id)
);
GO

CREATE TABLE [JOINT_BASADOS].[Bicicletas_Alquileres] (
 nro_serie VARCHAR(255) PRIMARY KEY,
 modelo_id INT  NOT NULL  REFERENCES [JOINT_BASADOS].[Modelos_Bicicletas](id),
 precio_hora DECIMAL(38,2) NOT NULL,
 precio_dia DECIMAL(38,2) NOT NULL,
 estado_id INT  NOT NULL  REFERENCES [JOINT_BASADOS].[Estados_Bicicletas_Alquileres](id),
 local_id INT  NOT NULL REFERENCES [JOINT_BASADOS].[Locales](id)
);
GO

CREATE TABLE [JOINT_BASADOS].[Clientes] (
    id INT IDENTITY(1,1)  PRIMARY KEY,
    nombre VARCHAR(255)  NOT NULL,
    apellido VARCHAR(255)  NOT NULL,
    dni VARCHAR(255)  NOT NULL,
    telefono VARCHAR(255)  NOT NULL,
    email VARCHAR(255)  NOT NULL,
    direccion VARCHAR(255)  NOT NULL,
    fecha_nacimiento DATETIME2  NOT NULL,
    localidad_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Localidades](id)
);
GO

CREATE TABLE [JOINT_BASADOS].[Empleados] (
    id INT IDENTITY(1,1)  PRIMARY KEY,
    nombre VARCHAR(255)  NOT NULL,
    apellido VARCHAR(255)  NOT NULL,
    dni VARCHAR(255)  NOT NULL,
    puesto VARCHAR(255)  NOT NULL,
    fecha_ingreso DATETIME2  NOT NULL,
    telefono VARCHAR(255) NOT NULL,
    email  VARCHAR(255) NOT NULL,
    domicilio VARCHAR(255) NOT NULL,
    fecha_de_nacimiento DATETIME2 NOT NULL,
    localidad_id INT  NOT NULL REFERENCES [JOINT_BASADOS].[Localidades] (id),
    local_id INT  NOT NULL REFERENCES [JOINT_BASADOS].[Locales](id)
);
GO

CREATE TABLE [JOINT_BASADOS].[Formas_De_Pago] (
    id INT IDENTITY(1,1)  PRIMARY KEY,
    descripcion VARCHAR(255)  NOT NULL
);
GO

CREATE TABLE [JOINT_BASADOS].[Estados_Alquileres] (
    id INT IDENTITY(1,1)  PRIMARY KEY,
    descripcion VARCHAR(255)  NOT NULL
);
GO

CREATE TABLE [JOINT_BASADOS].[Estados_Reparaciones] (
    id INT IDENTITY(1,1) PRIMARY KEY,
    descripcion VARCHAR(255)  NOT NULL
);
GO

CREATE TABLE [JOINT_BASADOS].[Categorias_Repuestos] (
    id INT IDENTITY(1,1)  PRIMARY KEY,
    categoria VARCHAR(255)  NOT NULL
);
GO

CREATE TABLE [JOINT_BASADOS].[Repuestos] (
    cod_repuesto VARCHAR(255) PRIMARY KEY,
    descripcion VARCHAR(MAX)  NOT NULL,
    compatibilidad VARCHAR(MAX)  NOT NULL,
    precio DECIMAL(38,2)  NOT NULL,
    categoria_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Categorias_Repuestos](id)
);
GO



CREATE TABLE [JOINT_BASADOS].[Alquileres] (
    nro_alquiler INT PRIMARY KEY,
    fecha_inicio DATETIME2 NOT NULL,
    fecha_fin_pactada DATETIME2  NOT NULL,
    fecha_devolucion_real DATETIME2  NULL,
    importe_total NUMERIC(38,2)   NULL,
    nro_serie_bicicleta VARCHAR(255)  NOT NULL REFERENCES [JOINT_BASADOS].[Bicicletas_Alquileres](nro_serie),
    estado_alquiler_id INT  NOT NULL REFERENCES [JOINT_BASADOS].[Estados_Alquileres](id),
    cliente_id INT  NOT NULL REFERENCES [JOINT_BASADOS].[Clientes](id),
    empleado_id INT  NOT NULL REFERENCES [JOINT_BASADOS].[Empleados](id),
    forma_pago_id INT  NOT NULL REFERENCES [JOINT_BASADOS].[Formas_De_Pago](id)
);
GO

CREATE TABLE [JOINT_BASADOS].[Reparaciones] (
    nro_reparacion INT  PRIMARY KEY,
    modelo_id INT NOT NULL  REFERENCES [JOINT_BASADOS].[Modelos_Bicicletas](id),
    cliente_id INT  NOT NULL REFERENCES [JOINT_BASADOS].[Clientes](id),
    empleado_id INT  NOT NULL REFERENCES [JOINT_BASADOS].[Empleados](id),
    estado_reparacion_id INT NOT NULL  REFERENCES [JOINT_BASADOS].[Estados_Reparaciones](id),
    fecha_ingreso DATETIME2  NOT NULL,
    fecha_entrega_estimada DATETIME2  NOT NULL,
    fecha_entrega_real DATETIME2 NULL,
    diagnostico VARCHAR(MAX) NULL,
    precio_mano_obra DECIMAL(38,2) NOT NULL,
    precio_repuestos DECIMAL(38,2) NOT NULL,
    precio_total DECIMAL(38,2) NOT NULL
);
GO

CREATE TABLE [JOINT_BASADOS].[Detalles_Reparaciones] (
    id INT IDENTITY(1,1)  PRIMARY KEY,
    cantidad_repuesto INT  NOT NULL,
    precio_unitario DECIMAL(38,2)  NOT NULL,
    subtotal DECIMAL(38,2)  NOT NULL,
    cod_repuesto VARCHAR(255)  NOT NULL REFERENCES [JOINT_BASADOS].[Repuestos](cod_repuesto),
    reparacion_id INT  NOT NULL REFERENCES [JOINT_BASADOS].[Reparaciones](nro_reparacion)
);
GO

CREATE TABLE [JOINT_BASADOS].[Proveedores] (
    id INT IDENTITY (1,1)  PRIMARY KEY,
    razon_social VARCHAR(255)  NOT NULL,
    cuit VARCHAR(255)  NOT NULL,
    telefono VARCHAR(255)  NOT NULL,
    email VARCHAR(255)  NOT NULL,
    direccion VARCHAR(255)  NOT NULL,
    localidad_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Localidades](id)
);
GO



CREATE TABLE [JOINT_BASADOS].[Compras] (
    nro_compra INT PRIMARY KEY,
    fecha DATETIME2  NOT NULL,
    total DECIMAL(38,2)  NOT NULL,
    proveedor_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Proveedores](id),
    empleado_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Empleados](id)
);
GO

CREATE TABLE [JOINT_BASADOS].[Tipos_De_Productos] (
    id INT IDENTITY (1,1) PRIMARY KEY,
    tipo VARCHAR(255) NOT NULL
);
GO

CREATE TABLE [JOINT_BASADOS].[Productos] (
    cod_producto VARCHAR(255)  PRIMARY KEY,
    nombre VARCHAR(255)  NOT NULL,
    descripcion VARCHAR(255) NOT NULL,
    precio_venta DECIMAL(38,2) NOT NULL,
    tipo_producto_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Tipos_De_Productos](id),
    accesorio_id INT   NULL REFERENCES [JOINT_BASADOS].[Accesorios](id),
    bicicleta_venta_id INT   NULL REFERENCES [JOINT_BASADOS].[Bicicletas_Ventas](id),
    garantia_en_meses INT  NULL
);
GO

CREATE TABLE [JOINT_BASADOS].[Detalles_Compras] (
    id INT IDENTITY (1,1)  PRIMARY KEY,
    nro_compra INT NOT NULL REFERENCES [JOINT_BASADOS].[Compras](nro_compra),
    cod_producto VARCHAR(255) NOT NULL REFERENCES [JOINT_BASADOS].[Productos](cod_producto),
    cantidad_prod INT  NOT NULL,
    precio_unitario DECIMAL(38,2) NOT NULL,
    subtotal DECIMAL(38,2) NOT NULL
);
GO 

CREATE TABLE [JOINT_BASADOS].[Ventas] (
    nro_venta INT PRIMARY KEY,
    fecha_hora DATETIME2 NOT NULL,
    total DECIMAL(38,2) NOT NULL,
    forma_pago_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Formas_De_Pago](id),
    local_id INT  NOT NULL REFERENCES [JOINT_BASADOS].[Locales](id),
    cliente_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Clientes](id),
    empleado_id INT NOT NULL REFERENCES [JOINT_BASADOS].[Empleados](id)
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


CREATE PROCEDURE [JOINT_BASADOS].[Migrar_Accesorios]
AS
BEGIN
    INSERT INTO [JOINT_BASADOS].[Accesorios] (talle, color, categoria_accesorio_id, marca_id)
    SELECT DISTINCT m.Accesorio_Talle_Accesorio, m.Accesorio_Color_Accesorio, ca.id, mar.id
    FROM gd_esquema.Maestra m
             JOIN [JOINT_BASADOS].[Categorias_Accesorios] ca
                  ON ca.nombre = m.Categoria_Accesorios_Categoria_Accesorio
             JOIN [JOINT_BASADOS].[Marcas] mar ON mar.nombre = m.Marca_Marca
    WHERE m.Categoria_Accesorios_Categoria_Accesorio IS NOT NULL;
END
GO
EXEC [JOINT_BASADOS].[Migrar_Accesorios];
GO

CREATE PROCEDURE [JOINT_BASADOS].[Migrar_Modelos_Bicicletas]
AS
BEGIN
    INSERT INTO [JOINT_BASADOS].[Modelos_Bicicletas]
    (nombre, nro_rodado, talle_cuadro, color, categoria_id, marca_id)
    SELECT DISTINCT m.Modelo_Bicicleta_Modelo_Bicicleta,
                    m.Modelo_Bicicleta_Rodado_Modelo_Bicicleta,
                    m.Modelo_Bicicleta_Cuadro_Modelo_Bicicleta,
                    m.Modelo_Bicicleta_Color_Modelo_Bicicleta,
                    c.id, mar.id
    FROM gd_esquema.Maestra m
             JOIN [JOINT_BASADOS].[Categorias_Bicicletas] c ON c.categoria = m.Categoria_Bicicleta_Categoria_Bicicleta
             JOIN [JOINT_BASADOS].[Marcas] mar ON mar.nombre = m.Marca_Marca
    WHERE m.Modelo_Bicicleta_Modelo_Bicicleta IS NOT NULL;
END
GO
EXEC [JOINT_BASADOS].[Migrar_Modelos_Bicicletas];
GO

CREATE PROCEDURE [JOINT_BASADOS].[Migrar_Bicicletas_Ventas]
AS
BEGIN
    INSERT INTO [JOINT_BASADOS].[Bicicletas_Ventas] (cod_producto, modelo_id)
    SELECT DISTINCT m.Producto_Cod_Producto, mb.id
    FROM gd_esquema.Maestra m
             JOIN [JOINT_BASADOS].[Categorias_Bicicletas] c
                  ON c.categoria = m.Categoria_Bicicleta_Categoria_Bicicleta
             JOIN [JOINT_BASADOS].[Marcas] mk
                  ON mk.nombre = m.Marca_Marca
             JOIN [JOINT_BASADOS].[Modelos_Bicicletas] mb
                  ON mb.nombre = m.Modelo_Bicicleta_Modelo_Bicicleta
                      AND mb.nro_rodado = m.Modelo_Bicicleta_Rodado_Modelo_Bicicleta
                      AND mb.talle_cuadro = m.Modelo_Bicicleta_Cuadro_Modelo_Bicicleta
                      AND mb.color = m.Modelo_Bicicleta_Color_Modelo_Bicicleta
                      AND mb.categoria_id = c.id
                      AND mb.marca_id = mk.id
    WHERE m.Producto_Cod_Producto IS NOT NULL
      AND m.Modelo_Bicicleta_Modelo_Bicicleta IS NOT NULL;
END
GO
EXEC [JOINT_BASADOS].[Migrar_Bicicletas_Ventas];
GO

CREATE PROCEDURE [JOINT_BASADOS].[Migrar_Bicicletas_Alquileres]
AS
BEGIN
    INSERT INTO [JOINT_BASADOS].[Bicicletas_Alquileres]
    (nro_serie, modelo_id, precio_hora, precio_dia, estado_id, local_id)
    SELECT DISTINCT
        m.Bicicleta_Alquiler_Nro_Serie_Bici_Alquiler,
        mb.id,
        m.Bicicleta_Alquiler_Precio_Bici_Alquiler_Hora,
        m.Bicicleta_Alquiler_Precio_Bici_Alquiler_Dia,
        e.id,
        l.id
    FROM gd_esquema.Maestra m
             JOIN [JOINT_BASADOS].[Categorias_Bicicletas] c ON c.categoria = m.Categoria_Bicicleta_Categoria_Bicicleta
             JOIN [JOINT_BASADOS].[Marcas] mar ON mar.nombre = m.Marca_Marca
             JOIN [JOINT_BASADOS].[Modelos_Bicicletas] mb
                  ON mb.nombre = m.Modelo_Bicicleta_Modelo_Bicicleta
                      AND mb.nro_rodado = m.Modelo_Bicicleta_Rodado_Modelo_Bicicleta
                      AND mb.talle_cuadro = m.Modelo_Bicicleta_Cuadro_Modelo_Bicicleta
                      AND mb.color = m.Modelo_Bicicleta_Color_Modelo_Bicicleta
                      AND mb.categoria_id = c.id
                      AND mb.marca_id = mar.id
             JOIN [JOINT_BASADOS].[Estados_Bicicletas_Alquileres] e
                  ON e.descripcion = m.Estado_Bici_Alquiler_Estado_Bici_Alquiler
             JOIN [JOINT_BASADOS].[Locales] l ON l.nombre = m.Local_Nombre_Local
    WHERE m.Bicicleta_Alquiler_Nro_Serie_Bici_Alquiler IS NOT NULL;
END
GO
EXEC [JOINT_BASADOS].[Migrar_Bicicletas_Alquileres];
GO

CREATE PROCEDURE [JOINT_BASADOS].[Migrar_Repuestos]
AS
BEGIN
    INSERT INTO [JOINT_BASADOS].[Repuestos] (cod_repuesto, descripcion, compatibilidad, precio, categoria_id)
    SELECT DISTINCT m.Repuesto_Cod_Repuesto, m.Repuesto_Desc_Repuesto,
                    m.Repuesto_Compatibilidad_Repuesto, m.Repuesto_Precio_Repuesto, c.id
    FROM gd_esquema.Maestra m
             JOIN [JOINT_BASADOS].[Categorias_Repuestos] c
                  ON c.categoria = m.Categoria_Repuestos_Categoria_Respuesto
    WHERE m.Repuesto_Cod_Repuesto IS NOT NULL;
END
GO
EXEC [JOINT_BASADOS].[Migrar_Repuestos];
GO

CREATE PROCEDURE [JOINT_BASADOS].[Migrar_Detalles_Reparaciones]
AS
BEGIN
    INSERT INTO [JOINT_BASADOS].[Detalles_Reparaciones]
    (cantidad_repuesto, precio_unitario, subtotal, cod_repuesto, reparacion_id)
    SELECT DISTINCT
        m.Detalle_Reparacion_Cantidad_Repuesto,
        m.Detalle_Reparacion_Precio_Unitario_Repuesto,
        m.Detalle_Reparacion_Subtotal_Repuesto,
        m.Repuesto_Cod_Repuesto,
        m.Reparacion_Nro_Reparacion
    FROM gd_esquema.Maestra m
    WHERE m.Reparacion_Nro_Reparacion IS NOT NULL
      AND m.Repuesto_Cod_Repuesto IS NOT NULL;
END
GO
EXEC [JOINT_BASADOS].[Migrar_Detalles_Reparaciones];
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
SELECT * FROM [JOINT_BASADOS].[Accesorios]
SELECT * FROM [JOINT_BASADOS].[Modelos_Bicicletas]
SELECT * FROM [JOINT_BASADOS].[Bicicletas_Ventas]
SELECT * FROM [JOINT_BASADOS].[Bicicletas_Alquileres]
SELECT * FROM [JOINT_BASADOS].[Repuestos]
SELECT * FROM [JOINT_BASADOS].[Detalles_Reparaciones]

