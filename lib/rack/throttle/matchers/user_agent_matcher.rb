module Rack; module Throttle
  ###
  # User Agent Matchers are used to restrict requests based on the User
  # Agent supplied by the requester. For instance, you may care about
  # limiting a specific API consumer who reliably uses a known User-Agent.
  # UserAgentMatchers take Regexp objects to match against the
  # User-Agent.
  class UserAgentMatcher < Matcher
    ###
    # @param [Rack::Request] request
    # @return [Boolean]
    def match?(request)
      !!(@rule =~ request.user_agent)
    end

    ###
    # @return [String]
    def identifier
      "ua-" + @rule.inspect
    end
  end

end; end
