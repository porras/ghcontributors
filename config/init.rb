$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'user'
require 'repo'
require 'helpers'

require 'couchrest'
ENV['CLOUDANT_URL'] ||= 'http://localhost:5984'
DB = CouchRest.database!("#{ENV['CLOUDANT_URL']}/ghcontributors")
