module Rack; module Throttle
  ###
  # UrlMatchers take Regexp objects and compare the request path against them
  class UrlMatcher < Matcher
    def match?(request)
      !!(@rule =~ request.path)
    end

    def identifier
      "url" + @rule.inspect
    end
  end

end; end

