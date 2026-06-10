Use master
GO

Create database EmpresaSQL
GO

use EmpresaSQL
GO 

--Tabla Departamento
create table TDepartamento (
    nDepartamentoID int identity(1,1),
    cNombreDepartamento nvarchar(100) not null,

    constraint PK_TDepartamento primary key (nDepartamentoID),
    constraint UQ_NombreDepartamento unique (cNombreDepartamento)
)
GO

--Tabla Cargo
create table TCargo (
    nCargoID int identity(1,1),
    cNombreCargo nvarchar(100) not null,
    
    constraint PK_TCargo primary key (nCargoID),
    constraint UQ_NombreCargo unique (cNombreCargo)
)
GO

--Tabla Empleado
create table TEmpleado (
    nEmpleadoID int identity(1,1),
    cNIF nvarchar(20) null, 
    cNombre nvarchar(50) not null,
    cApellido nvarchar(50) not null,
    nDepartamentoID int,
    nCargoID int,
    dFechaContratacion date,
    nSalario decimal(10,2),

    constraint PK_TEmpleado primary key (nEmpleadoID),
    constraint UQ_NIF unique (cNIF), 
    constraint CHK_Salario Mayor A 300 check (nSalario > 300),
    constraint DF_FechaContratacion default getdate() for dFechaContratacion,
    constraint FK_TEmpleado_TDepartamento foreign key (nDepartamentoID) 
        references TDepartamento(nDepartamentoID),
    constraint FK_TEmpleado_TCargo foreign key (nCargoID) 
        references TCargo(nCargoID)
)
GO

--Tabla Proyecto
create table TProyecto (
    nProyectoID int identity(1,1),           
    cNombreProyecto nvarchar(150) not null,   
    dFechaInicio date not null,              
    dFechaFinalizacion date null,            

    constraint PK_TProyecto primary key (nProyectoID)
)
GO

-- Tabla de relación entre Empleado y Proyecto
create table TEmpleadoProyecto (
    nEmpleadoID int,
    nProyectoID int,
    dFechaAsignacion date constraint DF_FechaAsignacion default getdate(), -- (Opcional, buena práctica)

    constraint PK_TEmpleadoProyecto primary key (nEmpleadoID, nProyectoID),
    constraint FK_TEmpleadoProyecto_TEmpleado foreign key (nEmpleadoID) 
        references TEmpleado(nEmpleadoID),
    constraint FK_TEmpleadoProyecto_TProyecto foreign key (nProyectoID) 
        references TProyecto(nProyectoID)
)
GO

