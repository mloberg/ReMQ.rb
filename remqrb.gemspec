$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), *%w[lib]))

require "ReMQ"

Gem::Specification.new do |s|
  s.name        = 'remq-rb'
  s.version     = ReMQ::VERSION
  s.summary     = "Redis based message queue."
  s.description = "Redis Message Queue (ReMQ) is a message queue backed by the awesome key-value store, Redis."
  s.authors     = ["Matthew Loberg"]
  s.email       = 'm@mloberg.com'

  s.require_path = %w[lib]

  s.add_runtime_dependency('redis', "~> 3.0")

  # = MANIFEST =
  s.files = %w[
    lib/RemQ.rb
  ]
  # = MANIFEST =
end
