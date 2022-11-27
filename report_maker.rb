require_relative 'main_program.rb'
require_relative 'functions.rb'
file_functions = FileFunctions.new

data_maker()
file_functions.render_ascii_art()

end_of_games = Dir["/games/*"].length - 1

puts "Type number of match -> 1 - #{end_of_games}"
puts 'Type r - For ranking'

type = gets.chomp

if type == 'r'
  file_functions.print_ranking
else
  file_functions.print_report(type)
end


