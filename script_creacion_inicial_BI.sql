USE GD2C_2026;
GO

-- ============================================================================
-- 1. CREACIÓN DE DIMENSIONES
-- ============================================================================

CREATE TABLE [JOINT_BASADOS].[BI_Tiempo] (
    id INT IDENTITY(1,1) PRIMARY KEY,
    anio INT NOT NULL,
    trimestre INT NOT NULL,
    mes INT NOT NULL
);
GO

CREATE TABLE [JOINT_BASADOS].[BI_Rango_Etario] (
    id INT IDENTITY(1,1) PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL
);
GO

CREATE TABLE [JOINT_BASADOS].[BI_Tipo_Producto] (
    id INT PRIMARY KEY,
    tipo VARCHAR(255) NOT NULL
);
GO

CREATE TABLE [JOINT_BASADOS].[BI_Local] (
    id INT PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL
);
GO

CREATE TABLE [JOINT_BASADOS].[BI_Categoria_Bicicleta] (
    id INT PRIMARY KEY,
    categoria VARCHAR(255) NOT NULL
);
GO

CREATE TABLE [JOINT_BASADOS].[BI_Categoria_Repuesto] (
    id INT PRIMARY KEY,
    categoria VARCHAR(255) NOT NULL
);
GO

CREATE TABLE [JOINT_BASADOS].[BI_Tipo_Ingreso_Reparacion] (
    id INT IDENTITY(1,1) PRIMARY KEY,
    descripcion VARCHAR(50) NOT NULL
);
GO

-- ============================================================================
-- 2. CREACIÓN DE TABLAS DE HECHOS
-- ============================================================================

-- Hechos de Ventas (resuelve vistas 1, 2, 3 y parte de 11)
CREATE TABLE [JOINT_BASADOS].[BI_Hechos_Ventas] (
    tiempo_id INT NOT NULL REFERENCES [JOINT_BASADOS].[BI_Tiempo](id),
    local_id INT NOT NULL REFERENCES [JOINT_BASADOS].[BI_Local](id),
    tipo_producto_id INT NOT NULL REFERENCES [JOINT_BASADOS].[BI_Tipo_Producto](id),
    rango_etario_id INT NOT NULL REFERENCES [JOINT_BASADOS].[BI_Rango_Etario](id),
    cantidad_ventas INT NOT NULL,
    facturacion_total DECIMAL(38,2) NOT NULL,
    PRIMARY KEY (tiempo_id, local_id, tipo_producto_id, rango_etario_id)
);
GO

-- Hechos de Alquileres (resuelve vistas 4, 5 y parte de 11)
CREATE TABLE [JOINT_BASADOS].[BI_Hechos_Alquileres] (
    tiempo_id INT NOT NULL REFERENCES [JOINT_BASADOS].[BI_Tiempo](id),
    local_id INT NOT NULL REFERENCES [JOINT_BASADOS].[BI_Local](id),
    categoria_bicicleta_id INT NOT NULL REFERENCES [JOINT_BASADOS].[BI_Categoria_Bicicleta](id),
    cantidad_alquileres INT NOT NULL,
    total_horas_alquiler DECIMAL(18,2) NOT NULL,
    facturacion_total DECIMAL(38,2) NOT NULL,
    PRIMARY KEY (tiempo_id, local_id, categoria_bicicleta_id)
);
GO

-- Hechos de Desvíos en Reparaciones (resuelve vista 6)
CREATE TABLE [JOINT_BASADOS].[BI_Hechos_Reparaciones] (
    tiempo_id INT NOT NULL REFERENCES [JOINT_BASADOS].[BI_Tiempo](id),
    local_id INT NOT NULL REFERENCES [JOINT_BASADOS].[BI_Local](id),
    cantidad_reparaciones INT NOT NULL,
    total_dias_desvio INT NOT NULL,
    PRIMARY KEY (tiempo_id, local_id)
);
GO

-- Hechos de Repuestos utilizados en Reparaciones (resuelve vista 7)
CREATE TABLE [JOINT_BASADOS].[BI_Hechos_Repuestos_Reparaciones] (
    tiempo_id INT NOT NULL REFERENCES [JOINT_BASADOS].[BI_Tiempo](id),
    categoria_repuesto_id INT NOT NULL REFERENCES [JOINT_BASADOS].[BI_Categoria_Repuesto](id),
    cantidad_utilizada INT NOT NULL,
    PRIMARY KEY (tiempo_id, categoria_repuesto_id)
);
GO

-- Hechos de Ingresos por Reparaciones (resuelve vista 8 y parte de 11)
CREATE TABLE [JOINT_BASADOS].[BI_Hechos_Ingresos_Reparaciones] (
    tiempo_id INT NOT NULL REFERENCES [JOINT_BASADOS].[BI_Tiempo](id),
    local_id INT NOT NULL REFERENCES [JOINT_BASADOS].[BI_Local](id),
    tipo_ingreso_id INT NOT NULL REFERENCES [JOINT_BASADOS].[BI_Tipo_Ingreso_Reparacion](id),
    facturacion_total DECIMAL(38,2) NOT NULL,
    PRIMARY KEY (tiempo_id, local_id, tipo_ingreso_id)
);
GO

-- Hechos de Compras (resuelve vistas 9 y 10)
CREATE TABLE [JOINT_BASADOS].[BI_Hechos_Compras] (
    tiempo_id INT NOT NULL REFERENCES [JOINT_BASADOS].[BI_Tiempo](id),
    local_id INT NOT NULL REFERENCES [JOINT_BASADOS].[BI_Local](id),
    tipo_producto_id INT NOT NULL REFERENCES [JOINT_BASADOS].[BI_Tipo_Producto](id),
    cantidad_compras INT NOT NULL,
    total_unidades INT NOT NULL,
    importe_total DECIMAL(38,2) NOT NULL,
    PRIMARY KEY (tiempo_id, local_id, tipo_producto_id)
);
GO

-- ============================================================================
-- 3. FUNCIÓN AUXILIAR PARA RANGO ETARIO
-- ============================================================================

CREATE FUNCTION [JOINT_BASADOS].[BI_Obtener_Rango_Etario] (
    @fecha_nacimiento DATETIME2,
    @fecha_operacion DATETIME2
)
RETURNS VARCHAR(50)
AS
BEGIN
    DECLARE @edad INT;
    SET @edad = DATEDIFF(YEAR, @fecha_nacimiento, @fecha_operacion)
        - CASE WHEN (MONTH(@fecha_nacimiento) > MONTH(@fecha_operacion))
                 OR (MONTH(@fecha_nacimiento) = MONTH(@fecha_operacion) AND DAY(@fecha_nacimiento) > DAY(@fecha_operacion))
               THEN 1 ELSE 0 END;

    RETURN CASE
        WHEN @edad <= 25 THEN 'Menores de 25 años inclusive'
        WHEN @edad <= 35 THEN 'Entre 25 y 35 años inclusive'
        WHEN @edad <= 50 THEN 'Entre 35 y 50 años inclusive'
        ELSE 'Mayores de 50 años'
    END;
END;
GO

-- ============================================================================
-- 4. STORED PROCEDURES DE CARGA DE DIMENSIONES
-- ============================================================================

CREATE PROCEDURE [JOINT_BASADOS].[BI_Migrar_Tiempo]
AS
BEGIN
    INSERT INTO [JOINT_BASADOS].[BI_Tiempo] (anio, trimestre, mes)
    SELECT DISTINCT anio, DATEPART(QUARTER, fecha), mes
    FROM (
        SELECT fecha_hora AS fecha, YEAR(fecha_hora) AS anio, MONTH(fecha_hora) AS mes FROM [JOINT_BASADOS].[Ventas]
        UNION
        SELECT fecha_inicio, YEAR(fecha_inicio), MONTH(fecha_inicio) FROM [JOINT_BASADOS].[Alquileres]
        UNION
        SELECT fecha_ingreso, YEAR(fecha_ingreso), MONTH(fecha_ingreso) FROM [JOINT_BASADOS].[Reparaciones]
        UNION
        SELECT fecha, YEAR(fecha), MONTH(fecha) FROM [JOINT_BASADOS].[Compras]
    ) AS fechas
    WHERE fecha IS NOT NULL;
END;
GO

CREATE PROCEDURE [JOINT_BASADOS].[BI_Migrar_Rango_Etario]
AS
BEGIN
    INSERT INTO [JOINT_BASADOS].[BI_Rango_Etario] (descripcion)
    VALUES 
        ('Menores de 25 años inclusive'),
        ('Entre 25 y 35 años inclusive'),
        ('Entre 35 y 50 años inclusive'),
        ('Mayores de 50 años');
END;
GO

CREATE PROCEDURE [JOINT_BASADOS].[BI_Migrar_Tipo_Producto]
AS
BEGIN
    INSERT INTO [JOINT_BASADOS].[BI_Tipo_Producto] (id, tipo)
    SELECT id, tipo
    FROM [JOINT_BASADOS].[Tipos_De_Productos];
END;
GO

CREATE PROCEDURE [JOINT_BASADOS].[BI_Migrar_Local]
AS
BEGIN
    INSERT INTO [JOINT_BASADOS].[BI_Local] (id, nombre)
    SELECT id, nombre
    FROM [JOINT_BASADOS].[Locales];
END;
GO

CREATE PROCEDURE [JOINT_BASADOS].[BI_Migrar_Categoria_Bicicleta]
AS
BEGIN
    INSERT INTO [JOINT_BASADOS].[BI_Categoria_Bicicleta] (id, categoria)
    SELECT id, categoria
    FROM [JOINT_BASADOS].[Categorias_Bicicletas];
END;
GO

CREATE PROCEDURE [JOINT_BASADOS].[BI_Migrar_Categoria_Repuesto]
AS
BEGIN
    INSERT INTO [JOINT_BASADOS].[BI_Categoria_Repuesto] (id, categoria)
    SELECT id, categoria
    FROM [JOINT_BASADOS].[Categorias_Repuestos];
END;
GO

CREATE PROCEDURE [JOINT_BASADOS].[BI_Migrar_Tipo_Ingreso_Reparacion]
AS
BEGIN
    INSERT INTO [JOINT_BASADOS].[BI_Tipo_Ingreso_Reparacion] (descripcion)
    VALUES ('Mano de Obra'), ('Repuestos');
END;
GO

-- ============================================================================
-- 5. STORED PROCEDURES DE CARGA DE HECHOS
-- ============================================================================

CREATE PROCEDURE [JOINT_BASADOS].[BI_Migrar_Hechos_Ventas]
AS
BEGIN
    INSERT INTO [JOINT_BASADOS].[BI_Hechos_Ventas] (
        tiempo_id, local_id, tipo_producto_id, rango_etario_id, cantidad_ventas, facturacion_total
    )
    SELECT
        t.id AS tiempo_id,
        v.local_id,
        p.tipo_producto_id,
        re.id AS rango_etario_id,
        COUNT(DISTINCT v.nro_venta) AS cantidad_ventas,
        SUM(dv.subtotal) AS facturacion_total
    FROM [JOINT_BASADOS].[Ventas] v
    JOIN [JOINT_BASADOS].[Detalles_Ventas] dv ON dv.nro_venta = v.nro_venta
    JOIN [JOINT_BASADOS].[Productos] p ON p.cod_producto = dv.cod_producto
    JOIN [JOINT_BASADOS].[Clientes] c ON c.id = v.cliente_id
    JOIN [JOINT_BASADOS].[BI_Tiempo] t 
        ON t.anio = YEAR(v.fecha_hora) AND t.mes = MONTH(v.fecha_hora)
    JOIN [JOINT_BASADOS].[BI_Rango_Etario] re 
        ON re.descripcion = [JOINT_BASADOS].[BI_Obtener_Rango_Etario](c.fecha_nacimiento, v.fecha_hora)
    GROUP BY t.id, v.local_id, p.tipo_producto_id, re.id;
END;
GO

CREATE PROCEDURE [JOINT_BASADOS].[BI_Migrar_Hechos_Alquileres]
AS
BEGIN
    INSERT INTO [JOINT_BASADOS].[BI_Hechos_Alquileres] (
        tiempo_id, local_id, categoria_bicicleta_id, cantidad_alquileres, total_horas_alquiler, facturacion_total
    )
    SELECT 
        t.id AS tiempo_id,
        ba.local_id,
        mb.categoria_id AS categoria_bicicleta_id,
        COUNT(a.nro_alquiler) AS cantidad_alquileres,
        SUM(
            CAST(DATEDIFF(MINUTE, a.fecha_inicio, COALESCE(a.fecha_devolucion_real, a.fecha_fin_pactada)) AS DECIMAL(18,2)) / 60.0
        ) AS total_horas_alquiler,
        SUM(ISNULL(a.importe_total, 0)) AS facturacion_total
    FROM [JOINT_BASADOS].[Alquileres] a
    JOIN [JOINT_BASADOS].[Bicicletas_Alquileres] ba ON ba.nro_serie = a.nro_serie_bicicleta
    JOIN [JOINT_BASADOS].[Modelos_Bicicletas] mb ON mb.id = ba.modelo_id
    JOIN [JOINT_BASADOS].[BI_Tiempo] t 
        ON t.anio = YEAR(a.fecha_inicio) AND t.mes = MONTH(a.fecha_inicio)
    GROUP BY t.id, ba.local_id, mb.categoria_id;
END;
GO

CREATE PROCEDURE [JOINT_BASADOS].[BI_Migrar_Hechos_Reparaciones]
AS
BEGIN
    INSERT INTO [JOINT_BASADOS].[BI_Hechos_Reparaciones] (
        tiempo_id, local_id, cantidad_reparaciones, total_dias_desvio
    )
    SELECT
        t.id AS tiempo_id,
        e.local_id,
        COUNT(r.nro_reparacion) AS cantidad_reparaciones,
        SUM(DATEDIFF(DAY, r.fecha_entrega_estimada, r.fecha_entrega_real)) AS total_dias_desvio
    FROM [JOINT_BASADOS].[Reparaciones] r
    JOIN [JOINT_BASADOS].[Empleados] e ON e.id = r.empleado_id
    JOIN [JOINT_BASADOS].[BI_Tiempo] t 
        ON t.anio = YEAR(r.fecha_ingreso) AND t.mes = MONTH(r.fecha_ingreso)
    WHERE r.fecha_entrega_real IS NOT NULL
    GROUP BY t.id, e.local_id;
END;
GO

CREATE PROCEDURE [JOINT_BASADOS].[BI_Migrar_Hechos_Repuestos_Reparaciones]
AS
BEGIN
    INSERT INTO [JOINT_BASADOS].[BI_Hechos_Repuestos_Reparaciones] (
        tiempo_id, categoria_repuesto_id, cantidad_utilizada
    )
    SELECT
        t.id AS tiempo_id,
        rep.categoria_id AS categoria_repuesto_id,
        SUM(dr.cantidad_repuesto) AS cantidad_utilizada
    FROM [JOINT_BASADOS].[Detalles_Reparaciones] dr
    JOIN [JOINT_BASADOS].[Reparaciones] r ON r.nro_reparacion = dr.reparacion_id
    JOIN [JOINT_BASADOS].[Repuestos] rep ON rep.cod_repuesto = dr.cod_repuesto
    JOIN [JOINT_BASADOS].[BI_Tiempo] t 
        ON t.anio = YEAR(r.fecha_ingreso) AND t.mes = MONTH(r.fecha_ingreso)
    GROUP BY t.id, rep.categoria_id;
END;
GO

CREATE PROCEDURE [JOINT_BASADOS].[BI_Migrar_Hechos_Ingresos_Reparaciones]
AS
BEGIN
    INSERT INTO [JOINT_BASADOS].[BI_Hechos_Ingresos_Reparaciones] (
        tiempo_id, local_id, tipo_ingreso_id, facturacion_total
    )
    SELECT
        t.id AS tiempo_id,
        e.local_id,
        ti.id AS tipo_ingreso_id,
        SUM(r.precio_mano_obra) AS facturacion_total
    FROM [JOINT_BASADOS].[Reparaciones] r
    JOIN [JOINT_BASADOS].[Empleados] e ON e.id = r.empleado_id
    JOIN [JOINT_BASADOS].[BI_Tiempo] t 
        ON t.anio = YEAR(r.fecha_ingreso) AND t.mes = MONTH(r.fecha_ingreso)
    JOIN [JOINT_BASADOS].[BI_Tipo_Ingreso_Reparacion] ti 
        ON ti.descripcion = 'Mano de Obra'
    GROUP BY t.id, e.local_id, ti.id

    UNION ALL

    SELECT
        t.id AS tiempo_id,
        e.local_id,
        ti.id AS tipo_ingreso_id,
        SUM(r.precio_repuestos) AS facturacion_total
    FROM [JOINT_BASADOS].[Reparaciones] r
    JOIN [JOINT_BASADOS].[Empleados] e ON e.id = r.empleado_id
    JOIN [JOINT_BASADOS].[BI_Tiempo] t 
        ON t.anio = YEAR(r.fecha_ingreso) AND t.mes = MONTH(r.fecha_ingreso)
    JOIN [JOINT_BASADOS].[BI_Tipo_Ingreso_Reparacion] ti 
        ON ti.descripcion = 'Repuestos'
    GROUP BY t.id, e.local_id, ti.id;
END;
GO

CREATE PROCEDURE [JOINT_BASADOS].[BI_Migrar_Hechos_Compras]
AS
BEGIN
    INSERT INTO [JOINT_BASADOS].[BI_Hechos_Compras] (
        tiempo_id, local_id, tipo_producto_id, cantidad_compras, total_unidades, importe_total
    )
    SELECT
        t.id AS tiempo_id,
        e.local_id,
        p.tipo_producto_id,
        COUNT(DISTINCT c.nro_compra) AS cantidad_compras,
        SUM(dc.cantidad_prod) AS total_unidades,
        SUM(dc.subtotal) AS importe_total
    FROM [JOINT_BASADOS].[Compras] c
    JOIN [JOINT_BASADOS].[Detalles_Compras] dc ON dc.nro_compra = c.nro_compra
    JOIN [JOINT_BASADOS].[Productos] p ON p.cod_producto = dc.cod_producto
    JOIN [JOINT_BASADOS].[Empleados] e ON e.id = c.empleado_id
    JOIN [JOINT_BASADOS].[BI_Tiempo] t 
        ON t.anio = YEAR(c.fecha) AND t.mes = MONTH(c.fecha)
    GROUP BY t.id, e.local_id, p.tipo_producto_id;
END;
GO

-- ============================================================================
-- 6. EJECUCIÓN DE LA MIGRACIÓN EN ORDEN
-- ============================================================================

EXEC [JOINT_BASADOS].[BI_Migrar_Tiempo];
EXEC [JOINT_BASADOS].[BI_Migrar_Rango_Etario];
EXEC [JOINT_BASADOS].[BI_Migrar_Tipo_Producto];
EXEC [JOINT_BASADOS].[BI_Migrar_Local];
EXEC [JOINT_BASADOS].[BI_Migrar_Categoria_Bicicleta];
EXEC [JOINT_BASADOS].[BI_Migrar_Categoria_Repuesto];
EXEC [JOINT_BASADOS].[BI_Migrar_Tipo_Ingreso_Reparacion];

EXEC [JOINT_BASADOS].[BI_Migrar_Hechos_Ventas];
EXEC [JOINT_BASADOS].[BI_Migrar_Hechos_Alquileres];
EXEC [JOINT_BASADOS].[BI_Migrar_Hechos_Reparaciones];
EXEC [JOINT_BASADOS].[BI_Migrar_Hechos_Repuestos_Reparaciones];
EXEC [JOINT_BASADOS].[BI_Migrar_Hechos_Ingresos_Reparaciones];
EXEC [JOINT_BASADOS].[BI_Migrar_Hechos_Compras];
GO

-- ============================================================================
-- 7. CREACIÓN DE LAS 11 VISTAS DE NEGOCIO
-- ============================================================================

-- 1. Facturación total mensual en ventas de cada local
CREATE VIEW [JOINT_BASADOS].[BI_Vista_1_Facturacion_Mensual_Ventas] AS
SELECT 
    t.anio,
    t.mes,
    l.nombre AS local,
    SUM(hv.facturacion_total) AS facturacion_total
FROM [JOINT_BASADOS].[BI_Hechos_Ventas] hv
JOIN [JOINT_BASADOS].[BI_Tiempo] t ON t.id = hv.tiempo_id
JOIN [JOINT_BASADOS].[BI_Local] l ON l.id = hv.local_id
GROUP BY t.anio, t.mes, l.nombre;
GO

-- 2. Ticket promedio ($) de venta mensual por tipo de producto y rango etario del cliente
CREATE VIEW [JOINT_BASADOS].[BI_Vista_2_Ticket_Promedio_Ventas] AS
SELECT
    t.anio,
    t.mes,
    tp.tipo AS tipo_producto,
    re.descripcion AS rango_etario,
    CAST(SUM(hv.facturacion_total) / SUM(hv.cantidad_ventas) AS DECIMAL(18,2)) AS ticket_promedio
FROM [JOINT_BASADOS].[BI_Hechos_Ventas] hv
JOIN [JOINT_BASADOS].[BI_Tiempo] t ON t.id = hv.tiempo_id
JOIN [JOINT_BASADOS].[BI_Tipo_Producto] tp ON tp.id = hv.tipo_producto_id
JOIN [JOINT_BASADOS].[BI_Rango_Etario] re ON re.id = hv.rango_etario_id
GROUP BY t.anio, t.mes, tp.tipo, re.descripcion;
GO

-- 3. Porcentaje de ventas trimestrales según tipo de producto por local
CREATE VIEW [JOINT_BASADOS].[BI_Vista_3_Porcentaje_Ventas_Trimestral] AS
SELECT
    t.anio,
    t.trimestre,
    l.nombre AS local,
    tp.tipo AS tipo_producto,
    CAST(
        SUM(hv.facturacion_total) * 100.0 / 
        SUM(SUM(hv.facturacion_total)) OVER (PARTITION BY t.anio, t.trimestre, l.nombre)
    AS DECIMAL(5,2)) AS porcentaje_ventas
FROM [JOINT_BASADOS].[BI_Hechos_Ventas] hv
JOIN [JOINT_BASADOS].[BI_Tiempo] t ON t.id = hv.tiempo_id
JOIN [JOINT_BASADOS].[BI_Local] l ON l.id = hv.local_id
JOIN [JOINT_BASADOS].[BI_Tipo_Producto] tp ON tp.id = hv.tipo_producto_id
GROUP BY t.anio, t.trimestre, l.nombre, tp.tipo;
GO

-- 4. Promedio de cantidad de horas de alquiler de bicicletas, por local y mes
CREATE VIEW [JOINT_BASADOS].[BI_Vista_4_Promedio_Horas_Alquiler] AS
SELECT 
    t.anio,
    t.mes,
    l.nombre AS local,
    CAST(SUM(ha.total_horas_alquiler) / SUM(ha.cantidad_alquileres) AS DECIMAL(18,2)) AS promedio_horas_alquiler
FROM [JOINT_BASADOS].[BI_Hechos_Alquileres] ha
JOIN [JOINT_BASADOS].[BI_Tiempo] t ON t.id = ha.tiempo_id
JOIN [JOINT_BASADOS].[BI_Local] l ON l.id = ha.local_id
GROUP BY t.anio, t.mes, l.nombre;
GO

-- 5. Top 5 categorías de bicicleta más alquiladas, por año
CREATE VIEW [JOINT_BASADOS].[BI_Vista_5_Top5_Categorias_Alquiladas] AS
WITH Ranking_Categorias AS (
    SELECT 
        t.anio,
        cb.categoria,
        SUM(ha.cantidad_alquileres) AS total_alquileres,
        ROW_NUMBER() OVER (
            PARTITION BY t.anio 
            ORDER BY SUM(ha.cantidad_alquileres) DESC
        ) AS posicion
    FROM [JOINT_BASADOS].[BI_Hechos_Alquileres] ha
    JOIN [JOINT_BASADOS].[BI_Tiempo] t ON t.id = ha.tiempo_id
    JOIN [JOINT_BASADOS].[BI_Categoria_Bicicleta] cb ON cb.id = ha.categoria_bicicleta_id
    GROUP BY t.anio, cb.categoria
)
SELECT anio, posicion, categoria, total_alquileres
FROM Ranking_Categorias
WHERE posicion <= 5;
GO

-- 6. Desvío promedio de reparaciones (en días), entre fecha de entrega estimada y real, por local y trimestre
CREATE VIEW [JOINT_BASADOS].[BI_Vista_6_Desvio_Promedio_Reparaciones] AS
SELECT
    t.anio,
    t.trimestre,
    l.nombre AS local,
    CAST(SUM(hr.total_dias_desvio) * 1.0 / SUM(hr.cantidad_reparaciones) AS DECIMAL(18,2)) AS desvio_promedio_dias
FROM [JOINT_BASADOS].[BI_Hechos_Reparaciones] hr
JOIN [JOINT_BASADOS].[BI_Tiempo] t ON t.id = hr.tiempo_id
JOIN [JOINT_BASADOS].[BI_Local] l ON l.id = hr.local_id
GROUP BY t.anio, t.trimestre, l.nombre;
GO

-- 7. Ranking de categoría de repuestos más utilizados por mes
CREATE VIEW [JOINT_BASADOS].[BI_Vista_7_Ranking_Repuestos_Mes] AS
SELECT
    t.anio,
    t.mes,
    cr.categoria AS categoria_repuesto,
    SUM(hrr.cantidad_utilizada) AS total_utilizado,
    ROW_NUMBER() OVER (
        PARTITION BY t.anio, t.mes
        ORDER BY SUM(hrr.cantidad_utilizada) DESC
    ) AS ranking
FROM [JOINT_BASADOS].[BI_Hechos_Repuestos_Reparaciones] hrr
JOIN [JOINT_BASADOS].[BI_Tiempo] t ON t.id = hrr.tiempo_id
JOIN [JOINT_BASADOS].[BI_Categoria_Repuesto] cr ON cr.id = hrr.categoria_repuesto_id
GROUP BY t.anio, t.mes, cr.categoria;
GO

-- 8. Porcentaje de facturación de reparaciones según el tipo de ingreso por trimestre
CREATE VIEW [JOINT_BASADOS].[BI_Vista_8_Porcentaje_Ingresos_Reparaciones] AS
SELECT
    t.anio,
    t.trimestre,
    ti.descripcion AS tipo_ingreso,
    CAST(
        SUM(hir.facturacion_total) * 100.0 / 
        SUM(SUM(hir.facturacion_total)) OVER (PARTITION BY t.anio, t.trimestre)
    AS DECIMAL(5,2)) AS porcentaje_facturacion
FROM [JOINT_BASADOS].[BI_Hechos_Ingresos_Reparaciones] hir
JOIN [JOINT_BASADOS].[BI_Tiempo] t ON t.id = hir.tiempo_id
JOIN [JOINT_BASADOS].[BI_Tipo_Ingreso_Reparacion] ti ON ti.id = hir.tipo_ingreso_id
GROUP BY t.anio, t.trimestre, ti.descripcion;
GO

-- 9. Promedio de unidades compradas según el tipo de producto por trimestre
CREATE VIEW [JOINT_BASADOS].[BI_Vista_9_Promedio_Unidades_Compradas] AS
SELECT
    t.anio,
    t.trimestre,
    tp.tipo AS tipo_producto,
    CAST(SUM(hc.total_unidades) * 1.0 / SUM(hc.cantidad_compras) AS DECIMAL(18,2)) AS promedio_unidades_compradas
FROM [JOINT_BASADOS].[BI_Hechos_Compras] hc
JOIN [JOINT_BASADOS].[BI_Tiempo] t ON t.id = hc.tiempo_id
JOIN [JOINT_BASADOS].[BI_Tipo_Producto] tp ON tp.id = hc.tipo_producto_id
GROUP BY t.anio, t.trimestre, tp.tipo;
GO

-- 10. Importe total de compras mensuales por local
CREATE VIEW [JOINT_BASADOS].[BI_Vista_10_Compras_Mensuales_Local] AS
SELECT
    t.anio,
    t.mes,
    l.nombre AS local,
    SUM(hc.importe_total) AS importe_total_compras
FROM [JOINT_BASADOS].[BI_Hechos_Compras] hc
JOIN [JOINT_BASADOS].[BI_Tiempo] t ON t.id = hc.tiempo_id
JOIN [JOINT_BASADOS].[BI_Local] l ON l.id = hc.local_id
GROUP BY t.anio, t.mes, l.nombre;
GO

-- 11. Facturación mensual del negocio (ventas + alquileres + reparaciones) por local
CREATE VIEW [JOINT_BASADOS].[BI_Vista_11_Facturacion_Total_Negocio] AS
WITH Facturacion_Unificada AS (
    SELECT tiempo_id, local_id, SUM(facturacion_total) AS monto
    FROM [JOINT_BASADOS].[BI_Hechos_Ventas]
    GROUP BY tiempo_id, local_id

    UNION ALL

    SELECT tiempo_id, local_id, SUM(facturacion_total) AS monto
    FROM [JOINT_BASADOS].[BI_Hechos_Alquileres]
    GROUP BY tiempo_id, local_id

    UNION ALL

    SELECT tiempo_id, local_id, SUM(facturacion_total) AS monto
    FROM [JOINT_BASADOS].[BI_Hechos_Ingresos_Reparaciones]
    GROUP BY tiempo_id, local_id
)
SELECT
    t.anio,
    t.mes,
    l.nombre AS local,
    SUM(f.monto) AS facturacion_total_negocio
FROM Facturacion_Unificada f
JOIN [JOINT_BASADOS].[BI_Tiempo] t ON t.id = f.tiempo_id
JOIN [JOINT_BASADOS].[BI_Local] l ON l.id = f.local_id
GROUP BY t.anio, t.mes, l.nombre;
GO