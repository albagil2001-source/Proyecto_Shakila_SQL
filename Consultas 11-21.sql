--11. Encuentra lo que costó el antepenúltimo alquiler ordenado por día.


select r."rental_id", r."rental_date", p.amount
from "rental" as r
left join "payment" as p 
on p."rental_id" = r.rental_id
order by r."rental_date" desc, r."rental_id" desc
limit 1 offset 2;

-- 12. Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC-17’ ni ‘G’
--  en cuanto a su clasificación.
select f."title" as Nombre_pelicula , f."rating"
from"film" f
where f."rating" not in ('NC-17','G');

-- 13. Encuentra el promedio de duración de las películas para cada clasificación de la
--     tabla film y muestra la clasificación junto con el promedio de duración.
select f."rating", round(avg(f."length"), 2) as duracion_media
from "film" f
group by f."rating"
order by duracion_media desc;


-- 14. Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos.

select f."title", f."length"
from "film" f
where f."length" > 180
order by f."length" desc, f."title";


-- 15. ¿Cuánto dinero ha generado en total la empresa?
select sum(amount)
from "payment" p;

-- 16. Muestra los 10 clientes con mayor valor de id.

select c."customer_id", c."first_name", c."last_name"
from "customer"c 
order by "customer_id" desc
limit 10;


-- 17. Encuentra el nombre y apellido de los actores que aparecen en la película con
--     título ‘Egg Igby’.

select a. "first_name", a."last_name", f."title" 
from "actor" a
join "film_actor" fa on a."actor_id" = fa. "actor_id"
join "film" f on f."film_id" = fa."film_id"  
where UPPER(F."title")= UPPER('Egg Igby')
; 


-- 18. Selecciona todos los nombres de las películas únicos.
select distinct f."title"
from "film" f
order by "title";

---- 19. Encuentra el título de las películas que son comedias y tienen una duración mayor
--     a 180 minutos en la tabla “film”.

select f."title" as titulo, c."name"as categoria
from "film" f
join "film_category" fc on f."film_id" = fc."film_id"
join "category" c on fc."category_id"  = c."category_id" 
where "length"> '180'
and UPPER (c."name") = UPPER ('Comedy')
order by f."title";

--20. Encuentra las categorías de películas que tienen un promedio de duración superior
--     a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración.

select c."name" as categoria, round(avg(f."length"), 2) as duracion_media
from "category" c
join "film_category" fc on fc."category_id" = c."category_id"
join "film" f  on f."film_id" = fc."film_id"
group by c."name"
having avg(f."length") > 110
order by duracion_media desc;

--21. ¿Cuál es la media de duración del alquiler de las películas?

select round (AVG("rental_duration"),2) as Media_duracion_alquiler
from "film" f;




