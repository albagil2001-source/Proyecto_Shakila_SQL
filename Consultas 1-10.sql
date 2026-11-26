-- 1. Crea el esquema de la BBDD.

/* El esquema (diagrama entidad-relación) se genera en DBeaver:
   clic derecho sobre la base de datos "shakila" > esquema "public" >
   "Ver diagrama" (View Diagram) .
 */

--2.Muestra los nombres de todas las películas con una clasificación por edades de ‘Rʼ

select f."title" as Nombre_pelicula
from "film" f
where "rating" = 'R'
order by f."title";

--3. Encuentra los nombres de los actores que tengan un “actor_idˮ entre 30  y 40.

select "actor_id" as Id,
concat (a."first_name",' ', a."last_name") as Nombre_actor
from "actor" a
where a."actor_id" between 30 and 40
order by a."actor_id";

--4. Obtén las películas cuyo idioma coincide con el idioma original

select f."film_id" as Id , f."title"as Nombre_pelicula
from "film" f
where f."language_id" = f."original_language_id";

--NO HAY DATOS PORQUE LA COLUMNA f.original_language_id es null--
select f."film_id" as Id, f."title" as Nombre_pelicula
from "film" f
where  f."original_language_id" is not null; -- comprobamos y los resultados son 0

--5. Ordena las películas por duración de forma ascendente.

select f."title" as Nombre_pelicula, f."length" as Duracion
from "film" f
order by f."length" asc;


--6. Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido.


select a."first_name",a."last_name"
from "actor" a
where a."last_name" Ilike '%allen%';

--7. Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación 
--junto con el recuento.


select f."rating" as Clasificacion,
count(f."film_id") as Total_peliculas
from "film" f
group by f."rating";

-- 8. Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración
-- mayor a 3 horas en la tabla film.
select f.title, f.rating, f.length
from film  f
where f.rating = 'PG-13'
   or f.length > 180 -- Porque la hora está en minutos
order by f.title;

-- 9. Encuentra la variabilidad de lo que costaría reemplazar las películas.

select ROUND(VARIANCE(f.replacement_cost), 2) as varianza_coste_reemplazo,
       ROUND(STDDEV(f.replacement_cost), 2)   as desviacion_tipica_coste_reemplazo,
       MIN(f.replacement_cost)                as coste_minimo,
       MAX(f.replacement_cost)                as coste_maximo
from film f;

---- 10. Encuentra la mayor y menor duración de una película de nuestra BBDD.
select 
max(f.length) as Duracion_maxima,
min(f.length ) as Duracion_minima
from "film"f
;

