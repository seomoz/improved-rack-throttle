require File.join(File.dirname(__FILE__), '..', 'spec_helper')

describe Rack::Throttle::UrlMatcher do
  include Rack::Test::Methods

  def app
    @target_app ||= example_target_app
    @app ||= Rack::Throttle::Limiter.new(@target_app, :rules => {:url => /foo/})
  end

  it "should not bother checking if the path doesn't match the rule" do
    expect(app).not_to receive(:allowed?)
    get "/bar"
    expect(last_response.body).to show_allowed_response
  end

  it "should check if the path matches the rule" do
    expect(app).to receive(:allowed?).and_return(false)
    get "/foo"
    expect(last_response.body).to show_throttled_response
  end

  it "should append the rule to the cache key" do
    get "/foo"
    expect(app.send(:cache_key, last_request)).to eq "127.0.0.1:url-/foo/"
  end
end

