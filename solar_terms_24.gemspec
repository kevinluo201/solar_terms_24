# frozen_string_literal: true

require_relative 'lib/solar_terms_24/version'

Gem::Specification.new do |spec|
  spec.name = 'solar_terms_24'
  spec.version = SolarTerms24::VERSION
  spec.authors = ['kevinluo201']
  spec.email = ['kevin.luo@hey.com']

  spec.summary = '`solar_terms_24` calculates and collects 24 solar terms each year by using NASA JPL Horizons System API.'
  spec.description = "It uses JPL Horizons System API to calculate the accurate solar terms' times and can translate them into different timezones and languages."
  spec.homepage = 'https://github.com/kevinluo201/solar_terms_24'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 2.4.0'

  spec.metadata['homepage_uri'] = spec.homepage

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  spec.add_dependency 'faraday', '~> 2.0'
  spec.add_dependency 'i18n', '~> 1.0'
  spec.add_dependency 'thor', '~> 1.0'
  spec.add_dependency 'tzinfo', '~> 2.0.0'
  spec.add_development_dependency 'debug', '~> 1.0'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'rubocop', '~> 1.21'

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
