require "test/unit"

require "ReMQ"

class Test::Unit::TestCase
  include RR::Adapters::TestUnit
end

class TestJob

  def self.perform
  end

end

class BadJob
end
