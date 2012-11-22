$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), *%w[lib]))

line = File.read("lib/ReMQ.rb")[/^\s*VERSION\s*=\s*.*/]
version = line.match(/.*VERSION\s*=\s*['"](.*)['"]/)[1]

Gem::Specification.new do |s|
  s.name        = 'remq-rb'
  s.version     = version
  s.summary     = "Redis based message queue."
  s.description = "Redis Message Queue (ReMQ) is a message queue backed by the awesome key-value store, Redis."
  s.authors     = ["Matthew Loberg"]
  s.email       = 'm@mloberg.com'

  s.require_path = %w[lib]

  s.add_runtime_dependency('redis', "~> 3.0")
  s.add_runtime_dependency('json', "~> 1.7")

  s.add_development_dependency('rake', "~> 0.9")
  s.add_development_dependency('yard', "~> 0.8")

  # = MANIFEST =
  s.files = %w[
    lib/RemQ.rb
  ]
  # = MANIFEST =
end
