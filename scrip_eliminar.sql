USE GD2C_2026;
GO

-- 1. Eliminar tablas dependientes (las que tienen FOREIGN KEYS hacia otras)
DROP TABLE IF EXISTS [JOINT_BASADOS].[Bicicleta_Venta];
DROP TABLE IF EXISTS [JOINT_BASADOS].[Bicicleta_Alquiler];
DROP TABLE IF EXISTS [JOINT_BASADOS].[Accesorio];
GO

-- 2. Eliminar tablas intermedias
DROP TABLE IF EXISTS [JOINT_BASADOS].[Modelo_Bicicleta];
GO

-- 3. Eliminar tablas independientes (las que no tienen FOREIGN KEYS)
DROP TABLE IF EXISTS [JOINT_BASADOS].[Estado_Bicicleta_Alquiler];
DROP TABLE IF EXISTS [JOINT_BASADOS].[Categoria_accesorio];
DROP TABLE IF EXISTS [JOINT_BASADOS].[Categoria_Bicicleta];
DROP TABLE IF EXISTS [JOINT_BASADOS].[Marca];
GO

-- 4. Finalmente, eliminar el esquema vacío
DROP SCHEMA IF EXISTS [JOINT_BASADOS];
GO