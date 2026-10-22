CREATE SCHEMA [JOINT_BASADOS];

CREATE TABLE JOINT_BASADOS.provincia (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
);


CREATE TABLE JOINT_BASADOS.localidad (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    provincia_id INT REFERENCES JOINT_BASADOS.provincia(id)

);


CREATE TABLE JOINT_BASADOS.cliente (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    nombre VARCHAR(255) NOT NULL,
    apellido VARCHAR(255) NOT NULL,
    dni INT NOT NULL,
    telefono VARCHAR(50) NOT NULL,
    email VARCHAR(50) NOT NULL,
    direccion VARCHAR(50) NOT NULL,
    fecha_nacimiento DATE NOT NULL,
    activo BIT(1),
    localidad_id INT REFERENCES JOINT_BASADOS.localidad(id)

);

CREATE TABLE JOINT_BASADOS.empleado (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    descripcion_estado VARCHAR(255) NOT NULL
);


CREATE TABLE JOINT_BASADOS.forma_de_pago (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    descripcion_estado VARCHAR(255) NOT NULL
);

CREATE TABLE JOINT_BASADOS.modelo_bicicleta (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    descripcion_estado VARCHAR(255) NOT NULL
);

CREATE TABLE JOINT_BASADOS.bicicleta_alquiler (
    nro_serie INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    descripcion_estado VARCHAR(255) NOT NULL
);



CREATE TABLE JOINT_BASADOS.estado_alquiler (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    descripcion_estado VARCHAR(255) NOT NULL
);

CREATE TABLE JOINT_BASADOS.estado_reparacion (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    descripcion_estado VARCHAR(255) NOT NULL
);

CREATE TABLE JOINT_BASADOS.categoria_repuesto (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    categoria VARCHAR(255) NOT NULL
);

CREATE TABLE JOINT_BASADOS.repuesto (
    cod_repuesto INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    descripcion_repuesto VARCHAR(MAX) NOT NULL,
    compatibilidad_repuesto VARCHAR(MAX) NOT NULL,
    precio_repuesto DECIMAL(10,2) NOT NULL,
    categoria_id INT
        REFERENCES JOINT_BASADOS.categoria_repuesto(id)
);

CREATE TABLE JOINT_BASADOS.alquiler (
    nro_alquiler INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    fecha_inicio DATE NOT NULL,
    fecha_fin_pactada DATE NOT NULL,
    fecha_devolucion_real DATE,
    importe_total DECIMAL(10,2) NOT NULL,
    bicicleta_alquilada INT
        REFERENCES JOINT_BASADOS.bicicleta_alquiler(nro_serie),
    estado_alquiler_id INT
        REFERENCES JOINT_BASADOS.estado_alquiler(id),
    cliente_id INT
        REFERENCES JOINT_BASADOS.cliente(id),
    empleado_id INT
        REFERENCES JOINT_BASADOS.empleado(id),
    forma_de_pago_id INT
        REFERENCES JOINT_BASADOS.forma_de_pago(id)
);

CREATE TABLE JOINT_BASADOS.reparacion (
    nro_reparacion INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    modelo_id INT
        REFERENCES JOINT_BASADOS.modelo_bicicleta(id),
    cliente_id INT
        REFERENCES JOINT_BASADOS.cliente(id),
    empleado_id INT
        REFERENCES JOINT_BASADOS.empleado(id),
    estado_reparacion_id INT
        REFERENCES JOINT_BASADOS.estado_reparacion(id),
    fecha_ingreso DATE NOT NULL,
    fecha_entrega_estimada DATE NOT NULL,
    fecha_entrega_real DATE,
    diagnostico VARCHAR(MAX),
    precio_mano_obra DECIMAL(10,2),
    precio_repuestos_reparacion DECIMAL(10,2),
    precio_total DECIMAL(10,2)
);

CREATE TABLE JOINT_BASADOS.detalle_reparacion (
    id INT IDENTITY(1,1) NOT NULL PRIMARY KEY,
    cantidad_repuestos INT NOT NULL,
    precio_unitario_repuesto DECIMAL(10,2) NOT NULL,
    subtotal_repuesto DECIMAL(10,2) NOT NULL,
    cod_repuesto INT
        REFERENCES JOINT_BASADOS.repuesto(cod_repuesto),
    reparacion_id INT
        REFERENCES JOINT_BASADOS.reparacion(nro_reparacion)
);



--SELECT DISTINCT m.Marca_Marca from GD2C_2026.gd_esquema.Maestra m;
