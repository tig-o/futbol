require 'CSV'
require_relative './games'
# require './lib/league'
# require './lib/season'
require_relative './team'
class StatTracker
  include Team
  attr_reader :teams, :games, :game_teams

  def initialize(data1, data2, data3)
    @teams = data2
    @games = Games.new(data1)
    @game_teams = data3
    @teams_hash = team_hash
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
    @teams.each do |row|
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
    away_goals_hash = {}
    away_games_hash = {}
    away_avg_hash = {}
    @teams.each do |row|
      away_avg_hash.merge!("#{row[:team_id]}" => @games.team_average_number_of_goals_per_away_game(row[:team_id]))
    end
    away_avg_hash.each do |k, v|
      if v == away_avg_hash.values.max
        return @teams_hash[k]
      end
    end
  end

  def lowest_scoring_visitor
    away_goals_hash = {}
    away_games_hash = {}
    away_avg_hash = {}
    @teams.each do |row|
      away_avg_hash.merge!("#{row[:team_id]}" => @games.team_average_number_of_goals_per_away_game(row[:team_id]))
    end
    away_avg_hash.each do |k, v|
      if v == away_avg_hash.values.min
        return @teams_hash[k]
      end
    end
  end

  def highest_scoring_home_team
    home_goals_hash = {}
    home_games_hash = {}
    home_avg_hash = {}
    @teams.each do |row|
      home_avg_hash.merge!("#{row[:team_id]}" => @games.team_average_number_of_goals_per_home_game(row[:team_id]))
    end
    home_avg_hash.each do |k, v|
      if v == home_avg_hash.values.max
        return @teams_hash[k]
      end
    end
  end

  def lowest_scoring_home_team
    home_goals_hash = {}
    home_games_hash = {}
    home_avg_hash = {}
    @teams.each do |row|
      home_avg_hash.merge!("#{row[:team_id]}" => @games.team_average_number_of_goals_per_home_game(row[:team_id]))
    end
    home_avg_hash.each do |k, v|
      if v == home_avg_hash.values.min
        return @teams_hash[k]
      end
    end
  end
  #stephen
  def count_of_teams
    @team_ids = []
    @teams[:team_id].each do |id|
      if !@team_ids.include?(id.to_i)
        @team_ids << id.to_i
      end
    end
    @team_ids.count
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
    @game_score.to_f / @game_count.to_f
  end

  def best_offense
    @id_avg_hash = {}
    @team_ids = game_teams[:team_id].uniq
    @team_ids.each do |id|
      @id_avg_hash.merge!("#{@teams_hash[id]}" => team_average_number_of_goals_per_game(id))
    end
    @id_avg_hash.each do |k, v|
      if v == @id_avg_hash.values.max
        return k
      end
    end
  end

  def worst_offense
    @id_avg_hash = {}
    @team_ids = game_teams[:team_id].uniq
    @team_ids.each do |id|
      @id_avg_hash.merge!("#{@teams_hash[id]}" => team_average_number_of_goals_per_game(id))
    end
    @id_avg_hash.each do |k, v|
      if v == @id_avg_hash.values.min
        return k
      end
    end
  end

  def team_info(team_id)
    @teams_info = {}
    @teams.each do |row|
      if row[:team_id] == team_id
        @teams_info.merge!('team_id' => row[:team_id], 'franchise_id' => row[:franchiseid],
            'team_name'=> row[:teamname], 'abbreviation' =>row[:abbreviation], 'link' => row[:link])
      end
    end
    @teams_info
  end

  def best_season(team_id)
    @games.best_season(team_id)
  end

  def worst_season(team_id)
    @games.worst_season(team_id)
  end

  def favorite_opponent(team_id)#Can move to games later??
    opp_win_avg_hash = {}
    opp_wins = @games.number_of_opponent_wins(team_id)
    opp_games = @games.number_of_games_against_opponents(team_id)
    opp_games.each do | gk, gv |
      opp_wins.each do | wk, wv |
        if !opp_wins.keys.include?(gk)
          opp_win_avg_hash.merge!("#{gk}" => 0.0)
        else
          if gk == wk
            opp_win_avg_hash.merge!("#{gk}" => (wv.to_f / gv.to_f))
          end
        end
      end
    end
    opp_win_avg_hash.each do | k, v|
      if v == opp_win_avg_hash.values.min
        return @teams_hash[k]
      end
    end
  end

  def rival(team_id)#Can move to games later??
     opp_win_avg_hash = {}
     opp_wins = @games.number_of_opponent_wins(team_id)
     opp_games = @games.number_of_games_against_opponents(team_id)
     opp_games.each do | gk, gv |
       opp_wins.each do | wk, wv |
         if gk == wk
           opp_win_avg_hash.merge!("#{wk}" => (wv.to_f / gv.to_f))
         end
       end
     end
     opp_win_avg_hash.each do | k, v|
       if v == opp_win_avg_hash.values.max
         return @teams_hash[k]
       end
     end
  end
end
