require_relative './reusable'
require_relative './stat_tracker'

class Teams
  include Reusable
  attr_reader :teams

  def initialize(data, hash)
    @teams = data
    @teams_hash = hash
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


end
