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
    delete && return unless get_data
    options.each do |attribute, value|
      doc[attribute] = value
    end
    DB.save_doc(doc, bulk)
  end
  
  private
  
  def get_data
    self.name = doc['name'] = GitHub.repo(name).full_name
    doc['contributors'] = contributors
  rescue Octokit::NotFound
    nil
  end
  
  def delete(options = {})
    DB.delete_doc(doc, options[:bulk])
  end
  
  def contributors
    {}.tap do |h|
      GitHub.contributors(name).each do |contributor|
        h[contributor.login] = contributor.contributions
      end
    end
  end
end