require 'test_helper'
require 'capybara/dsl'
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
    stub_request(:get, "https://api.github.com/repos/#{repo}/contributors?anon=false").
      to_return(:status => 200,
                :headers => {'Content-Type' => 'application/json; charset=utf-8'},
                :body => contributions.map { |user, n| {login: user.to_s, contributions: n} }.to_json)
  end
  def stub_github_api_not_found(repo)
    stub_request(:get, "https://api.github.com/repos/#{repo}/contributors?anon=false").
      to_return(:status => 404)
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
