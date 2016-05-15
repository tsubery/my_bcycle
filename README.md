## Description
This gem wraps bcycle personal statistics api to provider statistics for specific user. Currently only Austin is tested and supported but it might work for other cities where bcycle is operating. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'my_bcycle'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install my_bcycle

## Usage

```ruby
me = MyBcycle::User.new(
  username: "me",
  password: "secret"
)
me.statistics_for(Time.parse('2016-05-01')) =>
  "2001-01-01 01:01:01.01Z" => {
  miles: 999.80,
  duration: 22,
  money_saved: 1.5
}
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tsubery/my_bcycle.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

