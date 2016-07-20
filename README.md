# Jsender

JSender facilitates a simple jsend implementation for ruby. You can report success, error, fail, success with data, fail with data. The jsend response contains 'status' and 'data'. 'data' contains what-ever you put in it, as well as a 'notifications' array. Helpers are provided to check whether a notification is present and whether a specific data key is present. On error the response contains 'message'.

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
  end
```

```
  iut = CodeClass.new
```

### Returns Ruby Hash

```
  iut.success
  => {"status"=>"success", "data"=>{"result"=>nil, "notifications"=>["success"]}} 

  iut.success('happy day')
  => {"status"=>"success", "data"=>{"result"=>nil, "notifications"=>["happy day"]}} 

  result = iut.success_data({ 'a' => 'A', 'b' => 'B' })
  => {"status"=>"success", "data"=>{"a"=>"A", "b"=>"B", "notifications"=>["success"]}} 
  iut.has_data?(result, 'b')
  => true

  result = iut.success('some data for you', ['d', 'a', 't', 'a'])
  => {"status"=>"success", "data"=>{"result"=>["d", "a", "t", "a"], "notifications"=>["some data for you"]}} 
  iut.has_data?(result, 'result')
  => true
  iut.notifications_include?(result, 'ata fo')
  => true

  iut.error
  => {"status"=>"error", "message"=>nil} 

  iut.error('something went wrong')
  => {"status"=>"error", "message"=>"something went wrong"} 

  iut.fail
  => {"status"=>"fail", "data"=>{"result"=>nil, "notifications"=>["fail"]}} 

  iut.fail('a failure occurred')
  => {"status"=>"fail", "data"=>{"result"=>nil, "notifications"=>["a failure occurred"]}} 

  iut.fail('a failure occurred', ['d', 'a', 't', 'a'])
  => {"status"=>"fail", "data"=>{"result"=>["d", "a", "t", "a"], "notifications"=>["a failure occurred"]}} 
```

### Returns JSON

```
  iut.success_json
  => "{\"status\":\"success\", \"data\": null}"

  iut.success_json({:key1 => 'value1'})
  => "{\"status\":\"success\",\"data\":{\"key1\":\"value1\"}}"

  iut.fail_json
  => "{\"status\": \"fail\", \"data\": null}"

  iut.fail_json({:key1 => "value1"})
  => "{\"status\":\"fail\",\"data\":{\"key1\":\"value1\"}}"

  iut.error_json
  => ArgumentError, 'Missing required argument message'

  iut.error_json('My little error')
  => "{\"status\":\"error\", \"message\":\"My little error\"}"

  iut.error_json('Another little error', 401)
  => "{\"status\":\"error\",\"message\":\"Another little error\",\"code\":401}"

  iut.error_json('Another little error', 401, {:key1 => 'cause of another little error'})
  => "{\"status\":\"error\",\"message\":\"Another little error\",\"code\":401,\"data\":{\"key1\":\"cause of another little error\"}}"

  iut.error_json('Another little error', {:key1 => 'cause of another little error'})
  => "{\"status\":\"error\",\"message\":\"Another little error\",\"data\":{\"key1\":\"cause of another little error\"}}"
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hetznerZA/jsender.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

