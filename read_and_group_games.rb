file = File.open("qgames.log")
file_read = file.read

i = 1

group = file_read.split(/---/)
group.each do |game|
  if !game.empty? && game.size > 10
    File.delete("./games/game_#{i}.txt") if File.exist?("./games/game_#{i}.txt")
    new_file = File.new("./games/game_#{i}.txt", "w")
    new_file.puts(game)
    new_file.close
    i += 1
  end
end



