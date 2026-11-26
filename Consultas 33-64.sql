-- 33. Obtener todas las películas que tenemos y todos los registros de alquiler.
/* FULL JOIN: aparecen las películas sin alquileres y, si existiera, cualquier
   alquiler sin película asociada. Se pasa por inventory porque rental no
   tiene film_id. */
select f."film_id", f."title", r."rental_id", r."rental_date", r."return_date"
from "film" as f
left join "inventory" as i on i."film_id"      = f."film_id"
full join "rental"    as r on r."inventory_id" = i."inventory_id"
order by f."title", r."rental_date";


-- 34. Encuentra los 5 clientes que más dinero se hayan gastado con nosotros.
select c."customer_id", c."first_name", c."last_name", sum(p."amount") as total_gastado
from "customer" as c
join "payment"  as p on p."customer_id" = c."customer_id"
group by c."customer_id", c."first_name", c."last_name"
order by total_gastado desc
limit 5;


-- 35. Selecciona todos los actores cuyo primer nombre es 'Johnny'.
select a."actor_id", a."first_name", a."last_name"
from "actor" as a
where upper(a."first_name") = 'JOHNNY';


-- 36. Renombra la columna “first_name” como Nombre y “last_name” como Apellido.
select a."first_name" as "Nombre",
       a."last_name"  as "Apellido"
from "actor" as a;
/* Si se quiere renombrar de forma permanente en la tabla (no recomendable,
   rompe vistas/funciones de la BBDD que usan esos nombres):
   ALTER TABLE actor RENAME COLUMN first_name TO nombre;
   ALTER TABLE actor RENAME COLUMN last_name  TO apellido; */


-- 37. Encuentra el ID del actor más bajo y más alto en la tabla actor.
select min(a."actor_id") as id_minimo,
       max(a."actor_id") as id_maximo
from "actor" as a;


-- 38. Cuenta cuántos actores hay en la tabla “actor”.
select count(*) as total_actores
from "actor" as a;


-- 39. Selecciona todos los actores y ordénalos por apellido en orden ascendente.
select a."actor_id", a."first_name", a."last_name"
from "actor" as a
order by a."last_name" asc, a."first_name" asc;


-- 40. Selecciona las primeras 5 películas de la tabla “film”.
select f."film_id", f."title"
from "film" as f
order by f."film_id"
limit 5;


-- 41. Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre.
--     ¿Cuál es el nombre más repetido?
select a."first_name", count(*) as veces_repetido
from "actor" as a
group by a."first_name"
order by veces_repetido desc, a."first_name";

/* Nombre(s) más repetido(s). Se usa rank() porque hay empate:
   JULIA, KENNETH y PENELOPE aparecen 4 veces cada uno. */
with conteo_nombres as (
    select a."first_name",
           count(*) as veces_repetido,
           rank() over (order by count(*) desc) as posicion
    from "actor" as a
    group by a."first_name"
)
select "first_name", veces_repetido
from conteo_nombres
where posicion = 1
order by "first_name";


-- 42. Encuentra todos los alquileres y los nombres de los clientes que los realizaron.
select r."rental_id", r."rental_date", c."first_name", c."last_name"
from "rental"   as r
join "customer" as c on c."customer_id" = r."customer_id"
order by r."rental_date";


-- 43. Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no
--     tienen alquileres.
select c."customer_id", c."first_name", c."last_name", r."rental_id", r."rental_date"
from "customer" as c
left join "rental" as r on r."customer_id" = c."customer_id"
order by c."customer_id", r."rental_date";


-- 44. Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta?
--     ¿Por qué? Deja después de la consulta la contestación.
select f."title", c."name" as categoria
from "film" as f
cross join "category" as c;
/* Respuesta: No aporta valor. El CROSS JOIN genera el producto cartesiano:
   cada una de las 1000 películas combinada con las 16 categorías = 16 000
   filas, sin tener en cuenta la categoría real de cada película. La mayoría
   de combinaciones son falsas (p. ej. una comedia emparejada con 'Horror').
   La relación real entre película y categoría está en film_category y se
   obtiene con un INNER JOIN a través de esa tabla. El CROSS JOIN solo tiene
   sentido cuando de verdad se necesitan todas las combinaciones (ver 63). */


-- 45. Encuentra los actores que han participado en películas de la categoría 'Action'.
select distinct a."actor_id", a."first_name", a."last_name"
from "actor" as a
join "film_actor"    as fa on fa."actor_id"    = a."actor_id"
join "film_category" as fc on fc."film_id"     = fa."film_id"
join "category"      as c  on c."category_id"  = fc."category_id"
where c."name" = 'Action'
order by a."last_name", a."first_name";


-- 46. Encuentra todos los actores que no han participado en películas.
select a."actor_id", a."first_name", a."last_name"
from "actor" as a
where not exists (select 1
                  from "film_actor" as fa
                  where fa."actor_id" = a."actor_id");
/* Resultado: 0 filas. Todos los actores de la BBDD tienen al menos una película. */


-- 47. Selecciona el nombre de los actores y la cantidad de películas en las que han participado.
select a."first_name", a."last_name", count(fa."film_id") as cantidad_peliculas
from "actor" as a
left join "film_actor" as fa on fa."actor_id" = a."actor_id"
group by a."actor_id", a."first_name", a."last_name"
order by cantidad_peliculas desc, a."last_name";


-- 48. Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores
--     y el número de películas en las que han participado.
drop view if exists "actor_num_peliculas";

create view "actor_num_peliculas" as
select a."actor_id",
       a."first_name",
       a."last_name",
       count(fa."film_id") as "numero_peliculas"
from "actor" as a
left join "film_actor" as fa on fa."actor_id" = a."actor_id"
group by a."actor_id", a."first_name", a."last_name";

-- Consulta de la vista:
select "first_name", "last_name", "numero_peliculas"
from "actor_num_peliculas"
order by "numero_peliculas" desc, "last_name";


-- 49. Calcula el número total de alquileres realizados por cada cliente.
select c."customer_id", c."first_name", c."last_name", count(r."rental_id") as "total_alquileres"
from "customer" as c
left join "rental" as r on r."customer_id" = c."customer_id"
group by c."customer_id", c."first_name", c."last_name"
order by "total_alquileres" desc, c."customer_id";


-- 50. Calcula la duración total de las películas en la categoría 'Action'.
select sum(f."length") as duracion_total_minutos
from "film" as f
join "film_category" as fc on fc."film_id"    = f."film_id"
join "category"      as c  on c."category_id" = fc."category_id"
where c."name" = 'Action';


-- 51. Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total
--     de alquileres por cliente.
/* Las tablas temporales solo existen durante la sesión/conexión actual
   de DBeaver: hay que consultarlas desde el mismo editor/conexión. */
drop table if exists "cliente_rentas_temporal";

create temporary table "cliente_rentas_temporal" as
select c."customer_id",
       c."first_name",
       c."last_name",
       count(r."rental_id") as "total_alquileres"
from "customer" as c
left join "rental" as r on r."customer_id" = c."customer_id"
group by c."customer_id", c."first_name", c."last_name";

select *
from "cliente_rentas_temporal"
order by "total_alquileres" desc;


-- 52. Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas
--     que han sido alquiladas al menos 10 veces.
drop table if exists "peliculas_alquiladas";

create temporary table "peliculas_alquiladas" as
select f."film_id",
       f."title",
       count(r."rental_id") as "veces_alquilada"
from "film" as f
join "inventory" as i on i."film_id"      = f."film_id"
join "rental"    as r on r."inventory_id" = i."inventory_id"
group by f."film_id", f."title"
having count(r."rental_id") >= 10;

select *
from "peliculas_alquiladas"
order by "veces_alquilada" desc, "title";


-- 53. Encuentra el título de las películas que han sido alquiladas por el cliente con el
--     nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena los resultados
--     alfabéticamente por título de película.
select f."title"
from "customer" as c
join "rental"    as r on r."customer_id"  = c."customer_id"
join "inventory" as i on i."inventory_id" = r."inventory_id"
join "film"      as f on f."film_id"      = i."film_id"
where upper(c."first_name") = 'TAMMY'
  and upper(c."last_name")  = 'SANDERS'
  and r."return_date" is null
order by f."title";


-- 54. Encuentra los nombres de los actores que han actuado en al menos una película que
--     pertenece a la categoría ‘Sci-Fi’. Ordena los resultados alfabéticamente por apellido.
select a."first_name", a."last_name"
from "actor" as a
where exists (select 1
              from "film_actor"    as fa
              join "film_category" as fc on fc."film_id"    = fa."film_id"
              join "category"      as c  on c."category_id" = fc."category_id"
              where fa."actor_id" = a."actor_id"
                and c."name" = 'Sci-Fi')
order by a."last_name", a."first_name";


-- 55. Encuentra el nombre y apellido de los actores que han actuado en películas que se
--     alquilaron después de que la película ‘Spartacus Cheaper’ se alquilara por primera
--     vez. Ordena los resultados alfabéticamente por apellido.
with primer_alquiler_spartacus as (
    select min(r."rental_date") as fecha
    from "rental"    as r
    join "inventory" as i on i."inventory_id" = r."inventory_id"
    join "film"      as f on f."film_id"      = i."film_id"
    where upper(f."title") = 'SPARTACUS CHEAPER'
)
select distinct a."first_name", a."last_name"
from "actor" as a
join "film_actor" as fa on fa."actor_id"     = a."actor_id"
join "inventory"  as i  on i."film_id"       = fa."film_id"
join "rental"     as r  on r."inventory_id"  = i."inventory_id"
where r."rental_date" > (select fecha from primer_alquiler_spartacus)
order by a."last_name", a."first_name";


-- 56. Encuentra el nombre y apellido de los actores que no han actuado en ninguna película
--     de la categoría ‘Music’.
select a."first_name", a."last_name"
from "actor" as a
where a."actor_id" not in (select fa."actor_id"
                         from "film_actor"    as fa
                         join "film_category" as fc on fc."film_id"    = fa."film_id"
                         join "category"      as c  on c."category_id" = fc."category_id"
                         where c."name" = 'Music')
order by a."last_name", a."first_name";
/* NOT IN es seguro aquí porque film_actor.actor_id es NOT NULL; con columnas
   que admiten NULL sería preferible NOT EXISTS. */


-- 57. Encuentra el título de todas las películas que fueron alquiladas por más de 8 días.
select distinct f."title"
from "film" as f
join "inventory" as i on i."film_id"      = f."film_id"
join "rental"    as r on r."inventory_id" = i."inventory_id"
where r."return_date" - r."rental_date" > interval '8 days'
order by f."title";


-- 58. Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’.
select f."title"
from "film" as f
join "film_category" as fc on fc."film_id" = f."film_id"
where fc."category_id" = (select c."category_id"
                        from "category" as c
                        where c."name" = 'Animation')
order by f."title";


-- 59. Encuentra los nombres de las películas que tienen la misma duración que la película
--     con el título ‘Dancing Fever’. Ordena los resultados alfabéticamente por título.
select f."title", f."length"
from "film" as f
where f."length" = (select f2."length"
                  from "film" as f2
                  where upper(f2."title") = 'DANCING FEVER')
order by f."title";
/* Incluye la propia 'DANCING FEVER'. Para excluirla:
   and upper(f.title) <> 'DANCING FEVER' */


-- 60. Encuentra los nombres de los clientes que han alquilado al menos 7 películas
--     distintas. Ordena los resultados alfabéticamente por apellido.
select c."first_name", c."last_name", count(distinct i."film_id") as peliculas_distintas
from "customer" as c
join "rental"    as r on r."customer_id"  = c."customer_id"
join "inventory" as i on i."inventory_id" = r."inventory_id"
group by c."customer_id", c."first_name", c."last_name"
having count(distinct i."film_id") >= 7
order by c."last_name", c."first_name";


-- 61. Encuentra la cantidad total de películas alquiladas por categoría y muestra el
--     nombre de la categoría junto con el recuento de alquileres.
select c."name" as categoria, count(r."rental_id") as "total_alquileres"
from "category" as c
join "film_category" as fc on fc."category_id" = c."category_id"
join "inventory"     as i  on i."film_id"      = fc."film_id"
join "rental"        as r  on r."inventory_id" = i."inventory_id"
group by c."name"
order by "total_alquileres" desc;


-- 62. Encuentra el número de películas por categoría estrenadas en 2006.
select c."name" as categoria, count(f."film_id") as peliculas_2006
from "category" as c
join "film_category" as fc on fc."category_id" = c."category_id"
join "film"          as f  on f."film_id"      = fc."film_id"
where f."release_year" = 2006
group by c."name"
order by peliculas_2006 desc, categoria;


-- 63. Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos.
select s."staff_id", s."first_name", s."last_name", st."store_id"
from "staff" as s
cross join "store" as st
order by s."staff_id", st."store_id";


-- 64. Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el
--     ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas.
select c."customer_id", c."first_name", c."last_name", count(r."rental_id") as "peliculas_alquiladas"
from "customer" as c
left join "rental" as r on r."customer_id" = c."customer_id"
group by c."customer_id", c."first_name", c."last_name"
order by c."customer_id";
