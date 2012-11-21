require "date"

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), *%w[lib]))

require "ReMQ"

##
# Helper functions
##

def name
  @name ||= Dir['*.gemspec'].first.split('.').first
end

def version
  ReMQ::VERSION
end

def date
  Date.today.to_s
end

def gemspec_file
  "#{name}.gemspec"
end

def gem_file
  "#{name}-#{version}.gem"
end

def replace_header(head, header_name)
  head.sub!(/(\.#{header_name}\s*= ').*'/) { "#{$1}#{send(header_name)}'"}
end

###
# Packing tasks
###

desc "Build gem"
task :build do
  FileUtils.mkdir_p "pkg"
  system "gem build #{gemspec.name}.gemspec"
  FileUtils.mv "#{gemspec.name}-#{gemspec.version}.gem", "pkg"
end

desc "Install gem locally"
task :install => :build do
  system "gem install pkg/#{gemspec.name}-#{gemspec.version}"
end

desc "Clean automatically generated files"
task :clean do
  FileUtils.rm_rf "pkg"
end

task :gemspec do
  spec = File.read(gemspec_file)
  head, manifest, tail = spec.split("  # = MANIFEST =\n")

  replace_header(head, :name)
  replace_header(head, :version)
  replace_header(head, :date)

  files = `git ls-files`
          .split("\n")
          .sort
          .reject { |file| file =~ /^\./ }
          .reject { |file| file =~ /^(pkg)/ }
          .map { |file| "    #{file}"}
          .join("\n")

  manifest = "  s.files = %w[\n#{files}\n  ]\n"
  spec = [head, manifest, tail].join("  # = MANIFEST =\n")
  File.open(gemspec_file, 'w') { |f| f.write(spec) }
  puts "Updated #{gemspec_file}"
end
