## 04.example/start.rb
group "Target caso especial" do
  if get(:rol) == "jedi"
    # Evaluar un target especial
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

play do
  show
  export
end
