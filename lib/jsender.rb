require "jsender/version"

module Jsender
  def report(status, message, result = nil)
    data = compile_data(result)
    data['notifications'] = message.is_a?(Array) ? message : [ message ] 
    { 'status' => status, 'data' => data }
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
