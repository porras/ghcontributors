# Github Contributors

This repo contains the app powering [Github Contributors](http://ghcontributors.herokuapp.com/), a site I did some months ago when I had with some free time ;) I'm not adding any more features to it, so I decided to open source it, in case you can find it useful, or want to contribute something.

## Set up

The stack is quickly described in the [FAQ](http://ghcontributors.herokuapp.com/faq). So you need Ruby 1.9.3 and [CouchDB](http://couchdb.apache.org/) (in production it uses [Cloudant](https://cloudant.com/)). Apart from that, all other dependencies are specified using bundler so there should be no problem.

### Rake tasks

There are three rake tasks you need to use to setup the app:

* `rake db:setup`: this one sets the database up (creates the views). It doesn't touch the data so you can rerun it, but bear in mind that if you have lots of data, regenerating the views will take some time
* `rake data:get`: this one loads an *initial* data set of repos. It does so by scraping [this page](https://github.com/languages) so it can break whenever this page changes (it might actually be already broken)
* `rake update:all`: this one updates the data for the repos present in the database. It's supposed to be run periodically (once a day for example in production) via `cron`. This way to update the database is not very efficient but for not very big numbers (currently ~3700 in production), <del>it works</del>. **UPDATE**: *Github has changed its rate limit for unauthenticated requests to 60 per hour; this means that, even distributing the repos in 24 batches to update one per hour (which was my original plan), it's not going to work. The solution is to reimplement all Github API queries to use authentication (in that case the limit is 5000 which should be enough for some time, and, if the db some time exceeds 5000 repos, implement the 24 batches strategy)*. **This means the app is currently broken (and outdated) :(**

That's it, to contribute, fork & pull request!

## Copyright & Licensing

Copyright (c) 2013 Sergio Gil. MIT license, see LICENSE for details.
