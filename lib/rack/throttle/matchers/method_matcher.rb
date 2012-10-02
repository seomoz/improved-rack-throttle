module Rack; module Throttle
  ###
  # MethodMatchers take Symbol objects of :get, :put, :post, or :delete
  class MethodMatcher < Matcher
    def match?(request)
      rack_method = :"#{@rule}?"
      request.send(rack_method)
    end

    def identifier
      "meth-#{@rule}"
    end
  end

end; end
