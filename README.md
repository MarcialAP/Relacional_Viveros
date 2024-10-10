# Relacional_Viveros

Vivero (<ins>Código</ins>, Nombre, Longitud, Latitud)

Zona (<ins>Identificador</ins>, CodVivero, Tipo, Longitud, Latitud)
- CodVivero Foreign Key Vivero(Código)

Empleado (<ins>DNI</ins>, Teléfono, NombreCompleto)

Trabaja (<ins>IdEmpleado, IdZona</ins>, Fecha_Comienzo, Fecha_fin)
- IdEmpleado Foreign Key Empleado(DNI)
- IdZona Foreign Key Zona(Identificador)

Cliente (<ins>Código</ins>)

ClienteTajinastePlus (<ins>Código</ins>, DNI, Teléfono, Correo, Fecha_Ingreso)
- Código Foreign Key Cliente(Código)

Compra (<ins>IdCompra</ins>, IdEmpleado, Fecha, PrecioTotal, IdCliente)
- IdEmpleado Foreign Key Empleado(DNI)
- IdCliente Foreign Key Cliente(Código)

Producto (<ins>Código</ins>, Tipo)

Está_en (<ins>IdZona, IdProducto</ins>, Cantidad)
- IdZona Foreign Key Zona(Identificador)
- IdProducto Foreign Key Producto(Código)

Contiene(<ins>IdCompra, IdProducto</ins>, Cantidad)
- IdCompra Foreign Key Compra(IdCompra)
- IdProducto Foreign Key Producto(Código)
