require 'acceptance_helper'

class BasicTest < AcceptanceTest
  def test_adding_repos
    stub_github_api('rails/rails', porras: 5,
                                   fxn: 1)
    stub_github_api('linux/linux', porras: 1,
                                   fxn: 3,
                                   torvalds: 1000)
    
    visit '/'
    
    assert page.has_content?('Tracking 0 repos')
    
    fill_in 'repo', with: 'rails/rails'
    click_button 'Add'
    
    assert page.has_content?('Tracking 1 repos')
    
    visit '/porras'
    
    assert page.has_content?('rails/rails 5 commits')
    
    visit '/fxn'
    
    assert page.has_content?('rails/rails 1 commit')
    
    visit '/dhh'
    
    assert page.has_content?("user dhh doesn't exist or hasn't committed in any repo")
    
    fill_in 'repo', with: 'linux/linux'
    click_button 'Add'
    
    assert page.has_content?('Tracking 2 repos')
    
    visit '/porras'
    
    assert page.has_content?('rails/rails 5 commits')
    assert page.has_content?('linux/linux 1 commit')
    
    visit '/fxn'
    
    assert page.has_content?('rails/rails 1 commit')
    assert page.has_content?('linux/linux 3 commits')
    
    visit '/torvalds'
    
    assert page.has_content?('linux/linux 1000 commits')
    assert page.has_no_content?('rails/rails')
    
    visit '/dhh'
    
    assert page.has_content?("user dhh doesn't exist or hasn't committed in any repo")
  end
  
  def test_adding_repos_with_spaces
    stub_github_api('rails/rails', porras: 1)
    
    visit '/'
    
    fill_in 'repo', with: 'rails / rails'
    click_button 'Add'
    
    assert page.has_content?('Tracking 1 repos')
    
    visit '/porras'
    
    assert page.has_content?('rails/rails 1 commit')
  end
end