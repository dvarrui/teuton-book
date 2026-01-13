# 03.example/start.rb
group "Target de penalización" do
  target "Existe el usuario roo"
  run "id root"
  expect_ok

  target "El usuario vader penaliza", weight: -1
  run "id vader"
  expect_ok
end

play do
  show
  export
end
