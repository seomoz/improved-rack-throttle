require File.join(File.dirname(__FILE__), '..', 'spec_helper')


describe Rack::Throttle::Interval do
  include Rack::Test::Methods

  def app
    @target_app ||= example_target_app
    @app ||= Rack::Throttle::Interval.new(@target_app, :min => 0.1)
  end

  it "should allow the request if the source has not been seen" do
    get "/foo"
    expect(last_response.body).to show_allowed_response
  end

  it "should allow the request if the source has not been seen in the current interval" do
    Timecop.freeze do
      get "/foo"
      Timecop.freeze(1) do # Timecop.freeze won't do subsecond resolution
        get "/foo"
      end
    end
    expect(last_response.body).to show_allowed_response
  end

  it "should not allow the request if the source has been seen inside the current interval" do
    Timecop.freeze do
      2.times { get "/foo" }
    end
    expect(last_response.body).to show_throttled_response
  end

  it "should gracefully allow the request if the cache bombs on getting" do
    expect(app).to receive(:cache_get).and_raise(StandardError)
    get "/foo"
    expect(last_response.body).to show_allowed_response
  end

  it "should gracefully allow the request if the cache bombs on setting" do
    expect(app).to receive(:cache_set).and_raise(StandardError)
    get "/foo"
    expect(last_response.body).to show_allowed_response
  end
end
