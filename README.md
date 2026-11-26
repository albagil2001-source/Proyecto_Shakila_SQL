# Proyecto_Shakila_SQL
Proyecto sobre la base de datos Shakila utilizando DBeaver

Este repositorio contiene mi DataProject de Lógica de consultas SQL. Consiste en resolver 64 ejercicios sobre la base de datos Shakila, que simula un videoclub: películas, actores, clientes, alquileres y pagos. Las consultas están hechas con PostgreSQL y DBeaver.

*Diagrama de la base de datos*

<img width="1444" height="1292" alt="postgres - Shakila - public - diagrama" src="https://github.com/user-attachments/assets/7d24e070-9f46-48ab-9dae-7c3b50d8d8d3" />



*Archivos*

Las consultas están repartidas en cuatro archivos para que sea más fácil moverse por ellas:

1. Consultas 1-10.sql
2. Consultas 11-21.sql
3. Consultas 22-32.sql
4. Consultas 33-64.sql

*Cómo ejecutarlo*

Tener cargada la base de datos Shakila en PostgreSQL y conectada en DBeaver.

Abrir el archivo .sql en un editor SQL de DBeaver.

Poner el cursor sobre una consulta y pulsar Ctrl+Enter para ejecutarla, o Alt+X para ejecutar el archivo entero.

*Buenas prácticas que he intentado seguir*

JOIN siempre explícitos, sin unir tablas con comas en el WHERE.

Alias cortos para las tablas (f para film, a para actor...) y nombres claros para las columnas calculadas.

Solo las columnas necesarias en el SELECT en lugar de SELECT *.

UPPER() o ILIKE al comparar texto, porque los nombres y títulos están guardados en mayúsculas.

ORDER BY siempre que uso LIMIT.

DROP ... IF EXISTS antes de crear la vista y las tablas temporales.

*Conclusiones del análisis de la BBDD Shakila*

El negocio se concentra en verano de 2005. Fuera de esos meses casi no hay datos, por lo que no se pueden sacar conclusiones de tendencia anual.

El catálogo está muy repartido: ninguna clasificación ni categoría destaca mucho sobre las demás.

La facturación se reparte casi a partes iguales entre las dos tiendas y la base de clientes es muy homogénea. No hay clientes inactivos.

Hay detalles de calidad de datos a tener en cuenta: idioma original vacío, películas sin actores o sin copias, y alquileres con la misma fecha exacta.
