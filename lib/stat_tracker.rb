require 'CSV'
require_relative './games'
require_relative './game_teams'
require_relative './teams'
require_relative './reusable'
class StatTracker
  include Reusable
  attr_reader :teams, :games, :game_teams

  def initialize(data1, data2, data3)
    @team_csv = data2
    @teams_hash = team_hash
    @games = Games.new(data1, @teams_hash)
    @teams = Teams.new(data2, @teams_hash)
    @game_teams = GameTeams.new(data3, @teams_hash, @games, @teams)
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

  def most_accurate_team(season_id)
    @game_teams.most_accurate_team(season_id)
  end

  def least_accurate_team(season_id)
    @game_teams.least_accurate_team(season_id)
  end

  def average_win_percentage(team_id)
    @game_teams.average_win_percentage(team_id)
  end
  #C O O O O O O O O O O O O LIN
  def average_goals_per_game
    @games.average_goals_per_game
  end

  def average_goals_by_season
    average_by_season = {}
    season_hash = seasons_hash
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
  @game_teams.most_tackles(season)
  end

  def fewest_tackles(season)
  @game_teams.fewest_tackles(season)
  end

  def most_goals_scored(team_id)
    @game_teams.most_goals_scored(team_id)
  end

  def fewest_goals_scored(team_id)
    @game_teams.fewest_goals_scored(team_id)
  end
  # T H I A G O O O O O O O A L L L L L
  def winningest_coach(season_id)
    @game_teams.winningest_coach(season_id)
  end

  def worst_coach(season_id)
    @game_teams.worst_coach(season_id)
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

  def best_offense
  @game_teams.best_offense
  end

  def worst_offense
    @game_teams.worst_offense
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
