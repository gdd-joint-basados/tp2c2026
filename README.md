Universidad Tecnológica Nacional Facultad Regional Buenos Aires

## Base de Datos

## Trabajo Práctico

2° Cuatrimestre 2026

## FRBA – Gestión de Bicicletería

Enunciado V1.0

Última actualización: 03/09/2026


## Índice


DER.jpg DER_BI.jpg \data Consideración [URL 🔗](#page-0)

23 23 23 [URL 🔗](#page-0)

[23](#page-0)

## Ayuda y contacto Obtención de herramientas 24 25 [URL 🔗](#page-0)


## Introducción

## Objetivos generales

El presente trabajo práctico persigue los siguientes objetivos generales:

- Promover la investigación de técnicas de modelado y diseño de bases de datos.

- Aplicar la teoría vista en la asignatura en un caso de aplicación concreto.

- Ejercitar el proceso de diseño y normalización de una base de datos a partir de un caso de negocio realista.

- Desarrollar habilidades de implementación en SQL, incluyendo la creación de los objetos de base de datos, la migración de datos, la escritura de consultas, rutinas y vistas.

- Fomentar el trabajo en equipo y la organización de tareas dentro del grupo.

## Descripción general

Mediante este trabajo práctico se intenta simular la implementación de un nuevo sistema para una bicicletería. El mismo permitirá gestionar las ventas de productos, el servicio de alquiler de bicicletas, el servicio de reparación de su taller y las compras que realiza a sus proveedores.

Hasta el momento, la bicicletería llevaba el registro de toda su operación en una única tabla, sin mayor estructura ni validación. La implementación del nuevo sistema requiere diseñar una base de datos que modele correctamente las reglas del negocio, para luego migrar a ese nuevo modelo los datos existentes.

Además, se solicita la implementación de un segundo modelo, con sus correspondientes procedimientos y vistas, que pueda ser utilizado para la obtención de indicadores de gestión, análisis de escenarios y proyección para la toma de decisiones.

Además, se solicita la implementación de un segundo modelo, orientado al análisis de información, con sus correspondientes procedimientos de carga y vistas, que permita obtener indicadores de gestión, analizar escenarios y proyectar información para la toma de decisiones.


## Componentes del TP

El alumno recibirá dos componentes y, en base a estos, deberá realizar el modelo y los procedimientos correspondientes. Los componentes a recibir son:

## Base de Datos y Modelo de Datos

La cátedra provee un backup de la base de datos en el motor SQL Server 2022. Este incluye una única tabla, llamada maestra, que contiene datos provistos por la cátedra correspondientes al dominio del negocio que se describe en el TP.

Los datos de esta tabla se encuentran desorganizados y no poseen ningún tipo de normalización.

La lógica del negocio está definida, en su mayoría, por la especificación de los principales casos de uso que están implementados actualmente (tabla maestra).

El alumno deberá analizar los datos contenidos en dicha tabla y confeccionar un nuevo modelo de datos que siga todos los estándares de desarrollo de bases de datos explicados durante la cursada.

Si se presentan dudas al respecto, es recomendable consultar al grupo de Google de la materia antes de tomar decisiones incorrectas.

## Especificación de casos de uso

A continuación, se detallan algunas especificaciones de casos de uso relacionados al nuevo sistema, con el objetivo de contextualizar y ayudar al entendimiento de la operación del mismo.


## Introducción

Una bicicletería opera a través de varios locales y cuenta con tres líneas de negocio bien diferenciadas.

Por un lado, cada local vende bicicletas y accesorios de su catálogo, como cualquier comercio: el cliente elige el producto, lo paga y se lo lleva.

Por otro lado, cada local cuenta con una flota de bicicletas que alquila por hora o por día; estas bicicletas de alquiler nunca se venden, son unidades físicas que el local reserva para el uso temporal de sus clientes.

Además, cada local tiene un taller propio donde ofrece el servicio de reparación de bicicletas para clientes.

El negocio realiza también la gestión de compras periódicas a proveedores para reponer su catálogo de ventas. Cada local es responsable de sus compras.

El sistema deberá permitir registrar y gestionar estas cuatro operaciones: ventas, alquileres, reparaciones y compras.

## 1. Gestión de Ventas

El local registra las ventas de productos realizadas a sus clientes. Cada venta es atendida por un empleado. Un empleado pertenece únicamente a un local.

En una venta se registra información como:

- Nro de Venta

- Cliente: cliente que realiza la compra, con toda su información (nombre, apellido, DNI, teléfono, email, domicilio, etc.)

- Empleado: empleado que atiende la venta. Los empleados están previamente dados de alta en el sistema con toda su información (nombre, apellido, DNI, puesto, fecha de ingreso, etc.).

- Fecha y hora: fecha y hora en que se realiza la venta

- Forma de pago: forma en la que paga el cliente (efectivo, tarjeta, transferencia)

- Total: importe total de la venta

Una venta puede incluir uno o varios productos, que pueden ser bicicletas y/o accesorios. Por cada producto dentro de la venta se registra:

- Producto vendido: Puede corresponder a una bicicleta o a un accesorio

- Cantidad vendida: Cantidad del producto vendido

- Precio unitario al que se vendió: precio unitario del producto

- Subtotal del producto


Bicicletas: Las bicicletas disponibles para la venta ya se encuentran cargadas previamente en el sistema con su información correspondiente, como marca, categoría, rodado, cuadro, color y meses de garantía, entre otros. La información de marca, categoria, etc. corresponden al modelo de una bicicleta. Los meses de garantía no dependen del modelo sino del producto de bici en venta.

Accesorios: Los accesorios disponibles para la venta ya se encuentran cargados previamente en el sistema con su información correspondiente, como categoría, marca, talle (cuando corresponde), color, entre otros.

- 2. Gestión de Alquileres

Cada local alquila bicicletas de su flota propia a sus clientes. Las bicicletas para alquiler no son las mismas que están a la venta y se identifican unívocamente por su nro. de serie.

En un alquiler se registra información como:

- Nro de Alquiler

- Cliente: cliente que alquila, con toda su información (nombre, apellido, DNI, teléfono, email, domicilio, etc.)

- Empleado: empleado que gestiona el alquiler.

- Bicicleta: bicicleta de la flota elegida para el alquiler. Las bicicletas de la flota ya se encuentran cargadas previamente en el sistema con su información correspondiente, como número de serie, modelo, estado y precio por hora y por día, entre otros. El estado de la bici indica si está disponible, alquilada o de baja.

- Fecha y hora de inicio del alquiler

- Fecha y hora de inicio de devolución pactada

- Fecha y hora de devolución real

- Estado: estado del alquiler (reservado, en curso, devuelto, vencido)

- Forma de pago

- Importe total

Una misma bicicleta puede alquilarse muchas veces a lo largo del tiempo, pero nunca a dos clientes al mismo tiempo.


## 3. Gestión de Reparaciones

Los clientes traen bicicletas al taller de un local para reparar.

En una reparación se registra información como:

- Nro de Reparación

- Cliente: cliente que trae la bicicleta, con toda su información (nombre, apellido, DNI, teléfono, email, domicilio, etc.)

- Empleado: técnico que atiende la reparación.

- Bicicleta: modelo de la bicicleta a reparar (si el local no lo tiene cargado en su catálogo, se da de alta)

- Fecha de ingreso de la bici al taller

- Fecha estimada de entrega

- Fecha real de entrega

- Diagnóstico

- Estado: estado de la reparación (presupuestada, en proceso, lista, entregada)

- Precio de mano de obra: precio total que paga el cliente por la mano de obra de la reparación

- Precio de repuestos: precio total que paga el cliente por los repuestos

- Precio total: precio total que paga el cliente por la reparación.

En una misma reparación se pueden usar uno o varios repuestos del taller.

Repuestos: por cada repuesto utilizado en la reparación, se registra cuál es el repuesto elegido, la cantidad y el precio. Los repuestos ya se encuentran cargados previamente en el sistema con su información correspondiente, como código, descripción, categoría y compatibilidad, entre otros.

## 4. Gestión de Compras

Cada local compra productos a sus proveedores para reponer su catálogo.

En una compra se registra información como:

- Nro de Compra

- Proveedor: proveedor al que se le compra, con toda su información (razón social, CUIT, teléfono, email, dirección, etc.)

- Empleado: empleado que registra la compra.

- Fecha de la compra


- Total: importe total de la compra

Una compra puede incluir uno o varios productos, ya sean bicicletas y/o accesorios (los mismos productos del catálogo que se venden en el punto 1). Por cada producto comprado se registra la cantidad, el precio de costo al que se compró y el subtotal.

## Consideraciones

Cabe aclarar que la especificación de casos de uso es solo un resumen de la información contenida en la tabla maestra: ilustra las principales operaciones del sistema y hace foco en los aspectos más relevantes de cada una en el contexto de este TP. El resto de los campos correspondientes a cada entidad a modelar deberá ser relevado por el alumno a partir de los datos de la tabla.

Tener en cuenta que, al tratarse de datos DESNORMALIZADOS y DESORGANIZADOS, pueden existir inconsistencias que deberán documentar y cuyo impacto deberán controlar en el diseño de la base de datos. Por ejemplo: DNI duplicados, fechas invertidas o mal cargadas, ventas registradas bajo un vendedor que no corresponde, etc. La resolución de estas inconsistencias NUNCA debe llevar a modificar los datos originales, ni a suponer o inferir causas y motivos. Es habitual encontrarse con este tipo de errores en procesos de migración de sistemas anteriores.


## Requerimientos del TP

## General

El alumno deberá, primero, diseñar el nuevo modelo de datos, crear todos los componentes de base de datos y realizar la migración de los datos. Luego deberá implementar un modelo de Inteligencia de Negocios que le permita obtener los indicadores necesarios para un tablero de control.

## Modelo Transaccional del Sistema

El alumno deberá diseñar el modelo de datos transaccional y desarrollar un script de base de datos en SQL Server que realice la creación de dicho modelo y la migración de los datos de la tabla maestra hacia él.

## Base de Datos

El alumno deberá crear un modelo de datos que organice y normalice los datos de la única tabla provista por la cátedra.

## Deberá incluir:

- Creación de nuevas tablas.

- Creación de claves primarias y foráneas para relacionar estas tablas.

- Creación de constraints y triggers sobre estas tablas cuando fuese necesario.

- Creación de los índices necesarios para acceder a los datos de estas tablas de manera eficiente.

- Migración de datos: deberán cargarse todas las tablas del nuevo modelo a partir de la totalidad de los datos de la tabla maestra provista por la cátedra, utilizando Stored Procedures para este fin.

- Creación de su propio esquema con el nombre del grupo elegido

El alumno deberá entregar el DER del modelo transaccional y un único archivo de script que, al ejecutarse, realice todos los pasos mencionados anteriormente en el orden correcto. Todo el modelo de datos confeccionado por el alumno deberá ser creado y cargado correctamente ejecutando este Script una única vez.


## Consideraciones

Todas las columnas creadas para las nuevas tablas deberán respetar los mismos tipos de datos que las columnas existentes en la tabla maestra. A su vez, el alumno podrá crear nuevas columnas, claves e identificadores para satisfacer sus necesidades. Pero nunca se podrá inventar información, por ejemplo, crear una venta que nunca existió.

Tener en cuenta que DEBEN crear su propio esquema con el nombre de su grupo. Esto permite que cada grupo tenga su espacio propio de resolución, evitando que se mezcle con la solución de otro grupo o con la que la cátedra utiliza para la corrección del trabajo práctico.

## Modelo de Inteligencia de Negocios (BI)

En la segunda etapa, el alumno deberá generar un archivo de script que, al ejecutarse, realice la creación de un nuevo modelo de Inteligencia de Negocios y migre los datos de su sistema transaccional a dicho modelo, sobre el cual se realizarán las consultas que alimenten el tablero de control. Dicho script deberá incluir también la generación de las vistas necesarias para resolver las consultas de negocio.

## Base de Datos

El alumno deberá diseñar y crear un modelo de datos de BI que organice la información del negocio y soporte la ejecución de consultas simples para resolver las consultas de negocio que se definirán más adelante.

Deberá incluir:

- Creación de nuevas tablas y vistas que conforman el modelo de Inteligencia de Negocios propuesto.

- Creación de claves primarias y foráneas para relacionar estas tablas.

- Migración de datos al modelo dimensional: cargar todas las tablas del modelo dimensional a partir de los datos ya migrados al modelo transaccional creado en la etapa anterior.

- No se debe crear una nueva base de datos para estas tareas. Las mismas deben realizarse dentro de la misma base de datos, prefijando cada tabla con "BI_" quedando BI_nombre_de_tabla (por ejemplo, BI_Ventas).


El alumno deberá entregar el DER del Modelo de BI y un nuevo archivo de Script, siempre dentro del mismo esquema, que, al ejecutarse, realice todos los pasos mencionados anteriormente, en el orden correcto. Todo el modelo de datos deberá quedar creado y cargado correctamente al ejecutar este script una única vez.

Todas las columnas creadas para las nuevas tablas deberán respetar los mismos tipos de datos que las columnas correspondientes en la tabla maestra. A su vez, el alumno podrá crear nuevas columnas, claves e identificadores para satisfacer sus necesidades.

## Especificación del Modelo de BI

Teniendo en cuenta el modelo de datos transaccional creado, se deberá generar un nuevo modelo de datos de Inteligencia de Negocios que permita unificar la información necesaria para facilitar la creación de los tableros de control a nivel gerencial. Se deberán considerar, como mínimo, las siguientes dimensiones, además de las que el alumno considere convenientes:

- Tiempo : año/trimestre/mes

- Rango etario clientes

- Menores de 25 años inclusive

- Entre 25 y 35 años inclusive

- Entre 35 y 50 años inclusive

- Mayores de 50 años

- Tipo Producto

- Bicicleta

- Accesorio

- Local

- Categoría de Bicicleta

- Categoría de Repuestos

- Tipo Ingreso Reparaciones

- Mano de Obra

- Repuestos

A partir del modelo diseñado, se deberán construir vistas que permitan obtener, mediante consultas directas, la siguiente información para los indicadores de negocio:


- 1. Facturación total mensual en ventas de cada local

- 2. Ticket promedio (\$) de venta mensual por tipo de producto (bicicletas o accesorios) y rango etario del cliente.

- 3. Porcentaje de ventas trimestrales según tipo de producto (bicicletas o accesorios) por local.

- 4. Promedio de cantidad de horas de alquiler de bicicletas, por local y mes

- 5. Top 5 categorías de bicicleta más alquilados, por año

- 6. Desvío promedio de reparaciones (en días), entre fecha de entrega estimada y real, por local y trimestre.

- 7. Ranking de categoría de repuestos más utilizados por mes.

- 8. Porcentaje de facturación de reparaciones según el tipo de ingreso de reparación (mano de obra o repuestos) por trimestre

- 9. Promedio de unidades (cantidad) compradas según el tipo de producto (bicicletas o accesorios) por trimestre.

- 10. Importe total de compras mensuales por local.

- 11. Facturación mensual del negocio (ventas + alquileres + reparaciones) por local.


## Implementación

## General

A continuación, se detalla la implementación de cada componente.

## Base de Datos

El alumno debe instalar el motor de base de datos SQL Server 2022.

Una vez instalado el motor de base de datos, se deberá instalar la herramienta cliente de trabajo: “SQL Server Management Studio” (SSMS) para SQL Server 2022. Ejecutar esta aplicación e ingresar los datos del usuario “sa” creado durante la instalación (en modo “Autenticación de SQL Server”).

Luego se debe restaurar la base de datos, dicho procedimiento está documentado en el documento “Instructivo Restauración BD”.

Luego de cargados todos los datos de la tabla maestra, el alumno deberá crear su propio esquema dentro de la base de datos. El nombre del esquema deberá ser igual al nombre del grupo registrado en la materia (el proceso de registración se explica más adelante). El nombre del esquema debe ser en mayúsculas, sin espacios y separado por guiones bajos. Ejemplo “Los mejores” debe ser “LOS_MEJORES”.

Todas las tablas, stored procedures, vistas, triggers y otros objetos de base de datos nuevos que cree el alumno deberán pertenecer a este esquema. Si la solución entregada posee objetos de base de datos por fuera del esquema con el nombre del grupo, el TP será rechazado sin evaluar su funcionalidad.

Con esta configuración el alumno está listo para empezar la implementación de la parte de base de datos.

## Restricciones

El motor de base de datos deberá ser Microsoft SQL Server 2022. Tanto la versión Express, como la versión Full sirven para realizar el trabajo. No podrá utilizarse ninguna herramienta auxiliar que ayude a realizar la migración de datos, ni desarrollarse una aplicación personalizada para dicho fin. La misma deberá ser efectuada íntegramente en código T-SQL en el archivo de script “script_creacion_inicial.sql”.


## Condiciones de Evaluación y Aprobación

## Testing de Scripts

El alumno entregará a lo largo del TP dos scripts:

- Script de base de datos transaccional (script_creacion_inicial.sql), con todo lo necesario para crear su modelo transaccional y cargarlo con los datos correspondientes.

- Script de base de datos BI (script_creacion_BI.sql), con todo lo necesario para crear el modelo de BI, poblarlo correctamente y crear las vistas solicitadas sobre el mismo.

La cátedra probará el Trabajo Práctico en el siguiente orden:

- 1. Se dispondrá de una base de datos limpia, igual a la original entregada a los alumnos.

- 2. Se ejecutará el archivo script_creacion_inicial.sql. proporcionado por el alumno. Este archivo deberá tener absolutamente todo lo necesario para crear y cargar el modelo de datos correspondiente. Toda la ejecución deberá realizarse en orden y sin ningún tipo de error ni warning.

- 3. Se ejecutará el archivo script_creacion_BI.sql proporcionado por el alumno. Este archivo deberá tener absolutamente todo lo necesario para crear y cargar el modelo de BI. Toda la ejecución deberá realizarse en orden y sin ningún tipo de error ni warning.

Los archivos “script_creacion_inicial.sql” y “script_creacion_BI.sql” deben contener todo lo necesario para crear el modelo de datos correspondiente y cargarlo con los datos. Si el alumno utilizó alguna herramienta auxiliar o programa personalizado para resolver algún paso, tener en cuenta que la cátedra no lo ejecutará: solo se correrán los scripts SQL entregados.

Si en su ejecución se produjeran errores, el trabajo práctico será rechazado sin continuar su evaluación.


Todos los objetos de base de datos creados por el alumno deben pertenecer al esquema de base de datos creado con el nombre del grupo. Si esta restricción no se cumple el trabajo práctico será rechazado sin continuar su evaluación.

También deberán considerarse criterios de performance al momento de definir relaciones e índices en las tablas. El tiempo máximo de ejecución tolerado para cada script es de 10 minutos; superado ese límite, la ejecución se detendrá y el trabajo práctico no será corregido

## Consultas SQL

Todas las consultas SQL, vistas y stored procedure desarrollados por el alumno serán evaluados de acuerdo al estándar de programación SQL explicado en clase. La performance de las mismas será tenida en cuenta a la hora de fijar la nota.

## Sobre los grupos

Deberán estar compuestos de no más de cuatro integrantes. Cada grupo debe tener un representante, que será el único que podrá enviar mails con el TP para su corrección. Los grupos pueden estar compuestos por alumnos de distinto curso. Los alumnos deben registrar su grupo en un sitio de registración especial, especificando un nombre único que identifique al grupo. La URL del sitio de registración es la siguiente:

## [https://spreadsheets0.google.com/viewform?formkey=dG16aEltM Hc1X2hPN3U2YTVoVGxfeUE6MA](https://spreadsheets0.google.com/viewform?formkey=dG16aEltMHc1X2hPN3U2YTVoVGxfeUE6MA)

Al registrarse es necesario especificar un nombre de grupo. El nombre debe ser en mayúsculas, sin espacios y separado por guiones bajos. Ejemplo “Los mejores” debe ser “LOS_MEJORES”.

Luego, el 25/09/2026 se enviarán los mails correspondientes con la confirmación de los grupos y se les asignará un número de grupo además del nombre que determinaron. Luego de esa fecha, la cátedra publicará en el Grupo de Google OFICIAL de la materia la conformación de los mismos, la cual será inalterable hasta la finalización del cuatrimestre. Cualquier cambio de integrantes, sea por el motivo que fuese, deberá realizarse antes de esa fecha; no se aceptará ninguna modificación posterior. Es obligación de los alumnos ingresar al grupo de la cátedra para obtener dicha información.


## Entregas

## Fechas de entrega y condiciones

A continuación se detallan las entregas que deberán realizarse y cuáles son las condiciones generales y específicas para cada una de ellas.

## Entrega DER

En esta primera entrega deberá enviarse solamente el DER del sistema en un archivo formato imagen, preferentemente JPG, el cual debe estar realizado con una herramienta acorde y ser netamente legible, no pixelado, con todas sus relaciones y campos que componen la entidad.

No se aceptarán imágenes de DER realizado a mano, en lápiz, birome, etc.

Fecha: 01/10/2026 hasta las 12:00hs del mediodía (GMT 3:00 Buenos Aires).

En caso de que el DER no sea correcto, los errores serán informados en la corrección y deberán ser resueltos para la entrega siguiente de Modelo de Datos Relacional y Migración. Esto quiere decir que no hay reentrega específica del DER. La motivación de esta entrega es la corrección temprana de errores en el modelado de la base de datos antes del proceso de migración.

## Entrega de Modelo de Datos Relacional y Migración

En esta entrega se deberán enviar:

- El script de creación y migración de datos (un único script) del modelo relacional según el formato especificado en la sección de formato de entrega del presente documento.

- DER del modelo correspondiente (Corregido en el caso que corresponda)

- Documento de estrategia que respalde las decisiones tomadas.

## Modelo de datos y migración

Fecha: 30/10/2026 hasta las 12:00hs del mediodía (GMT 3:00 Buenos Aires).


## Entrega de BI

En esta entrega se deberán enviar:

- DER del modelo relacional (Corregido en el caso que corresponda)

- El script de creación del modelo relacional y migración de datos (Corregido en el caso que corresponda)

- DER del modelo de BI correspondiente.

- El script de creación y carga de datos (un único script) del modelo de BI según el formato especificado en la sección de formato de entrega del presente documento.

- Documento de estrategia actualizado que respalde las decisiones tomadas.

## Entrega del Modelo de BI y la carga de datos

Fecha: 25/11/2026 hasta las 12:00hs del mediodía (GMT 3:00 Buenos Aires).

## Condiciones de Entregas

- Para cada entrega existe una sola fecha de entrega posible como límite.

- En el caso del DER solo existe una única entrega, es decir, una vez corregido no hay reentregas intermedias. Si al momento de recibir la corrección deben realizar modificaciones, las mismas serán observadas al momento de entregar la migración al modelo relacional.

- Existen SOLO 2 (dos) posibilidades de re entrega en total, independientemente si se trata del modelo relacional o el modelo de BI.

- Tanto la entrega del Modelo Relacional como el Modelo de BI deben contar con un DER que respalde el modelo y facilite su corrección e interpretación, además de los comentarios que crean necesarios en el apartado de estrategia.

- La entrega del TP es grupal y la responsabilidad es de todos los integrantes del grupo para llegar en fecha.

- Los TPs entregados luego del horario indicado, se considerarán fuera de término perdiendo así una posibilidad de entrega y restándole un instancia de presentación.

- El TPs no se podrá entregar antes de la fecha


- Las 2(dos) instancias de reentrega disponibles no tienen fecha asignada y serán determinadas por el grupo para entregar cuando consideren, bajo responsabilidad de los alumnos, siempre y cuando no exceda la fecha final del TP.

- Una vez entregado el TP, el periodo de corrección es aproximadamente de 7 días. Este factor puede variar dependiendo de la cantidad de TPs entregados en ese momento. Por lo cual, se recomienda tenerlo en cuenta para la fecha final de entrega del trabajo.

- Si llegaran a realizar una sola entrega del TP, cercana a la última fecha (menor a 7 días), es netamente responsabilidad del grupo y solo contarán con esa entrega habiendo perdido las oportunidades anteriormente descritas, es decir, única entrega sin posibilidad de re entrega.

- Cualquier indicio de copia (similitudes de edición, bloques de código, mismas descripciones, comentarios, etc.) será penado con la pérdida de la materia, aun así, tengan los parciales aprobados. Se supone que el TP tiene carácter de parcial y es una producción propia del grupo.

## Fecha Final

La última fecha para recepción de TP es el día 14/12/2026

## Formato de entrega

## Lugar de envío

La entrega debe realizarse por mail antes de las fechas estipuladas en el documento de enunciado.

La dirección del mail es:

[gestiondedatos.entregas@gmail.com](mailto:gestiondedatos.entregas@gmail.com)

## Asunto

El asunto del mail debe cumplir con el siguiente formato:

TP2C2026<b><curso><b><nombreGrupo><br><Nro de grupo>

<b>: espacio en blanco

Ejemplos: TP2C2026 k9999 LOS_MEJORES 10

(Respetar los espacios en blanco existentes)


## Cuerpo del Mail

El cuerpo del mail debe contener lo siguiente:

Grupo: Curso: Integrantes: <apellido>, <nombres> - <legajo>

Nota: En caso de que haya integrantes de cursos distintos, se debe poner el curso de la persona elegida como representante.

En caso de que algún alumno del grupo haya dejado de cursar o se haya cambiado de grupo, deberá ser aclarado en el mail de la entrega del TP.

Solo debe enviarse la entrega desde el mail del representante del grupo.

Los alumnos deberán registrar su grupo en la dirección mencionada anteriormente. No se aceptarán TPs de grupos que no estén registrados.

## Adjunto

Se debe adjuntar el trabajo práctico en un archivo del tipo zip con el mismo nombre que el asunto del mail.

Por cuestiones de seguridad Gmail rechaza todos los adjuntos que contengan archivos zip con .exe y .dll en su interior, por lo que es necesario renombrar la extensión .zip a .zip123.

Por ejemplo:

TP1C2026 k9999 LOS_MEJORES 10.zip123

(Respetar los espacios en blanco existentes)

No enviar adjuntos de más de 20 MB. La casilla de mail rechazará mails que superen esta restricción.


## Estructura del archivo zip

El archivo zip (.zip123) debe contener la siguiente estructura de directorios:

\

- Readme.txt

- Estrategia.pdf

- DER.jpg

- DER_BI.jpg

- \data

- (1) Archivo de script de base de datos “script_creación_inicial.sql”.

- (2) Archivo de script de base de datos “script_creación_BI.sql”.

## Readme.txt

Es un archivo de texto plano con los siguientes datos:

- Curso

- Número de grupo

- Nombre y legajo de todos los integrantes

- Email del integrante responsable del grupo.

## Estrategia.pdf

Archivo PDF en donde se deberá explicar en forma detallada la estrategia utilizada para desarrollar el TP. Debe incluir una explicación y/o justificación de las estructuras utilizadas, junto con todas las decisiones que fueron tomadas por el grupo a fin de dar cumplimiento al Trabajo Práctico.

Cualquier consideración tomada o asumida deberá ser aclarada en este documento.

Se debe incluir el DER (legible y entendible) tanto del modelo de datos RELACIONAL como el de BI detallando cada entidad, relaciones, claves primarias y foráneas, índices, stored procedures, triggers, vistas, etc, que será estrictamente necesario para la corrección del modelo.

El archivo de estrategia deberá entregarse en formato PDF obligatoriamente, con carátula e índice. En caso de no cumplir esta condición, el TP será rechazado sin evaluar su funcionalidad.

Sin este archivo la entrega no será tomada como válida.


## DER.jpg

Se debe entregar también el DER del modelo Relacional en formato de imagen (PNG, JPEG, etc.)

Sin este archivo la entrega no será tomada como válida.

## DER_BI.jpg

Se debe entregar también el DER del modelo de BI en formato de imagen (PNG, JPEG, etc.)

Sin este archivo la entrega no será tomada como válida.

## \ data

- Archivo “script_creación_inicial.sql” con toda la creación del modelo de datos y la migración. El archivo debe poder ejecutar perfectamente de una sola vez, sin ningún tipo de error. Todas las sentencias deben estar perfectamente ordenadas para ejecutar correctamente. Cada sentencia debe estar comentada explicando su intención.

- Archivo “script_creación_BI.sql” con toda la creación del modelo de inteligencia de negocios y su respectiva carga de datos. El archivo se debe poder ejecutar perfectamente de una sola vez, sin ningún tipo de error. Todas las sentencias deben estar perfectamente ordenadas para ejecutar correctamente. Cada sentencia debe estar comentada explicando su intención.

## Consideración

Cualquier TP entregado que no cumpla con alguno de los requisitos mencionados en este documento, será rechazado sin ser evaluado, perdiendo una oportunidad de entrega.


## Ayuda y contacto

El sitio oficial de la materia es el siguiente:

https://sites.google.com/site/gestiondedatosutn

También existe un grupo de Google en donde se podrán plantear dudas sobre el TP. Su dirección es la siguiente: http://groups.google.com/group/gestiondedatos [URL 🔗](http://groups.google.com/group/gestiondedatos)

Todos los mensajes referentes al trabajo práctico deberán contener la etiqueta [TP] antes del asunto. Ej: “[TP] consulta sobre base de datos”.

Es obligación del alumno revisar el grupo periódicamente y mantenerse informado sobre actualizaciones, cambios de consignas, cambios de fecha, etc. La cátedra no asigna ayudantes específicos a cada grupo. Todas las consultas deberán hacerse a través del grupo de Google. El grupo OFICIAL es el único medio de comunicación con los alumnos sobre cuestiones del trabajo práctico. La cátedra no se hará responsable por grupos paralelos que no sean el detallado en el presente enunciado. Cualquier tipo de información sobre el trabajo práctico que haya sido brindada por los docentes, tendrá que ser validada con los ayudantes ya sea el Ing. López Matias Miguel o el Ing. Ariosti Maximiliano.

A lo largo de la cursada pueden ir surgiendo dudas particulares sobre el Trabajo Práctico que sean útiles para el resto de los alumnos. Para ello la cátedra cuenta con un documento denominado “Apéndice del Enunciado” en el cuál se agregan consideraciones generales de manera online. Su dirección es la siguiente:

https://docs.google.com/document/d/1dvYVOJqiz1u7ZvMwgMZvn0x vtW1Yps_A4dLXY4mAIu8/edit?usp=sharing [URL 🔗](https://docs.google.com/document/d/1dvYVOJqiz1u7ZvMwgMZvn0xvtW1Yps_A4dLXY4mAIu8/edit?usp=sharing)

Inicialmente el Apéndice se encuentra vacío. A medida que vayan surgiendo dudas sobre el desarrollo del Trabajo Práctico, la cátedra evaluará agregar consideraciones generales al documento. Es obligación del alumno revisar este documento periódicamente.


## Obtención de herramientas

El motor de base de datos a utilizar es SQL Server 2022 Express. Puede ser descargado de la siguiente dirección:

https://www.microsoft.com/es-ar/sql-server/sql-server-2022

Es necesario descargar e instalar dos componentes:

- Instalar Microsoft SQL Server 2022 Express Edition

- SQL Server Management Studio (SSMS)
