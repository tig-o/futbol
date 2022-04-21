require 'CSV'
require_relative './games'
# require './lib/league'
require_relative './teams'
require_relative './reusable'
class StatTracker
  include Reusable
  attr_reader :teams, :games, :game_teams

  def initialize(data1, data2, data3)
    @team_csv = data2
    @game_teams = data3
    @teams_hash = team_hash
    @games = Games.new(data1, @teams_hash)
    @teams = Teams.new(data2, @teams_hash)
  end

  def self.from_csv(locations)
    data = []
    locations.values.each do |location|
      contents = CSV.read "#{location}", headers: true, header_converters: :symbol
      data << contents
      end
      StatTracker.new(data[0], data[1], data[2])
  end

  def highest_total_score
    @games.highest_total_score
  end

  def lowest_total_score
    @games.lowest_total_score
  end
#SAI
  def percentage_home_wins
    @games.percentage_home_wins
  end

  def percentage_visitor_wins
    @games.percentage_visitor_wins
  end

  def percentage_ties
    @games.percentage_ties
  end

  def games_by_season(season)
    games_in_season = @games.games.collect { |row| row[:game_id] if row[:season] == season}
    games_in_season.compact
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
    final_hash.each do |k, v|
      if v == final_hash.values.max
        return @teams_hash[k]
      end
    end
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
    final_hash.each do |k, v|
      if v == final_hash.values.min
        return @teams_hash[k]
      end
    end
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
  #C O O O O O O O O O O O O LIN
  def average_goals_per_game
    @games.average_goals_per_game
  end

  def average_goals_by_season
    average_by_season = {}
    season_hash = @games.games.group_by { |row| row[:season].itself }
    season_hash.each do |season, games|
      counter = 0
      game = 0
      games.each do |key|
        counter += (key[:away_goals].to_i + key[:home_goals].to_i)
        game += 1
      end
        average_by_season.merge!(season => (counter.to_f/game.to_f).round(2))
    end
    average_by_season
  end

  def count_of_games_by_season
    season_games_hash = {}
    season_games = @games.games.group_by { |row| row[:season].itself }
    season_games.each do |season, games|
      game = 0
      games.each do |key|
        game += 1
      end
        season_games_hash.merge!(season => game)
    end
    season_games_hash
  end

  def most_tackles(season)
  game_array = []
  tackle_hash = {}
  max_tackles_team = []
  @game_teams.each do | row |
      if season.to_s.include?(row[:game_id][0..3])
      game_array << row
      end
    end
    team_hash = game_array.group_by { |row| row[:team_id].itself }
    team_hash.each do | team, stats |
      stats.map do | row |
        tackle_hash.merge!(team => row[:tackles].sum)
      end
    end
    @team_csv.each do |row|
      if row[:team_id] == tackle_hash.max_by{|k,v| v}[0]
        max_tackles_team << row[:teamname]
      end
    end
    return max_tackles_team[0]
  end

  def seasons_hash
    @games.games.group_by { |row| row[:season].itself}
  end

  def fewest_tackles(season)
  final_hash = {}
  game_array = []
  tackle_hash = {}
  min_tackles_team = []
  working_array = seasons_hash
  acceptable_games = []
  (working_array[season]).each { |row| acceptable_games << row[:game_id]}
  @game_teams.each do | row |
      if acceptable_games.include?(row[:game_id])
      game_array << row
      end
    end
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
  # T H I A G O O O O O O O A L L L L L
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

  def highest_scoring_visitor
    away_avg_hash = {}
    @teams_hash.each do |k,v|
      away_avg_hash.merge!(k => @games.team_average_number_of_goals_per_away_game(k))
    end
    hash_max_hash(away_avg_hash)

  end


  def lowest_scoring_visitor
    away_avg_hash = {}
    @teams_hash.each do |k,v|
      away_avg_hash.merge!(k => @games.team_average_number_of_goals_per_away_game(k))
    end
    hash_min_hash(away_avg_hash)
  end

  def highest_scoring_home_team
    home_avg_hash = {}
    @teams_hash.each do |k,v|
      home_avg_hash.merge!(k => @games.team_average_number_of_goals_per_home_game(k))
    end
    hash_max_hash(home_avg_hash)
  end

  def lowest_scoring_home_team
    home_avg_hash = {}
    @teams_hash.each do |k,v|
      home_avg_hash.merge!(k => @games.team_average_number_of_goals_per_home_game(k))
    end
    hash_min_hash(home_avg_hash)
  end
  #stephen
  def count_of_teams
    @teams.count_of_teams
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

  def team_info(team_id)
    @teams.team_info(team_id)
  end

  def best_season(team_id)
    @games.best_season(team_id)
  end

  def worst_season(team_id)
    @games.worst_season(team_id)
  end

  def favorite_opponent(team_id)#Can move to games later??
    @games.favorite_opponent(team_id)
  end

  def rival(team_id)#Can move to games later??
    @games.rival(team_id)
  end
end
