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

play do
  show
  export
end
