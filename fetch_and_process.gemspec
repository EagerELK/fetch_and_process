# frozen_string_literal: true

# - Automatically index files dropped in a S3 bucket
# - Use the filename / bucket to determine index and pipeline

require_relative 'lib/fetch_and_process/version'

Gem::Specification.new do |spec|
  spec.name          = 'fetch_and_process'
  spec.version       = FetchAndProcess::VERSION
  spec.authors       = ['Jurgens du Toit']
  spec.email         = ['jrgns@eagerelk.com']

  spec.summary       = 'Simple framework to fetch and process files.'
  spec.description   = 'Systems need to process files. Sometimes those files reside remotely. This simple gem allows you to easily fetch and process remote files.'
  spec.homepage      = 'https://github.com/EagerELK/fetch_and_process'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.3.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/EagerELK/fetch_and_process'
  spec.metadata['changelog_uri'] = 'https://github.com/EagerELK/fetch_and_process/blob/master/Changelog.md'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{\A(?:test|spec|features)/}) }
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
  spec.add_dependency 'zeitwerk', '>= 2.3'

  spec.add_development_dependency 'bundler', '>= 2.2'
  spec.add_development_dependency 'rake', '>= 13.0'
  spec.add_development_dependency 'rspec', '>= 3.10'
  spec.add_development_dependency 'rubocop', '>= 0.93'
  spec.add_development_dependency 'rubocop-performance', '>= 1.10'
  spec.add_development_dependency 'rubocop-rspec', '>= 1.44'
  spec.add_development_dependency 'rubocop-thread_safety', '>= 0.4'

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
