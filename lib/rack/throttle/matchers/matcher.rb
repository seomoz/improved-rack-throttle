module Rack; module Throttle
  ###
  # This is the base class for matcher implementations.
  # Implementations are provided for User Agent, URL, and request
  # method. Subclass Matcher if you want to provide a custom
  # implementation.
  class Matcher
    attr_reader :rule

    def initialize(rule)
      @rule = rule
    end

    # Must be implemented in a subclass.
    # MUST return true or false.
    # @return [Boolean]
    # @abstract
    def match?
      true
    end

    # Must be implemented in a subclass.
    # Used to produce a unique key in our cache store.
    # Typically of the form "xx-"
    # @return [String]
    # @abstract
    def identifier
      ""
    end
  end

end; end
