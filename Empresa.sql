use master
go

if exists (select name from sys.databases where name = 'empresasql')
begin
    drop database empresasql;
end
go

create database empresasql
go

use empresasql
go 

-- tabla tdepartamento
create table tdepartamento (
    ndepartamentoid int identity(1,1),
    cnombredepartamento nvarchar(100) not null,

    constraint pk_tdepartamento primary key (ndepartamentoid),
    constraint uq_nombredepartamento unique (cnombredepartamento)
)
go

-- tabla tcargo
create table tcargo (
    ncargoid int identity(1,1),
    cnombrecargo nvarchar(100) not null,
    
    constraint pk_tcargo primary key (ncargoid),
    constraint uq_nombrecargo unique (cnombrecargo)
)
go

-- 5.tabla templeado
create table templeado (
    nempleadoid int identity(1,1),
    cnif nvarchar(20) null, 
    cnombre nvarchar(50) not null,
    capellido nvarchar(50) not null,
    ndepartamentoid int,
    ncargoid int,
    dfechacontratacion date,
    nsalario decimal(10,2),

    constraint pk_templeado primary key (nempleadoid),
    constraint uq_nif unique (cnif), 
    constraint chk_salario_mayor_a_300 check (nsalario > 300),
    constraint df_fechacontratacion default getdate() for dfechacontratacion,
    constraint fk_templeado_tdepartamento foreign key (ndepartamentoid) 
        references tdepartamento(ndepartamentoid),
    constraint fk_templeado_tcargo foreign key (ncargoid)
        references tcargo(ncargoid)
)
go

--tabla tproyecto
create table tproyecto (
    nproyectoid int identity(1,1),           
    cnombreproyecto nvarchar(150) not null,   
    dfechainicio date not null,              
    dfechafinalizacion date null,            

    constraint pk_tproyecto primary key (nproyectoid)
)
go

-- tabla  TEmpleadoProyecto para relación muchos a muchos
create table templeadoproyecto (
    nempleadoid int,
    nproyectoid int,
    dfechaasignacion date constraint df_fechaasignacion default getdate(),

    constraint pk_templeadoproyecto primary key (nempleadoid, nproyectoid),
    
    constraint fk_templeadoproyecto_templeado foreign key (nempleadoid) 
        references templeado(nempleadoid),
        
    constraint fk_templeadoproyecto_tproyecto foreign key (nproyectoid) 
        references tproyecto(nproyectoid)
)
go