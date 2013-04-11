require 'acceptance_helper'

class ForksTest < AcceptanceTest
  def test_adding
    stub_github_api_repo('porras/rails', full_name: 'porras/rails', source: {full_name: 'rails/rails'})
    stub_github_api('rails/rails', porras: 1)
    
    visit '/'
    
    fill_in 'repo', with: 'porras/rails'
    click_button 'Add'
    
    visit '/porras'
    
    assert page.has_content?('rails/rails 1 commit')
    assert page.has_no_content?('porras/rails')
  end
  
  def test_update
    stub_github_api('porras/rails', porras: 1)
    
    visit '/'
    
    fill_in 'repo', with: 'porras/rails'
    click_button 'Add'
    
    visit '/porras'
    
    assert page.has_content?('porras/rails 1 commit')
    
    stub_github_api_repo('porras/rails', full_name: 'porras/rails', source: {full_name: 'rails/rails'})
    stub_github_api('rails/rails', porras: 1)
    
    update_all_repos
    
    visit '/porras'
    
    assert page.has_content?('rails/rails 1 commit')
    assert page.has_no_content?('porras/rails')
  end
end