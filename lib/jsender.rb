require 'jsender/version'
require 'jsender/json'
require 'jsender/rack'

module Jsender
  extend self

  def report(status, message, result = nil)
    return {'status' => 'error', 'message' => message} if status == 'error'
    data = compile_data(result)
    data['notifications'] = message.is_a?(Array) ? message : [message]
    {'status' => status, 'data' => data}
  end

  def error(message = nil)
    report('error', message)
  end

  def failure(message = nil, data = nil)
    message ||= 'fail'
    report('fail', message, data)
  end

  def fail_data(data = nil)
    failure(nil, data)
  end

  def success_data(data = nil)
    success(nil, data)
  end

  def success(message = nil, data = nil)
    message ||= 'success'
    report('success', message, data)
  end

  def has_data?(result, key = nil)
    return false if key.nil?
    return false if (result.nil?) or (result['data'].nil?)
    return false if (not key.nil?) and (result['data'][key].nil?)
    true
  end

  def notifications_include?(result, pattern)
    return false unless has_data?(result, 'notifications')
    result['data']['notifications'].to_s.include?(pattern)
  end

  ##
  # @param data optional [Hash]
  # @return [String] jsend json
  def success_json(data = nil)
    raise ArgumentError, 'Optional data argument should be of type Hash' if invalid_hash?(data)
    return JSON.generate({
                             :status => 'success',
                             :data => data
                         })
  end

  ##
  # @param data optional [Hash]
  # @return [String] jsend json
  def fail_json(data = nil)
    raise ArgumentError, 'Optional data argument should be of type Hash' if invalid_hash?(data)
    return JSON.generate({
                             :status => 'fail',
                             :data => data
                         })
  end

  ##
  # @param msg [String]
  # @param code optional [Integer]
  # @param data optional [Hash]
  # @return [String] jsend json
  def error_json(msg, code = nil, data = nil)
    code, data = validate_and_sanitize(msg, code, data)
    jsend = {
        :status => 'error',
        :message => msg
    }
    generate_error_json(jsend, code, data)
  end

  private

  def invalid_integer?(value)
    (not value.nil?) and (not value.is_a? Integer)
  end

  def invalid_hash?(data)
    if not data.nil?
      return true if not data.is_a? Hash
    end
    false
  end

  def generate_error_json(jsend, code, data)
    jsend['code'] = code unless code.nil?
    jsend['data'] = data unless data.nil?
    return JSON.generate(jsend)
  end

  def validate_and_sanitize(msg, code, data)
    validate_message(msg)
    code, data = set_code_and_data(code, data)
    validate_data(data)
    validate_code(code)
    return code, data
  end

  def set_code_and_data(code, data)
    code, data = nil, code if not code.is_a? Integer and code.is_a? Hash and data.nil?
    return code, data
  end

  def validate_message(msg)
    raise ArgumentError, 'Missing required message of type String' if msg.empty? or not msg.is_a? String
  end

  def validate_data(data)
    raise ArgumentError, 'Optional data argument should be of type Hash' if invalid_hash?(data)
  end

  def validate_code(code)
    raise ArgumentError, 'Optional code argument should be of type Integer' if invalid_integer?(code)
  end

  def compile_data(result)
    data ||= {}
    result = {'result' => result} unless result.is_a? Hash
    result.each do |key, value|
      data[key] = value
    end
    data
  end

end
