# 📒 Proyecto de Cátedra: Sistema de Agenda Telefónica Profesional

## 📌 Datos Generales
- **Asignatura**: Programación I / Base de Datos
- **Ciclo Académico**: 2026
- **Entorno de Desarrollo**: Visual Studio 2026 (Compatible con Visual Studio 2022)
- **Lenguaje & Framework**: C# (.NET 8.0 / .NET 10.0 Windows Forms)
- **Gestor de Base de Datos**: Microsoft SQL Server 2019 / 2022 / 2026 / Express / LocalDB

---

## 👥 Integrantes y Autores
- **Elías Caleb Rivera Herrera**
- **Josué David Flores Martínez**

---

## 📁 Archivos de la Solución

1. **`Proyecto_Agenda_Telefonica_Completo.slnx`**:
   - Formato nativo moderno de solución para **Visual Studio 2026** (XML simplificado).
2. **`Proyecto_Agenda_Telefonica_Completo.sln`**:
   - Formato universal de solución para **Visual Studio** (compatible con cualquier versión de Visual Studio).
3. **`AgendaTelefonica_Completo_Con_Diagramas.sql`**:
   - Script maestro de base de datos SQL con **diagramas conceptuales (DER)**, **arquitectura de tres capas**, **diccionarios de datos en cuadros ASCII**, triggers de auditoría, vistas, procedimientos almacenados y datos de prueba. Se encuentra vinculado directamente en el Explorador de Soluciones de Visual Studio y también en el Escritorio.

---

## 🏗️ Arquitectura de Software (3 Capas)

El proyecto está diseñado bajo buenas prácticas de ingeniería de software con separación estricta de responsabilidades:

```
┌─────────────────────────────────────────────────────────────┐
│ 1. Capa de Presentación (UI - Windows Forms)                │
│    • FormPrincipal.cs : CRUD, búsqueda interactiva, rejilla │
│    • FormAutores.cs   : Ficha informativa de autores        │
├─────────────────────────────────────────────────────────────┤
│ 2. Capa de Lógica de Negocio (BLL)                          │
│    • ContactoService.cs : Validaciones (Regex, reglas)      │
├─────────────────────────────────────────────────────────────┤
│ 3. Capa de Acceso a Datos (DAL)                             │
│    • Conexion.cs           : Conexión segura a SQL Server   │
│    • ContactoRepository.cs : Operaciones CRUD con ADO.NET   │
│    • CategoriaRepository.cs: Carga de categorías            │
├─────────────────────────────────────────────────────────────┤
│ 4. Capa de Entidades (Modelos de Dominio)                   │
│    • Contacto.cs, Categoria.cs, AgendaException.cs          │
└─────────────────────────────────────────────────────────────┘
```

---

## 🚀 Guía de Puesta en Marcha

### Paso 1: Crear la Base de Datos en SQL Server
1. Abre **SQL Server Management Studio (SSMS)** o el **Explorador de Objetos de SQL Server** en Visual Studio.
2. Abre el archivo [`AgendaTelefonica_Completo_Con_Diagramas.sql`](./AgendaTelefonica_Completo_Con_Diagramas.sql).
3. Presiona **Ejecutar (F5)**.
4. El script creará la base de datos `AgendaTelefonica`, sus tablas, índices únicos, triggers, vistas, procedimientos almacenados e insertará los contactos iniciales de prueba.

### Paso 2: Abrir y Ejecutar en Visual Studio 2026
1. Haz doble clic en [`Proyecto_Agenda_Telefonica_Completo.slnx`](./Proyecto_Agenda_Telefonica_Completo.slnx) o en [`Proyecto_Agenda_Telefonica_Completo.sln`](./Proyecto_Agenda_Telefonica_Completo.sln).
2. Si tu instancia de SQL Server tiene un nombre diferente (por ejemplo, `(localdb)\mssqllocaldb` o `.`), ajusta la cadena en `appsettings.json`:
   ```json
   {
     "ConnectionStrings": {
       "AgendaDB": "Server=localhost\\SQLEXPRESS;Database=AgendaTelefonica;Integrated Security=True;TrustServerCertificate=True;Connect Timeout=5;"
     }
   }
   ```
3. Presiona **Iniciar (F5)** o el botón verde de depuración.
4. ¡La aplicación iniciará lista para usar!
