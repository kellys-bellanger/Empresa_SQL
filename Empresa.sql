use master
go

if exists (select name from sys.databases where name = 'Empresaql')
begin
    drop database Empresaql;
end
go

create database Empresaql
go

use Empresaql
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
    dfechacontratacion date constraint df_fechacontratacion default getdate(),
    nsalario decimal(10,2),

    constraint pk_templeado primary key (nempleadoid),
    constraint uq_nif unique (cnif), 
    constraint chk_salario_mayor_a_300 check (nsalario > 300),
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

--Parte II
alter table templeado
add cemail nvarchar (100) not null
go

alter table templeado
add ctelefono int
go

alter table templeado
alter column cnombre nvarchar(100) not null
go

alter table templeado
alter column capellido nvarchar(100) not null
go

alter table templeado
add cdireccion nvarchar(200)
go

alter table templeado
add nedad int
go

alter table templeado
add constraint chk_empleado_edad check (nedad >= 18 and nedad <= 65)
go

alter table templeado
add constraint uq_empleado_email unique (cemail)
go

alter table templeado 
add bactivo bit constraint df_empleado_bactivo default 1
go

alter table templeado
drop column cdireccion
go

alter table templeado
alter column ctelefono nvarchar(20)
go

alter table templeado
add cgenero char(1)
go

alter table templeado
add constraint chk_empleado_genero check (cgenero in ('M', 'F', 'O'))
go

alter table templeado
add dfechanacimiento date
go

--tabla sucursal
create table tsucursal (
    nsucursalid int identity(1,1),
    cnombresucursal nvarchar(150) not null,
    cdireccionsucursal nvarchar(250) not null,
    
    constraint pk_tsucursal primary key (nsucursalid),
    constraint uq_nombresucursal unique (cnombresucursal)
)
go