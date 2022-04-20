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

  def score_counter # Module??
    goals = []
    @games.each do |row|
      i = row[:away_goals].to_f + row[:home_goals].to_f
      goals << i
    end
    return goals
  end

end
