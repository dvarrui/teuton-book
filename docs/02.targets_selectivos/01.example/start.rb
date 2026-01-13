# 01.example/start.rb
group "Target uniforme" do
  target "Existe el usuario obiwan"
  run "id obiwan"
  expect_ok
end

play do
  show
  export
end
