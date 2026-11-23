/*
====================================================================================================
  PROYECTO DE CÁTEDRA: SISTEMA DE AGENDA TELEFÓNICA PROFESIONAL
  ASIGNATURA: PROGRAMACIÓN I / BASE DE DATOS - CICLO ACADÉMICO 2026
  COMPATIBILIDAD: MICROSOFT SQL SERVER 2019 / 2022 / 2026 / AZURE SQL / LOCALDB
  VISUAL STUDIO: VISUAL STUDIO 2026 / VISUAL STUDIO 2022 (.NET 10.0 / .NET 8.0)
  
  INTEGRANTES / AUTORES:
    • Elías Caleb Rivera Herrera
    • Josué David Flores Martínez
====================================================================================================

════════════════════════════════════════════════════════════════════════════════════════════════════
  SECCIÓN 1: CUADROS Y DIAGRAMAS DEL SISTEMA (ARQUITECTURA Y MODELO DE DATOS)
════════════════════════════════════════════════════════════════════════════════════════════════════

┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│                             DIAGRAMA 1: MODELO CONCEPTUAL Y ENTIDAD-RELACIÓN (DER)               │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘

   ┌────────────────────────────────┐                 ┌────────────────────────────────┐
   │          CATEGORIAS            │                 │           CONTACTOS            │
   ├────────────────────────────────┤                 ├────────────────────────────────┤
   │ PK │ Id             (INT)      │ 1             N │ PK │ Id                 (INT)      │
   │    │ Nombre         (NVARCHAR) │─────────────────┼───<│ Nombre             (NVARCHAR) │
   │    │ Descripcion    (NVARCHAR) │                 │    │ Apellido           (NVARCHAR) │
   │    │ FechaCreacion  (DATETIME) │                 │    │ TelefonoPrincipal  (NVARCHAR) │
   └────────────────────────────────┘                 │    │ TelefonoSecundario (NVARCHAR) │
                                                      │    │ Email              (NVARCHAR) │
                                                      │    │ Direccion          (NVARCHAR) │
                                                      │ FK │ CategoriaId        (INT)      │
                                                      │    │ Favorito           (BIT)      │
                                                      │    │ Activo             (BIT)      │
                                                      │    │ FechaRegistro      (DATETIME) │
                                                      │    │ FechaModificacion  (DATETIME) │
                                                      └────────────────┬───────────────┘
                                                                       │ 1
                                                                       │
                                                                       │ posee teléfonos
                                                                       ▼ N
                                                      ┌────────────────────────────────┐
                                                      │           TELEFONOS            │
                                                      ├────────────────────────────────┤
                                                      │ PK │ Id                 (INT)      │
                                                      │ FK │ ContactoId         (INT)      │
                                                      │    │ Numero             (NVARCHAR) │
                                                      │    │ TipoTelefono       (NVARCHAR) │
                                                      │    │ EsPrincipal        (BIT)      │
                                                      └────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│                             DIAGRAMA 2: ARQUITECTURA DE TRES CAPAS (3-TIER ARCHITECTURE)         │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘

   ┌────────────────────────────────────────────────────────────────────────────────────────────┐
   │ CAPA DE PRESENTACIÓN (FRONT-END / UI - WINDOWS FORMS .NET 10 / 8)                          │
   │   • FormPrincipal.cs  (CRUD Visual, Búsquedas reactivas, DataGridView, Filtros interactivos)│
   │   • FormAutores.cs    (Créditos de cátedra, equipo de desarrollo y versión)               │
   └──────────────────────────────────────────────▲─────────────────────────────────────────────┘
                                                  │ Llamadas a métodos y retorno de modelos DTO
                                                  ▼
   ┌────────────────────────────────────────────────────────────────────────────────────────────┐
   │ CAPA DE LÓGICA DE NEGOCIO (BLL - BUSINESS LOGIC LAYER)                                     │
   │   • ContactoService.cs (Validaciones de formato de teléfono [8-15 dígitos], RegEx Email,   │
   │                         Reglas de negocio, Control de duplicados, Normalización de textos) │
   └──────────────────────────────────────────────▲─────────────────────────────────────────────┘
                                                  │ Transferencia de Entidades (Contacto, Categoria)
                                                  ▼
   ┌────────────────────────────────────────────────────────────────────────────────────────────┐
   │ CAPA DE ACCESO A DATOS (DAL - DATA ACCESS LAYER)                                           │
   │   • Conexion.cs           (Lectura segura de appsettings.json, Fallback a SQLEXPRESS)     │
   │   • ContactoRepository.cs (Mapeo ADO.NET optimizado, Ejecución transaccional y Stored Proc)│
   │   • CategoriaRepository.cs(Carga de catálogo para ComboBox y filtros)                      │
   └──────────────────────────────────────────────▲─────────────────────────────────────────────┘
                                                  │ Conexión ADO.NET (Microsoft.Data.SqlClient)
                                                  ▼
   ┌────────────────────────────────────────────────────────────────────────────────────────────┐
   │ MOTOR DE BASE DE DATOS (SQL SERVER 2026 / 2022 / 2019 / EXPRESS / LOCALDB)                 │
   │   • Tablas Normalizadas: Categorias, Contactos, Telefonos, AuditoriaContactos              │
   │   • Integridad: PK, FK con ON DELETE NO ACTION / CASCADE, Índices Filtrados Únicos         │
   │   • Seguridad y Automatización: Procedimientos Almacenados, Vistas y Triggers de Auditoría │
   └────────────────────────────────────────────────────────────────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│                             CUADRO 1: DICCIONARIO DE DATOS - TABLA "CATEGORIAS"                  │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
┌────────────────┬──────────────┬──────────┬──────────┬─────────────┬───────────┬──────────────────────┐
│ Campo          │ Tipo de Dato │ Longitud │ Nulo     │ Clave       │ Default   │ Descripción          │
├────────────────┼──────────────┼──────────┼──────────┼─────────────┼───────────┼──────────────────────┤
│ Id             │ INT          │ 4 bytes  │ NO       │ PK IDENTITY │ (1,1)     │ Identificador único  │
│ Nombre         │ NVARCHAR     │ 50       │ NO       │ UNIQUE      │ Ninguno   │ Nombre de categoría  │
│ Descripcion    │ NVARCHAR     │ 200      │ SI       │ Ninguna     │ NULL      │ Detalle explicativo  │
│ FechaCreacion  │ DATETIME     │ 8 bytes  │ NO       │ Ninguna     │ GETDATE() │ Fecha de registro    │
└────────────────┴──────────────┴──────────┴──────────┴─────────────┴───────────┴──────────────────────┘

┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│                             CUADRO 2: DICCIONARIO DE DATOS - TABLA "CONTACTOS"                   │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
┌────────────────────┬──────────────┬──────────┬──────────┬─────────────┬───────────┬──────────────────┐
│ Campo              │ Tipo de Dato │ Longitud │ Nulo     │ Clave       │ Default   │ Descripción      │
├────────────────────┼──────────────┼──────────┼──────────┼─────────────┼───────────┼──────────────────┤
│ Id                 │ INT          │ 4 bytes  │ NO       │ PK IDENTITY │ (1,1)     │ Identificador    │
│ Nombre             │ NVARCHAR     │ 60       │ NO       │ Ninguna     │ Ninguno   │ Nombres contacto │
│ Apellido           │ NVARCHAR     │ 60       │ NO       │ Ninguna     │ Ninguno   │ Apellidos        │
│ TelefonoPrincipal  │ NVARCHAR     │ 20       │ NO       │ IX UNIQUE*  │ Ninguno   │ Teléfono móvil/ppal│
│ TelefonoSecundario │ NVARCHAR     │ 20       │ SI       │ Ninguna     │ NULL      │ Teléfono aux/fijo│
│ Email              │ NVARCHAR     │ 100      │ SI       │ IX UNIQUE*  │ NULL      │ Correo personal  │
│ Direccion          │ NVARCHAR     │ 200      │ SI       │ Ninguna     │ NULL      │ Dirección física │
│ CategoriaId        │ INT          │ 4 bytes  │ NO       │ FK          │ Ninguno   │ Ref Categorias   │
│ Favorito           │ BIT          │ 1 byte   │ NO       │ Ninguna     │ 0         │ 1=Fav, 0=Normal  │
│ Activo             │ BIT          │ 1 byte   │ NO       │ Ninguna     │ 1         │ 1=Activo,0=Baja  │
│ FechaRegistro      │ DATETIME     │ 8 bytes  │ NO       │ Ninguna     │ GETDATE() │ Fecha de ingreso │
│ FechaModificacion  │ DATETIME     │ 8 bytes  │ SI       │ Ninguna     │ NULL      │ Última edición   │
└────────────────────┴──────────────┴──────────┴──────────┴─────────────┴───────────┴──────────────────┘
* Nota: Los índices únicos de Teléfono y Email son filtrados (WHERE Activo = 1) para permitir reingreso si se elimina.

┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│                             CUADRO 3: DICCIONARIO DE DATOS - TABLA "TELEFONOS"                   │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
┌────────────────┬──────────────┬──────────┬──────────┬─────────────┬───────────┬──────────────────────┐
│ Campo          │ Tipo de Dato │ Longitud │ Nulo     │ Clave       │ Default   │ Descripción          │
├────────────────┼──────────────┼──────────┼──────────┼─────────────┼───────────┼──────────────────────┤
│ Id             │ INT          │ 4 bytes  │ NO       │ PK IDENTITY │ (1,1)     │ Clave primaria       │
│ ContactoId     │ INT          │ 4 bytes  │ NO       │ FK CASCADE  │ Ninguno   │ Ref a Contactos(Id)  │
│ Numero         │ NVARCHAR     │ 20       │ NO       │ Ninguna     │ Ninguno   │ Número telefónico    │
│ TipoTelefono   │ NVARCHAR     │ 20       │ NO       │ CHECK       │ 'Móvil'   │ Móvil, Casa, Trabajo │
│ EsPrincipal    │ BIT          │ 1 byte   │ NO       │ Ninguna     │ 0         │ Indicador principal  │
└────────────────┴──────────────┴──────────┴──────────┴─────────────┴───────────┴──────────────────────┘

┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│                             CUADRO 4: PROCEDIMIENTOS ALMACENADOS IMPLEMENTADOS                   │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
┌───────────────────────────────┬────────────────────────────────────┬─────────────────────────────────┐
│ Procedimiento Almacenado      │ Parámetros Principales             │ Descripción / Propósito         │
├───────────────────────────────┼────────────────────────────────────┼─────────────────────────────────┤
│ sp_Categorias_Listar          │ Ninguno                            │ Lista catálogo ordenado por nom │
│ sp_Contactos_Listar           │ @CategoriaId (0 = todas)           │ Retorna contactos activos       │
│ sp_Contactos_Buscar           │ @Texto, @CategoriaId               │ Búsqueda global (nom, ape, tel) │
│ sp_Contactos_ObtenerPorId     │ @Id                                │ Obtiene ficha completa contacto │
│ sp_Contactos_Insertar         │ Datos del contacto, @NuevoId OUT   │ Inserta contacto y sync teléf.  │
│ sp_Contactos_Modificar        │ @Id, Datos actualizados            │ Actualiza datos y auditoría     │
│ sp_Contactos_EliminarLogico   │ @Id                                │ Borrado lógico (Activo = 0)     │
│ sp_Contactos_Reactivar        │ @Id                                │ Restaura contacto eliminado     │
│ sp_EstadisticasAgenda         │ Ninguno                            │ Totales, promedios y categorías │
└───────────────────────────────┴────────────────────────────────────┴─────────────────────────────────┘

┌──────────────────────────────────────────────────────────────────────────────────────────────────┐
│                             DIAGRAMA 3: DEFINICIÓN MERMAID (RENDERIZABLE)                        │
└──────────────────────────────────────────────────────────────────────────────────────────────────┘
```mermaid
erDiagram
    CATEGORIAS ||--o{ CONTACTOS : "clasifica (1:N)"
    CONTACTOS ||--o{ TELEFONOS : "posee (1:N)"
    CONTACTOS ||--o{ AUDITORIA_CONTACTOS : "audita (1:N)"

    CATEGORIAS {
        int Id PK
        string Nombre
        string Descripcion
        datetime FechaCreacion
    }

    CONTACTOS {
        int Id PK
        string Nombre
        string Apellido
        string TelefonoPrincipal
        string TelefonoSecundario
        string Email
        string Direccion
        int CategoriaId FK
        bit Favorito
        bit Activo
        datetime FechaRegistro
        datetime FechaModificacion
    }

    TELEFONOS {
        int Id PK
        int ContactoId FK
        string Numero
        string TipoTelefono
        bit EsPrincipal
    }

    AUDITORIA_CONTACTOS {
        int Id PK
        int ContactoId
        string Accion
        string Detalle
        datetime FechaAccion
        string Usuario
    }
```
*/

-- =================================================================================================
--   SECCIÓN 2: CREACIÓN DE LA BASE DE DATOS Y CONFIGURACIÓN INICIAL
-- =================================================================================================

USE master;
GO

-- Crear base de datos si no existe con intercalación insensible a mayúsculas/minúsculas y acentos
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'AgendaTelefonica')
BEGIN
    PRINT 'Creando la base de datos AgendaTelefonica...';
    CREATE DATABASE AgendaTelefonica
    COLLATE Modern_Spanish_CI_AS;
END
ELSE
BEGIN
    PRINT 'La base de datos AgendaTelefonica ya existe.';
END
GO

USE AgendaTelefonica;
GO

-- =================================================================================================
--   SECCIÓN 3: ELIMINACIÓN PREVIA DE OBJETOS (LIMPIEZA ORDENADA PARA REINSTALACIÓN)
-- =================================================================================================

-- Desactivar y eliminar triggers si existen
IF OBJECT_ID('dbo.trg_Contactos_Auditoria', 'TR') IS NOT NULL DROP TRIGGER dbo.trg_Contactos_Auditoria;
IF OBJECT_ID('dbo.trg_Sync_Telefonos', 'TR') IS NOT NULL DROP TRIGGER dbo.trg_Sync_Telefonos;
GO

-- Eliminar Procedimientos Almacenados si existen
IF OBJECT_ID('dbo.sp_EstadisticasAgenda', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_EstadisticasAgenda;
IF OBJECT_ID('dbo.sp_Contactos_Reactivar', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_Contactos_Reactivar;
IF OBJECT_ID('dbo.sp_Contactos_EliminarLogico', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_Contactos_EliminarLogico;
IF OBJECT_ID('dbo.sp_Contactos_Modificar', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_Contactos_Modificar;
IF OBJECT_ID('dbo.sp_Contactos_Insertar', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_Contactos_Insertar;
IF OBJECT_ID('dbo.sp_Contactos_ObtenerPorId', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_Contactos_ObtenerPorId;
IF OBJECT_ID('dbo.sp_Contactos_Buscar', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_Contactos_Buscar;
IF OBJECT_ID('dbo.sp_Contactos_Listar', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_Contactos_Listar;
IF OBJECT_ID('dbo.sp_Categorias_Listar', 'P') IS NOT NULL DROP PROCEDURE dbo.sp_Categorias_Listar;
GO

-- Eliminar Vistas si existen
IF OBJECT_ID('dbo.vw_EstadisticasPorCategoria', 'V') IS NOT NULL DROP VIEW dbo.vw_EstadisticasPorCategoria;
IF OBJECT_ID('dbo.vw_AgendaCompleta', 'V') IS NOT NULL DROP VIEW dbo.vw_AgendaCompleta;
GO

-- Eliminar Tablas respetando integridad referencial
IF OBJECT_ID('dbo.AuditoriaContactos', 'U') IS NOT NULL DROP TABLE dbo.AuditoriaContactos;
IF OBJECT_ID('dbo.Telefonos', 'U') IS NOT NULL DROP TABLE dbo.Telefonos;
IF OBJECT_ID('dbo.Contactos', 'U') IS NOT NULL DROP TABLE dbo.Contactos;
IF OBJECT_ID('dbo.Categorias', 'U') IS NOT NULL DROP TABLE dbo.Categorias;
GO

-- =================================================================================================
--   SECCIÓN 4: CREACIÓN DE TABLAS NORMALIZADAS Y RESTRICCIONES
-- =================================================================================================

PRINT 'Creando tabla Categorias...';
CREATE TABLE dbo.Categorias (
    Id INT IDENTITY(1,1) NOT NULL,
    Nombre NVARCHAR(50) NOT NULL,
    Descripcion NVARCHAR(200) NULL,
    FechaCreacion DATETIME NOT NULL CONSTRAINT DF_Categorias_FechaCreacion DEFAULT GETDATE(),
    CONSTRAINT PK_Categorias PRIMARY KEY CLUSTERED (Id ASC),
    CONSTRAINT UQ_Categorias_Nombre UNIQUE NONCLUSTERED (Nombre ASC)
);
GO

PRINT 'Creando tabla Contactos...';
CREATE TABLE dbo.Contactos (
    Id INT IDENTITY(1,1) NOT NULL,
    Nombre NVARCHAR(60) NOT NULL,
    Apellido NVARCHAR(60) NOT NULL,
    TelefonoPrincipal NVARCHAR(20) NOT NULL,
    TelefonoSecundario NVARCHAR(20) NULL,
    Email NVARCHAR(100) NULL,
    Direccion NVARCHAR(200) NULL,
    CategoriaId INT NOT NULL,
    Favorito BIT NOT NULL CONSTRAINT DF_Contactos_Favorito DEFAULT (0),
    Activo BIT NOT NULL CONSTRAINT DF_Contactos_Activo DEFAULT (1),
    FechaRegistro DATETIME NOT NULL CONSTRAINT DF_Contactos_FechaRegistro DEFAULT GETDATE(),
    FechaModificacion DATETIME NULL,
    CONSTRAINT PK_Contactos PRIMARY KEY CLUSTERED (Id ASC),
    CONSTRAINT FK_Contactos_Categorias FOREIGN KEY (CategoriaId)
        REFERENCES dbo.Categorias(Id)
        ON UPDATE CASCADE
        ON DELETE NO ACTION,
    CONSTRAINT CK_Contactos_Nombre_NoVacio CHECK (LEN(LTRIM(RTRIM(Nombre))) > 0),
    CONSTRAINT CK_Contactos_Apellido_NoVacio CHECK (LEN(LTRIM(RTRIM(Apellido))) > 0),
    CONSTRAINT CK_Contactos_TelPrincipal_NoVacio CHECK (LEN(LTRIM(RTRIM(TelefonoPrincipal))) >= 7)
);
GO

PRINT 'Creando tabla Telefonos...';
CREATE TABLE dbo.Telefonos (
    Id INT IDENTITY(1,1) NOT NULL,
    ContactoId INT NOT NULL,
    Numero NVARCHAR(20) NOT NULL,
    TipoTelefono NVARCHAR(20) NOT NULL CONSTRAINT DF_Telefonos_Tipo DEFAULT ('Móvil'),
    EsPrincipal BIT NOT NULL CONSTRAINT DF_Telefonos_EsPrincipal DEFAULT (0),
    CONSTRAINT PK_Telefonos PRIMARY KEY CLUSTERED (Id ASC),
    CONSTRAINT FK_Telefonos_Contactos FOREIGN KEY (ContactoId)
        REFERENCES dbo.Contactos(Id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    CONSTRAINT CK_Telefonos_Tipo CHECK (TipoTelefono IN ('Móvil', 'Casa', 'Trabajo', 'WhatsApp', 'Fax', 'Otro'))
);
GO

PRINT 'Creando tabla AuditoriaContactos...';
CREATE TABLE dbo.AuditoriaContactos (
    Id INT IDENTITY(1,1) NOT NULL,
    ContactoId INT NOT NULL,
    Accion NVARCHAR(20) NOT NULL,
    Detalle NVARCHAR(500) NOT NULL,
    FechaAccion DATETIME NOT NULL CONSTRAINT DF_Auditoria_Fecha DEFAULT GETDATE(),
    Usuario NVARCHAR(100) NOT NULL CONSTRAINT DF_Auditoria_Usuario DEFAULT SUSER_SNAME(),
    CONSTRAINT PK_AuditoriaContactos PRIMARY KEY CLUSTERED (Id ASC)
);
GO

-- =================================================================================================
--   SECCIÓN 5: ÍNDICES OPTIMIZADOS PARA RENDIMIENTO
-- =================================================================================================

-- 1. Índice para búsqueda y ordenamiento rápido por Apellido y Nombre
CREATE NONCLUSTERED INDEX IX_Contactos_Listado
ON dbo.Contactos (Activo ASC, Apellido ASC, Nombre ASC)
INCLUDE (Id, TelefonoPrincipal, TelefonoSecundario, Email, Direccion, CategoriaId, Favorito);
GO

-- 2. Índice por CategoriaId para optimizar filtrado en combo
CREATE NONCLUSTERED INDEX IX_Contactos_CategoriaId
ON dbo.Contactos (CategoriaId ASC, Activo ASC)
INCLUDE (Id, Nombre, Apellido, TelefonoPrincipal);
GO

-- 3. Índice Único Filtrado: Evita duplicados en Teléfono Principal sólo entre contactos activos
CREATE UNIQUE NONCLUSTERED INDEX UQ_Contactos_TelefonoPrincipal_Activo
ON dbo.Contactos (TelefonoPrincipal ASC)
WHERE Activo = 1;
GO

-- 4. Índice Único Filtrado: Evita correos duplicados entre contactos activos (ignora nulos)
CREATE UNIQUE NONCLUSTERED INDEX UQ_Contactos_Email_Activo
ON dbo.Contactos (Email ASC)
WHERE Activo = 1 AND Email IS NOT NULL AND Email <> '';
GO

-- 5. Índice para teléfonos por contacto
CREATE NONCLUSTERED INDEX IX_Telefonos_ContactoId
ON dbo.Telefonos (ContactoId ASC);
GO

-- =================================================================================================
--   SECCIÓN 6: TRIGGERS (AUDITORÍA AUTOMÁTICA Y SINCRONIZACIÓN)
-- =================================================================================================

PRINT 'Creando triggers de auditoría y sincronización...';
GO

-- Trigger 1: Registra modificaciones y bajas lógicas en AuditoriaContactos
CREATE TRIGGER dbo.trg_Contactos_Auditoria
ON dbo.Contactos
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Si se modificó la columna Activo a 0 (Eliminación lógica)
    IF UPDATE(Activo)
    BEGIN
        INSERT INTO dbo.AuditoriaContactos (ContactoId, Accion, Detalle)
        SELECT i.Id, 'ELIMINACION_LOGICA',
               CONCAT('Contacto dado de baja lógica: ', i.Nombre, ' ', i.Apellido, ' (Tel: ', i.TelefonoPrincipal, ')')
        FROM inserted i
        INNER JOIN deleted d ON d.Id = i.Id
        WHERE d.Activo = 1 AND i.Activo = 0;

        INSERT INTO dbo.AuditoriaContactos (ContactoId, Accion, Detalle)
        SELECT i.Id, 'REACTIVACION',
               CONCAT('Contacto reactivado: ', i.Nombre, ' ', i.Apellido)
        FROM inserted i
        INNER JOIN deleted d ON d.Id = i.Id
        WHERE d.Activo = 0 AND i.Activo = 1;
    END

    -- Modificación de datos generales
    IF UPDATE(Nombre) OR UPDATE(Apellido) OR UPDATE(TelefonoPrincipal) OR UPDATE(TelefonoSecundario) OR UPDATE(Email) OR UPDATE(CategoriaId)
    BEGIN
        INSERT INTO dbo.AuditoriaContactos (ContactoId, Accion, Detalle)
        SELECT i.Id, 'ACTUALIZACION',
               CONCAT('Modificación de datos del contacto: ', i.Nombre, ' ', i.Apellido, ' | CategoriaId: ', i.CategoriaId)
        FROM inserted i
        INNER JOIN deleted d ON d.Id = i.Id
        WHERE i.Activo = 1;
    END
END;
GO

-- Trigger 2: Mantiene sincronizada la tabla Telefonos con el Contacto
CREATE TRIGGER dbo.trg_Sync_Telefonos
ON dbo.Contactos
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Sincronizar inserción de teléfono principal
    MERGE dbo.Telefonos AS TARGET
    USING (
        SELECT Id AS ContactoId, TelefonoPrincipal, 1 AS EsPrincipal, 'Móvil' AS Tipo
        FROM inserted
        WHERE TelefonoPrincipal IS NOT NULL AND LTRIM(RTRIM(TelefonoPrincipal)) <> ''
    ) AS SOURCE
    ON (TARGET.ContactoId = SOURCE.ContactoId AND TARGET.EsPrincipal = 1)
    WHEN MATCHED THEN
        UPDATE SET TARGET.Numero = SOURCE.TelefonoPrincipal
    WHEN NOT MATCHED THEN
        INSERT (ContactoId, Numero, TipoTelefono, EsPrincipal)
        VALUES (SOURCE.ContactoId, SOURCE.TelefonoPrincipal, SOURCE.Tipo, SOURCE.EsPrincipal);

    -- Sincronizar teléfono secundario si existe
    MERGE dbo.Telefonos AS TARGET2
    USING (
        SELECT Id AS ContactoId, TelefonoSecundario, 0 AS EsPrincipal, 'Casa' AS Tipo
        FROM inserted
        WHERE TelefonoSecundario IS NOT NULL AND LTRIM(RTRIM(TelefonoSecundario)) <> ''
    ) AS SOURCE2
    ON (TARGET2.ContactoId = SOURCE2.ContactoId AND TARGET2.EsPrincipal = 0 AND TARGET2.TipoTelefono = 'Casa')
    WHEN MATCHED THEN
        UPDATE SET TARGET2.Numero = SOURCE2.TelefonoSecundario
    WHEN NOT MATCHED THEN
        INSERT (ContactoId, Numero, TipoTelefono, EsPrincipal)
        VALUES (SOURCE2.ContactoId, SOURCE2.TelefonoSecundario, SOURCE2.Tipo, SOURCE2.EsPrincipal);
END;
GO

-- =================================================================================================
--   SECCIÓN 7: VISTAS DEL SISTEMA
-- =================================================================================================

PRINT 'Creando vistas del sistema...';
GO

-- Vista 1: Vista enriquecida para visualización en Reportes y DataGridView
CREATE VIEW dbo.vw_AgendaCompleta
AS
SELECT 
    c.Id,
    c.Nombre,
    c.Apellido,
    CONCAT(c.Apellido, ', ', c.Nombre) AS NombreCompleto,
    c.TelefonoPrincipal,
    ISNULL(c.TelefonoSecundario, 'N/A') AS TelefonoSecundario,
    ISNULL(c.Email, 'Sin correo') AS Email,
    ISNULL(c.Direccion, 'Sin dirección') AS Direccion,
    c.CategoriaId,
    k.Nombre AS Categoria,
    c.Favorito,
    c.Activo,
    c.FechaRegistro,
    c.FechaModificacion
FROM dbo.Contactos c
INNER JOIN dbo.Categorias k ON k.Id = c.CategoriaId
WHERE c.Activo = 1;
GO

-- Vista 2: Estadísticas consolidadas por categoría
CREATE VIEW dbo.vw_EstadisticasPorCategoria
AS
SELECT 
    k.Id AS CategoriaId,
    k.Nombre AS Categoria,
    COUNT(c.Id) AS TotalContactos,
    SUM(CASE WHEN c.Favorito = 1 THEN 1 ELSE 0 END) AS TotalFavoritos,
    SUM(CASE WHEN c.Email IS NOT NULL AND c.Email <> '' THEN 1 ELSE 0 END) AS ConEmail,
    SUM(CASE WHEN c.TelefonoSecundario IS NOT NULL AND c.TelefonoSecundario <> '' THEN 1 ELSE 0 END) AS ConTelSecundario
FROM dbo.Categorias k
LEFT JOIN dbo.Contactos c ON c.CategoriaId = k.Id AND c.Activo = 1
GROUP BY k.Id, k.Nombre;
GO

-- =================================================================================================
--   SECCIÓN 8: PROCEDIMIENTOS ALMACENADOS (CRUD PROFESIONAL)
-- =================================================================================================

PRINT 'Creando procedimientos almacenados...';
GO

-- 1. Listar Categorías
CREATE PROCEDURE dbo.sp_Categorias_Listar
AS
BEGIN
    SET NOCOUNT ON;
    SELECT Id, Nombre, ISNULL(Descripcion, '') AS Descripcion, FechaCreacion
    FROM dbo.Categorias
    ORDER BY Nombre ASC;
END;
GO

-- 2. Listar Contactos con Filtro Opcional de Categoría
CREATE PROCEDURE dbo.sp_Contactos_Listar
    @CategoriaId INT = 0
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        c.Id,
        c.Nombre,
        c.Apellido,
        c.TelefonoPrincipal,
        c.TelefonoSecundario,
        c.Email,
        c.Direccion,
        c.CategoriaId,
        k.Nombre AS Categoria,
        c.Favorito
    FROM dbo.Contactos c
    INNER JOIN dbo.Categorias k ON k.Id = c.CategoriaId
    WHERE c.Activo = 1
      AND (@CategoriaId = 0 OR c.CategoriaId = @CategoriaId)
    ORDER BY c.Apellido ASC, c.Nombre ASC;
END;
GO

-- 3. Búsqueda Global de Contactos (Nombre, Apellido, Teléfonos, Correo)
CREATE PROCEDURE dbo.sp_Contactos_Buscar
    @Texto NVARCHAR(100),
    @CategoriaId INT = 0
AS
BEGIN
    SET NOCOUNT ON;

    SET @Texto = LTRIM(RTRIM(ISNULL(@Texto, '')));
    DECLARE @Filtro NVARCHAR(102) = '%' + @Texto + '%';

    SELECT 
        c.Id,
        c.Nombre,
        c.Apellido,
        c.TelefonoPrincipal,
        c.TelefonoSecundario,
        c.Email,
        c.Direccion,
        c.CategoriaId,
        k.Nombre AS Categoria,
        c.Favorito
    FROM dbo.Contactos c
    INNER JOIN dbo.Categorias k ON k.Id = c.CategoriaId
    WHERE c.Activo = 1
      AND (@CategoriaId = 0 OR c.CategoriaId = @CategoriaId)
      AND (
          @Texto = '' OR
          c.Nombre LIKE @Filtro OR
          c.Apellido LIKE @Filtro OR
          c.TelefonoPrincipal LIKE @Filtro OR
          c.TelefonoSecundario LIKE @Filtro OR
          c.Email LIKE @Filtro OR
          c.Direccion LIKE @Filtro
      )
    ORDER BY c.Apellido ASC, c.Nombre ASC;
END;
GO

-- 4. Obtener Contacto por ID
CREATE PROCEDURE dbo.sp_Contactos_ObtenerPorId
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        c.Id,
        c.Nombre,
        c.Apellido,
        c.TelefonoPrincipal,
        c.TelefonoSecundario,
        c.Email,
        c.Direccion,
        c.CategoriaId,
        k.Nombre AS Categoria,
        c.Favorito,
        c.Activo,
        c.FechaRegistro,
        c.FechaModificacion
    FROM dbo.Contactos c
    INNER JOIN dbo.Categorias k ON k.Id = c.CategoriaId
    WHERE c.Id = @Id;
END;
GO

-- 5. Insertar Contacto con Validación y Retorno de ID
CREATE PROCEDURE dbo.sp_Contactos_Insertar
    @Nombre NVARCHAR(60),
    @Apellido NVARCHAR(60),
    @TelefonoPrincipal NVARCHAR(20),
    @TelefonoSecundario NVARCHAR(20) = NULL,
    @Email NVARCHAR(100) = NULL,
    @Direccion NVARCHAR(200) = NULL,
    @CategoriaId INT,
    @Favorito BIT = 0,
    @NuevoId INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        -- Limpieza de cadenas
        SET @Nombre = LTRIM(RTRIM(@Nombre));
        SET @Apellido = LTRIM(RTRIM(@Apellido));
        SET @TelefonoPrincipal = LTRIM(RTRIM(@TelefonoPrincipal));
        SET @TelefonoSecundario = NULLIF(LTRIM(RTRIM(@TelefonoSecundario)), '');
        SET @Email = NULLIF(LTRIM(RTRIM(@Email)), '');
        SET @Direccion = NULLIF(LTRIM(RTRIM(@Direccion)), '');

        INSERT INTO dbo.Contactos (
            Nombre, Apellido, TelefonoPrincipal, TelefonoSecundario,
            Email, Direccion, CategoriaId, Favorito, Activo, FechaRegistro
        )
        VALUES (
            @Nombre, @Apellido, @TelefonoPrincipal, @TelefonoSecundario,
            @Email, @Direccion, @CategoriaId, ISNULL(@Favorito, 0), 1, GETDATE()
        );

        SET @NuevoId = SCOPE_IDENTITY();

        -- Auditoría
        INSERT INTO dbo.AuditoriaContactos (ContactoId, Accion, Detalle)
        VALUES (@NuevoId, 'CREACION', CONCAT('Contacto registrado: ', @Nombre, ' ', @Apellido, ' (Tel: ', @TelefonoPrincipal, ')'));

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- 6. Modificar Contacto
CREATE PROCEDURE dbo.sp_Contactos_Modificar
    @Id INT,
    @Nombre NVARCHAR(60),
    @Apellido NVARCHAR(60),
    @TelefonoPrincipal NVARCHAR(20),
    @TelefonoSecundario NVARCHAR(20) = NULL,
    @Email NVARCHAR(100) = NULL,
    @Direccion NVARCHAR(200) = NULL,
    @CategoriaId INT,
    @Favorito BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        BEGIN TRANSACTION;

        SET @Nombre = LTRIM(RTRIM(@Nombre));
        SET @Apellido = LTRIM(RTRIM(@Apellido));
        SET @TelefonoPrincipal = LTRIM(RTRIM(@TelefonoPrincipal));
        SET @TelefonoSecundario = NULLIF(LTRIM(RTRIM(@TelefonoSecundario)), '');
        SET @Email = NULLIF(LTRIM(RTRIM(@Email)), '');
        SET @Direccion = NULLIF(LTRIM(RTRIM(@Direccion)), '');

        UPDATE dbo.Contactos
        SET Nombre = @Nombre,
            Apellido = @Apellido,
            TelefonoPrincipal = @TelefonoPrincipal,
            TelefonoSecundario = @TelefonoSecundario,
            Email = @Email,
            Direccion = @Direccion,
            CategoriaId = @CategoriaId,
            Favorito = ISNULL(@Favorito, 0),
            FechaModificacion = GETDATE()
        WHERE Id = @Id AND Activo = 1;

        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('El contacto no existe o se encuentra inactivo.', 16, 1);
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END;
GO

-- 7. Eliminación Lógica
CREATE PROCEDURE dbo.sp_Contactos_EliminarLogico
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE dbo.Contactos
        SET Activo = 0,
            FechaModificacion = GETDATE()
        WHERE Id = @Id AND Activo = 1;

        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('El contacto no existe o ya fue eliminado.', 16, 1);
        END
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

-- 8. Reactivación de Contacto
CREATE PROCEDURE dbo.sp_Contactos_Reactivar
    @Id INT
AS
BEGIN
    SET NOCOUNT ON;
    BEGIN TRY
        UPDATE dbo.Contactos
        SET Activo = 1,
            FechaModificacion = GETDATE()
        WHERE Id = @Id AND Activo = 0;

        IF @@ROWCOUNT = 0
        BEGIN
            RAISERROR('El contacto no existe o ya está activo.', 16, 1);
        END
    END TRY
    BEGIN CATCH
        THROW;
    END CATCH
END;
GO

-- 9. Resumen y Estadísticas Globales de la Agenda
CREATE PROCEDURE dbo.sp_EstadisticasAgenda
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        (SELECT COUNT(*) FROM dbo.Contactos WHERE Activo = 1) AS TotalActivos,
        (SELECT COUNT(*) FROM dbo.Contactos WHERE Activo = 0) AS TotalInactivos,
        (SELECT COUNT(*) FROM dbo.Contactos WHERE Activo = 1 AND Favorito = 1) AS TotalFavoritos,
        (SELECT COUNT(*) FROM dbo.Categorias) AS TotalCategorias,
        (SELECT COUNT(*) FROM dbo.Telefonos) AS TotalLineasTelefonicas;
END;
GO

-- =================================================================================================
--   SECCIÓN 9: INSERCIÓN DE DATOS DE PRUEBA (SEED DATA)
-- =================================================================================================

PRINT 'Insertando categorías de prueba...';
INSERT INTO dbo.Categorias (Nombre, Descripcion)
VALUES 
    (N'Familia', N'Contactos de familiares directos y parientes cercanos'),
    (N'Trabajo', N'Compañeros de trabajo, jefaturas, clientes y proveedores'),
    (N'Amigos', N'Amistades personales y círculos sociales'),
    (N'Universidad', N'Compañeros de cátedra, docentes y personal académico'),
    (N'Negocios', N'Socios comerciales y contactos empresariales'),
    (N'Emergencias', N'Servicios hospitalarios, bomberos, policía y médicos');
GO

PRINT 'Insertando contactos iniciales de prueba...';
-- Obtener IDs de categorías
DECLARE @IdFamilia INT = (SELECT Id FROM dbo.Categorias WHERE Nombre = N'Familia');
DECLARE @IdTrabajo INT = (SELECT Id FROM dbo.Categorias WHERE Nombre = N'Trabajo');
DECLARE @IdAmigos INT = (SELECT Id FROM dbo.Categorias WHERE Nombre = N'Amigos');
DECLARE @IdUniversidad INT = (SELECT Id FROM dbo.Categorias WHERE Nombre = N'Universidad');
DECLARE @IdEmergencias INT = (SELECT Id FROM dbo.Categorias WHERE Nombre = N'Emergencias');

-- Contactos con los autores e información de cátedra
INSERT INTO dbo.Contactos (Nombre, Apellido, TelefonoPrincipal, TelefonoSecundario, Email, Direccion, CategoriaId, Favorito, Activo)
VALUES
(N'Elías Caleb', N'Rivera Herrera', N'7012-3456', N'2222-1111', N'elias.rivera@alumno.edu.sv', N'San Salvador, El Salvador', @IdUniversidad, 1, 1),
(N'Josué David', N'Flores Martínez', N'7234-5678', NULL, N'josue.flores@alumno.edu.sv', N'Soyapango, San Salvador', @IdUniversidad, 1, 1),

-- Contactos de prueba adicionales
(N'Carlos Alberto', N'Guevara Serrano', N'7890-1234', N'2234-5678', N'carlos.guevara@empresa.com', N'Colonia Escalón, San Salvador', @IdTrabajo, 1, 1),
(N'María José', N'Martínez Ramos', N'7456-7890', NULL, N'mariajose.m@gmail.com', N'Residencial San Antonio, San Miguel', @IdFamilia, 1, 1),
(N'Ana Sofía', N'Rivas Henríquez', N'7543-2109', N'2255-8899', N'ana.rivas@negocios.com', N'Antiguo Cuscatlán, La Libertad', @IdTrabajo, 0, 1),
(N'Roberto Carlos', N'Fernández Gómez', N'7654-3210', N'2288-9900', N'roberto.fernandez@yahoo.com', N'Santa Ana, El Salvador', @IdAmigos, 0, 1),
(N'Sistema Nacional', N'Cruz Roja Salvadoreña', N'2222-5155', N'2239-4900', N'emergencias@cruzroja.org.sv', N'Centro de Gobierno, San Salvador', @IdEmergencias, 1, 1);
GO

-- =================================================================================================
--   SECCIÓN 10: CONSULTAS DE VERIFICACIÓN Y PRUEBA INMEDIATA
-- =================================================================================================

PRINT '══════════════════════════════════════════════════════════════════════';
PRINT '  RESUMEN DE VERIFICACIÓN DE INSTALACIÓN DE BASE DE DATOS';
PRINT '══════════════════════════════════════════════════════════════════════';

-- Ejecutar procedimiento de estadísticas
EXEC dbo.sp_EstadisticasAgenda;

-- Consultar vista enriquecida
SELECT TOP 10 
    Id, NombreCompleto, TelefonoPrincipal, TelefonoSecundario, Email, Categoria, Favorito
FROM dbo.vw_AgendaCompleta;

-- Consultar resumen por categoría
SELECT * FROM dbo.vw_EstadisticasPorCategoria;

-- Consultar log de auditoría
SELECT TOP 5 
    Id, ContactoId, Accion, Detalle, FechaAccion, Usuario
FROM dbo.AuditoriaContactos
ORDER BY Id DESC;

PRINT '¡Base de datos AgendaTelefonica creada y verificada exitosamente!';
GO
