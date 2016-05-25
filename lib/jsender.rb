require 'jsender/version'

module Jsender

  def report(status, message, result = nil)
    return { 'status' => 'error', 'message' => message } if status == 'error'
    data = compile_data(result)
    data['notifications'] = message.is_a?(Array) ? message : [ message ] 
    { 'status' => status, 'data' => data }
  end

  def error(message = nil)
    report('error', message)
  end

  def fail(message = nil, data = nil)
    message ||= 'fail'
    report('fail', message, data)
  end

  def fail_data(data = nil)
    fail(nil, data)
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
    return false if not has_data?(result, 'notifications')
    result['data']['notifications'].to_s.include?(pattern)
  end

  ##
  # @param data optional [Hash]
  # @return [String] jsend json
  def success_json(data = nil)
    raise ArgumentError, 'data should be hash' if not data.is_a? Hash and not data.nil?
    return JSON.generate({
      :status => 'success',
      :data => data
    })
  end

  ##
  # @param data optional [Hash]
  # @return [String] jsend json
  def fail_json(data = nil)
    raise ArgumentError, 'Optional data argument should be hash' if not data.is_a? Hash and not data.nil?
    return JSON.generate({
      :status => 'fail',
      :data => data
    })
  end

  ##
  # @param msg [String]
  # @param args optional [Integer]
  # @param data optional [Hash]
  # @return [String] jsend json
  def error_json(msg, code = nil, data = nil)
    raise ArgumentError, 'Missing required message' if msg.empty? or not msg.is_a? String
    raise ArgumentError if not code.nil? and not code.is_a? Integer
    raise ArgumentError if not data.nil? and not data.is_a? Hash
    jsend = {
      :status => 'error',
      :message => msg
    }
    jsend['code'] = code if not code.nil?
    jsend['data'] = data if not data.nil?
    return JSON.generate(jsend)
  end

  private

  def compile_data(result)
    data ||= {}
    result = { 'result' => result} if not result.is_a? Hash
    result.each do |key, value|
      data[key] = value
    end
    data
  end
end
