require 'rake/testtask'
require File.join(File.dirname(__FILE__), 'config', 'init')
require 'batch'

Rake::TestTask.new do |t|
  t.pattern = "test/**/*_test.rb"
  t.libs << 'test'
  t.verbose = true
end

task :default => :test

namespace :db do
  desc 'Creates database and views'
  task :setup do
    CONTRIBUTIONS = <<-JS
      function(doc) {
        if (doc.type == "repo") {
          for (user in doc.contributors) {
            emit([user, doc.name], doc.contributors[user]);
          }
        }
      }
    JS
    
    REPOS = <<-JS
      function(doc) {
        if (doc.type == "repo") {
          emit(doc.name, doc);
        }
      }
    JS
    
    SIZES = <<-JS
      function(doc) {
        if (doc.type == "repo") {
          for (user in doc.contributors) {
            emit(doc.contributors[user]);
          }
        }
      }
    JS
    
    BATCHES = <<-JS
      function(doc) {
        if (doc.type == "repo") {
          emit(parseInt(doc._id.substr(-6, 6), 16) % 24, doc.name);
        }
      }
    JS
    
    VIEWS = { :contributions => {:map => CONTRIBUTIONS},
              :repos => {:map => REPOS},
              :sizes => {:map => SIZES},
              :batches => {:map => BATCHES}
            }
    
    DESIGN_ID = '_design/ghcontributors'
    
    begin
      doc = DB.get(DESIGN_ID)
      OUT.print 'Updating design document...'
      doc['views'] = VIEWS
      doc.save
    rescue RestClient::ResourceNotFound
      OUT.print 'Creating design document...'
      DB.save_doc('_id' => DESIGN_ID, :views => VIEWS)
    end
    OUT.puts ' [OK]'
  end
end

namespace :update do
  desc 'Update a batch of repos'
  task :batch, [:n] do |t, args|
    raise "Please tell me which batch!" unless args[:n]
    Batch.new(args[:n].to_i).update
  end
  desc 'Update current batch of repos'
  task :current do
    Batch.new(Time.now.hour).update
  end
end

namespace :data do
  desc 'Gets most popular repos from GitHub'
  task :get do
    require 'nokogiri'
    require 'open-uri'
    languages = Nokogiri.parse(open('https://github.com/languages').read).css('.left table tr a').map {|l| l[:href]}.uniq
    languages.each_with_index do |link, i|
      puts "Language #{i + 1}/#{languages.size} (#{link})"
      pages = (1..10).to_a
      pages.each do |page|
        puts "  Page #{page}/#{pages.size}"
        repos = Nokogiri.parse(open("https://github.com#{link}/most_watched?page=#{page}").read).css('table.repo tr .title a').map {|l| l[:href]}.uniq
        repos.each_with_index do |repo, i|
          puts "    Repo #{i + 1}/#{repos.size} (#{repo[1..-1]})"
          `curl -s -X POST -d 'repo=#{repo[1..-1]}' -i http://ghcontributors.herokuapp.com/repo`
        end
      end
    end
  end
end
