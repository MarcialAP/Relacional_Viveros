create database viveros;

CREATE TABLE vivero (
    codigo serial PRIMARY KEY,
    nombre VARCHAR (50) NOT NULL,
    longitud real NOT NULL,
    latitud real NOT NULL
);

create table zona (
    identificador serial PRIMARY KEY,
    codvivero integer REFERENCES vivero(codigo) on delete cascade on update cascade NOT NULL,
    tipo VARCHAR (50) NOT NULL,
    longitud real NOT NULL,
    latitud real NOT NULL
);

create table empleado (
    dni VARCHAR (9) PRIMARY KEY,
    nombrecompleto VARCHAR (50) NOT NULL,
    telefono VARCHAR (9) check (telefono ~ '^[0-9]{9}$') NOT NULL
);

create table trabaja (
    idzona integer REFERENCES zona(identificador),
    idempleado VARCHAR (9) REFERENCES empleado(dni),
    PRIMARY KEY (idzona, idempleado)
);

create table cliente (
    codigo serial PRIMARY KEY,
    dni VARCHAR (9),
    telefono VARCHAR (9) check (telefono ~ '^[0-9]{9}$'),
    correo VARCHAR (50),
    fecha_ingreso DATE check (fecha_ingreso <= CURRENT_DATE),
    nombrecompleto VARCHAR (50),
    identificado boolean DEFAULT true
);


create table compra (
    idcompra serial PRIMARY KEY,
    idempleado VARCHAR (9) REFERENCES empleado(dni) NOT NULL,
    fecha DATE NOT NULL,
    preciototal real check (preciototal >= 0) DEFAULT 0,
    idcliente integer REFERENCES cliente(codigo) on delete set null
);

create table producto (
    codigo serial PRIMARY KEY,
    tipo VARCHAR (50),
    precio real check (precio > 0) NOT NULL,
    descripcion VARCHAR (100)
);

create table esta_en (
    idzona integer REFERENCES zona(identificador),
    codproducto integer REFERENCES producto(codigo),
    cantidad integer check (cantidad >= 0),
    PRIMARY KEY (idzona, codproducto)
);

create table contiene (
    idcompra integer REFERENCES compra(idcompra),
    codproducto integer REFERENCES producto(codigo),
    cantidad integer check (cantidad > 0),
    PRIMARY KEY (idcompra, codproducto)
);

CREATE OR REPLACE PROCEDURE nuevo_producto_compra_proc(p_idcompra integer, idproducto integer, cantidad integer)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE compra
    SET preciototal = preciototal + (
        (SELECT precio FROM producto WHERE codigo = idproducto) * cantidad
        )
    WHERE idcompra = p_idcompra;
END;
$$;

CREATE OR REPLACE FUNCTION actualizar_precio_total_func()
RETURNS trigger AS $$
BEGIN
    CALL nuevo_producto_compra_proc(NEW.idcompra, NEW.codproducto, NEW.cantidad);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS actualizar_precio_total ON contiene;
CREATE TRIGGER actualizar_precio_total
AFTER INSERT ON contiene
FOR EACH ROW
EXECUTE FUNCTION actualizar_precio_total_func();


create or replace function actualizar_stock_func()
RETURNS trigger AS $$
BEGIN
    UPDATE esta_en
    SET cantidad = cantidad - NEW.cantidad
    WHERE idzona = (SELECT idzona FROM trabaja WHERE idempleado = 
    (select idempleado from compra where idcompra = NEW.idcompra LIMIT 1)
    LIMIT 1)
      AND codproducto = NEW.codproducto;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS actualizar_stock ON contiene;
CREATE TRIGGER actualizar_stock
AFTER INSERT OR UPDATE ON contiene
FOR EACH ROW
EXECUTE FUNCTION actualizar_stock_func();