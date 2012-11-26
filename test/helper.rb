require "test/unit"

require "ReMQ"

module Test::Unit::Assertions

  def assert_contains(needle, haystack, msg = nil)
    unless msg
      msg = "#{haystack} was expected to contain #{needle}"
    end
    assert(haystack.include?(needle), msg)
  end

  def assert_not_contains(needle, haystack, msg = nil)
    unless msg
      msg = "#{haystack} was expected to not contain #{needle}"
    end
    assert(!haystack.include?(needle), msg)
  end

end

class TestJob

  extend Test::Unit::Assertions

  def self.perform(foo, bar)
    assert_equal(foo, 'foo')
    assert_equal(bar, 'bar')
  end

end

class FailingJobError < StandardError
end

class FailingJob

  def self.perform
    raise FailingJobError, "did not run job"
  end

end

class BadJob
end
