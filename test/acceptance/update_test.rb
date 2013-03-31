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
    assert page.has_content?('Tracking 3 repos')
    
    update_all_repos
    visit '/porras'
    
    assert page.has_content?('rails/rails 1 commit')
    assert page.has_content?('linux/linux 1 commit')
    assert page.has_content?('porras/ghcontributors 1 commit')
    assert page.has_content?('Tracking 3 repos')
    
    stub_github_api('porras/ghcontributors', porras: 2)
    update_all_repos
    visit '/porras'
    
    assert page.has_content?('rails/rails 1 commit')
    assert page.has_content?('linux/linux 1 commit')
    assert page.has_content?('porras/ghcontributors 2 commits')
    assert page.has_content?('Tracking 3 repos')
  end
  
  def test_removing_a_repo
    query = stub_github_api_not_found('rails/rails')
    update_all_repos
    
    visit '/porras'
    
    assert page.has_content?('linux/linux 1 commit')
    assert page.has_content?('porras/ghcontributors 1 commit')
    assert page.has_no_content?('rails/rails')
    assert page.has_content?('Tracking 2 repos')
    
    # should not query it again
    WebMock.reset!
    update_all_repos
    
    assert_not_requested query
  end
  
  def update_all_repos
    # very inefficient but only way to be sure all repos are updated without coupling to the fact
    # they're updated by batches; that logic is (will be) tested in batch_test.rb
    (0..23).each do |i|
      Batch.new(i).update
    end
  end
end