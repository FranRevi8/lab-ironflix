drop database if exists Ironflix;
create database Ironflix;
use Ironflix;

create table Usuarios(
usuario_id INT auto_increment primary key,
nombre VARCHAR(100),
email VARCHAR(100)
);

create table Peliculas(
pelicula_id INT auto_increment primary key,
titulo VARCHAR(100),
genero VARCHAR(50),
ano_estreno YEAR
);

create table Views(
view_id INT auto_increment primary key,
pelicula_id INT,
usuario_id INT,
fecha_view DATE,
FOREIGN KEY (usuario_id) REFERENCES Usuarios(usuario_id),
FOREIGN KEY (pelicula_id) REFERENCES Peliculas(pelicula_id)
);

-- Insertar registros en la tabla Usuarios
INSERT INTO Usuarios (nombre, email) VALUES
('Juan Perez', 'juan.perez@example.com'),
('Maria Lopez', 'maria.lopez@example.com'),
('Carlos Garcia', 'carlos.garcia@example.com'),
('Ana Torres', 'ana.torres@example.com'),
('Luis Fernandez', 'luis.fernandez@example.com');

-- Insertar registros en la tabla Peliculas
INSERT INTO Peliculas (titulo, genero, ano_estreno) VALUES
('Inception', 'Ciencia Ficción', 2010),
('The Matrix', 'Acción', 1999),
('Interstellar', 'Ciencia Ficción', 2014),
('The Godfather', 'Drama', 1972),
('Pulp Fiction', 'Crimen', 1994);

-- Insertar registros en la tabla Views
INSERT INTO Views (pelicula_id, usuario_id, fecha_view) VALUES
(1, 1, '2024-01-01'),
(2, 2, '2024-01-02'),
(3, 3, '2024-01-03'),
(4, 4, '2024-01-04'),
(5, 5, '2024-01-05');

-- 4

select u.nombre as Usuario, p.titulo as Pelicula
from Usuarios u
join Views v on v.usuario_id = u.usuario_id
join Peliculas p on p.pelicula_id = v.pelicula_id;

select p.titulo as Pelicula, count(v.view_id) as Reproducciones
from Peliculas p
join Views v on v.pelicula_id = p.pelicula_id
group by Pelicula;

select u.nombre as Usuario, count(v.view_id) as Reproducciones
from Usuarios u
join Views v on v.usuario_id = u.usuario_id
group by Usuario;

select p.titulo as Pelicula, p.genero as Genero
from Peliculas p
order by Genero ASC;

-- 5 -- La consulta devuelve las peliculas visualizadas hoy.

set @today = curdate();

select p.titulo as Titulo, count(v.view_id) as Visualizaciones
from Peliculas p
join Views v on p.pelicula_id = v.pelicula_id and v.fecha_view = @today
group by Titulo;

-- 6 

DELIMITER $$

create procedure usuarios_checked()
begin
	declare done BOOLEAN default false;
	declare id_user INT;
	declare nombre_actual VARCHAR(100);

	declare cursor_usuarios cursor for select usuario_id, nombre from Usuarios;
	declare continue handler for not found set done = true;

	open cursor_usuarios;

	read_loop: loop
		fetch cursor_usuarios into id_user, nombre_actual;
		
		if done then 
			leave read_loop;
		end if;
	
		update Usuarios set nombre = CONCAT(nombre_actual, '_checked') where usuario_id = id_user;
		
	end loop;

	close cursor_usuarios;
	
end $$

DELIMITER ;

call usuarios_checked();






























