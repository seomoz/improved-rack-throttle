require File.dirname(__FILE__) + '/spec_helper'

describe Rack::Throttle::UrlMatcher do
  include Rack::Test::Methods

  def app
    @target_app ||= example_target_app
    @app ||= Rack::Throttle::Limiter.new(@target_app, :rules => {:url => /foo/})
  end

  it "should not bother checking if the path doesn't match the rule" do
    app.should_not_receive(:allowed?)
    get "/bar"
    last_response.body.should show_allowed_response
  end
  
  it "should check if the path matches the rule" do
    app.should_receive(:allowed?).and_return(false)
    get "/foo"
    last_response.body.should show_throttled_response
  end

  it "should append the rule to the cache key" do
    get "/foo"
    app.send(:cache_key, last_request).should == "127.0.0.1:url/foo/"
  end
end

