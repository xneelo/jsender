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

```bash
bundle
```

Or install it yourself as:

```bash
gem install jsender
```

## Usage
### Returns JSON

Basic usage without any parameters yielding default json encoded jsend format:

```ruby
Jsender::Json.success
 => "{\"status\":\"success\",\"data\":null}"

Jsender::Json.failure
 => "{\"status\":\"fail\",\"data\":{\"message\":\"A failure has occurred\"}}"

Jsender::Json.error
 => "{\"status\":\"error\",\"message\":\"An error has occurred\"}"
```

Or with parameters yielding the correct json encoded jsend format:

```ruby
Jsender::Json.success(data: {'key' => 'value'})
 => "{\"status\":\"success\",\"data\":{\"key\":\"value\"}}"

Jsender::Json.failure(message: 'custom message')
 => "{\"status\":\"fail\",\"data\":{\"message\":\"custom message\"}}"

Jsender::Json.error(message: 'custom message')
 => "{\"status\":\"error\",\"message\":\"custom message\"}"
```

### Returns Rack Response Tuple

Basic usage without any parameters yielding default json encoded jsend format in a Rack tuple:

```ruby
Jsender::Rack.success
 => [200, {"Content-Type"=>"application/json"}, "{\"status\":\"success\",\"data\":null}"]

Jsender::Rack.failure
 => [400, {"Content-Type"=>"application/json"}, "{\"status\":\"fail\",\"data\":{\"message\":\"A failure has occurred\"}}"]

Jsender::Rack.error
=> [500, {"Content-Type"=>"application/json"}, "{\"status\":\"error\",\"message\":\"An error has occurred\"}"]
```

Or with parameters yielding the correct json encoded jsend format in a Rack tuple for use in controllers (including Sinatra):

```ruby
Jsender::Rack.success(data: {'key' => 'value'}, code: 201, flow_id: '123')
 => [201, {"Content-Type"=>"application/json", "X-Flow-Identifier"=>"123"}, "{\"status\":\"success\",\"data\":{\"key\":\"value\"}}"]

Jsender::Rack.failure(message: 'some custom failure message', code: 201, flow_id: '123')
 => [201, {"Content-Type"=>"application/json", "X-Flow-Identifier"=>"123"}, "{\"status\":\"fail\",\"data\":{\"message\":\"some custom failure message\"}}"]

Jsender::Rack.error(message: 'some custom failure message', code: 201, flow_id: '123')
 => [201, {"Content-Type"=>"application/json", "X-Flow-Identifier"=>"123"}, "{\"status\":\"error\",\"message\":\"some custom failure message\"}"]
```

### Returns Rack Response Tuple for Middlewares

Rack middlware responses require that the body of the response tuple is in an array. Enable this using the body_as_array parameter (false by default):

```ruby
Jsender::Rack.error(body_as_array: true)
 => [500, {"Content-Type"=>"application/json"}, ["{\"status\":\"error\",\"message\":\"An error has occurred\"}"]]
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/hetznerZA/jsender.

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
