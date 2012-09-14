$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'user'
require 'repo'

require 'couchrest'
DB = CouchRest.database('http://localhost:5984/ghcontributors')
