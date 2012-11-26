module ReMQ
  class Worker

    # Create a new ReMQ worker.
    #
    # @param [String] name Optional name of the queue
    def initialize(name = nil)
      @queues = []
      add_queue(name) if name
    end

    # Return the list of quques that this worker will run.
    #
    # @return [Array] Array of queues
    def queues
      @queues.map { |name| name.gsub(/^remq\:/, '') }
    end

    # Add a queue to the worker.
    #
    # @param [String] name Queue name
    def add_queue(name)
      queues = find_queues(name)
      queues << ReMQ.normalize_queue_name(name)
      @queues = @queues.concat(queues).uniq
    end

    # Remove a queue from the worker.
    #
    # @param [String] name Queue name
    def remove_queue(name)
      @queues.delete(ReMQ.normalize_queue_name(name))
    end

    # Run the worker
    #
    # @param [Integer] time Seconds to run the worker for
    # @param [Integer] count Number of jobs to run
    def run(args = {})
      if args[:time]
        start = Time.now
        while (start + args[:time]) > Time.now do
          process(1)
        end
      elsif args[:count]
        args[:count].times do
          process(0)
        end
      else
        loop do
          process(0)
        end
      end
    end

    private

      # Find queues in Redis
      #
      # @param [String] match
      def find_queues(match)
        match = ReMQ.normalize_queue_name(match)
        ReMQ.redis.keys(match)
      end

      # Handle the job processing
      #
      # @param [Integer] timeout Redis BLPOP timeout
      def process(timeout)
        queues = @queues << timeout
        begin
          queue, job = ReMQ.redis.blpop(*queues)
          if job
            body = JSON.parse(job)
            job_class = body.shift
            if ReMQ.is_valid_job?(job_class)
              Object.const_get(job_class).perform(*body)
            end
          end
        rescue Exception => e
          ReMQ.redis.rpush(queue, job)
          raise e
        end
      end

  end
end
