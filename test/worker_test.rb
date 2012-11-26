require "helper"

class TestWorker < Test::Unit::TestCase

  def setup
    @redis_mock = Object.new
    @redis_mock.extend(Test::Unit::Assertions)
    ReMQ.set_redis(@redis_mock)
    @worker = ReMQ::Worker.new
  end

  def redis_keys_returns_empty
    def @redis_mock.keys(match)
      []
    end
  end

  def test_add_queue
    redis_keys_returns_empty
    @worker.add_queue('example')
    assert_contains('example', @worker.queues)
    @worker.add_queue('test')
    assert_contains('test', @worker.queues)
    # assert that the previous queue is still in place
    assert_contains('test', @worker.queues)
  end

  def test_remove_queue
    redis_keys_returns_empty
    @worker.add_queue('example')
    @worker.add_queue('test')
    @worker.remove_queue('example')
    assert_not_contains('example', @worker.queues)
  end

  def test_process
    def @redis_mock.blpop(*queues, timeout)
      [ 'example', [ 'TestJob', 'foo', 'bar' ].to_json ]
    end
    @worker.run(:count => 1)
  end

  def test_reenqueue_after_exception
    def @redis_mock.rpush(key, value)
      assert_equal('example', key)
      assert_equal(['FailingJob'].to_json, value)
    end
    def @redis_mock.blpop(*queues, timeout)
      [ 'example', [ 'FailingJob' ].to_json ]
    end
    assert_raise(FailingJobError) { @worker.run(:count => 1) }
  end

  def test_throws_exception_if_not_valid_job
    def @redis_mock.blpop(*queues, timeout)
      [ 'example', [ 'BadJob' ].to_json ]
    end
    def @redis_mock.rpush(key, value)
    end
    assert_raise(ReMQ::BadJobError) { @worker.run(:count => 1) }
  end

end
