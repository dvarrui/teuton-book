## 05.example/start.rb
group "Target personalizado" do

  target "Existe el usuario #{get(:username)}"
  run "id #{get(:username)}"
  expect_ok

end

play do
  show
  export
end
