# Relacional_Viveros

Vivero (<ins>Código</ins>, Nombre, Longitud, Latitud)

Zona (Identificador, CodVivero, Tipo, Longitud, Latitud)
- CodVivero Foreign Key Vivero(Código)

Empleado (DNI, Teléfono, NombreCompleto)

Trabaja (IdEmpleado, IdZona, Fecha_Comienzo, Fecha_fin)
- IdEmpleado Foreign Key Empleado(DNI)
- IdZona Foreign Key Zona(Identificador)

Cliente (Código)

ClienteTajinastePlus (Código, DNI, Teléfono, Correo, Fecha_Ingreso)
- Código Foreign Key Cliente(Código)

Compra (IdCompra, IdEmpleado, Fecha, PrecioTotal, IdCliente)
- IdEmpleado Foreign Key Empleado(DNI)
- IdCliente Foreign Key Cliente(Código)

Producto (Código, Tipo)

Está_en (IdZona, IdProducto, Cantidad)
- IdZona Foreign Key Zona(Identificador)
- IdProducto Foreign Key Producto(Código)

Contiene(IdCompra, IdProducto, Cantidad)
- IdCompra Foreign Key Compra(IdCompra)
- IdProducto Foreign Key Producto(Código)
