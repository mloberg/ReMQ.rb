$LOAD_PATH.unshift File.dirname(__FILE__)

require "redis"
require "json"

require "ReMQ/Queue"

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
    unless job.class == Class and job.methods.include?(:perform)
      raise BadJobError, "#{job} is not a valid job"
      return false
    end
    return true
  end

end
