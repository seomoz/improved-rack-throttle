require 'rack'

module Rack
  module Throttle
    autoload :Limiter,       'rack/throttle/limiter'
    autoload :Interval,      'rack/throttle/interval'
    autoload :TimeWindow,    'rack/throttle/time_window'
    autoload :Daily,         'rack/throttle/daily'
    autoload :Hourly,        'rack/throttle/hourly'
    autoload :VERSION,       'rack/throttle/version'
    autoload :Matcher,       'rack/throttle/matcher'
    autoload :UrlMatcher,    'rack/throttle/matchers/url_matcher'
    autoload :MethodMatcher, 'rack/throttle/matchers/method_matcher'
    autoload :UserAgentMatcher, 'rack/throttle/matchers/user_agent_matcher'
  end
end
