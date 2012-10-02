module Rack; module Throttle
  ###
  # IpMatchers take RegExp objects and compare the request ip against them
  class IpMatcher < Matcher
    def match?(request)
      !!(@rule =~ request.ip)
    end

    def identifier
      "ip" + @rule.inspect
    end
  end

end; end
