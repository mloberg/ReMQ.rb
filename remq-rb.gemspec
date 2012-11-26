$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), *%w[lib]))

line = File.read("lib/ReMQ.rb")[/^\s*VERSION\s*=\s*.*/]
version = line.match(/.*VERSION\s*=\s*['"](.*)['"]/)[1]

Gem::Specification.new do |s|
  s.name        = 'remq-rb'
  s.version     = version
  s.summary     = "Redis based message queue."
  s.description = "Redis Message Queue (ReMQ) is a message queue backed by the awesome key-value store, Redis."
  s.homepage    = 'https://github.com/mloberg/ReMQ.rb'
  s.authors     = ["Matthew Loberg"]
  s.email       = 'm@mloberg.com'

  s.require_path = %w[lib]

  s.add_runtime_dependency('redis', "~> 3.0")
  s.add_runtime_dependency('json', "~> 1.7")

  s.add_development_dependency('rake', "~> 0.9")
  s.add_development_dependency('yard', "~> 0.8")

  # = MANIFEST =
  s.files = %w[
    Gemfile
    LICENSE
    README.md
    Rakefile
    lib/ReMQ.rb
    lib/ReMQ/Queue.rb
    lib/ReMQ/Worker.rb
    remq-rb.gemspec
    test/helper.rb
    test/queue_test.rb
    test/worker_test.rb
  ]
  # = MANIFEST =

  s.test_files = s.files.select { |path| path =~ /^test\/test_.*\.rb/ }
end
