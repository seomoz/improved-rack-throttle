module Rack; module Throttle
  ##
  # This rate limiter strategy throttles the application with
  # a sliding window (implemented as a leaky bucket). It operates
  # on second-level resolution. It takes :burst and :average 
  # options, which correspond to the maximum size of a traffic 
  # burst, and the maximum allowed average traffic level.
  class SlidingWindow < Limiter
    ##
    # @param  [#call]                    app
    # @param  [Hash{Symbol => Object}]   options
    # @option options [Integer] :burst   5
    # @option options [Float] :average   1
    def initialize(app, options = {})
      super
      options[:burst] ||= 5
      options[:average] ||= 1
    end

    ##
    # Returns `true` if sufficient time (equal to or more than
    # {#minimum_interval}) has passed since the last request and the given
    # present `request`.
    #
    # @param  [Rack::Request] request
    # @return [Boolean]
    def allowed?(request)
      t1 = request_start_time(request)
      key = cache_key(request)
      bucket = cache_get(key) rescue nil
      bucket ||= LeakyBucket.new(options[:burst], options[:average])
      bucket.maximum, bucket.outflow = options[:burst], options[:average]
      bucket.leak! 
      bucket.increment!
      allowed = !bucket.full?
      begin
        cache_set(key, bucket)
        allowed
      rescue StandardError => e
        allowed = true
        # If an error occurred while trying to update the timestamp stored
        # in the cache, we will fall back to allowing the request through.
        # This prevents the Rack application blowing up merely due to a
        # backend cache server (Memcached, Redis, etc.) being offline.
      end
    end

    class LeakyBucket
      attr_accessor :maximum, :outflow
      attr_reader :count, :last_touched

      def initialize(maximum, outflow)
        @maximum, @outflow = maximum, outflow
        @count, @last_touched = 0, Time.now
      end

      def leak!
        t = Time.now
        time = t - last_touched
        loss = (outflow * time).to_f
        if loss > 0
          @count -= loss
          @last_touched = t 
        end
      end

      def increment!
        @count = 0 if count < 0
        @count += 1
        @count = maximum if count > maximum
      end

      def full?
        count == maximum
      end
    end

  end
end; end
