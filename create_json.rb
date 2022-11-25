require 'json'
require_relative 'functions.rb'

file_functions = FileFunctions.new


# for i in 1...Dir["/games/*"].length;
  i = 5
  players = []
  all_players = []
  kill_by_player = []
  game = File.open("#{Dir.pwd}/players/game_#{i}.txt")
  kill = File.open("#{Dir.pwd}/death_by_round_no_world/game_#{i}.txt")
  File.delete("./json/game_#{i}.json") if File.exist?("./json/game_#{i}.json")
  json_file = File.new("./json/game_#{i}.json", "w")
  kill.readlines.each do |line|
    first_player_index = line.index('->')
    first_player = line[0..(first_player_index).to_i - 1]
    all_players << first_player
    unless players.include?(first_player)
      players << first_player
    end
  end
  players.each do |player|
    count = all_players.count(player)
    kill_by_player.push({player => count})
  end

  json_file = Hash.new
  json_file["game_#{i}"] = Hash.new
  json_file["game_#{i}"]['total_kills'] = count_kills(i)
  json_file["game_#{i}"]['players'] = players
  json_file["game_#{i}"]['kills'] = Hash.new
  json_file["game_#{i}"]['kills'] = kill_by_player

  File.write("./json/game_#{i}.json", JSON.dump(json_file))
# end

# players.each do |player|
#   count = 0
#   kill.readlines.each do |line|
#     first_player_index = line.index('->')
#     first_player = line[0..(first_player_index).to_i - 1]
#     puts first_player
#     puts player
#     if first_player = player
#       count += 1
#     end
#   end
#   kill_by_player.push({player => count})