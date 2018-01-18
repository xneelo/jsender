module Jsender
  module Rack
    extend self

    def error(code: 500, flow_id: nil, message: "An error has occurred", body_as_array: false)
      [
        code,
        headers(flow_id: flow_id),
        body(data: Jsender::Json.error(message: message), body_as_array: body_as_array)
      ]
    end

    def failure(code: 400, flow_id: nil, message: "A failure has occurred", body_as_array: false)
      [
        code,
        headers(flow_id: flow_id),
        body(data: Jsender::Json.failure(message: message), body_as_array: body_as_array)
      ]
    end

    def success(code: 200, flow_id: nil, data: nil, body_as_array: false)
      [
        code,
        headers(flow_id: flow_id),
        body(data: Jsender::Json.success(data: data), body_as_array: body_as_array)
      ]
    end

    private

    def body(data:, body_as_array: false)
      return [data] if body_as_array
      data
    end

    def headers(flow_id:)
      {
        'Content-Type' => 'application/json',
        'X-Flow-Identifier' => flow_id
      }
    end
  end

end
