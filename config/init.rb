$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')

require 'user'
require 'repo'
require 'helpers'

require 'couchrest'
DB = CouchRest.database!('http://localhost:5984/ghcontributors2')
