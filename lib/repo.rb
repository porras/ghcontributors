class Repo < Struct.new(:name, :doc)
  class << self
    def get(name)
      return unless repo = DB.view('ghcontributors/repos', :key => name)['rows'][0]
      new(name, repo['value'])
    end
    
    def add(name)
      name.gsub!(/\s+/, '')
      get(name) || begin
        return unless name = real_name(name)
        DB.save_doc(:type => 'repo', :name => name)
        get(name)
      end
    end
    
    def count
      DB.view('ghcontributors/repos', :limit => 0)['total_rows']
    end
    
    private
    
    def real_name(name)
      GitHub.repo(name).full_name
    rescue Octokit::NotFound
      nil
    end
  end
  
  def update(options = {})
    bulk = options.delete(:bulk)
    OUT.puts "Getting data from repo #{name}"
    if doc['contributors'] = contributors
      options.each do |attribute, value|
        doc[attribute] = value
      end
      DB.save_doc(doc, bulk)
    else
      DB.delete_doc(doc, bulk)
    end
  end
  
  private
  
  def contributors
    {}.tap do |h|
      GitHub.contributors(name).each do |contributor|
        h[contributor.login] = contributor.contributions
      end
    end
  rescue Octokit::NotFound
    nil
  end
end