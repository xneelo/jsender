require 'spec_helper'
require 'jsender'
require 'json'

class Tester
  include Jsender
end

describe Jsender do


  before :all do
    @iut = Tester.new
    @data = {
      :key1 => 'value1',
      :key2 => 'value2'
    }
  end

  describe '#success_json' do

    context 'no arguments' do
      it 'should return jsend data as null' do
        actual_result = @iut.success_json()
        expected_result = JSON.generate({
          :status => 'success',
          :data => nil
        })
        expect(actual_result).to eq(expected_result)
      end
    end

    context 'invalid arguments' do
      it 'should raise invalid argument exception' do
        expect {
          @iut.success_json('string')
        }.to raise_error ArgumentError
        expect {
          @iut.success_json(123)
        }.to raise_error ArgumentError
      end
    end

    context 'valid arguments' do
      it 'should return jsend success and data ' do
        actual_result = @iut.success_json(@data)
        expected_result = JSON.generate({
          :status => 'success',
          :data => @data
        })
        expect(actual_result).to eq(expected_result)
      end
    end
  end

  describe '#fail_json' do
    context 'no arguments' do
      it 'should return jsend data as null' do
        actual_result = @iut.fail_json()
        expected_result = JSON.generate({
          :status => 'fail',
          :data => nil
        })
        expect(actual_result).to eq(expected_result)
      end
    end

    context 'invalid arguments' do
      it 'should raise invalid argument exception' do
        expect {
          @iut.fail_json('string')
        }.to raise_error ArgumentError
        expect {
          @iut.success_json(123)
        }.to raise_error ArgumentError
      end
    end

    context 'valid arguments' do
      it 'should return jsend success and data ' do
        actual_result = @iut.fail_json(@data)
        expected_result = JSON.generate({
          :status => 'fail',
          :data => @data
        })
        expect(actual_result).to eq(expected_result)
      end
    end
  end

  describe '#error_json' do

    before :all do
      @msg = 'My descriptive error message'
    end

    context 'no arguments' do
      it 'should raise invalid arguments exception' do
        expect {
          @iut.error_json()
        }.to raise_error ArgumentError
      end
    end

    context 'invalid arguments' do
      it 'code should only accept integers' do
        expect {
          @iut.error_json(@msg, @data).to raise_error ArgumentError
        }
        expect {
          @iut.error_json(@msg, 'string').to raise_error ArgumentError
        }
      end
      it 'data should only accept a hash' do
        expect {
          @iut.error_json(@msg, 400, [1, 2, 3]).to raise_error ArgumentError
        }
        expect {
          @iut.error_json(@msg, 400, 0).to raise_error ArgumentError
        }
      end
    end

    context 'valid arguments' do

      it 'should return jsend error and message' do
        expect(@iut.error_json(@msg)).to eq(JSON.generate({
          :status => 'error',
          :message => @msg
        }))
      end

      it 'should return json error, message and code' do
        expect(@iut.error_json(@msg, 200)).to eq({
          :status => 'error',
          :message => @msg,
          :code => 200
        }.to_json)

        expect(@iut.error_json(@msg, 0)).to eq({
          :status => 'error',
          :message => @msg,
          :code => 0
        }.to_json)
      end

      it 'should return json error, message, code and data' do
        expect(@iut.error_json(@msg, 200, @data)).to eq({
          :status => 'error',
          :message => @msg,
          :code => 200,
          :data => @data
        }.to_json)
      end

      it 'should return json error, message and data' do
        expect(@iut.error_json(@msg, @data)).to eq({
          :status => 'error',
          :message => @msg,
          :data => @data
        }.to_json)

        expect(@iut.error_json(@msg, nil, @data)).to eq({
          :status => 'error',
          :message => @msg,
          :data => @data
        }.to_json)
      end

    end

  end

end
