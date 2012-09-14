class User < Struct.new(:username, :contributions)
  class << self
    def get(username)
      new(username, contributions(username))
    end
  
    def contributions(username)
      rows = DB.view('ghcontributors/contributions', :start_key => [username], :end_key => [username, {}])['rows']
      rows = rows.map { |row| [row['key'][1], row['value']] }.sort_by { |repo, contributions| -contributions }
      Hash[*rows.flatten]
    end
  end
end