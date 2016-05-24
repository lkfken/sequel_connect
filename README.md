# SequelConnect

The intend for this gem is to define a framework for Sequel's database connection.

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

The first level is to specify the Ruby implementation (`RbConfig::CONFIG['RUBY_INSTALL_NAME']`), such as :jruby, :ruby, etc.
The second level is to specify the stage `%w[development test production]`

For example:
```ruby
jruby:
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

ruby:
  default: &default_ruby
    adapter: tinytds

  development:
    <<: *default_ruby
    adapter: sqlite
    database: db/development.sqlite3   # if memory, set it to empty

  test:
    <<: *default_ruby
    adapter: sqlite
    database: db/test.sqlite3

  production:
    <<: *default_ruby
    user: <%= ENV['USER'] %>
    password: <%= ENV['PASSWORD'] %>
    database: <%= ENV['DATABASE'] %>
    dataserver: <%= ENV['DB_SERVER'] %>    
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

