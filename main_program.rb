require_relative 'functions.rb'

file_functions = FileFunctions.new


file_functions.file_to_games()
file_functions.filter_kills()
file_functions.killers_and_deaths_by_game()
file_functions.players_by_game()
file_functions.filter_kills_no_world()
file_functions.filter_kills_only_world
file_functions.create_json()
file_functions.players_then_scored()
file_functions.players_ranking_without_world()
file_functions.players_killed_by_world()

