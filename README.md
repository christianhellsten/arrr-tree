# Arrr::Tree :boat:

Tree queries with CTEs for Rails/ActiveRecord and PostgreSQL

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'arrr-tree', git: 'git@github.com:christianhellsten/arrr-tree.git'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install arrr-tree

## Usage

```ruby
class Organization
  include Arrr::Tree
end
```

```ruby
parent = Organization.create!(name: 'Berkshire Hathaway')
child = Organization.create!(name: 'Acme Brick Company', parent: parent)
grandchild = Organization.create!(name: 'American Tile and Stone', parent: child)
```

```ruby
parent.descendants.map(&:name) => ['Acme Brick Company', 'American Tile and Stone']
child.ancestors.map(&:name) => ['Berkshire Hathaway']
grandchild.ancestors.map(&:name) => ['Acme Brick Company', ['Berkshire Hathaway']
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/christianhellsten/tree-rails. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Arrr::Tree project’s codebases, issue trackers, chat rooms and mailing lists is expetreed to follow the [code of conduct](https://github.com/christianhellsten/cte-rails/blob/master/CODE_OF_CONDUCT.md).
