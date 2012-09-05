Hubot Script Catalog
====================

Lists available scripts from [github/hubot-scripts](https://github.com/github/hubot-scripts).

Available at http://hubot-script-catalog.herokuapp.com (currently updates once an hour).

Developing
----------

Hubot Script Catalog is built in Ruby with Sinatra, and uses [Redis](http://redis.io) to store the script index.


### Installing dependencies 

With [Ruby](http://www.ruby-lang.org/en/), [Redis](http://redis.io) and [RubyGems](http://rubygems.org/) present, dependencies can be installed with:

    gem install bundler
    bundle install

### Building the index

To build the index, just run `rake`.

### Running the site

To run the site, run:

    ruby app.rb

If you're looking to reload app code on the fly, use [shotgun](http://rtomayko.github.com/shotgun/) or [Pow](http://pow.cx)'s `always_restart` feature.
