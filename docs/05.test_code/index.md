[<<back](README.md)

# Tutorial: evaluar código con Teuton

Vamos a testear código usando Teuton.

## Exercicio

Le pedimos a los alumnos un script para realizar sumas y multuplicaciones.

Modo de uso:

```bash
$ files/math_1.py 3 4
Sum = 7
Mul = 12
```

## Ejemplo "demo1"

Definimos los "targets" `sum` y `mul`:

```ruby
# File: start.rb
group "Test code example" do
  # Reading filepath from config file
  filepath = "./#{get(:folder)}/#{get(:filename)}"

  target "Sum"
  run "#{filepath} 3 4"
  expect [ "Sum", "7" ] # Using Array/List of required items

  target "Mul"
  run "#{filepath} 3 4"
  expect /Mul\s+=\s+12/ # Using a regular expresion
end
```

Definimos los parámetros que necesitamos en la configuración:

```yaml
# File: config.yaml
---
global:
  folder: files
cases:
- tt_members: student_1_python
  filename: math_1.py
- tt_members: student_2_python
  filename: math_2.py
- tt_members: student_3_ruby
  filename: math_3.rb
```

* Copiamos los scripts de los alumnos en la carpeta `demo/files`.
* Ejecutamos el test de Teuton:

```bash
$ teutonx demo1
------------------------------------
Started at 2026-08-27 10:48:32 +0100
......
Finished in 0.160 seconds
------------------------------------
 
CASE RESULTS
+------+------------------+-------+-------+
| CASE | MEMBERS          | GRADE | STATE |
| 01   | student_1_python | 100.0 | ✔     |
| 02   | student_2_python | 100.0 | ✔     |
| 03   | student_3_ruby   | 100.0 | ✔     |
+------+------------------+-------+-------+
```

## Ejemplo "demo2"

En este ejemplo, partimos del anterior y en lugar de comprobar únicamente una suma y una multiplicación, vamos a comprobar muchas sumas y muchas multiplicaciones.

Empezamos modificando el código en 2 groups. Uno para las sumas y otro para las multiplicaciones. Lo hacemos así, simplemente por motivos didácticos y de claridad.

En el group de las sumas, añadimos una lista de 3 elementos que vamos a usar para comprobar. A su vez, cada elemento de la lista está compuesto de 2 números que usaremos para hacer la suma.

```ruby
values = [ [1, 0], [3, 2], [7, 9] ]
```

A continuación hacer un bucle con el iterador `for ... in values`. Donde vamos leyendo cada elemento contenido en `values` y repetimos la tarea.

```ruby
group "Test Sum" do
  filepath = "./#{get(:folder)}/#{get(:filename)}"
  values = [ [1, 0], [3, 2], [7, 9] ]

  for number1, number2 in values
    target "Script calculates the sum of 2 numbers"
    run "#{filepath} #{number1} #{number2}"
    expect ["Sum", number1 + number2 ]
  end
end
```

* Ejecutamos el test:

```bash
$ teuton demo2 
------------------------------------
Started at 2026-08-27 11:03:05 +0100
..................
Finished in 0.474 seconds
------------------------------------
 
CASE RESULTS
+------+------------------+-------+-------+
| CASE | MEMBERS          | GRADE | STATE |
| 01   | student_1_python | 100.0 | ✔     |
| 02   | student_2_python | 100.0 | ✔     |
| 03   | student_3_ruby   | 100.0 | ✔     |
+------+------------------+-------+-------+
```

Hemos aumentado x6 el número de tests realizados sin apenas tener que crear nuevo código.