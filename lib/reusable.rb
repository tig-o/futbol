module Reusable

  def team_hash
    hash = {}
    @teams.each do |row|
      hash[row[:team_id]] = row[:teamname]
    end
  return hash
  end


  def hash_min(hash)
    hash.each do |k,v|
      if v == hash.values.min
        return @teams_hash[k]
      end
    end
  end

  def hash_max(hash)
    hash.each do |k,v|
      if v == hash.values.max
        return @teams_hash[k]
      end
    end
  end
end
