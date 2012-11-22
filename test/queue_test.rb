require "helper"

class TestQueue < Test::Unit::TestCase

  def setup
    @redis_mock = Object.new
    @redis_mock.extend(Test::Unit::Assertions)
    ReMQ.set_redis(@redis_mock)
    @queue = ReMQ::Queue.new('test')
  end

  def test_enqueue
    def @redis_mock.rpush(key, value)
      assert_equal('remq:test', key)
      assert_equal(['TestJob', 'foo', 'bar'].to_json, value)
      return true
    end
    assert(@queue.enqueue(TestJob, 'foo', 'bar'))
  end

  def test_throws_error_on_bad_job
    assert_raise(ReMQ::BadJobError) { @queue.enqueue(BadJob) }
  end

end
