[<< back](../index.md)

```
EN DESARROLLO!!!
Para la versión 4.0.0
```

# Disparadores de acciones


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
