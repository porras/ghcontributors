$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'user'
require 'repo'
require 'helpers'

require 'couchrest'
ENV['CLOUDANT_URL'] ||= 'http://localhost:5984'
DB = CouchRest.database!("#{ENV['CLOUDANT_URL']}/ghcontributors")

require 'octokit'

GitHub = Octokit::Client.new(:client_id => ENV['GH_CLIENT_ID'], :client_secret => ENV['GH_CLIENT_SECRET'])
