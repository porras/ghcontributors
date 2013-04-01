require 'acceptance_helper'

class HookTest < AcceptanceTest
  include ApiHelper
  
  def setup
    stub_github_api('porras/ghcontributors', porras: 15)
  end
  
  def test_new_repo
    visit '/'
    
    assert page.has_content?('Tracking 0 repos')
    
    post_hook 'porras/ghcontributors'
    
    assert last_response.ok?
    assert_equal 'Repository porras/ghcontributors updated', last_response.body
    
    visit '/porras'
    
    assert page.has_content?('porras/ghcontributors 15 commits')
    assert page.has_content?('Tracking 1 repo')
  end
  
  def test_existing_repo
    visit '/'
    
    fill_in 'repo', with: 'porras/ghcontributors'
    click_button 'Add'
    
    assert page.has_content?('Tracking 1 repos')
    
    visit '/porras'
    
    assert page.has_content?('porras/ghcontributors 15 commits')
    
    stub_github_api('porras/ghcontributors', porras: 16)
    post_hook 'porras/ghcontributors'
    
    visit '/porras'
    
    assert page.has_content?('porras/ghcontributors 16 commits')
    assert page.has_content?('Tracking 1 repo')
  end
  
end