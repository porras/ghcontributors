class Repo < Struct.new(:name, :doc)
  class << self
    def get(name)
      return unless repo = DB.view('ghcontributors/repos', :key => name)['rows'][0]
      new(name, repo['value'])
    end
    
    def add(name)
      get(name) || (DB.save_doc(:type => 'repo', :name => name) && get(name))
    end
    
    def all
      DB.view('ghcontributors/repos')['rows'].map do |row|
        new(row['key'], row['value'])
      end
    end
    
    def count
      DB.view('ghcontributors/repos', :limit => 0)['total_rows']
    end
  end
  
  def update
    doc['contributors'] = contributors
    DB.save_doc(doc)
  end
  
  def contributors
    {}.tap do |h|
      GitHub.contributors(name).each do |contributor|
        h[contributor.login] = contributor.contributions
      end
    end
  rescue Octokit::NotFound
    {}
  end
end