require 'spec_helper'
require './lib/jsender'

class Tester
  include Jsender
end

describe Jsender do
  before :each do
    @iut = Tester.new
  end

  context "when reporting" do
    context "given a result that is not a hash" do
      it "should turn the result into a result hash and include it in the jsend data result field" do
        expect(@iut.report("status", "message", "result")).to eq({'status' => 'status', 'data' => { 'result' => 'result', 'notifications' => ['message'] }})
      end
    end

    context "given a result that is a hash" do
      it "should include all keys and values in the hash in the jsend data result field" do
        expect(@iut.report("status", "message", {'one' => 1, 'two' => 'two'})).to eq({'status' => 'status', 'data' => { 'one' => 1, 'two' => 'two', 'notifications' => ['message'] }})
      end
    end

    context "given a result that is nil" do
      it "should turn the nil into a result hash and include it in the jsend data result field" do
        expect(@iut.report("status", "message", nil)).to eq({'status' => 'status', 'data' => { 'result' => nil, 'notifications' => ['message'] }})
      end
    end

    context "given a message that is nil" do
      it "should include the nil in an array and set that as the jsend data notifications field" do
        expect(@iut.report("status", nil, "result")).to eq({'status' => 'status', 'data' => { 'result' => 'result', 'notifications' => [nil] }})
      end
    end

    context "given a message that is not an array" do
      it "should include the message in an array and set that as the jsend data notifications field" do
        expect(@iut.report("status", "message", "result")).to eq({'status' => 'status', 'data' => { 'result' => 'result', 'notifications' => ['message'] }})
      end
    end

    context "given a message that is an array" do
      it "should set the message as the jsend data notifications field" do
        expect(@iut.report("status", [ "message1", "message2"], "result")).to eq({'status' => 'status', 'data' => { 'result' => 'result', 'notifications' => ['message1', 'message2'] }})
      end
    end

    context "given a status that is nil" do
      it "should set the jsend status field to the status" do
        expect(@iut.report(nil, "message", "result")).to eq({'status' => nil, 'data' => { 'result' => 'result', 'notifications' => ['message'] }})
      end
    end

    context "given a status" do
      it "should set the jsend status field to the status" do
        expect(@iut.report("status", "message", "result")).to eq({'status' => 'status', 'data' => { 'result' => 'result', 'notifications' => ['message'] }})
      end
    end
  end

  context "when asked to report an error" do
    it "should set the jsend status to 'error'" do
      expect(@iut.error).to eq({'status' => 'error', 'message' => nil})
    end

    it "should set the jsend messahe field to the message provided" do
      expect(@iut.error("message")).to eq({'status' => 'error', 'message' => 'message'})
    end
  end

  context "when asked to report failure" do
    it "should set the jsend status to 'fail'" do
      expect(@iut.fail("message", "result")).to eq({'status' => 'fail', 'data' => { 'result' => 'result', 'notifications' => ['message'] }})
    end

    it "should include 'fail' in the jsend data notifications field if the message is nil" do
      expect(@iut.fail(nil, "result")).to eq({'status' => 'fail', 'data' => { 'result' => 'result', 'notifications' => ['fail'] }})
    end

    it "should include the message in the jsend data notifications field" do
      expect(@iut.fail("message", "result")).to eq({'status' => 'fail', 'data' => { 'result' => 'result', 'notifications' => ['message'] }})
    end

    it "should include a result field set to nil and no other data keys, other than notifications if no data was provided" do
      expect(@iut.fail("message")).to eq({'status' => 'fail', 'data' => { 'result' => nil, 'notifications' => ['message'] }})     
    end

    it "should include data provided in the jsend data field" do
      expect(@iut.fail("message", "result")).to eq({'status' => 'fail', 'data' => { 'result' => 'result', 'notifications' => ['message'] }})
    end
  end

  context "when asked to report failure with data" do
    it "should set status to fail, notifications to fail and result to nil if no data provided" do
      expect(@iut.fail_data()).to eq({'status' => 'fail', 'data' => { 'result' => nil, 'notifications' => ['fail'] }})
    end

    it "should set status to fail, notifications to fail and include the data provided in the jsend data result field" do
      expect(@iut.fail_data("data")).to eq({'status' => 'fail', 'data' => { 'result' => "data", 'notifications' => ['fail'] }})
    end
  end

  context "whensuccess asked to report success" do
    it "should ssuccesset the jsend stasuccesstus to 'success'" do
      expect(@iut.success("message", "result")).to eq({'status' => 'success', 'data' => { 'result' => 'result', 'notifications' => ['message'] }})
    end

    it "should include 'success' in the jsend data notifications field if the message is nil" do
      expect(@iut.success(nil, "result")).to eq({'status' => 'success', 'data' => { 'result' => 'result', 'notifications' => ['success'] }})
    end

    it "should include the message in the jsend data notifications field" do
      expect(@iut.success("message", "result")).to eq({'status' => 'success', 'data' => { 'result' => 'result', 'notifications' => ['message'] }})
    end

    it "should include a result field set to nil and no other data keys, other than notifications if no data was provided" do
      expect(@iut.success("message")).to eq({'status' => 'success', 'data' => { 'result' => nil, 'notifications' => ['message'] }})     
    end

    it "should include data provided in the jsend data field" do
      expect(@iut.success("message", "result")).to eq({'status' => 'success', 'data' => { 'result' => 'result', 'notifications' => ['message'] }})
    end
  end

  context "when asked to report success with data" do
    it "should set status to success, notifications to success and result to nil if no data provided" do
      expect(@iut.success_data()).to eq({'status' => 'success', 'data' => { 'result' => nil, 'notifications' => ['success'] }})
    end

    it "should set status to success, notifications to success and include the data provided in the jsend data result field" do
      expect(@iut.success_data("data")).to eq({'status' => 'success', 'data' => { 'result' => "data", 'notifications' => ['success'] }})
    end
  end

  context "when asked whether a data key is present given a jsend result" do
    it "should return false if they key is nil" do
      expect(@iut.has_data?({'data' => {'index' => 'value'}}, nil)).to eq(false)
    end

    it "should return false if the result provided is nil" do
      expect(@iut.has_data?(nil, 'index')).to eq(false)
    end

    it "should return false if the result provided does not have data" do
      expect(@iut.has_data?({}, 'index''index')).to eq(false)
    end

    it "should return false if the result provided's data does not have the key provided" do
      expect(@iut.has_data?({'data' => {}}, 'index')).to eq(false)
    end

    it "should return false if the result provided's data does have the key provided, but the value is nil" do
      expect(@iut.has_data?({'data' => {'index' => nil}}, 'index')).to eq(false)
    end

    it "should return true if the result provided's data does have the key provided" do
      expect(@iut.has_data?({'data' => {'index' => 'value'}}, 'index')).to eq(true)
    end
  end

  context "when asked whether a notification is present given a jsend result" do
    it "should return false if the result provided is nil" do
      expect(@iut.notifications_include?(nil, 'index')).to eq(false)
    end

    it "should return false if the result provided does not have data" do
      expect(@iut.notifications_include?({}, 'index''index')).to eq(false)
    end

    it "should return false if the result provided's data does not have notifications" do
      expect(@iut.notifications_include?({'data' => {}}, 'index')).to eq(false)
    end

    it "should return false if the result provided's data does notifications, but the value is nil" do
      expect(@iut.notifications_include?({'data' => {'notifications' => nil}}, 'index')).to eq(false)
    end

    it "should return false if the result provided's data does have notifications, but the pattern is not in any of them" do
      expect(@iut.notifications_include?({'data' => {'notifications' => ['value']}}, 'index')).to eq(false)
    end

    it "should return true if the result provided's data does have notifications, and the pattern is in one or more of them" do
      expect(@iut.notifications_include?({'data' => {'notifications' => ['value', 'an index']}}, 'index')).to eq(true)
    end
  end
end
