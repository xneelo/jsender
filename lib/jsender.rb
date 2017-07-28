require 'jsender/version'

module Jsender

  def self.report(status, message, result = nil)
    return { 'status' => 'error', 'message' => message } if status == 'error'
    data = compile_data(result)
    data['notifications'] = message.is_a?(Array) ? message : [ message ]
    { 'status' => status, 'data' => data }
  end

  def self.error(message = nil)
    report('error', message)
  end

  def self.failure(message = nil, data = nil)
    message ||= 'fail'
    report('fail', message, data)
  end

  def self.fail_data(data = nil)
    failure(nil, data)
  end

  def self.success_data(data = nil)
    success(nil, data)
  end

  def self.success(message = nil, data = nil)
    message ||= 'success'
    report('success', message, data)
  end

  def self.has_data?(result, key = nil)
    return false if key.nil?
    return false if (result.nil?) or (result['data'].nil?)
    return false if (not key.nil?) and (result['data'][key].nil?)
    true
  end

  def self.notifications_include?(result, pattern)
    return false unless has_data?(result, 'notifications')
    result['data']['notifications'].to_s.include?(pattern)
  end

  ##
  # @param data optional [Hash]
  # @return [String] jsend json
  def self.success_json(data = nil)
    raise ArgumentError, 'Optional data argument should be of type Hash' if invalid_hash?(data)
    return JSON.generate({
      :status => 'success',
      :data => data
    })
  end

  ##
  # @param data optional [Hash]
  # @return [String] jsend json
  def self.fail_json(data = nil)
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
  def self.error_json(msg, code = nil, data = nil)
    code, data = validate_and_sanitize(msg, code, data)
    jsend = {
      :status => 'error',
      :message => msg
    }
    generate_error_json(jsend, code, data)
  end

  private

  def self.invalid_integer?(value)
    (not value.nil?) and (not value.is_a? Integer)
  end

  def self.invalid_hash?(data)
    if not data.nil?
      return true if not data.is_a? Hash
    end
    false
  end

  def self.generate_error_json(jsend, code, data)
    jsend['code'] = code unless code.nil?
    jsend['data'] = data unless data.nil?
    return JSON.generate(jsend)
  end

  def self.validate_and_sanitize(msg, code, data)
    validate_message(msg)
    code, data = set_code_and_data(code, data)
    validate_data(data)
    validate_code(code)
    return code, data
  end

  def self.set_code_and_data(code, data)
    code, data = nil, code if not code.is_a? Integer and code.is_a? Hash and data.nil?
    return code, data
  end

  def self.validate_message(msg)
    raise ArgumentError, 'Missing required message of type String' if msg.empty? or not msg.is_a? String
  end

  def self.validate_data(data)
    raise ArgumentError, 'Optional data argument should be of type Hash' if invalid_hash?(data)
  end

  def self.validate_code(code)
    raise ArgumentError, 'Optional code argument should be of type Integer' if invalid_integer?(code)
  end

  def self.compile_data(result)
    data ||= {}
    result = { 'result' => result} unless result.is_a? Hash
    result.each do |key, value|
      data[key] = value
    end
    data
  end
end
