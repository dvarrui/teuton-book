[<<back](README.md)

# Tutorial: evaluar SQL y la creación de bases de datos con Teuton

## Ejercicio

* Le pedimos a los alumnos que creen una base de datos Sqlite.
* Dentro se crea la tabla `characters` con los campos: `name` tipo varchar, y `rol` tipo varchar.

Ejemplo de base de datos:

```bash
$ sqlite3 files/student1/sqlite.db

sqlite> .schema characters
CREATE TABLE characters ( name varchar(255), rol varchar(255));

sqlite> select * from characters;
Obiwan|Jedi
```

* A continuación, le pedimos a los estudiantes que creen una sentencia SQL, dentro de su propio fichero, para por ejemplo: seleccionar todos los characters con el rol Jedi.

Ejemplo:

```bash
$ cat files/student1/query01.sql

select * from characters where rol='Jedi';
```

> Esto sería un ejemplo de la creación del ejercicio.

## Teuton test

Ahora vamos a crear el test que evalúa dicho ejercicio:

* Definimos los "targets" (fichero `demo/start.rb`):

```ruby
group "Test SQL and database content" do
  database = "#{get(:folder)}/#{get(:database)}"
  query = "#{get(:folder)}/#{get(:query)}"

  target "Database schema"
  run "sqlite3 #{database} '.schema characters'"
  expect "name varchar", "rol varchar"

  target "Query Jedi"
  run "sqlite3 #{database} '.read #{query}'"
  expect "Obiwan", "Jedi"
end
```

* Configuramos los parámetros que necesitamos (Fichero `demo/config.yaml`):

```yaml
---
global:
  folder: files
cases:
- tt_members: Student 01
  database: student1/sqlite.db
  query: student1/query01.sql
- tt_members: Student 02
  database: student2/sqlite.db
  query: student2/query01.sql
```

## Run test

```bash
$ teuton demo 
------------------------------------
Started at 2026-08-27 12:18:28 +0100
F.F.
Finished in 0.010 seconds
------------------------------------
 
CASE RESULTS
+------+------------+-------+-------+
| CASE | MEMBERS    | GRADE | STATE |
| 01   | Student 01 | 100.0 | ✔     |
| 02   | Student 02 | 0.0   | ?     |
+------+------------+-------+-------+
```

# Más ideas

En los ejemplos anteriores estamos ejecutando las sentencias SQL del alumno1 contra la base de datos proporcionada por el propio alumno1.

Para evaluar si la base de datos está bien creada, el profesor necesitará lanzar sentencias SQL confeccionadas por él mismo contra la base de datos de cada alumno. Pero para estar bien seguro de que las sentencias SQL proporcionadas por los alumnos son correctas, el profesor necesitará lanzar las sentencias SQL del alumno contra una base de datos controlada por el propio profesor (Por ejemplo: `files/teacher/sqlite.db`).

Ya que el alumno puede "hacer trampas" si adapta el contenido de las tablas de su porpia base de datos para que su sentencia SQL de el resultado esperado por el profesor aunque esté mal construida.