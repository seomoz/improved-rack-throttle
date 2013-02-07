require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Rack::Throttle::SlidingWindow do
  include Rack::Test::Methods

  def app
    @target_app ||= example_target_app
    @app ||= Rack::Throttle::SlidingWindow.new(@target_app, :burst => 2, :average => 1)
  end

  before(:each) do
    Timecop.freeze
    @time = Time.now
  end

  after(:each) do
    Timecop.return
  end

  it "should allow the request if the source has not been seen at all" do
    get "/foo"
    last_response.body.should show_allowed_response
  end
  
  it "should allow the request if the rate is above-average but within the burst rule" do
    Timecop.freeze(@time) { get "/foo" }
    Timecop.freeze(@time + 0.5) { get "/foo" }
    last_response.body.should show_allowed_response
  end

   it "should not allow the request if the rate is greater than the burst rule" do
    Timecop.freeze(@time) { get "/foo" }
    Timecop.freeze(@time + 0.3) { get "/foo" }
    Timecop.freeze(@time + 0.6) { get "/foo" }
    last_response.body.should show_throttled_response
  end
  
  it "should allow the request if the rate is less than the average" do
    Timecop.freeze(@time) { get "/foo" }
    Timecop.freeze(@time + 0.5) { get "/foo" }
    Timecop.freeze(@time + 2) { get "/foo" }

    last_response.body.should show_allowed_response
  end

  it "should not allow the request if the rate is more than the average" do
    Timecop.freeze(@time) { get "/foo" }
    Timecop.freeze(@time + 0.5) { get "/foo" }
    Timecop.freeze(@time + 1) { get "/foo" }
    Timecop.freeze(@time + 1.5) { get "/foo" }

    last_response.body.should show_throttled_response
  end

  it "should gracefully allow the request if the cache bombs on getting" do
    app.should_receive(:cache_get).and_raise(StandardError)
    get "/foo"
    last_response.body.should show_allowed_response
  end
  
  it "should gracefully allow the request if the cache bombs on setting" do
    app.should_receive(:cache_set).and_raise(StandardError)
    get "/foo"
    last_response.body.should show_allowed_response
  end
end

