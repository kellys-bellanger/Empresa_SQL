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

--Parte III
-- 5 departamentos diferentes
insert into tdepartamento (cnombredepartamento) values 
('sistemas'),
('contabilidad'),
('recursos humanos'),
('mercadeo'),
('operaciones');
go

-- 5 cargos diferentes
insert into tcargo (cnombrecargo) values 
('gerente'),
('desarrollador backend'),
('contador'),
('analista de datos'),
('asistente administrativo');
go

-- 10 empleados
insert into templeado (cnif, cnombre, capellido, ndepartamentoid, ncargoid, dfechacontratacion, nsalario, cemail, ctelefono, nedad, cgenero) values
('101', 'carlos', 'mendoza', 1, 2, '2025-01-15', 850.00, 'carlos@empresa.com', '88881111', 25, 'm'),
('102', 'maria', 'lopez', 1, 4, '2025-02-20', 900.00, 'maria@empresa.com', '88882222', 28, 'f'),
('103', 'juan', 'perez', 2, 3, '2024-11-10', 700.00, 'juan@empresa.com', '88883333', 35, 'm'),
('104', 'ana', 'gomez', 3, 1, '2023-05-12', 1500.00, 'ana@empresa.com', '88884444', 42, 'f'),
('105', 'luis', 'torres', 4, 5, '2025-03-01', 400.00, 'luis@empresa.com', '88885555', 23, 'm'),
('106', 'sofia', 'ruiz', 5, 5, '2025-04-18', 450.00, 'sofia@empresa.com', '88886666', 30, 'f'),
('107', 'diego', 'reyes', 1, 2, '2025-05-02', 800.00, 'diego@empresa.com', '88887777', 26, 'm'),
('108', 'lucia', 'diaz', 2, 3, '2024-08-14', 750.00, 'lucia@empresa.com', '88888888', 31, 'f'),
('109', 'jorge', 'espinoza', 4, 1, '2022-09-01', 1600.00, 'jorge@empresa.com', '88889999', 45, 'm'),
('110', 'elena', 'castro', 3, 5, '2025-06-01', 420.00, 'elena@empresa.com', '88880000', 24, 'f');
go

-- 3 proyectos
insert into tproyecto (cnombreproyecto, dfechainicio, dfechafinalizacion) values
('proyecto web uamarket', '2026-01-10', '2026-06-30'),
('sistema inventario ia', '2026-03-01', null),
('app ancla digital', '2026-04-15', '2026-12-31');
go

-- asignar empleados a proyectos
insert into templeadoproyecto (nempleadoid, nproyectoid) values
(1, 1), -- carlos en uamarket
(2, 1), -- maria en uamarket
(1, 2), -- carlos tambien en inventario ia
(7, 3); -- diego en ancla digital
go

-- empleado utilizando el valor por defecto de fecha
insert into templeado (cnif, cnombre, capellido, ndepartamentoid, ncargoid, nsalario, cemail, ctelefono, nedad, cgenero) values
('111', 'alejandro', 'silva', 1, 2, 600.00, 'ale@empresa.com', '77771111', 22, 'm');
go

-- empleado con correo electronico
insert into templeado (cnif, cnombre, capellido, ndepartamentoid, ncargoid, dfechacontratacion, nsalario, cemail, ctelefono, nedad, cgenero) values
('112', 'keyssi', 'granera', 1, 4, '2026-02-15', 950.00, 'keyssi@empresa.com', '77772222', 21, 'f');
go

-- empleado sin indicar estado activo
-- como bactivo tiene default 1, al no ponerlo en la lista de campos, se activara solito
insert into templeado (cnif, cnombre, capellido, ndepartamentoid, ncargoid, dfechacontratacion, nsalario, cemail, ctelefono, nedad, cgenero) values
('113', 'roberto', 'gaitan', 2, 3, '2026-05-10', 720.00, 'roberto@empresa.com', '77773333', 29, 'm');
go

-- registros usando multiples VALUES
insert into tdepartamento (cnombredepartamento) values 
('logistica'),
('auditoria');
go

-- salario negativo y analizar el error
insert into templeado (cnif, cnombre, capellido, ndepartamentoid, ncargoid, dfechacontratacion, nsalario, cemail, ctelefono, nedad, cgenero) values
('114', 'test', 'error', 1, 2, '2026-06-01', -100.00, 'error@empresa.com', '00000000', 30, 'm');
go

