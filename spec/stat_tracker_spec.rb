require 'simplecov'
SimpleCov.start
require './lib/stat_tracker'

describe StatTracker do
  before(:each) do

    game_path = './data/games_test.csv'
    team_path = './data/teams_test.csv'
    game_teams_path = './data/game_teams_test.csv'

    locations = {
      games: game_path,
      teams: team_path,
      game_teams: game_teams_path
    }

    @stat_tracker = StatTracker.from_csv(locations)
  end

  it 'finds highest scoring game' do
    expect(@stat_tracker.highest_total_score).to eq(12)
  end

  it 'finds lowest scoring game' do
    expect(@stat_tracker.lowest_total_score).to eq(1)
  end








































































#SAI
  it 'returns a percentage of how many wins were home wins' do
    expect(@stat_tracker.percentage_home_wins).to eq(44.44)
  end
  it 'returns a percentage of how many wins were away wins' do
    expect(@stat_tracker.percentage_visitor_wins).to eq(55.56)
  end
  it 'returns a percentage of how many ties there were' do
    expect(@stat_tracker.percentage_ties).to eq(0.00)
  end


























































































#COLIN
it 'find the average goals per game' do
  # require 'pry'; bind!ing.pry
  expect(@stat_tracker.average_goals_per_game).to eq(4.78)
end































































































#THIAGO
  it 'can return name of coach with best win percentage based on season' do
    expect(@stat_tracker.winningest_coach).to eq("Claude Julien")
  end





















# Ensuring this line stays on 325










































































#STEPHEN



































































































end
