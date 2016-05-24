# SequelConnect

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/sequel_connect`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sequel_connect'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install sequel_connect

## Usage

You must define `config/database.yml` file first.

For example:
```ruby
default: &default
  adapter: jdbc
  
development:
  <<: *default
  database: sqlite:db/development.sqlite3

test:
  <<: *default
  database: sqlite:db/test.sqlite3

production:
  <<: *default
  database: jtds:sqlserver://<%= ENV['DB_SERVER'] %>/<%= ENV['DATABASE'] %>;user=<%= ENV['USER'] %>;password=<%= ENV['PASSWORD'] %>
```

Reference: http://sequel.jeremyevans.net/rdoc/files/doc/opening_databases_rdoc.html

Now, the constant `SequelConect::DB` can be used to connect to your database.

```ruby
require 'bundler/setup'
require 'sequel_connect'
require 'pp'

class Member  < Sequel::Model(SequelConnect::DB)
end

pp SequelConnect::DB
# <Sequel::JDBC::Database: "jdbc:jtds:sqlserver://somerserver/somedatabase" {"adapter"=>"jdbc", "database"=>"jtds:sqlserver://someserver/somedatabase"}>
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/lkfken/sequel_connect.

