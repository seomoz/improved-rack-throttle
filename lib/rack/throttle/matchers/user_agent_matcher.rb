module Rack; module Throttle
  ###
  # IpMatchers take RegExp objects and compare the request ip against them
  class UserAgentMatcher < Matcher
    def match?(request)
      !!(@rule =~ request.user_agent)
    end

    def identifier
      "ua-" + @rule.inspect
    end
  end

end; end
