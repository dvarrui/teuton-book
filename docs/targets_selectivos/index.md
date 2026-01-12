[<< back](../index.md)

# Targets selectivos

Habitualmente, cuando ejecutamos un test `start.rb` queremos evaluar todos los `targets` sobre las máquinas definidas en el fichero `config.yaml`. Para ello, lo habitual es que todos las `cases` hayan establecido valor para los mismos parámetros. Esto es lo más habitual.

## Ejemplo 1

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
group "Target uniforme" do
  target "Existe el usuario obiwan"
  run "id obiwan"
  expect_ok
end
```

```
$ teuton 01.example 
 
CASE RESULTS
+------+----------+-------+-------+
| CASE | MEMBERS  | GRADE | STATE |
| 01   | Alumno 1 | 0.0   | ?     |
| 02   | Alumno 2 | 0.0   | ?     |
| 03   | Alumno 3 | 0.0   | ?     |
+------+----------+-------+-------+
```

## Ejemplo 2

La herramienta Teuton es muy flexible y permite que definir diferentes parámetros para cada `case`. Se entiende que son casos "particulares" que van a tener un tratamiento "especial". Porque si se trataran todos los `cases` por igual entonces el sentido común nos dice que deberían tener los mismos parámetros. 

Veamos [02.example](./02.example/):

```yaml
# 02.example/config.yaml
---
global:
cases:
- tt_members: Alumno 1
- tt_members: Alumno 2
  rol: sith
- tt_members: Alumno 3
```

```ruby
# 02.example/start.rb
group "Target selectivo" do
  if get(:rol) == "sith"
    # Evaluar un target especial
    log "En este caso tenemos a un SITH"

    target "No existe el usuario obiwan"
    run "id obiwan"
    expect_fail
  else
    # Evaluar el target estándar
    target "Existe el usuario obiwan"
    run "id obiwan"
    expect_ok
  end
end
```

> Hemos añadido una sentencia `log` simplemente por añadir más información en el informe de salida.

```
$ teuton 02.example             
 
CASE RESULTS
+------+----------+-------+-------+
| CASE | MEMBERS  | GRADE | STATE |
| 01   | Alumno 1 | 0.0   | ?     |
| 02   | Alumno 2 | 100.0 | ✔     |
| 03   | Alumno 3 | 0.0   | ?     |
+------+----------+-------+-------+
```

Informe de salida `cat/02.example/case-02.txt`

```
LOGS
    [18:21:11]  INFO: En este caso tenemos a un SITH

GROUPS
- Target selectivo
    01 (1.0/1.0)
        Description : No existe el usuario obiwan
        Command     : id obiwan
        Output      : id: ‘obiwan’: no existe ese usuario
        Duration    : 0.002 (local)
        Alterations : Read exit code
        Expected    : Greater than 0
        Result      : 1
```
