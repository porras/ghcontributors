class User < Struct.new(:username, :contributions)
  class << self
    def get(username)
      contrib = contributions(username)
      new(username, contrib) unless contrib.empty?
    end
  
    def contributions(username)
      rows = DB.view('ghcontributors/contributions', :startkey => [username], :endkey => [username, {}])['rows']
      rows = rows.map { |row| [row['key'][1], row['value']] }.sort_by { |repo, contributions| -contributions }
      Hash[*rows.flatten]
    end
  end
end