
class Games
  attr_reader :games

  def initialize(data)
    @games = data
  end

  def highest_total_score
    goals = score_counter
    goals.max
  end

  def lowest_total_score
    goals = score_counter
    goals.min
  end

  def percentage_home_wins
    total_games = @games[:game_id].count.to_f
    home_wins = 0
    @games.each { |row| home_wins += 1 if row[:home_goals].to_i > row[:away_goals].to_i }
    decimal = (home_wins.to_f / total_games)
    decimal.round(2)
  end

  def percentage_visitor_wins
    total_games = @games[:game_id].count.to_f
    visitor_wins = 0
    @games.each { |row| visitor_wins += 1 if row[:home_goals].to_i < row[:away_goals].to_i }
    decimal = (visitor_wins.to_f / total_games)
    decimal.round(2)
  end

  def percentage_ties
    total_games = @games[:game_id].count.to_f
    number_tied = 0
    @games.each { |row| number_tied += 1 if row[:home_goals].to_i == row[:away_goals].to_i }
    decimal = (number_tied.to_f / total_games)
    decimal.round(2)
  end

  def average_goals_per_game
    goals = score_counter
    (goals.sum / goals.count).round(2)
  end

  def best_season(team_id)
    seasons_win_avg_hash = {}
    games_per_season = teams_games_played_in_season(team_id)
    wins_per_season = teams_wins_in_season(team_id)
    games_per_season.each do | gk, gv |
      wins_per_season.each do | wk, wv |
        if gk == wk
          seasons_win_avg_hash.merge!("#{wk}" => (wv.to_f / gv.to_f))
        end
      end
    end
    seasons_win_avg_hash.max_by{|k,v| v}[0]
  end

  def worst_season(team_id)
    seasons_win_avg_hash = {}
    games_per_season = teams_games_played_in_season(team_id)
    wins_per_season = teams_wins_in_season(team_id)
    games_per_season.each do | gk, gv |
      wins_per_season.each do | wk, wv |
        if gk == wk
          seasons_win_avg_hash.merge!("#{wk}" => (wv.to_f / gv.to_f))
        end
      end
    end
    seasons_win_avg_hash.min_by{|k,v| v}[0]
  end


  def team_average_number_of_goals_per_away_game(team_id) #Helper
    away_game_count = 0
    away_game_score = 0
    @games.each do |row|
      if row[:away_team_id].to_i == team_id.to_i
        away_game_count += 1
        away_game_score += row[:away_goals].to_i
      end
    end
    away_game_score.to_f / away_game_count.to_f
  end

  def team_average_number_of_goals_per_home_game(team_id) #Helper
    home_game_count = 0
    home_game_score = 0
    @games.each do |row|
      if row[:home_team_id].to_i == team_id.to_i
        home_game_count += 1
        home_game_score += row[:home_goals].to_i
      end
    end
    home_game_score.to_f / home_game_count.to_f
  end

  def teams_games_played_in_season(team_id) #Helper
    games_per_season_arr = []
    @games.each do |row|
      if (row[:home_team_id] || row[:away_team_id]) == team_id
        games_per_season_arr << row[:season]
      end
    end
    games_per_season_hash = games_per_season_arr.tally
    games_per_season_hash
  end

  def teams_wins_in_season(team_id) #Helper
    season_wins_arr = []
    @games.each do |row|
      if row[:away_team_id] == team_id
        if row[:away_goals].to_f > row[:home_goals].to_f
          season_wins_arr << row[:season]
        end
      end
      if row[:home_team_id] == team_id
        if row[:home_goals].to_f > row[:away_goals].to_f
          season_wins_arr << row[:season]
        end
      end
    end
    season_wins_hash = season_wins_arr.tally
    season_wins_hash
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

  def score_counter # Module??
    goals = []
    @games.each do |row|
      i = row[:away_goals].to_f + row[:home_goals].to_f
      goals << i
    end
    return goals
  end
end
