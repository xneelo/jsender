# Jsender

JSender facilitates a simple jsend implementation for ruby. You can report success, fail, success with data, fail with data. The jsend response contains 'status' and 'data'. 'data' contains what-ever you put in it, as well as a 'notifications' array. Helpers are provided to check whether a notification is present and whether a specific data key is present.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jsender'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jsender

## Usage

```
  require 'jsender'
  
  class CodeClass
    include Jsender
  
    def action(code)
      return success if code == 1
      return success('code 2 selected') if code == 2
      return success_data({ 'a' => 'A', 'b' => 'B' }) if code == 3
      return success('some data for you', ['d', 'a', 't', 'a']) if code == 4
      return fail('code 5 selected') if code == 5
      return fail_data({ 'a' => 'A', 'b' => 'B' }) if code == 6
      return fail('some errors for you', ['d', 'a', 't', 'a']) if code == 7
      fail
    end
  end
```

```
  iut = CodeClass.new
```

```
  iut.action(1)
  => {"status"=>"success", "data"=>{"result"=>nil, "notifications"=>["success"]}} 

  iut.action(2)
  => {"status"=>"success", "data"=>{"result"=>nil, "notifications"=>["code 2 selected"]}} 

  iut.action(3)
  => {"status"=>"success", "data"=>{"a"=>"A", "b"=>"B", "notifications"=>["success"]}} 

  iut.action(4)
  => {"status"=>"success", "data"=>{"result"=>["d", "a", "t", "a"], "notifications"=>["some data for you"]}} 

  iut.action(5)
  => {"status"=>"fail", "data"=>{"result"=>nil, "notifications"=>["code 5 selected"]}} 

  iut.action(6)
  => {"status"=>"fail", "data"=>{"a"=>"A", "b"=>"B", "notifications"=>["fail"]}} 

  iut.action(7)
  => {"status"=>"fail", "data"=>{"result"=>["d", "a", "t", "a"], "notifications"=>["some errors for you"]}} 

  iut.action(0)
  => {"status"=>"fail", "data"=>{"result"=>nil, "notifications"=>["fail"]}} 

  iut.has_data?(result, 'a')
  => true 
  iut.has_data?(result, 'z')
  => false 

  result = iut.action(6)
  iut.notifications_include?(result, "ail")
  => true 
  iut.notifications_include?(result, "not")
  => false 

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hetznerZA/jsender. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

