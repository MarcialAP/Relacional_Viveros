INSERT INTO vivero (nombre, longitud, latitud) VALUES
('Vivero Central', -3.70379, 40.41678),
('Vivero Norte', -3.70300, 40.45000),
('Vivero Sur', -3.70450, 40.38000),
('Vivero Este', -3.68000, 40.41600),
('Vivero Oeste', -3.73000, 40.42000);

INSERT INTO zona (codvivero, tipo, longitud, latitud) VALUES
(1, 'Plantas ornamentales', -3.70370, 40.41680),
(1, 'Semillas', -3.70375, 40.41685),
(2, 'Árboles', -3.70310, 40.45050),
(3, 'Cactus', -3.70460, 40.38050),
(4, 'Herbáceas', -3.68010, 40.41610);

INSERT INTO empleado (dni, nombrecompleto, telefono) VALUES
('11111111A','Ana López','600111111'),
('22222222B','Carlos Pérez','600222222'),
('33333333C','María García','600333333'),
('44444444D','Luis Martínez','600444444'),
('55555555E','Sofía Ruiz','600555555');

INSERT INTO trabaja (idzona, idempleado) VALUES
(1, '11111111A'),
(1, '22222222B'),
(2, '33333333C'),
(3, '44444444D'),
(4, '55555555E');

INSERT INTO cliente (dni, telefono, correo, fecha_ingreso, nombrecompleto) VALUES
('99999991X','611111111','cli1@example.com', CURRENT_DATE - INTERVAL '30 days','Cliente Uno'),
('99999992X','611111112','cli2@example.com', CURRENT_DATE - INTERVAL '20 days','Cliente Dos'),
('99999993X','611111113','cli3@example.com', CURRENT_DATE - INTERVAL '10 days','Cliente Tres'),
('99999994X','611111114','cli4@example.com', CURRENT_DATE - INTERVAL '5 days','Cliente Cuatro'),
('99999995X','611111115','cli5@example.com', CURRENT_DATE,'Cliente Cinco');
INSERT INTO cliente (identificado) VALUES 
(false),
(false),
(false),
(false),
(false);

INSERT INTO producto (tipo, precio, descripcion) VALUES
('Planta','5.5','Rosa roja'),
('Planta','3.2','Margarita blanca'),
('Árbol','25.0','Olivo joven'),
('Cactus','7.0','Cactus pequeño'),
('Semilla','1.0','Semillas mixtas');

INSERT INTO compra (idempleado, fecha, preciototal, idcliente) VALUES
('11111111A', CURRENT_DATE - INTERVAL '15 days', 0, 1),
('22222222B', CURRENT_DATE - INTERVAL '10 days', 0, 2),
('33333333C', CURRENT_DATE - INTERVAL '5 days', 0, 3),
('44444444D', CURRENT_DATE - INTERVAL '3 days', 0, 4),
('55555555E', CURRENT_DATE, 0, 5);

INSERT INTO esta_en (idzona, codproducto, cantidad) VALUES
(1, 1, 10),
(1, 2, 15),
(2, 5, 50),
(3, 3, 5),
(4, 4, 8);

INSERT INTO contiene (idcompra, codproducto, cantidad) VALUES
(1, 1, 2),
(1, 2, 1),
(2, 3, 1),
(3, 4, 2),
(4, 5, 10);
