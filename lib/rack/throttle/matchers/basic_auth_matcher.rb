require 'rack/throttle/matchers/matcher'

module Rack; module Throttle
  ###
  # BasicAuthMatchers are used to restrict requests based on the Basic Auth user name used in the
  # request. For instance, you may care about limiting requests
  # to a machine-consumed API, but not be concerned about requests
  # coming from browsers.
  # BasicAuthMatchers take Regexp object to matcha gainst the request path.
  #
  class BasicAuthMatcher < Matcher
    ###
    # @param [Rack::Request] request
    # @return [Boolean]
    def match?(request)
      debugger
      !!(@rule =~ request.path)
    end

    ###
    # @return [String]
    def identifier
      "basic_auth-" + @rule.inspect
    end
  end
  puts "defining BasicAuthMatcher"

end; end

