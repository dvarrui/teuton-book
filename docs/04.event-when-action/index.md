[<< back](../index.md)

```
EN DESARROLLO!!!
Para la versión 4.0.0
```

# Disparadores de acciones

Vamos a tener la posibilidad de invocar las siguientes acciones:

Acciones:
* **stop**: Se da la orden de para el test en ese instante.
* **grades_to_zero**: Todos los puntos ganados hasta el momento se ponen a cero, pero el test continúa.

Evento disparador:
* El evento es lo que dispara la acción. De momento sólo tenemos definido un evento.
* Evento **last_target_failed**: Este evento se produce cuando el último `target` evaluado no es correcto.

## Acción "stop"

Ejemplo:

```ruby
group "Target con condición de salida" do
  target "Existe el usuario root"
  run "id root"
  expect_ok

  target "Existe el usuario vader", when_fails: :stop
  run "id vader"
  expect_ok

  when_event :last_target_failed, do 
    stop
  end

  target "Existe el usuario mail"
  run "id mail"
  expect_ok
end
```

Es test se ejecuta de la siguiente forma:
* target 1: Se evalúa y se puntúa.
* target 2: Se evalúa y se puntúa.
* when_event: Según el resultado del último target haremos:
    * Si el resultado es correcto, se continúa de forma normal con el target 3.
    * Si el resultado es un fallo, entonces el test se termina aquí para este `case`.
* Al finalizar:
    * El resto de los "targets" pendientes de evaluar se consideran como fallos.
    * La nota final se obtiene de los targets evaluados y los no evaluados.

## Acción "grades_to_zero"

Ejemplo:

```ruby
group "Target con condición de salida" do
  target "Existe el usuario root"
  run "id root"
  expect_ok

  target "Existe el usuario vader"
  run "id vader"
  expect_ok

  when_event :last_target_failed, do 
    grades_to_zero
  end

  target "Existe el usuario mail"
  run "id mail"
  expect_ok
end
```

Es test se ejecuta de la siguiente forma:
* target 1: Se ejecuta y se evalúa.
* target 2: Se ejecuta y se evalúa.
* when_event: Según el resultado del último target haremos:
    * Si el resultado es correcto se continúa de forma normal.
    * Si el resultado es un fallo, entonces todas las notas recopiladas hasta el momento se ponen a cero.
* Al finalizar:
    * Se continúa evaluando al resto de los "targets" pendientes.
    * La nota final se obtiene de los targets evaluados y los no evaluados.

## Combinamos las dos acciones

Ejemplo:

```ruby
group "Target con condición de salida" do
  target "Existe el usuario root"
  run "id root"
  expect_ok

  target "Existe el usuario vader"
  run "id vader"
  expect_ok

  when_event :last_target_failed, do 
    grades_to_zero
    stop
  end

  target "Existe el usuario mail"
  run "id mail"
  expect_ok
end
```

Es test se ejecuta de la siguiente forma:
* target 1: Se ejecuta y se evalúa.
* target 2: Se ejecuta y se evalúa.
* when_event: Según el resultado del último target haremos:
    * Si el resultado es correcto se continúa de forma normal.
    * Si el resultado es un fallo, entonces todas las notas recopiladas hasta el momento se ponen a cero y se termina el test. La nota final es cero.
