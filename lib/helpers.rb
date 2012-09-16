module Helpers
  def github_link(name)
    %Q{<a href="http://github.com/#{name}">#{name}</a>}
  end

  def commits_link(repo, user, commits)
    %Q{<a href="http://github.com/#{repo}/commits?author=#{user}">#{pluralize('commit', commits)}</a>}
  end
  
  def pluralize(word, n)
    n.to_s + ' ' + word + (n == 1 ? '' : 's')
  end
  
  def normalize(n, max)
    ((Math.log(n) / Math.log(max)) * 90).to_i + 10
  end
end