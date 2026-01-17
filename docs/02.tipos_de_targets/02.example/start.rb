# 02.example/start.rb
group "Target estándar" do
  target "Existe el usuario obiwan", weight: 2
  run "id obiwan"
  expect_ok

  target "No existe el usuario vader"
  run "id vader"
  expect_fail
end

play do
  show
  export
end
