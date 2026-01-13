# 06.example/start.rb
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

play do
  show
  export
end
