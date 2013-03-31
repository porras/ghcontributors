$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'bundler/setup'

require 'user'
require 'repo'
require 'helpers'

require 'couchrest'
ENV['CLOUDANT_URL'] ||= 'http://localhost:5984'
DB = CouchRest.database!("#{ENV['CLOUDANT_URL']}/ghcontributors#{'-test' if ENV['RACK_ENV'] == 'test'}")
OUT = ENV['RACK_ENV'] == 'test' ? StringIO.new : STDOUT

require 'octokit'

GitHub = Octokit::Client.new(:client_id => ENV['GH_CLIENT_ID'], :client_secret => ENV['GH_CLIENT_SECRET'])
