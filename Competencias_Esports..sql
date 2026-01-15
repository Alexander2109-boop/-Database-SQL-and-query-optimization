CREATE DATABASE IF NOT EXISTS Competencias_Esports;
USE Competencias_Esports;

CREATE TABLE IF NOT EXISTS regiones (
  id_region INT AUTO_INCREMENT PRIMARY KEY,
  nombre_region VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS paises (
  id_pais INT AUTO_INCREMENT PRIMARY KEY,
  nombre_pais VARCHAR(50) NOT NULL,
  id_region INT NOT NULL,
  CONSTRAINT FK_pais_region FOREIGN KEY (id_region) REFERENCES regiones(id_region)
);
CREATE TABLE IF NOT EXISTS tipos_competencia (
  id_tipo_competencia INT AUTO_INCREMENT PRIMARY KEY,
  nombre_tipo VARCHAR(50) NOT NULL
);

CREATE TABLE IF NOT EXISTS competencias (
  id_competencia INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  fecha_inicio DATE NOT NULL,
  fecha_fin DATE NOT NULL,
  id_pais INT,
  premio_total DECIMAL(18,2) CHECK (premio_total > 0),
  id_tipo_competencia INT NOT NULL,
  CONSTRAINT FK_competencia_pais FOREIGN KEY (id_pais) REFERENCES paises(id_pais),
  CONSTRAINT FK_competencia_tipo FOREIGN KEY (id_tipo_competencia) REFERENCES tipos_competencia(id_tipo_competencia)
);



CREATE TABLE IF NOT EXISTS equipos (
  id_equipo INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(100) NOT NULL,
  id_pais INT NOT NULL,
  entrenador VARCHAR(50) NOT NULL,
  CONSTRAINT FK_equipo_pais FOREIGN KEY (id_pais) REFERENCES paises(id_pais)
);

CREATE TABLE IF NOT EXISTS roles (
  id_rol INT AUTO_INCREMENT PRIMARY KEY,
  nombre_rol VARCHAR(30) NOT NULL
);

CREATE TABLE IF NOT EXISTS jugadores (
  id_jugador INT AUTO_INCREMENT PRIMARY KEY,
  nombre VARCHAR(50) NOT NULL,
  edad INT CHECK (edad > 0),
  id_pais INT NOT NULL,
  id_rol INT NOT NULL,
  id_equipo INT NOT NULL,
  CONSTRAINT FK_jugador_pais FOREIGN KEY (id_pais) REFERENCES paises(id_pais),
  CONSTRAINT FK_jugador_rol FOREIGN KEY (id_rol) REFERENCES roles(id_rol),
  CONSTRAINT FK_jugador_equipo FOREIGN KEY (id_equipo) REFERENCES equipos(id_equipo)
);

CREATE TABLE IF NOT EXISTS participaciones (
  id_participacion INT AUTO_INCREMENT PRIMARY KEY,
  id_competencia INT NOT NULL,
  id_equipo INT NOT NULL,
  victorias INT CHECK (victorias >= 0),
  derrotas INT CHECK (derrotas >= 0),
  CONSTRAINT FK_participacion_competencia FOREIGN KEY (id_competencia) REFERENCES competencias(id_competencia),
  CONSTRAINT FK_participacion_equipo FOREIGN KEY (id_equipo) REFERENCES equipos(id_equipo)
);


CREATE TABLE IF NOT EXISTS estadisticas_individuales (
  id_estadistica INT AUTO_INCREMENT PRIMARY KEY,
  id_jugador INT NOT NULL,
  id_competencia INT NOT NULL,
  CONSTRAINT FK_estadistica_jugador FOREIGN KEY (id_jugador) REFERENCES jugadores(id_jugador),
  CONSTRAINT FK_estadistica_competencia FOREIGN KEY (id_competencia) REFERENCES competencias(id_competencia)
);

CREATE TABLE IF NOT EXISTS tipos_detalle (
  id_tipo INT AUTO_INCREMENT PRIMARY KEY,
  nombre_tipo VARCHAR(50) NOT NULL,
  descripcion VARCHAR(100)
); 

CREATE TABLE IF NOT EXISTS estadisticas_detalle (
  id_estadistica_detalle INT AUTO_INCREMENT PRIMARY KEY,
  id_estadistica INT NOT NULL,
  id_tipo INT NOT NULL,
  valor VARCHAR(100) NOT NULL,
  CONSTRAINT FK_estadistica_detalle FOREIGN KEY (id_estadistica) REFERENCES estadisticas_individuales(id_estadistica),
  CONSTRAINT FK_tipo_detalle FOREIGN KEY (id_tipo) REFERENCES tipos_detalle(id_tipo)
);

CREATE TABLE IF NOT EXISTS estadisticas_partidos (
  id_estadistica_partido INT AUTO_INCREMENT PRIMARY KEY,
  id_jugador INT,
  id_competencia INT,
  partidas_jugadas INT,
  victorias INT CHECK (victorias >= 0),
  derrotas INT CHECK (derrotas >= 0),
  CONSTRAINT FK_partido_jugador FOREIGN KEY (id_jugador) REFERENCES jugadores(id_jugador),
  CONSTRAINT FK_partido_competencia FOREIGN KEY (id_competencia) REFERENCES competencias(id_competencia)
);
-- Registros 
USE Competencias_Esports;
-- 1. Catálogo de Tipos de Competencia
INSERT INTO tipos_competencia (nombre_tipo) VALUES
('Individual'),
('Equipo');

-- 2. Regiones
INSERT INTO regiones (nombre_region) VALUES
('Sudamérica'),
('Norteamérica'),
('Europa'),
('Asia');

-- 3. Catálogo de Países
INSERT INTO paises (nombre_pais, id_region) VALUES
('Ecuador', 1),
('Estados Unidos', 2),
('Corea del Sur', 4),
('Japón', 4),
('Alemania', 3),
('Francia', 3),
('España', 3),
('Reino Unido', 3),
('Brasil', 1),
('Argentina', 1),
('México', 2);

-- 4. Competencias (ahora usando id_pais y id_tipo_competencia)
INSERT INTO competencias (nombre, fecha_inicio, fecha_fin, id_pais, premio_total, id_tipo_competencia) VALUES
('Torneo Invierno', '2025-01-10', '2025-01-20', 1, 10000.00, 1),   
('Copa Nacional', '2025-03-15', '2025-03-25', 1, 15000.00, 2),   
('Gran Final 2025', '2025-12-01', '2025-12-10', 2, 30000.00, 2);

-- 5. Equipos (ahora con id_pais en lugar de id_region)
INSERT INTO equipos (nombre, id_pais, entrenador) VALUES
('Dragones', 1, 'Carlos Pérez'),
('Tiburones', 1, 'Luis Gómez'),
('Gladiadores', 1, 'Ana Martínez'),
('Leones', 1, 'Sofía Ramírez'),
('Águilas', 1, 'Jorge Silva'),
('Tigres', 1, 'María López'),
('Lobos', 1, 'Ricardo Díaz'),
('Panteras', 1, 'Elena Torres'),
('Buitres', 1, 'Gabriel Castillo'),
('Cóndores', 1, 'Paula Morales'),
('LA Titans', 2, 'Michael Johnson'),
('Seoul Dragons', 3, 'Kim Min-ho'),
('Tokyo Samurais', 4, 'Hiroshi Tanaka'),
('Berlin Warriors', 5, 'Hans Müller'),
('Paris Phantoms', 6, 'Jean Dupont'),
('Madrid Bulls', 7, 'Carlos Fernández'),
('London Lions', 8, 'William Smith'),
('Rio Strikers', 9, 'Paulo Silva'),
('BA Gladiators', 10, 'Martín Rodríguez'),
('Aztec Power', 11, 'Diego Ramírez');

-- 6. Catálogo de Roles
INSERT INTO roles (nombre_rol) VALUES
('top laner'),
('mid laner'),
('bot laner'),
('jungler'),
('support');

-- 7. Jugadores (usando id_pais e id_rol)
INSERT INTO jugadores (nombre, edad, id_pais, id_rol, id_equipo) VALUES
('Juan', 22, 1, 1, 1),
('Miguel', 24, 1, 2, 2),
('Andrés', 21, 1, 3, 3),
('Luis', 23, 1, 1, 4),
('Carlos', 25, 1, 2, 5),
('Diego', 22, 1, 3, 6),
('Pedro', 24, 1, 1, 7),
('Jorge', 23, 1, 2, 8),
('Miguel Ángel', 21, 1, 3, 9),
('Raúl', 22, 1, 1, 10),
('Kevin', 23, 2, 2, 11),
('Min-Jun', 21, 3, 1, 12),
('Takashi', 22, 4, 3, 13),
('Lukas', 24, 5, 1, 14),
('Pierre', 25, 6, 2, 15),
('Sergio', 23, 7, 3, 16),
('Oliver', 22, 8, 1, 17),
('Rafael', 24, 9, 2, 18),
('Matías', 21, 10, 3, 19),
('José', 23, 11, 1, 20);

-- 8. Participaciones 
INSERT INTO participaciones (id_competencia, id_equipo, victorias, derrotas) VALUES
(1,7,5,3), (2,8,6,2), (3,9,4,4), (1,10,7,1), (1,11,3,5), (1,12,5,2),
(1,13,6,1), (1,14,7,3), (3,15,4,6), (1,16,5,2), (2,17,6,1), (3,18,3,4),
(1,19,7,0), (2,20,5,3), (3,4,4,5), (1,5,6,2), (1,6,3,3), (3,7,7,2),
(1,8,5,1), (2,9,6,2), (1,10,4,4), (1,11,7,1), (1,12,3,5), (3,13,5,2),
(1,14,6,1), (2,15,7,3), (3,16,4,6), (1,17,5,2), (1,18,6,1), (3,19,3,4);

-- 9. Estadísticas Individuales
INSERT INTO estadisticas_individuales (id_jugador, id_competencia) VALUES
(1, 1),(2, 2),(3, 3),(4, 1),(5, 2),
(6, 3),(7, 1),(8, 2),(9, 3),(10, 1),
(11, 2),(12, 3),(13, 1),(14, 2),(15, 3),
(16, 1),(17, 2),(18, 3),(19, 1),(20, 2);

-- 10. Tipos de Detalle
INSERT INTO tipos_detalle (nombre_tipo, descripcion) VALUES
('Comentario', 'Opiniones o anotaciones generales'),
('Crítica', 'Observaciones con oportunidades de mejora');

-- 11. Estadísticas Detalle
INSERT INTO estadisticas_detalle (id_estadistica, id_tipo, valor) VALUES
(1, 1, 'Excelente desempeño como top laner'),
(2, 1, 'Gran habilidad como mid laner'),
(3, 1, 'Muy competente como bot laner');

-- 12. Estadísticas Partidos
INSERT INTO estadisticas_partidos (id_jugador, id_competencia, partidas_jugadas, victorias, derrotas) VALUES
(1, 1, 7, 5, 2),
(2, 2, 7, 6, 1),
(3, 3, 7, 4, 3);

SELECT * FROM paises;
SELECT * FROM regiones;
SELECT * FROM tipos_competencia;
SELECT * FROM competencias;
SELECT * FROM equipos;
SELECT * FROM roles;
SELECT * FROM jugadores;
SELECT * FROM participaciones;
SELECT * FROM estadisticas_individuales;
SELECT * FROM tipos_detalle;
SELECT * FROM estadisticas_detalle;
SELECT * FROM estadisticas_partidos;

-- ¿Qué equipo tiene el mejor desempeño en competencias internacionales?
SELECT e.nombre AS Equipo,
       SUM(p.victorias) AS Victorias
FROM equipos e
INNER JOIN participaciones p ON e.id_equipo = p.id_equipo
INNER JOIN competencias c ON p.id_competencia = c.id_competencia
INNER JOIN paises pa ON c.id_pais = pa.id_pais
WHERE pa.nombre_pais <> 'Ecuador'
GROUP BY e.nombre
ORDER BY Victorias DESC
LIMIT 1;
-- ¿Qué jugador tiene el mayor promedio de victorias por temporada?
-- Suponiendo que 1 tmeporada = 1 año
-- PROMEDIO = SUM()/LEN()
SELECT j.nombre AS Nombre_Jugador,
       ROUND(SUM(ep.victorias) / COUNT(DISTINCT YEAR(c.fecha_inicio)), 2) AS Promedio_Victorias
FROM jugadores j
INNER JOIN estadisticas_partidos ep ON j.id_jugador = ep.id_jugador
INNER JOIN competencias c ON ep.id_competencia = c.id_competencia
GROUP BY j.nombre
ORDER BY Promedio_Victorias DESC
LIMIT 1;
-- ¿Qué competencias tienen mayor participación de equipos?
SELECT c.nombre AS Nombre_Competencia,
       COUNT(p.id_equipo) AS Participacion_Equipo
FROM competencias c
INNER JOIN participaciones p ON c.id_competencia = p.id_competencia
GROUP BY c.nombre
ORDER BY Participacion_Equipo DESC;

USE Competencias_Esports;
-- Vistas 
-- 1
CREATE OR REPLACE VIEW vw_participaciones_detalle AS
SELECT 
    p.id_participacion,
    c.nombre AS competencia,
    e.nombre AS equipo,
    p.victorias,
    p.derrotas
FROM participaciones p
INNER JOIN competencias c ON p.id_competencia = c.id_competencia
INNER JOIN equipos e ON p.id_equipo = e.id_equipo;

SELECT * FROM vw_participaciones_detalle;

-- 2
CREATE OR REPLACE VIEW vw_promedio_victorias_jugador AS
SELECT 
    j.nombre AS Nombre_Jugador,
    ROUND(SUM(sp.victorias) / COUNT(DISTINCT YEAR(c.fecha_inicio)), 2) AS Promedio_Victorias
FROM jugadores j
INNER JOIN estadisticas_partidos sp ON j.id_jugador = sp.id_jugador
INNER JOIN competencias c ON sp.id_competencia = c.id_competencia
GROUP BY j.nombre;

SELECT * FROM vw_promedio_victorias_jugador
ORDER BY Promedio_Victorias DESC
LIMIT 1;

-- 3
CREATE OR REPLACE VIEW vw_participacion_equipo AS
SELECT 
    c.nombre AS Nombre_Competencia,
    COUNT(p.id_equipo) AS Participacion_Equipo
FROM competencias c
INNER JOIN participaciones p ON c.id_competencia = p.id_competencia
GROUP BY c.nombre;

SELECT * FROM vw_participacion_equipo
ORDER BY Participacion_Equipo DESC;



-- 1
EXPLAIN
SELECT e.nombre, SUM(p.victorias) AS total_victorias
FROM participaciones p
INNER JOIN equipos e ON p.id_equipo = e.id_equipo
INNER JOIN competencias c ON p.id_competencia = c.id_competencia
INNER JOIN tipos_competencia tc ON c.id_tipo_competencia = tc.id_tipo_competencia
WHERE tc.nombre_tipo = 'Equipo'
GROUP BY e.nombre
ORDER BY total_victorias DESC
LIMIT 1;

-- 2
EXPLAIN
SELECT j.nombre, AVG(sp.victorias) AS promedio_victorias
FROM estadisticas_partidos sp
INNER JOIN jugadores j ON sp.id_jugador = j.id_jugador
GROUP BY j.nombre
ORDER BY promedio_victorias DESC
LIMIT 1;

-- 3
EXPLAIN
SELECT c.nombre AS Nombre_Competencia,
       COUNT(p.id_equipo) AS Participacion_Equipo
FROM competencias c
INNER JOIN participaciones p ON c.id_competencia = p.id_competencia
GROUP BY c.nombre;

