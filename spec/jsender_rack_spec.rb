require 'spec_helper'
require 'jsender'
require 'json'

describe Jsender::Rack do
  subject { described_class }

  let(:data) {
    {
      'key' => 'value'
    }
  }

  let(:message) {
    'some message'
  }

  let(:flow_id) {
    'test_123'
  }

  let(:code) {
    111
  }

  describe '#success' do
    context 'no arguments' do
      it 'should return rack compatible empty success tuple' do
        expected_result =
        [
          200,
          {
            "Content-Type"      => "application/json",
            "X-Flow-Identifier" => nil
          },
          {
            'status' => 'success',
            'data'   => nil
          }.to_json
        ]
        expect(subject.success()).to eq(expected_result)
      end
    end

    context 'with data argument' do
      it 'should return rack compatible success tuple including the data' do
        expected_result =
        [
          200,
          {
            "Content-Type"      => "application/json",
            "X-Flow-Identifier" => nil
          },
          {
            'status' => 'success',
            'data'   => data
          }.to_json
        ]
        expect(subject.success(data: data)).to eq(expected_result)
      end
    end

    context 'with flow_id argument' do
      it 'should return rack compatible success tuple including the flow_id' do
        expected_result =
        [
          200,
          {
            "Content-Type"      => "application/json",
            "X-Flow-Identifier" => flow_id
          },
          {
            'status' => 'success',
            'data'   => nil
          }.to_json
        ]
        expect(subject.success(flow_id: flow_id)).to eq(expected_result)
      end
    end

    context 'with code argument' do
      it 'should return rack compatible success tuple including the code' do
        expected_result =
        [
          code,
          {
            "Content-Type"      => "application/json",
            "X-Flow-Identifier" => nil
          },
          {
            'status' => 'success',
            'data'   => nil
          }.to_json
        ]
        expect(subject.success(code: code)).to eq(expected_result)
      end
    end

    context 'with body_as_array argument set to true for use in rack middleware' do
      it 'should return rack compatible success tuple including the code' do
        expected_result =
        [
          200,
          {
            "Content-Type"      => "application/json",
            "X-Flow-Identifier" => nil
          },
          [
            {
              'status' => 'success',
              'data'   => nil
            }.to_json
          ]
        ]
        expect(subject.success(body_as_array: true)).to eq(expected_result)
      end
    end
  end

  describe '#failure' do
  end

  describe '#error' do
  end

end
