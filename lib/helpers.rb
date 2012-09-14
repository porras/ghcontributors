module Helpers
  def github_link(name)
    %Q{<a href="http://github.com/#{name}">#{name}</a>}
  end

  def commits_link(repo, user, commits)
    %Q{<a href="http://github.com/#{repo}/commits?author=#{user}">#{commits} commits</a>}
  end
end