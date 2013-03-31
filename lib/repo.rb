class Repo < Struct.new(:name, :doc)
  class << self
    def get(name)
      return unless repo = DB.view('ghcontributors/repos', :key => name)['rows'][0]
      new(name, repo['value'])
    end
    
    def add(name)
      get(name) || (DB.save_doc(:type => 'repo', :name => name) && get(name))
    end
    
    def count
      DB.view('ghcontributors/repos', :limit => 0)['total_rows']
    end
  end
  
  def update(bulk = false)
    OUT.puts "Getting data from repo #{name}"
    doc['contributors'] = contributors
    if contributors.empty?
      DB.delete_doc(doc, bulk)
    else
      DB.save_doc(doc, bulk)
    end
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