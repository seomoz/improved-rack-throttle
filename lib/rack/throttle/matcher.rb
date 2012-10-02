module Rack; module Throttle
  ###
  # This is the base class for matcher implementations
  # Implements IP, user agent, url, and request method based matching
  # e.g. implement throttling rules that discriminate by ip, user agent, url, request method,
  # or any combination thereof
  class Matcher
    attr_reader :rule

    def initialize(rule)
      @rule = rule
    end

    # MUST return true or false
    def match?
      true
    end

    def identifier
      ""
    end
  end

end; end
