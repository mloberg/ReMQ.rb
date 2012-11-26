module ReMQ
  class Queue

    # @!attribute [r] name
    #   @return [String] the queue name
    attr_reader :name

    # Create a new queue.
    #
    # @param [String] name queue name
    def initialize(name)
      @name = ReMQ.normalize_queue_name(name)
    end

    # Add a job to the queue.
    #
    # @raise [ReMQ::BadJobError] if job is invalid
    # @param [String] class Job class name
    # @param [mixed] params Job parameters
    # @return [Boolean] true if job was queued
    def enqueue(*args)
      body = args.to_json
      if ReMQ.is_valid_job?(args.first)
        ReMQ.redis().rpush(name, body)
      end
    end

  end
end
