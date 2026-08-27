[<<back](README.md)

# Tutorial: evaluar SQL y la creación de bases de datos con Teuton

## Ejercicio

* Le pedimos a los alumnos que creen una base de datos Sqlite.
* Dentro se crea la tabla `characters` con los campos: `name` tipo varchar, y `rol` tipo varchar.

Ejemplo de base de datos:

```bash
$ sqlite3 files/database_01.db

sqlite> .schema characters
CREATE TABLE characters ( name varchar(255), rol varchar(255));

sqlite> select * from characters;
Obiwan|Jedi
```

* A continuación, le pedimos a los estudiantes que creen una sentencia SQL, dentro de su propio fichero, para por ejemplo: seleccionar todos los characters con el rol Jedi.

Ejemplo:

```bash
$ cat files/query_01.sql

select * from characters where rol='Jedi';
```

> Esto sería un ejemplo de la creación del ejercicio.

## Teuton test

Ahora vamos a crear el test que evalúa dicho ejercicio:

* Definimos los "targets" (fichero `start.rb`):

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

* Configuramos los parámetros que necesitamos (Fichero `config.yaml`):

```yaml
---
global:
  folder: files
cases:
- tt_members: student_1
  database: database_01.db
  query: query_01.sql
```

## Run test

```bash
$ teuton demo                               

CASE RESULTS
+------+-----------+-------+-------+
| CASE | MEMBERS   | GRADE | STATE |
| 01   | student_1 | 100.0 | ✔     |
+------+-----------+-------+-------+
```
