# GitHub Contributors

This repo contains the app powering [GitHub Contributors](http://ghcontributors.herokuapp.com/),
a site I did some months ago when I had with some free time ;)
I'm not adding any more features to it, so I decided to open source it,
in case you can find it useful, or want to contribute something.

## Set up

The stack is quickly described in the [FAQ](http://ghcontributors.herokuapp.com/faq).
So you need Ruby 1.9.3 and [CouchDB](http://couchdb.apache.org/)
(in production it uses [Cloudant](https://cloudant.com/)).
Apart from that, all other dependencies are specified using bundler
so there should be no problem.

### Rake tasks

There are three rake tasks you need to use to setup the app:

* `rake db:setup`: this one sets the database up (creates the views).
  It doesn't touch the data so you can rerun it,
  but bear in mind that if you have lots of data,
  regenerating the views will take some time
* `rake data:get`: this one loads an *initial* data set of repos.
  It does so by scraping [this page](https://github.com/languages)
  so it can break whenever this page changes
  (it might actually be already broken)
* `rake update:current`: the DB automatically mantains a series of 24 *batches* of repos.
  This *batches* are meant to update one per hour, so every repo gets updated once per day,
  while not making an insane amount of queries to the GitHub API all at once.
  This task updates a batch based on the current time, and it's meant to be called
  by `cron` once per hour.
* `rake update:batch[N]`: Updates a specific batch from 0 to 23 (for debugging purposes).

That's it, to contribute, fork & send pull requests!

## To do

Bear in mind this is *my* roadmap,
but if you contribute something else and it's cool,
I'll merge it anyway :)

* Add ability to update a repo with each commit
  via [GitHub hooks](https://help.github.com/articles/post-receive-hooks)
* Detect forks and mirrors and display only the main repo
* Some nice design ;)
* Show most interesting/recent/active users in home page instead of a fixed list

## Copyright & Licensing

Copyright (c) 2013 Sergio Gil. MIT license, see LICENSE for details.
