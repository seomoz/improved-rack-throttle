module Rack; module Throttle
  ###
  # MethodMatchers are used to restrict throttling based on the HTTP
  # method used by the request. For instance, you may only care about
  # throttling POST requests on a login form; GET requests are just
  # fine.
  # MethodMatchers take Symbol objects of :get, :put, :post, or :delete
  class MethodMatcher < Matcher
    ##
    # @param [Rack::Request] request
    # @return [Boolean]
    def match?(request)
      rack_method = :"#{@rule}?"
      request.send(rack_method)
    end

    ##
    # @return [String]
    def identifier
      "meth-#{@rule}"
    end
  end

end; end
