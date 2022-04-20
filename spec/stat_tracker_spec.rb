require 'simplecov'
SimpleCov.start
require './lib/stat_tracker'

describe StatTracker do
  before(:each) do

    @game_path = './data/games_test.csv'
    @team_path = './data/teams_test.csv'
    @game_teams_path = './data/game_teams_test.csv'

    locations = {
      games: @game_path,
      teams: @team_path,
      game_teams: @game_teams_path
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
  context 'Games: Percentages' do
    it 'returns a percentage of how many wins were home wins' do
        expect(@stat_tracker.percentage_home_wins).to eq(0.44)
    end

    it 'returns a percentage of how many wins were away wins' do
        expect(@stat_tracker.percentage_visitor_wins).to eq(0.56)
    end

    it 'returns a percentage of how many ties there were' do
        expect(@stat_tracker.percentage_ties).to eq(0.00)
    end

  end
  context "Season: Accuracy Ratios" do
    before(:each) do

      @game_path = './data/games_test.csv'
      @team_path = './data/teams_test.csv'
      @game_teams_path = './data/game_teams_test_sai.csv'

      locations = {
        games: @game_path,
        teams: @team_path,
        game_teams: @game_teams_path
      }

      @stat_tracker = StatTracker.from_csv(locations)
    end
    it 'can separate game ids by season' do
      expect(@stat_tracker.games_by_season('20122013')).to eq(['2012030221', '2012030225', '2012030314'])
    end

    it 'returns the name of the team with the best shot to goal ratio' do
      expect(@stat_tracker.most_accurate_team("20122013")).to eq("FC Dallas")
    end

    it 'returns the name of the team with the worst shot to goal ratio' do
      expect(@stat_tracker.least_accurate_team("20122013")).to eq("Sporting Kansas City")
    end
  end
  context 'Average win Percentage' do
    before(:each) do

      @game_path = './data/games_test.csv'
      @team_path = './data/teams_test.csv'
      @game_teams_path = './data/game_teams_test_sai.csv'

      locations = {
        games: @game_path,
        teams: @team_path,
        game_teams: @game_teams_path
      }

      @stat_tracker = StatTracker.from_csv(locations)
    end
    it 'returns the average win percentage based off a team id' do
      expect(@stat_tracker.average_win_percentage('3')).to eq(0.2)
      expect(@stat_tracker.average_win_percentage('5')).to eq(0.0)
      expect(@stat_tracker.average_win_percentage('6')).to eq(0.83)
    end
  end
#COLIN
it 'find the average goals per game' do
  expect(@stat_tracker.average_goals_per_game).to eq(4.78)
end

it 'finds the average goals by season' do
  expect(@stat_tracker.average_goals_by_season).to eq({"20122013"=>3.33, "20132014"=>4.0, "20152016"=>4.0, "20142015"=>8.5})
end

it 'counts games per season' do
  expect(@stat_tracker.count_of_games_by_season).to eq ({"20122013"=>3, "20132014"=>2, "20152016"=>2, "20142015"=>2})
end

it 'shows the team with the most tackles in a given season' do
  expect(@stat_tracker.most_tackles(20122013)).to eq("Houston Dynamo")
end

it 'shows the team with the fewest tackles in a given season' do
  expect(@stat_tracker.fewest_tackles("20122013")).to eq("FC Dallas")
end

it 'shows the most goals a given team has scored' do
  expect(@stat_tracker.most_goals_scored("3")).to eq(2)
  expect(@stat_tracker.most_goals_scored("6")).to eq(3)
end

it 'shows the fewest goals a given team has scored' do
  expect(@stat_tracker.fewest_goals_scored("3")).to eq(1)
  expect(@stat_tracker.fewest_goals_scored("6")).to eq(2)
end
#THIAGO
  context "thiagos fancy testing section for coaches" do
    before :each do
      @game_path = './data/games_test_tigo.csv'
      @team_path = './data/teams_test.csv'
      @game_teams_path = './data/game_teams_test_sai.csv'

      locations = {
        games: @game_path,
        teams: @team_path,
        game_teams: @game_teams_path
      }

      @stat_tracker = StatTracker.from_csv(locations)
    end

      it 'can return name of coach with best win percentage based on season' do
        expect(@stat_tracker.winningest_coach("20122013")).to eq("Claude Julien")
      end

      it 'can return name of coach with worst win percentage based on season' do
        expect(@stat_tracker.worst_coach("20122013")).to eq("Dan Bylsma")
      end
  end

  context "thiagos fancy testing section for visitors and home teams" do
    before :each do
      @game_path = './data/games_test_tigo.csv'
      @team_path = './data/teams_test.csv'
      @game_teams_path = './data/game_teams_test.csv'

      locations = {
        games: @game_path,
        teams: @team_path,
        game_teams: @game_teams_path
      }

      @stat_tracker = StatTracker.from_csv(locations)
    end

    it 'can retrieve highest scoring visitor' do
        expect(@stat_tracker.highest_scoring_visitor).to eq("FC Dallas")
    end

    it 'can retrieve lowest scoring visitor' do
        expect(@stat_tracker.lowest_scoring_visitor).to eq("Chicago Fire")
    end

    it 'can retrieve highest avg score per home game across all seasons' do
        expect(@stat_tracker.highest_scoring_home_team). to eq("Atlanta United")
    end

    it 'can retrieve lowest avg score per home game across all seasons' do
        expect(@stat_tracker.lowest_scoring_home_team). to eq("Chicago Fire")
    end
  end
#STEPHEN
  it 'counts the total number of teams in the data' do
    expect(@stat_tracker.count_of_teams).to eq(9)
  end

  it 'can name the team with the best offense' do
    expect(@stat_tracker.best_offense).to eq("FC Dallas")
  end

  it 'can name the team with the worst offense' do
    expect(@stat_tracker.worst_offense).to eq("Houston Dynamo")
  end

  it 'can return a team info hash' do
    expect(@stat_tracker.team_info("3")).to eq({"team_id"=>"3",
 "franchise_id"=>"10",
 "team_name"=>"Houston Dynamo",
 "abbreviation"=>"HOU",
 "link"=>"/api/v1/teams/3"})
  end

  it 'can return the best season for a team' do
    expect(@stat_tracker.best_season("6")).to eq("20132014")
  end

  it 'can return the worst season for a team' do
    expect(@stat_tracker.worst_season("6")).to eq("20122013")
  end

  it "can return the favorite opponent" do
    expect(@stat_tracker.favorite_opponent("3")).to eq("FC Dallas")
  end

  it "can return the teams riveal" do
   expect(@stat_tracker.rival("6")).to eq("Sporting Kansas City")
 end

end
