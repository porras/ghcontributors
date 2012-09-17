namespace :db do
  desc 'Creates database and views'
  task :setup do
    require './config/init'
    
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
    
    DB.delete_doc DB.get("_design/ghcontributors") rescue nil

    DB.save_doc({
      "_id" => "_design/ghcontributors",
      :views => {
        :contributions => {:map => CONTRIBUTIONS},
        :repos => {:map => REPOS},
        :sizes => {:map => SIZES}
      }
    })

  end
end

namespace :update do
  desc 'Update all repos'
  task :all do
    require './config/init'
    require 'benchmark'
    repos = Repo.all
    time = Benchmark.measure { repos.each(&:update) }
    puts "Updated %d repos in %0.2f seconds" % [repos.size, time.real]
  end
end