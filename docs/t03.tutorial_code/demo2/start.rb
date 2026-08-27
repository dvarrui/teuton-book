group "Test Sum" do
  filepath = "./#{get(:folder)}/#{get(:filename)}"
  values = [ [1, 0], [3, 2], [7, 9] ]

  values.each do |number1, number2|
    target "Script calculates the sum of 2 numbers"
    run "#{filepath} #{number1} #{number2}"
    expect ["Sum", number1 + number2 ]
  end
end

group "Test Mul" do
  filepath = "./#{get(:folder)}/#{get(:filename)}"
  values = [ [1, 0], [3, 2], [7, 9] ]

  values.each do |number1, number2|
    target "Script calculates the multiplication of 2 numbers"
    run "#{filepath} #{number1} #{number2}"
    expect(/Mul\s+=\s+#{number1*number2}/)
  end
end

play do
  show
  export
end
