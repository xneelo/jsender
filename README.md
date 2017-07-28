# Jsender

[![Gem Version](https://badge.fury.io/rb/jsender.png)](https://badge.fury.io/rb/jsender)
[![Build Status](https://travis-ci.org/hetznerZA/jsender.svg?branch=master)](https://travis-ci.org/hetznerZA/jsender)
[![Coverage Status](https://coveralls.io/repos/github/hetznerZA/jsender/badge.svg?branch=master)](https://coveralls.io/github/hetznerZA/jsender?branch=master)
[![Codacy Badge](https://api.codacy.com/project/badge/Grade/2823754c19964ba698f0a90167583d94)](https://www.codacy.com/app/ernst-van-graan/jsender?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=hetznerZA/jsender&amp;utm_campaign=Badge_Grade)

JSender facilitates a simple jsend implementation for ruby. You can report success, error, fail, success with data, fail with data. The jsend response contains 'status' and 'data'. 'data' contains what-ever you put in it, as well as a 'notifications' array. Helpers are provided to check whether a notification is present and whether a specific data key is present. On error the response contains 'message'.

For more info about JSend refer to https://labs.omniti.com/labs/jsend

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
### Returns Ruby Hash

```
  Jsender.success
  => {"status"=>"success", "data"=>{"result"=>nil, "notifications"=>["success"]}}

  Jsender.success('happy day')
  => {"status"=>"success", "data"=>{"result"=>nil, "notifications"=>["happy day"]}}

  result = Jsender.success_data({ 'a' => 'A', 'b' => 'B' })
  => {"status"=>"success", "data"=>{"a"=>"A", "b"=>"B", "notifications"=>["success"]}}
  Jsender.has_data?(result, 'b')
  => true

  result = Jsender.success('some data for you', ['d', 'a', 't', 'a'])
  => {"status"=>"success", "data"=>{"result"=>["d", "a", "t", "a"], "notifications"=>["some data for you"]}}
  Jsender.has_data?(result, 'result')
  => true
  Jsender.notifications_include?(result, 'ata fo')
  => true

  Jsender.error
  => {"status"=>"error", "message"=>nil}

  Jsender.error('something went wrong')
  => {"status"=>"error", "message"=>"something went wrong"}

  Jsender.failure
  => {"status"=>"fail", "data"=>{"result"=>nil, "notifications"=>["fail"]}}

  Jsender.failure('a failure occurred')
  => {"status"=>"fail", "data"=>{"result"=>nil, "notifications"=>["a failure occurred"]}}

  Jsender.failure('a failure occurred', ['d', 'a', 't', 'a'])
  => {"status"=>"fail", "data"=>{"result"=>["d", "a", "t", "a"], "notifications"=>["a failure occurred"]}}
```

### Returns JSON

```
  Jsender.success_json
  => "{\"status\":\"success\", \"data\": null}"

  Jsender.success_json({:key1 => 'value1'})
  => "{\"status\":\"success\",\"data\":{\"key1\":\"value1\"}}"

  Jsender.fail_json
  => "{\"status\": \"fail\", \"data\": null}"

  Jsender.fail_json({:key1 => "value1"})
  => "{\"status\":\"fail\",\"data\":{\"key1\":\"value1\"}}"

  Jsender.error_json
  => ArgumentError, 'Missing required argument message'

  Jsender.error_json('My little error')
  => "{\"status\":\"error\", \"message\":\"My little error\"}"

  Jsender.error_json('Another little error', 401)
  => "{\"status\":\"error\",\"message\":\"Another little error\",\"code\":401}"

  Jsender.error_json('Another little error', 401, {:key1 => 'cause of another little error'})
  => "{\"status\":\"error\",\"message\":\"Another little error\",\"code\":401,\"data\":{\"key1\":\"cause of another little error\"}}"

  Jsender.error_json('Another little error', {:key1 => 'cause of another little error'})
  => "{\"status\":\"error\",\"message\":\"Another little error\",\"data\":{\"key1\":\"cause of another little error\"}}"
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hetznerZA/jsender.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
