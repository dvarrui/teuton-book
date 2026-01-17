[<< back](../index.md)

```
EN DESARROLLO!!! (Para la versión 3.0.0)
```

# Eventos

Los eventos sirven para definir acciones que se disparan únicamente cuando se producen las condiciones adecuadas.

Sintaxis: 
```ruby
event on: OBJECT, when: CONDITION do ACTIONS end 
```

Los eventos tienen tres partes
* `on: OBJECT`, define el objeto sobre el que se va a definir el evento.
* `when: CONDITION`, define la condición que debe cumplirse sobre el OBJECT para disparar la acción o las acciones.
* `do ACTIONS end`, define la acción o las acciones que se van a ejecutar cuando se dispare el evento.

En una primera versión tendremos los siguientes:

| Tipo      | Elemento       | Descripción |
| --------- | -------------- | ----------- |
| OBJECT    | last_target    | Es el último `target` que se haya evaluado |
| CONDITION | failed         | El estado del objeto es `failed`|
| ACTION    | grades_to_zero | Todos los puntos ganados hasta el momento se ponen a cero |
| ACTION    | stop           | Se para el test |

## Ejemplo 1: acción "stop"

Ejemplo:

```ruby
group "Target con condición de salida" do
  target "Existe el usuario root"
  run "id root"
  expect_ok

  target "Existe el usuario vader", when_fails: :stop
  run "id vader"
  expect_ok

  event on: :last_target, when: :failed, do 
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
* event: 
    * `on: :last_taget`: según el resultado del último target haremos:
    * `when: :failed`
        * Si el resultado es un fallo, entonces el test se termina aquí (para este `case`).
        * Si el resultado es correcto, se continúa de forma normal con el target 3.
* Al finalizar:
    * El resto de los "targets" se quedan sin evaluar.
    * La nota final se obtiene de los targets evaluados y los no evaluados.

## Ejemplo 2: acción "grades_to_zero"

Ejemplo:

```ruby
group "Target con condición de salida" do
  target "Existe el usuario root"
  run "id root"
  expect_ok

  target "Existe el usuario vader"
  run "id vader"
  expect_ok

  event on: :last_target, when: :failed, do 
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
* event:
    * `on: :last_targt`, según el resultado del último target haremos:
    * `when: :failed`
        * Si el resultado es un fallo, entonces todos los "targets" evaluados hasta el momento se ponen a cero.
        * Si el resultado es correcto se continúa de forma normal.
* Al finalizar:
    * Se continúa evaluando al resto de los "targets" no evaluados.
    * La nota final se obtiene de los targets evaluados y los no evaluados.

## Ejemplo 3: Combinar dos acciones

Ejemplo:

```ruby
group "Target con condición de salida" do
  target "Existe el usuario root"
  run "id root"
  expect_ok

  target "Existe el usuario vader"
  run "id vader"
  expect_ok

  event on: :last_target, when: :failed, do 
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
* `event`
    * `on: :last_target`, según el resultado del último target haremos:
    * `when: :failed`
        * Si el resultado es un fallo, entonces todos los "targets" evalaudos hasta el momento se ponen a cero y se termina el test. En este caso, la nota final será cero.
        * Si el resultado es correcto se continúa de forma normal.
