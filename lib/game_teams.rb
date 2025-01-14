require_relative './reusable'
require_relative './stat_tracker'

class GameTeams
  include Reusable
  attr_reader :game_teams

  def initialize(data, hash, games, teams)
    @teams_hash = hash
    @game_teams = data
    @games = games
    @teams = teams
  end

  def winningest_coach(season_id)
    hash = {}
    final_hash = {}
    season_games = games_by_season(season_id)
    array = @game_teams.select { |row| season_games.include?(row[:game_id])}
    array.each do |row|
      if !hash.keys.include?(row[:head_coach])
        hash[row[:head_coach]] = [row[:result]]
      else
        hash[row[:head_coach]] << row[:result]
      end
    end
    hash.each do |key, array|
      wins = array.select { |element| element == "WIN" }
      final_hash.merge!("#{key}" => (wins.count.to_f / array.count.to_f))
    end
    final_hash.each do |k, v|
      if v == final_hash.values.max
        return k
      end
    end
  end

  def worst_coach(season_id)
    hash = {}
    final_hash = {}
    season_games = games_by_season(season_id)
    array = @game_teams.select { |row| season_games.include?(row[:game_id])}
    array.each do |row|
      if !hash.keys.include?(row[:head_coach])
        hash[row[:head_coach]] = [row[:result]]
      else
        hash[row[:head_coach]] << row[:result]
      end
    end
    hash.each do |key, array|
      win = array.select { |element| element == "WIN" }
      final_hash.merge!("#{key}" => (win.count.to_f / array.count.to_f))
    end
    final_hash.each do |k, v|
      if v == final_hash.values.min
        return k
      end
    end
  end

  def most_accurate_team(season_id)
    hash = {}
    final_hash = {}
    season_games = games_by_season(season_id)
    array = @game_teams.select { |row| season_games.include?(row[:game_id])}
    array.each do |row|
      if !hash.keys.include?(row[:team_id])
        hash[row[:team_id]] = {goals: row[:goals].to_f, shots: row[:shots].to_f}
      else
        hash[row[:team_id]][:goals] += row[:goals].to_f
        hash[row[:team_id]][:shots] += row[:shots].to_f
      end
    end
    hash.each do |key, hash2|
      final_hash.merge!("#{key}" => (hash2[:goals] / hash2[:shots]))
    end
    hash_max_hash(final_hash)
  end

  def least_accurate_team(season_id)
    hash = {}
    final_hash = {}
    season_games = games_by_season(season_id)
    array = @game_teams.select { |row| season_games.include?(row[:game_id])}
    array.each do |row|
      if !hash.keys.include?(row[:team_id])
        hash[row[:team_id]] = {goals: row[:goals].to_f, shots: row[:shots].to_f}
      else
        hash[row[:team_id]][:goals] += row[:goals].to_f
        hash[row[:team_id]][:shots] += row[:shots].to_f
      end
    end
    hash.each do |key, hash2|
      final_hash.merge!("#{key}" => (hash2[:goals] / hash2[:shots]))
    end
    hash_min_hash(final_hash)
  end

  def average_win_percentage(team_id)
    counter = 0
    team_id_h = @game_teams.group_by { |row| row[:team_id].itself }
    team_id_h[team_id].each do |row|
      if row[:result] == "WIN"
        counter += 1
      end
    end
    (counter.to_f / team_id_h[team_id].count.to_f).round(2)
  end

  def most_goals_scored(team_id)
    goals = []
    most_goals = @game_teams.group_by { |row| row[:team_id].itself}
    most_goals.each do | team, stats |
      if team_id.to_s == team
        stats.each do | goal |
          goals << goal[:goals].to_i
        end
      end
    end
    return goals.sort.pop
  end

  def fewest_goals_scored(team_id)
    goals = []
    fewest_goals = @game_teams.group_by { |row| row[:team_id].itself}
    fewest_goals.each do | team, stats |
      if team_id.to_s == team
        stats.each do | goal |
          goals << goal[:goals].to_i
        end
      end
    end
    return goals.sort.shift
  end

  def best_offense
    @id_avg_hash = {}
    @teams_hash.each do |k,v|
      @id_avg_hash.merge!("#{@teams_hash[k]}" => team_average_number_of_goals_per_game(k))
    end
    hash_max(@id_avg_hash)
  end

  def worst_offense
    @id_avg_hash = {}
    @teams_hash.each do |k,v|
      @id_avg_hash.merge!("#{@teams_hash[k]}" => team_average_number_of_goals_per_game(k))
    end
    hash_min(@id_avg_hash)
  end

  def most_tackles(season)
    final_hash = {}
    game_array = []
    tackle_hash = {}
    min_tackles_team = []
    game_array = game_array(season)
      team_hash = game_array.group_by { |row| row[:team_id].itself }
      team_hash.each do | team, stats |
        counter = 0
        stats.each do | row |
          counter += row[:tackles].to_i
        end
        tackle_hash.merge!("#{team}" => counter)
      end
      tackle_hash.each do |k, v|
        if v == tackle_hash.invert.max[0]
          min_tackles_team << k
        end
      end
      min_tackles_team.each do |element|
        @teams_hash.each do |k, v|
          if element == k
            final_hash.merge!("#{element}" => v)
          end
        end
      end
      final_hash.invert.sort[0][0]
  end

  def fewest_tackles(season)
    final_hash = {}
    game_array = []
    tackle_hash = {}
    min_tackles_team = []
    game_array = game_array(season)
      team_hash = game_array.group_by { |row| row[:team_id].itself }
      team_hash.each do | team, stats |
        counter = 0
        stats.each do | row |
          counter += row[:tackles].to_i
        end
        tackle_hash.merge!("#{team}" => counter)
      end
      tackle_hash.each do |k, v|
        if v == tackle_hash.invert.min[0]
          min_tackles_team << k
        end
      end
      min_tackles_team.each do |element|
        @teams_hash.each do |k, v|
          if element == k
            final_hash.merge!("#{element}" => v)
          end
        end
      end
      final_hash.invert.sort[0][0]
  end

end
