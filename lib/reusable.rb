module Reusable

  def team_hash
    hash = {}
    @team_csv.each do |row|
      hash[row[:team_id]] = row[:teamname]
    end
  return hash
  end

  def seasons_hash
    @games.games.group_by { |row| row[:season].itself}
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

  def games_by_season(season)
    games_in_season = @games.games.collect { |row| row[:game_id] if row[:season] == season}
    games_in_season.compact
  end

  def team_average_number_of_goals_per_game(team_id)#Helper--game_teams
    @game_count = 0
    @game_score = 0
    @game_teams.each do |row|
      if row[:team_id].to_i == team_id.to_i
        @game_count += 1
        @game_score += row[:goals].to_i
      end
    end
    if @game_count > 0
      return @game_score.to_f / @game_count.to_f
    end
  end

  def game_array(season)
  array = []
  working_array = seasons_hash
  acceptable_games = []
  (working_array[season]).each { |row| acceptable_games << row[:game_id]}
  @game_teams.each do | row |
      if acceptable_games.include?(row[:game_id])
      array << row
      end
    end
    array
  end


end
