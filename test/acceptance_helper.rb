require 'test_helper'
require 'capybara/dsl'
require 'rack/test'
require 'webmock/minitest'

WebMock.disable_net_connect!(:allow_localhost => true)

require File.join(File.dirname(__FILE__), '..', 'app')
Capybara.app = GhContributors

require 'rake'
load File.join(File.dirname(__FILE__), '..', 'Rakefile')
Rake::Task['db:setup'].invoke

module TestHelper
  module AcceptanceHelper
    def empty_database
      DB.view('ghcontributors/repos')['rows'].each do |row|
        DB.delete_doc row['value'], true
      end
      DB.bulk_save
    end
  end
  def stub_github_api(repo, contributions = {})
    stub_github_api_repo(repo, full_name: repo)
    stub_github_api_contributors(repo, contributions)
  end
  def stub_github_api_repo(repo, attributes = {})
    stub_request(:get, "https://api.github.com/repos/#{repo}").
      to_return(:status => 200,
                :headers => {'Content-Type' => 'application/json; charset=utf-8'},
                :body => MultiJson.dump(attributes))
  end
  def stub_github_api_contributors(repo, contributions = {})
    stub_request(:get, "https://api.github.com/repos/#{repo}/contributors?anon=false").
      to_return(:status => 200,
                :headers => {'Content-Type' => 'application/json; charset=utf-8'},
                :body => MultiJson.dump(contributions.map { |user, n| {login: user.to_s, contributions: n} }))
  end
  def stub_github_api_not_found(repo)
    stub_request(:get, "https://api.github.com/repos/#{repo}/contributors?anon=false").
      to_return(:status => 404)
  end
  def update_all_repos
    # very inefficient but only way to be sure all repos are updated without coupling to the fact
    # they're updated by batches; that logic is (will be) tested in batch_test.rb
    (0..23).each do |i|
      Batch.new(i).update
    end
  end
  
  module ApiHelper
    include Rack::Test::Methods
    
    def post_hook(repo)
      user, repo = repo.split('/')
      post '/', payload: MultiJson.dump(repository: {name: repo, owner: {name: user}})
    end

    def app
      GhContributors.new
    end
  end
end

class AcceptanceTest < UnitTest
  include AcceptanceHelper
  include Capybara::DSL
  include WebMock::API
  
  def teardown
    empty_database
    
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end
