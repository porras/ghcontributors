require 'octokit'

class Repo < Struct.new(:name, :doc)
  class << self
    def get(name)
      return unless repo = DB.view('ghcontributors/repos', :key => name)['rows'][0]
      new(name, repo['value'])
    end
    
    def add(name)
      get(name) || (DB.save_doc(:type => 'repo', :name => name) && get(name))
    end
  end
  
  def update
    doc['contributors'] = contributors
    DB.save_doc(doc)
  end
  
  def contributors
    {}.tap do |h|
      Octokit.contributors(name).each do |contributor|
        h[contributor.login] = contributor.contributions
      end
    end
  end
end