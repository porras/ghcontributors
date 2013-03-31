require 'acceptance_helper'

class UpdateTest < AcceptanceTest
  def setup
    ['rails/rails', 'linux/linux', 'porras/ghcontributors'].each do |repo|
      stub_github_api(repo, porras: 1)
      
      visit '/'
      fill_in 'repo', with: repo
      click_button 'Add'
    end
  end
  
  def test_basic
    visit '/porras'
    
    assert page.has_content?('rails/rails 1 commit')
    assert page.has_content?('linux/linux 1 commit')
    assert page.has_content?('porras/ghcontributors 1 commit')
    
    update_all_repos
    visit '/porras'
    
    assert page.has_content?('rails/rails 1 commit')
    assert page.has_content?('linux/linux 1 commit')
    assert page.has_content?('porras/ghcontributors 1 commit')
    
    stub_github_api('porras/ghcontributors', porras: 2)
    update_all_repos
    visit '/porras'
    
    assert page.has_content?('rails/rails 1 commit')
    assert page.has_content?('linux/linux 1 commit')
    assert page.has_content?('porras/ghcontributors 2 commits')
  end
  
  def update_all_repos
    (0..23).each do |i|
      Batch.new(i).update
    end
  end
end