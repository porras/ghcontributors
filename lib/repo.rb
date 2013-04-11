class Repo < Struct.new(:name, :doc)
  class << self
    def get(name)
      return unless repo = DB.view('ghcontributors/repos', :key => name)['rows'][0]
      new(name, repo['value'])
    end
    
    def add(name)
      name.gsub!(/\s+/, '')
      get(name) || (DB.save_doc(:type => 'repo', :name => name) && get(name))
    end
    
    def count
      DB.view('ghcontributors/repos', :limit => 0)['total_rows']
    end
  end
  
  def update(options = {})
    bulk = options.delete(:bulk)
    OUT.puts "Getting data from repo #{name}"
    data = GitHub.repo(name)
    if data.source
      DB.delete_doc(doc, bulk)
      return Repo.add(data.source.full_name).update
    end
    self.name = doc['name'] = data.full_name
    doc['contributors'] = contributors
    options.each do |attribute, value|
      doc[attribute] = value
    end
    if doc['contributors'].empty?
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