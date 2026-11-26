
-- 22. Crea una columna con el nombre y apellidos de todos los actores y actrices.
select concat(a."first_name", ' ', a."last_name") as nombre_completo
from "actor"a
order by nombre_completo;

--23. Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente.
select r."rental_date" as Fecha_alquiler, 
count(r."rental_id") as cantidad_alquiler
from  "rental"r
group by r."rental_date"
order by cantidad_alquiler desc;

--24. Encuentra las películas con una duración superior al promedio.
select title as Titulo, f."length" as duracion
from "film" f
where f."length" > (select AVG(f2."length") from film as f2);


-- 25. Averigua el número de alquileres registrados por mes.
select to_char(r."rental_date", 'YYYY-MM') as mes,
       count(*)                          as numero_alquileres
from "rental" r
group by to_char(r."rental_date", 'YYYY-MM')
order by mes;

-- 26. Encuentra el promedio, la desviación estándar y varianza del total pagado.
select round(avg(p."amount"), 2)      as promedio_pago,
       round(stddev(p."amount"), 2)   as desviacion_estandar,
       round(variance(p."amount"), 2) as varianza
from "payment" p;


-- 27. ¿Qué películas se alquilan por encima del precio medio?
select f."title", f."rental_rate"
from "film" f
where f."rental_rate" > (select avg(f2."rental_rate") from "film" as f2)
order by f."rental_rate" desc, f."title";


-- 28. Muestra el id de los actores que hayan participado en más de 40 películas.
select fa."actor_id", count(fa."film_id") as "numero_peliculas"
from "film_actor" as fa
group by fa."actor_id"
having count(fa."film_id") > 40
order by "numero_peliculas" desc;


-- 29. Obtener todas las películas y, si están disponibles en el inventario, mostrar la
--     cantidad disponible.
/* LEFT JOIN para incluir las películas sin copias (aparecen con 0).
   "copias_en_inventario" = copias totales; "copias_disponibles_ahora" =
   copias que no tienen un alquiler sin devolver. */
select f."film_id",
       f."title",
       count(i."inventory_id") as copias_en_inventario,
       count(i."inventory_id") filter (
           where not exists (select 1
                             from "rental" as r
                             where r."inventory_id" = i."inventory_id"
                               and r."return_date" is null)
       ) as copias_disponibles_ahora
from "film" as f
left join "inventory" as i on i."film_id" = f."film_id"
group by f."film_id", f."title"
order by f."title";


-- 30. Obtener los actores y el número de películas en las que ha actuado.
select a."actor_id", a."first_name", a."last_name", count(fa."film_id") as "numero_peliculas"
from "actor" as a
left join "film_actor" as fa on fa."actor_id" = a."actor_id"
group by a."actor_id", a."first_name", a."last_name"
order by "numero_peliculas" desc, a."last_name";


-- 31. Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso
--     si algunas películas no tienen actores asociados.
select f."title", a."first_name", a."last_name"
from "film" as f
left join "film_actor" as fa on fa."film_id"  = f."film_id"
left join "actor"      as a  on a."actor_id"  = fa."actor_id"
order by f."title", a."last_name";


-- 32. Obtener todos los actores y mostrar las películas en las que han actuado, incluso si
--     algunos actores no han actuado en ninguna película.
select a."first_name", a."last_name", f."title"
from "actor" as a
left join "film_actor" as fa on fa."actor_id" = a."actor_id"
left join "film"       as f  on f."film_id"   = fa."film_id"
order by a."last_name", a."first_name", f."title";