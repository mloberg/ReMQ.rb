require "redis"

module ReMQ
  VERSION = '0.0.0'

  def normalize_queue_name(name)
    "remq:#{name}"
  end

end
