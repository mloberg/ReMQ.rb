# ReMQ.rb

[![Build Status](https://secure.travis-ci.org/mloberg/ReMQ.rb.png?branch=master)](https://travis-ci.org/mloberg/ReMQ.rb)

Redis Message Queue (ReMQ) is a message queue built on top of the awesome Redis key-value store.

This is the Ruby clone of the original [ReMQ](https://github.com/mloberg/ReMQ) PHP library.

## Getting ReMQ

ReMQ.rb is packaged as a gem, so assuming you have RubyGems installed you simply run `gem install remq-rb` or add it to your Gemfile.

Once it's installed just add `require "ReMQ"` to your script.

## Jobs

Jobs are stored as classes. The class must have a perform method which can take a variable number of parameters/

	class Job

	  def self.perform(param1, param2)
	    puts "Ran job with #{param1} and #{param2}"
	  end

	end

## Queuing Jobs

Instead of creating a queue for each job, ReMQ allows multiple jobs per queue. This is for simplicity's sake, and there is no other reason behind it.

	queue = ReMQ::Queue.new('name')
	queue.enqueue(Job, 'param1', 'param2')

## Processing Jobs

To process a job, you need to create a worker for the queue.

	worker = ReMQ::Worker.new('name')

You can also add additional queues to the process.

	worker.add_queue('other')

You can also match queue names.

	worker.add_queue('*')
	worker.add_queue('namespaced:*')

Running the worker.

	worker.run(:time => 60)
	worker.run(:count => 10)
	worker.run()
