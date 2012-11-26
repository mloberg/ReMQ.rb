$LOAD_PATH.unshift File.dirname(__FILE__)

require "redis"
require "json"

require "ReMQ/Queue"
require "ReMQ/Worker"

module ReMQ
  VERSION = '0.0.0'

  class BadJobError < StandardError
  end

  extend self

  # Get a normalized ReMQ queue name.
  #
  # @param [String] name
  # @return [String]
  def normalize_queue_name(name)
    "remq:#{name}"
  end

  # Set Redis connection options.
  #
  # @param [Hash] config
  def set_redis_config(config)
    @redis = Redis.new(config)
  end

  # Set a custom Redis connection.
  #
  # @param [Object] redis
  def set_redis(redis)
    @redis = redis
  end

  # Return the Redis connection or create a new connection.
  #
  # @return [Object] Redis conenction
  def redis
    @redis ||= Redis.new
  end

  # Check if the job is a valid job.
  #
  # @raise [ReMQ::BadJobError]
  # @param [Object] job
  # @return [Boolean]
  def is_valid_job?(job)
    # check if is class
    if job.class != Class and Object.const_defined?(job)
      job = Object.const_get(job)
    elsif job.class != Class
      raise BadJobError, "#{job} is not a class"
      return false
    end
    # check if it has the perform method
    unless job.methods.include?(:perform)
      raise BadJobError, "#{job} does not have a perform method"
      return false
    end
    return true
  end

end
