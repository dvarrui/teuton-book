[<<back](README.md)

# Test code

Vamos a testear código usando Teuton.

## Exercicio

Le pedimos a los alumnos un script para realizar sumas y multuplicaciones.

Modo de uso:

```bash
$ demo/files/math_1.py 3 4
Sum = 7
Mul = 12
```

## Ejemplo

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
  folder: demo/files
cases:
- tt_members: student_1
  filename: math_1.py
- tt_members: student_2
  filename: math_2.py
```

* Copiamos los scripts de los alumnos en la carpeta `demo/files`.
* Ejecutamos el test de Teuton:

```bash
$ teuton demo

CASE RESULTS
+------+-----------+-------+-------+
| CASE | MEMBERS   | GRADE | STATE |
| 01   | student_1 | 100.0 | ✔     |
| 02   | student_2 | 100.0 | ✔     |
+------+-----------+-------+-------+
```
