[<< back](../index.md)

# Tipos de "targets"

1. [Estándar](#1-target-estándar)
2. [Con peso](#2-target-con-peso)
3. [Penalización](#3-target-de-penalización)
4. [Caso especial](#4-target-de-un-caso-especial)
5. [Personalizado](#5-target-personalizado)
6. [DEVEL: con respuesta al fallo](#6-target-con-respuesta-al-fallo)
    * Acción `:stop`
    * Acción `:zero`
    * Acción `:clean`

## 1. Target estándar

Normalmente, cuando ejecutamos un test `start.rb` queremos evaluar todos los `targets` sobre todas las máquinas definidas en el fichero `config.yaml`. En este caso, todos las `cases` tienen los mismos parámetros.

Veamos [01.example](./01.example/):

```yaml
# 01.example/config.yaml
---
global:
cases:
- tt_members: Alumno 1
- tt_members: Alumno 2
- tt_members: Alumno 3
```

```ruby
# 01.example/start.rb
# 01.example/start.rb
group "Target estándar" do
  target "Existe el usuario obiwan"
  run "id obiwan"
  expect_ok

  target "No existe el usuario vader"
  run "id vader"
  expect_fail
end
```

```
$ teuton 01.example 
 
CASE RESULTS
+------+----------+-------+-------+
| CASE | MEMBERS  | GRADE | STATE |
| 01   | Alumno 1 | 50.0  |       |
| 02   | Alumno 2 | 50.0  |       |
| 03   | Alumno 3 | 50.0  |       |
+------+----------+-------+-------+
```

Todos los `cases` tienen el 50% porque el usuario "vader" no existe y es lo esperado.

## 2. Target con peso

Por defecto, los targets tiene peso 1.0, pero se puede modificar para que tengan distintos valores según su importancia. En este caso vamos a modificar el ejemplo anterior para que sea más importante el "target 1" del usuario `obiwan` que el "target 2" con el usuario `vader`.

Veamos [02.example](./02.example/):

```ruby
# 02.example/start.rb
group "Target con pesos" do
  target "Existe el usuario obiwan", weight: 2.0
  run "id obiwan"
  expect_ok

  target "No existe el usuario vader"
  run "id vader"
  expect_fail
end
```

> Los pesos pueden ser valores números enteros o números decimales.

```
$ teuton 02.example 
 
CASE RESULTS
+------+----------+-------+-------+
| CASE | MEMBERS  | GRADE | STATE |
| 01   | Alumno 1 | 33.0  | ?     |
| 02   | Alumno 2 | 33.0  | ?     |
| 03   | Alumno 3 | 33.0  | ?     |
+------+----------+-------+-------+
```

Todos los `cases` tienen el 33% porque sólo se cumple el target 2 que es el 33% del total.

## 3. Target de penalización

El `target` de penalización se usa para "castigar" situaciones "prohibidas". Por ejemplo, queremos que el alumno tenga el usuario `root`, pero si existe el usuario `vader` entonces penalizamos al alumno con -1.0.

Por defecto, los `targets` tiene peso 1.0, pero se puede modificar para que tengan distintos valores según su importancia. En este caso vamos a modificar el ejemplo anterior para que sea más importante el target 1 del usuario `obiwan` que el target 2 con el usuario `vader`.

Veamos [02.example](./02.example/):

```ruby
# 03.example/start.rb
group "Target de penalización" do
  target "Existe el usuario roo"
  run "id root"
  expect_ok

  target "El usuario vader penaliza", weight: -1
  run "id vader"
  expect_ok
end
```

> La penalización puede ser un entero negativo o un número decimal negativo.

Si el usuario `vader` no existe, entonces no hay penalización:
```
$ teuton 03.example 
 
CASE RESULTS
+------+----------+-------+-------+
| CASE | MEMBERS  | GRADE | STATE |
| 01   | Alumno 1 | 100.0 | ✔     |
| 02   | Alumno 2 | 100.0 | ✔     |
| 03   | Alumno 3 | 100.0 | ✔     |
+------+----------+-------+-------+
```

Si el usuario `vader` existe, entonces si hay penalización:
```
$ teuton 03.example
 
CASE RESULTS
+------+----------+-------+-------+
| CASE | MEMBERS  | GRADE | STATE |
| 01   | Alumno 1 | 0.0   | ?     |
| 02   | Alumno 2 | 0.0   | ?     |
| 03   | Alumno 3 | 0.0   | ?     |
+------+----------+-------+-------+
```

Todos los `cases` tienen el 33% porque sólo se cumple el target 2 que es el 33% del total.

## 4. Target de un caso especial

Teuton es muy flexible y se puede adaptar a casi cualquier estilo docente. En este caso vamos a definir un parámetro diferente excluivo para un `case`. Se entiende que éste `case` es un caso "particular" y que va a tener un tratamiento "especial". Porque si se trataran todos los `cases` por igual entonces el sentido común nos dice que deberían tener los mismos parámetros. 

Veamos [04.example](./04.example/):

```yaml
# 04.example/config.yaml
---
global:
cases:
- tt_members: Alumno 1
- tt_members: Alumno 2
  rol: jedi
- tt_members: Alumno 3
```

El "Alumno 2" tiene un parámetro diferente. Usaremos el valor de este parámetro para decidir si ejecutamos un target u otro.

```ruby
## 04.example/start.rb
group "Target caso especial" do
  if get(:rol) == "jedi"
    # Evaluar un target especial para los jedi
    log "En este caso tenemos un JEDI"

    target "No existe el usuario quigon"
    run "id quigon"
    expect_fail
  else
    # Evaluar el target estándar
    target "Existe el usuario maul"
    run "id maul"
    expect_ok
  end
end
```

> **NOTA**: Hemos añadido una sentencia `log`, para registrar este caso especial en el informe de salida.

```
$ teuton 04.example
 
CASE RESULTS
+------+----------+-------+-------+
| CASE | MEMBERS  | GRADE | STATE |
| 01   | Alumno 1 | 0.0   | ?     |
| 02   | Alumno 2 | 100.0 | ✔     |
| 03   | Alumno 3 | 0.0   | ?     |
+------+----------+-------+-------+
```

Informe de salida `cat/04.example/case-02.txt`

```
LOGS
    [20:06:04]  INFO: En este caso tenemos un JEDI

GROUPS
- Target condicional
    01 (1.0/1.0)
        Description : No existe el usuario quigon
        Command     : id quigon
        Output      : id: ‘quigon’: no existe ese usuario
        Duration    : 0.002 (local)
        Alterations : Read exit code
        Expected    : Greater than 0
        Result      : 1
```

## 5. Target personalizado

Puede ser que queramos ejecutar el mismo `target` a todos los `cases` pero "diferente". Esto es, vamos a "personalizar" el `target` para que sea parecido en cada `case` pero no exactamente igual. Es como el caso anterior de "caso especial" pero en este caso consideramos a todos los `cases` como casos especiales.

Podríamos incluir en el código del test muchas sentencias `if-end`, pero lo vamos a hacer de forma más sencilla. En este caso tenemos 1 target que evalua la presencia del usuario `username`, donde `username` tendrá un valor diferente para cada `case`.

Veamos [05.example](./05.example/):

```yaml
# 05.example/config.yaml
---
global:
cases:
- tt_members: Alumno 1
  username: yoda
- tt_members: Alumno 2
  username: emperador
- tt_members: Alumno 3
  username: root
```

```ruby
## 05.example/start.rb
group "Target personalizado" do

  target "Existe el usuario #{get(:username)}"
  run "id #{get(:username)}"
  expect_ok

end
```

Sólo tenemos 1 `target`, pero como el valor devuelto por `get(:username)` es diferente para cada `case`, entonces el comando `run` que se ejecuta en cada uno es ligeramente diferente. Lo hemos "personalizado" para cada `case`.

```
$ teuton 05.example 
 
CASE RESULTS
+------+----------+-------+-------+
| CASE | MEMBERS  | GRADE | STATE |
| 01   | Alumno 1 | 0.0   | ?     |
| 02   | Alumno 2 | 0.0   | ?     |
| 03   | Alumno 3 | 100.0 | ✔     |
+------+----------+-------+-------+
```

## 6. Target con respuesta al fallo

### 6.1 Acción "stop"

Ejemplo:

```ruby
group "Target con condición de salida" do
  target "Existe el usuario root"
  run "id root"
  expect_ok

  target "Existe el usuario vader", when_fails: :stop
  run "id vader"
  expect_ok

  target "Existe el usuario mail"
  run "id mail"
  expect_ok
end
```

Es test se ejecuta de la siguiente forma:
* Se evalúa el `target` 1 y se puntúa.
* Se evalúa el `target` 2 y se puntúa.
    * Si el resultado es correcto, se continúa de forma normal.
    * Si el resultado es un fallo, entonces el test se termina en este `case`.
* El resto de los "targets" pendientes de evaluar se consideran como fallos.
* La nota final se obtiene de los targets evaluados y los no evaluados.

### 6.2 Acción "zero"

Ejemplo:

```ruby
group "Target con condición de salida" do
  target "Existe el usuario root"
  run "id root"
  expect_ok

  target "Existe el usuario vader", when_fails: :zero
  run "id vader"
  expect_ok

  target "Existe el usuario mail"
  run "id mail"
  expect_ok
end
```

Es test se ejecuta de la siguiente forma:
* Se ejecuta el `target` 1 y se evalúa.
* Se ejecuta el `target` 2 y se evalúa.
    * Si el resultado es correcto se continúa de forma normal.
    * Si el resultado es un fallo, entonces el test se termina en este `case`.
* La nota final es cero.

### 6.3 Acción "clean"

Ejemplo:

```ruby
group "Target con condición de salida" do
  target "Existe el usuario root"
  run "id root"
  expect_ok

  target "Existe el usuario vader", when_fails: :clean
  run "id vader"
  expect_ok

  target "Existe el usuario mail"
  run "id mail"
  expect_ok
end
```

Es test se ejecuta de la siguiente forma:
* Se ejecuta el `target` 1 y se evalúa.
* Se ejecuta el `target` 2 y se evalúa.
    * Si el resultado es correcto, se continúa de forma normal.
    * Si el resultado es un fallo, entonces todas las puntuaciones obtenidas hasta ese momento se ponen a cero.
    * Se continúa de forma normal.
* Se ejecuta el `target` 3 y se evalúa.
