for i in 1..21;
  game = File.open("#{Dir.pwd}/games/game_#{i}.txt")
  File.delete("./death_by_round/game_#{i}.txt") if File.exist?("./death_by_round/game_#{i}.txt")
  new_file = File.new("./death_by_round/game_#{i}.txt", "a")
  game_read = game.readlines.each do |line|
    if line.include?('Kill')
      File.open(new_file, 'a') do |file|
        file.puts(line)
      end
    end
    new_file.close
    i += 1
  end
end
