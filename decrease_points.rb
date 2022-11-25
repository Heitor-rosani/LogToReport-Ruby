require 'json'

File.delete("./all_player_scored/world_deaths.json") if File.exist?("./all_player_scored/world_deaths.json")
new_file = File.new("./all_player_scored/world_deaths.json", "a")
all_players = []
for i in 1...Dir["/games/*"].length;
  game = File.open("#{Dir.pwd}/death_by_round_only_world/game_#{i}.txt")
  game.readlines.each do |line|
    first_player_index = line.index('->')
    first_player = line[(first_player_index).to_i + 2..-1]
    all_players << first_player
  end
end
count = all_players.tally.sort_by {|key, value| value}.reverse.to_h
File.write("./all_player_scored/world_deaths.json", JSON.dump(count))

