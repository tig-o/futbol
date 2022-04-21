module Reusable

  def team_hash
    hash = {}
    @team_csv.each do |row|
      hash[row[:team_id]] = row[:teamname]
    end
  return hash
  end


  def hash_min_hash(hash)
    hash.each do |k,v|
      if v == hash.values.min
        return @teams_hash[k]
      end
    end
  end

  def hash_max_hash(hash)
    hash.each do |k,v|
      if v == hash.values.max
        return @teams_hash[k]
      end
    end
  end

  def hash_max(hash)
    hash.each do |k,v|
      if v == hash.values.compact.max
        return k
      end
    end
  end

  def hash_min(hash)
    hash.each do |k,v|
      if v == hash.values.compact.min
        return k
      end
    end
  end

  def number_of_opponent_wins(team_id) #Helper
    opponent_wins_arr = []
    @games.each do |row|
      if row[:away_team_id] == team_id
        if row[:away_goals].to_f < row[:home_goals].to_f
          opponent_wins_arr << row[:home_team_id]
        end
      end
      if row[:home_team_id] == team_id
        if row[:home_goals].to_f < row[:away_goals].to_f
          opponent_wins_arr << row[:away_team_id]
        end
      end
    end
    opponent_wins_hash = opponent_wins_arr.tally
    opponent_wins_hash
  end

  def number_of_games_against_opponents(team_id) #Helper
    opponent_games_arr = []
    @games.each do |row|
      if row[:home_team_id] == team_id
      opponent_games_arr << row[:away_team_id]
      end
      if row[:away_team_id] == team_id
      opponent_games_arr << row[:home_team_id]
      end
    end
    opponents_games_hash = opponent_games_arr.tally
    opponents_games_hash
  end
end
