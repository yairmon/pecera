texto = [['Menu1', "01"],
        ['Menu2', "02"],
        ['Menu3', "03"]]

texto2 = [{"texto" => "Menu1", "valor" => "01"},
          {"texto" => "Menu2", "valor" => "02"},
          {"texto" => "Menu3", "valor" => "03"}]

(0...texto2.size).each do |i|
  print texto2[i]['texto']
  print "\n"
end # each
(0...texto2.size).each do |i|
  texto2[i]['texto'] = texto2[i]['texto'].delete('Menu')
  print "\n"
end # each
(0...texto2.size).each do |i|
  print texto2[i]['texto']
  print "\n"
end # each
#
# texto2.each do |i|
#   texto2[i]['texto'] = texto2[i]['texto'].delete 'Menu'
# end # each
#
# texto2.each do |i|
#   print texto2[i]['texto']
# end # each
