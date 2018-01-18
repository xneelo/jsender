require 'spec_helper'
require 'jsender'
require 'json'

describe Jsender::Json do
  subject { described_class }

  let(:data) {
    {
      'key' => 'value'
    }
  }

  let(:message) {
    'some message'
  }

  describe '#error' do
    context 'with no arguments' do
      it 'should return a json encoded hash with default error message' do
        expected_result = {
          'status' => 'error',
          'message'   => 'An error has occurred'
        }.to_json
        expect(subject.error()).to eq(expected_result)
      end
    end

    context 'with message argument' do
      it 'should return a json encoded hash with provided message' do
        expected_result = {
          'status' => 'error',
          'message'   => message
        }.to_json
        expect(subject.error(message: message)).to eq(expected_result)
      end
    end
  end

  describe '#failure' do
    context 'with no arguments' do
      it 'should return a json encoded hash with default failure message' do
        expected_result = {
          'status' => 'fail',
          'data'   => {
            'message' => 'A failure has occurred'
          }
        }.to_json
        expect(subject.failure()).to eq(expected_result)
      end
    end

    context 'with message argument' do
      it 'should return a json encoded hash with provided message' do
        expected_result = {
          'status' => 'fail',
          'data'   => {
            'message' => message
          }
        }.to_json
        expect(subject.failure(message: message)).to eq(expected_result)
      end
    end
  end

  describe '#success' do
    context 'with no arguments' do
      it 'should return a json encoded hash with nil data' do
        expected_result = {
          'status' => 'success',
          'data'   => nil
        }.to_json
        expect(subject.success()).to eq(expected_result)
      end
    end

    context 'with data argument' do
      it 'should return a json encoded hash with provided data' do
        expected_result = {
          'status' => 'success',
          'data'   => data
        }.to_json
        expect(subject.success(data: data)).to eq(expected_result)
      end
    end
  end
end
