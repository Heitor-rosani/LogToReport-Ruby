require 'json'

class FileFunctions
  def file_to_games
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
  end

  def filter_kills
    for i in 1...Dir["/games/*"].length;
      game = File.open("#{Dir.pwd}/games/game_#{i}.txt")
      File.delete("./death_by_round/game_#{i}.txt") if File.exist?("./death_by_round/game_#{i}.txt")
      new_file = File.new("./death_by_round/game_#{i}.txt", "a")
      game.readlines.each do |line|
        if line.include?('Kill')
          kill = line.split(/[0-9]+:/)
          kill.each do |killer|
            if killer.include?('by')
              File.open(new_file, 'a') do |file|
                file.puts(killer)
              end
            end
          end
        end
        new_file.close
        i += 1
      end
    end
  end

  def filter_kills_no_world
    for i in 1...Dir["/games/*"].length;
      game = File.open("#{Dir.pwd}/games/game_#{i}.txt")
      File.delete("./death_by_round_no_world/game_#{i}.txt") if File.exist?("./death_by_round_no_world/game_#{i}.txt")
      new_file = File.new("./death_by_round_no_world/game_#{i}.txt", "a")
      game.readlines.each do |line|
        if line.include?('Kill')
          kill = line.split(/[0-9]+:/)
          kill.each do |killer|
            if killer.include?('by')
              unless killer.include?('<world>')
                File.open(new_file, 'a') do |file|
                  file.puts(killer)
                end
              end
            end
          end
        end
        new_file.close
        i += 1
      end
    end
  end

  def killers_and_deaths_by_game
    for i in 1...Dir["/games/*"].length;
      game = File.open("#{Dir.pwd}/death_by_round/game_#{i}.txt")
      File.delete("./kills/game_#{i}.txt") if File.exist?("./kills/game_#{i}.txt")
      new_file = File.new("./kills/game_#{i}.txt", "a")
      killers = []
      deaths = []
      File.open(new_file, 'a')
      game.readlines.each do |line|
        index_killer = line.index('killed')
        killer = line[1..index_killer-2]
        killers << killer
        index_death = line.index('by')
        death = line[index_killer+7..index_death-2]
        deaths << death
        new_file.puts("#{killer}->#{death}")
      end
      new_file.close
    end
  end

  def filter_kills_no_world
    for i in 1...Dir["/games/*"].length;
      game = File.open("#{Dir.pwd}/kills/game_#{i}.txt")
      File.delete("./death_by_round_no_world/game_#{i}.txt") if File.exist?("./death_by_round_no_world/game_#{i}.txt")
      new_file = File.new("./death_by_round_no_world/game_#{i}.txt", "a")
      game.readlines.each do |line|
        unless line.include?('<world>')
          File.open(new_file, 'a') do |file|
            file.puts(line)
          end
        end
        new_file.close
        i += 1
      end
    end
  end

  def players_by_game
    for i in 1...Dir["/games/*"].length;
      players = []
      game = File.open("#{Dir.pwd}/kills/game_#{i}.txt")
      File.delete("./players/game_#{i}.txt") if File.exist?("./players/game_#{i}.txt")
      new_file = File.new("./players/game_#{i}.txt", "w")
      File.open(new_file, 'a')
      game.readlines.each do |line|
        line_array = line.split('->')
        unless line_array[0].eql?('<world>') || players.include?(line_array[0])
          players << line_array[0]
          new_file.puts(line_array[0])
        end
      end
      new_file.close
    end
  end

  def count_kills(game)
    file=File.open("./death_by_round/game_#{game}.txt","r")
    count = file.readlines.size
    count
  end

  def create_json
    for i in 1...Dir["/games/*"].length;
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
    end
  end
end