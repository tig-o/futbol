module Team

  def team_hash
    hash = {}
    @teams.each do |row|
      hash[row[:team_id]] = row[:teamname]
    end
  return hash
  end

end
