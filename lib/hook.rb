class Hook
  attr_reader :repo
  
  def initialize(json)
    data = MultiJson.load(json)
    @repo = data['repository']['owner']['name'] + '/' + data['repository']['name']
  end
  
  def update
    Repo.add(repo).update(hook: true)
  end
end